package MAuthorBase;

use Data::Dumper;
use utf8;
use Text::BibTeX;    # parsing bib files
use 5.010;           # because of ~~ and say
use DBI;
use List::MoreUtils qw(any uniq);
use BibSpace::Model::MTeamMembership;

use BibSpace::Model::StorageBase;

use Moose;
use MooseX::Storage;
with Storage( 'format' => 'JSON', 'io' => 'File' );


has 'id'      => ( is => 'rw', isa     => 'Int' );
has 'uid'     => ( is => 'rw', isa     => 'Str' );
has 'display' => ( is => 'rw', default => 0 );
has 'master' =>
    ( is => 'rw', isa => 'Maybe[Str]', default => sub { shift->{uid} } );
has 'master_id' => ( is => 'rw', isa => 'Maybe[Int]' );
has 'masterObj' => (
    is      => 'rw',
    isa     => 'Maybe[MAuthor]',
    default => sub {undef},
    traits  => ['DoNotSerialize']    # due to cycyles
);


has 'bteamMemberships' => (
    is      => 'rw',
    isa     => 'ArrayRef[MTeamMembership]',
    traits  => [ 'Array', 'DoNotSerialize' ],
    default => sub { [] },
    handles => {
        teamMemberships_all        => 'elements',
        teamMemberships_add        => 'push',
        teamMemberships_map        => 'map',
        teamMemberships_filter     => 'grep',
        teamMemberships_find       => 'first',
        teamMemberships_get        => 'get',
        teamMemberships_find_index => 'first_index',
        teamMemberships_delete     => 'delete',
        teamMemberships_clear      => 'clear',
        teamMemberships_join       => 'join',
        teamMemberships_count      => 'count',
        teamMemberships_has        => 'count',
        teamMemberships_has_no     => 'is_empty',
        teamMemberships_sorted     => 'sort',
    },
);

has 'bteams' => (
    is      => 'rw',
    isa     => 'ArrayRef[MTeam]',
    traits  => [ 'Array', 'DoNotSerialize' ],
    default => sub { [] },
    handles => {
        teams_all        => 'elements',
        teams_add        => 'push',
        teams_map        => 'map',
        teams_filter     => 'grep',
        teams_find       => 'first',
        teams_get        => 'get',
        teams_find_index => 'first_index',
        teams_delete     => 'delete',
        teams_clear      => 'clear',
        teams_join       => 'join',
        teams_count      => 'count',
        teams_has        => 'count',
        teams_has_no     => 'is_empty',
        teams_sorted     => 'sort',
    },
);

has 'bentries' => (
    is      => 'rw',
    isa     => 'ArrayRef[MEntry]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        entries_all        => 'elements',
        entries_add        => 'push',
        entries_map        => 'map',
        entries_filter     => 'grep',
        entries_find       => 'first',
        entries_find_index => 'first_index',
        entries_delete     => 'delete',
        entries_clear      => 'clear',
        entries_get        => 'get',
        entries_join       => 'join',
        entries_count      => 'count',
        entries_has        => 'count',
        entries_has_no     => 'is_empty',
        entries_sorted     => 'sort',
    },
);

################################################################################
sub init_storage {
    my $self = shift;
    if( $self->teams_count == 0){
        $self->bteams([]);
    }
    if( $self->entries_count == 0){
        $self->bentries([]);
    }
    if( $self->teamMemberships_count == 0){
        $self->bteamMemberships([]);
    }
}
####################################################################################
sub replaceFromStorage {
    my $self    = shift;
    my $storage = shift;    # dependency injection
                            # use BibSpace::Model::StorageBase;

    my $storageItem = $storage->authors_find( sub { $_->equals($self) } );

    die "Cannot find " . ref($self) . ": " . Dumper($self) . " in storage "
        unless $storageItem;
    return $storageItem;
}

