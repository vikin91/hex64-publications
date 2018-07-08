package Author;

use Data::Dumper;
use utf8;
use Text::BibTeX;    # parsing bib files
use v5.16;           # because of ~~ and say
use List::MoreUtils qw(any uniq);
use BibSpace::Model::Membership;
use Moose;
use MooseX::Storage;
use MooseX::Privacy;
with Storage;
require BibSpace::Model::IEntity;
require BibSpace::Model::IAuthored;
require BibSpace::Model::IMembered;
with 'IEntity', 'IAuthored', 'IMembered';
use BibSpace::Model::SerializableBase::AuthorSerializableBase;
extends 'AuthorSerializableBase';

# Cast self to SerializableBase and serialize
sub TO_JSON {
  my $self = shift;
  my $copy = $self->meta->clone_object($self);
  return AuthorSerializableBase->meta->rebless_instance_back($copy)->TO_JSON;
}

# has 'master' => (
#   is            => 'rw',
#   isa           => 'Maybe[Str]',
#   default       => sub { shift->{uid} },
#   traits        => ['DoNotSerialize'],
#   documentation => q{Author master name. Redundant field.}
# );

# A placeholder for master object. This will be lazily populated on first read
has 'masterObj' => (
  is            => 'rw',
  isa           => 'Maybe[Author]',
  default       => sub {undef},
  traits        => [qw/DoNotSerialize/, qw/Private/],
  documentation => q{Author's master author object.}
);

# called after the default constructor
sub BUILD {
  my $self = shift;
  $self->name($self->uid);
  $self->id;    # trigger lazy execution of idProvider
  if ( not defined $self->get_master_id
    or $self->get_master_id < 1
    or not defined $self->master)
  {
    $self->set_master($self);
  }
}

sub equals {
  my $self = shift;
  my $obj  = shift;

  return if !defined $obj;
  die "Comparing apples to peaches! " . ref($self) . " against " . ref($obj)
    unless ref($self) eq ref($obj);

  my $result = $self->uid eq $obj->uid;
  return $result;
}

sub master_name {
  my $self = shift;
  return $self->get_master->uid;
}

sub master {
  my $self = shift;
  return $self if not $self->master_id;
  return $self if not $self->masterObj;
  return $self->masterObj;
}

sub set_master {
  my $self   = shift;
  my $master = shift;
  if (not $master->id) {
    warn "Cannot set_master if master has no ID";
    return;
  }
  $self->masterObj($master);
  $self->master_id($master->id);
}

sub get_master {
  shift->master;
}

sub is_master {
  my $self = shift;
  return 1 if ($self->id == $self->master_id);
  return;
}

sub is_minion {
  my $self = shift;
  return not $self->is_master;
}

sub is_minion_of {
  my $self   = shift;
  my $master = shift;
  return 1 if $self->master_id == $master->id;
  return;
}

sub update_name {
  my $self       = shift;
  my $new_master = shift;

  $self->uid($new_master);
  $self->name($new_master);
  return 1;
}

sub remove_master {
  my $self = shift;

  $self->set_master($self);
}

sub add_minion {
  my $self   = shift;
  my $minion = shift;

  return if !defined $minion;
  $minion->set_master($self);
  return 1;
}

sub can_merge_authors {
  my $self          = shift;
  my $source_author = shift;

  if (  (defined $source_author)
    and (defined $source_author->id)
    and (defined $self->id)
    and ($source_author->id != $self->id)
    and (!$self->equals($source_author)))
  {
    return 1;
  }
  return;
}

sub toggle_visibility {
  my $self = shift;

  if ($self->display == 0) {
    $self->display(1);
  }
  else {
    $self->display(0);
  }
}

sub is_visible {
  my $self = shift;

  return $self->display == 1;
}

sub can_be_deleted {
  my $self = shift;

  return if $self->display == 1;

  my @teams = $self->get_teams;

  return 1 if scalar @teams == 0 and $self->display == 0;
  return;
}

sub has_entry {
  my $self  = shift;
  my $entry = shift;

  my $authorship = $self->authorships_find(
    sub {
      $_->entry->equals($entry) and $_->author->equals($self);
    }
  );
  return defined $authorship;
}

################################################################################ TEAMS

sub joined_team {
  my $self = shift;
  my $team = shift;

  return -1 if !defined $team;

  my $query_mem = Membership->new(
    author    => $self->get_master,
    team      => $team,
    author_id => $self->get_master->id,
    team_id   => $team->id
  );
  my $mem = $self->memberships_find(sub { $_->equals($query_mem) });

  return -1 if !defined $mem;
  return $mem->start;
}

sub left_team {
  my $self = shift;
  my $team = shift;

  return -1 if !defined $team;

  my $query_mem = Membership->new(
    author    => $self->get_master,
    team      => $team,
    author_id => $self->get_master->id,
    team_id   => $team->id
  );
  my $mem = $self->memberships_find(sub { $_->equals($query_mem) });

  return -1 if !defined $mem;
  return $mem->stop;
}

sub update_membership {
  my $self  = shift;
  my $team  = shift;
  my $start = shift;
  my $stop  = shift;

  return if !$team;

  my $query_mem_master = Membership->new(
    author    => $self->get_master,
    team      => $team,
    author_id => $self->get_master->id,
    team_id   => $team->id
  );
  my $query_mem_minor = Membership->new(
    author    => $self,
    team      => $team,
    author_id => $self->id,
    team_id   => $team->id
  );
  my $mem_master
    = $self->memberships_find(sub { $_->equals($query_mem_master) });
  my $mem_minor = $self->memberships_find(sub { $_->equals($query_mem_minor) });

  if ($mem_minor != $mem_master) {
    warn "MEMBERSHIP for master differs to membership of minor!";
  }
  my $mem = $mem_master // $mem_minor;

  if ($start < 0) {
    die "Invalid start $start: start must be 0 or greater";
  }
  if ($stop < 0) {
    die "Invalid stop $stop: stop must be 0 or greater";
  }
  if ($stop > 0 and $start > 0 and $stop < $start) {
    die "Invalid range: stop must me non-smaller than start";
  }
  if (!$mem) {
    die "Invalid team. Cannot find author membership in that team.";
  }

  $mem->start($start) if defined $start;
  $mem->stop($stop)   if defined $stop;
  return 1;
}

#################################################################################### TAGS

sub get_tags {

  my $self = shift;
  my $type = shift // 1;

  my @myTags;

  map { push @myTags, $_->get_tags($type) } $self->get_entries;
  @myTags = uniq @myTags;

  return @myTags;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;