####################################################################################
# called after the default constructor
sub BUILD {
    my $self = shift;

    if ( !defined $self->master or $self->master eq '' ) {
        $self->master( $self->uid );
    }
    if ( !defined $self->master_id and defined $self->{id} ) {
        $self->master_id( $self->id );
    }
    if ( defined $self->masterObj and $self->masterObj == $self ) {
        $self->masterObj(undef);
    }
}
####################################################################################
sub toString {
    my $self = shift;
    my $str  = $self->freeze;
    $str .= "\n\t (MASTER): " . $self->masterObj->freeze
        if defined $self->masterObj;

    $str .= "\nMEMBERSHIPS: [\n";
    map { $str .= "\t" . $_->toString . "\n" } $self->teamMemberships_all;
    $str .= "]\n";

    $str .= "\nTEAMS: [\n";
    map { $str .= "\t" . $_->toString . "\n" } $self->teams_all;
    $str .= "]\n";
    $str;
}
####################################################################################
sub equals {
    my $self = shift;
    my $obj  = shift;

    return 0 if !defined $obj;

    # return 0 unless $obj->isa("MAuthorBase");
    my $result = $self->uid cmp $obj->uid;
    return $result == 0;
}
####################################################################################
####################################################################################
####################################################################################
sub set_master {
    my $self          = shift;
    my $master_author = shift;

    $self->{masterObj} = $master_author;

    $self->{master}    = $master_author->{uid};
    $self->{master_id} = $master_author->{id};
}
####################################################################################
sub get_master {
    my $self = shift;

    return $self if !defined $self->masterObj;
    return $self->masterObj;
}
####################################################################################
sub is_master {
    my $self = shift;

    return 1 if !defined $self->masterObj;
    return 1 if $self->equals( $self->masterObj );
    return 0;
}
####################################################################################
sub is_minion {
    my $self = shift;
    return $self->is_master == 0;
}
####################################################################################
sub is_minion_of {
    my $self   = shift;
    my $master = shift;

    return 1
        if defined $self->{masterObj} and $self->{masterObj}->equals($master);
    return 1
        if defined $master->{id}
        and defined $self->{master_id}
        and $self->{master_id} == $master->{id};
    return 1
        if defined $self->{master}
        and ( $self->{master} cmp $master->{uid} ) == 0;
    return 0 if $self->is_master;

    return 0;
}
####################################################################################
sub update_master_name {
    my $self       = shift;
    my $new_master = shift;

    # TODO: if this is minion, then this may not have sense
    if ( $self->is_minion ) {
        die "Cannot update master name if author is a minion";
    }

    $self->{master} = $new_master;
    $self->{uid}    = $new_master;

    return 1;
}
####################################################################################
sub remove_master {
    my $self = shift;

    $self->{masterObj} = undef;

    $self->{master}    = $self->{uid};
    $self->{master_id} = $self->{id};
}
####################################################################################
sub add_minion {
    my $self   = shift;
    my $minion = shift;

    return 0 unless defined $minion;
    $minion->set_master($self);
    return 1;
}
##############################################################################################################
sub can_merge_authors {
    my $self          = shift;
    my $source_author = shift;


    if (    defined $source_author
        and $source_author->{id} != $self->{id}
        and !$self->equals($source_author) )
    {
        return 1;
    }
    return 0;
}
##############################################################################################################
sub merge_authors {
    my $self          = shift;
    my $source_author = shift;

    if ($source_author) {

        # author with new_user_id already exist
        # move all entries of candidate to this author
        $self->take_entries_from_author($source_author);

        # necessary due to possible conflicts caused on ON UPDATE CASCADE
        $source_author->abandon_all_entries();
        $source_author->abandon_all_teams();
        $source_author->set_master($self);
    }
}
####################################################################################
####################################################################################
####################################################################################
sub toggle_visibility {
    my $self = shift;

    if ( $self->display == 0 ) {
        $self->display(1);
    }
    else {
        $self->display(0);
    }
}
####################################################################################
sub is_visible {
    my $self = shift;

    return $self->display == 1;
}
####################################################################################
sub can_be_deleted {
    my $self = shift;

    return 0 if $self->{display} == 1;

    my @teams = $self->teams();

    return 1 if scalar @teams == 0 and $self->{display} == 0;
    return 0;
}
####################################################################################
####################################################################################
####################################################################################
sub entries {
    my $self = shift;
    return $self->entries_all;
}

####################################################################################
sub has_entry {
    my $self = shift;
    my $e    = shift;

    my $exists = $self->entries_find_index( sub { $_->equals($e) } ) > -1;
    return $exists;
}
####################################################################################
sub assign_entry {
    my ( $self, @entries ) = @_;

    my $added = 0;
    foreach my $e (@entries) {
        if ( !$self->has_entry($e) ) {
            $self->entries_add($e);
            ++$added;

            # if ( !$e->has_author($self) ) {
            #     $e->assign_author($self);
            # }
        }

    }
    return $added;

}
####################################################################################
sub remove_entry {
    my $self  = shift;
    my $entry = shift;

    my $index = $self->entries_find_index( sub { $_->equals($entry) } );
    return 0 if $index == -1;
    return 1 if $self->entries_delete($index);
    return 0;
}
####################################################################################
sub remove_all_entries {
    my $self = shift;
    $self->entries_clear;
}
####################################################################################
sub take_entries_from_author {
    my $self        = shift;
    my $from_author = shift;

    warn "This function may cause entries to be duplicated for author "
        . $self->toString;
    $self->entries_add( $from_author->entries );
    $from_author->abandon_all_entries;
}


################################################################################
sub abandon_all_entries {
    my $self = shift;
    $self->entries_clear;
}
################################################################################
################################################################################ TEAMS
################################################################################
####################################################################################
sub joined_team {
    my $self = shift;
    my $team = shift;

    return -1 if !defined $team;

    my $mem = $self->teamMemberships_find(
        sub {
            $_->{team_id} == $team->id and $_->{author_id} == $self->id;
        }
    );
    return -1 if !defined $mem;
    return $mem->start;
}
####################################################################################
sub left_team {
    my $self = shift;
    my $team = shift;

    return -1 if !defined $team;

    my $mem = $self->teamMemberships_find(
        sub {
            $_->{team_id} == $team->id and $_->{author_id} == $self->id;
        }
    );
    return -1 if !defined $mem;
    return $mem->stop;
}
################################################################################
sub abandon_all_teams {
    my $self = shift;

    $self->teamMemberships_clear;
    $self->teams_clear;

}
################################################################################
sub update_membership {
    my $self  = shift;
    my $team  = shift;
    my $start = shift;
    my $stop  = shift;

    my $mem = $self->teamMemberships_find(
        sub {
            $_->{team_id} == $team->id and $_->{author_id} == $self->id;
        }
    );

    if ( $start < 0 ) {
        die "Invalid start $start: start must be 0 or greater";
    }
    if ( $stop < 0 ) {
        die "Invalid stop $stop: stop must be 0 or greater";
    }
    if ( $stop > 0 and $start > 0 and $stop < $start ) {
        die "Invalid range: stop must me non-smaller than start";
    }
    if ( !$mem ) {
        die "Invalid team. Cannot find author membership in that team.";
    }

    if ($mem) {
        $mem->start($start) if defined $start;
        $mem->stop($stop)   if defined $stop;
    }
}

################################################################################
sub add_to_team {
    my $self = shift;
    my $team = shift;


    return 0 if !defined $team and $team->{id} <= 0;



    if ( !$self->is_member_of($team) ) {
        $self->teams_add($team);

# TODO:
# not sure if I should have it here
# how do I save it later, if it is not in the storage?
# maybe I should remove memberships from the storage and leave them only in author and evtl. team?

        $self->teamMemberships_add(
            MTeamMembership->new(
                author_id => $self->id,
                team_id   => $team->id,
                author    => $self,
                team      => $team,
                start     => 0,
                stop      => 0
            )
        );
        return 1;
    }
    return 0;


}
################################################################################
sub is_member_of {
    my $self = shift;
    my $team = shift;

    my $found = $self->teams_find( sub { $_->equals($team) } );
    return 1 if $found;
    return 0;
}
################################################################################
sub remove_from_team {
    my $self = shift;
    my $team = shift;

    return 0 if !defined $team and $team->{id} <= 0;

    my $mem_index = $self->teamMemberships_find_index(
        sub {
            $_->{team_id} == $team->id and $_->{author_id} == $self->id;
        }
    );
    return 0 if $mem_index == -1;
    $self->teamMemberships_delete($mem_index);

    my $index = $self->teams_find_index( sub { $_->equals($team) } );
    return 0 if $index == -1;
    return 1 if $self->teams_delete($index);
    return 0;

}
################################################################################
sub teams {
    my $self = shift;
    return $self->teams_all;
}
####################################################################################
#################################################################################### TAGS
####################################################################################
sub tags {

    my $self = shift;
    my $type = shift // 1;

    my @myTags;

    map { push @myTags, $_->tags($type) } $self->entries;
    @myTags = uniq @myTags;

    return @myTags;
}
####################################################################################
no Moose;
__PACKAGE__->meta->make_immutable;
1;