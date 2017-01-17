package Labeling;

use Data::Dumper;
use utf8;
use 5.010;    #because of ~~ and say
use BibSpace::Model::Author;

use DBI;
use Try::Tiny;
use Devel::StackTrace;
use Moose;
use MooseX::Storage;
with Storage( 'format' => 'JSON', 'io' => 'File' );

# the fileds below are crucial, beacuse static_all has access only to tag/author ids and not to objects
# MTagMembership->load($dbh) should then fill the objects based on ids
has 'entry_id'   => ( is => 'ro', isa => 'Int' );
has 'tag_id' => ( is => 'ro', isa => 'Int' );
has 'entry' => (
    is     => 'rw',
    isa    => 'Maybe[Entry]',
    traits => ['DoNotSerialize']    # due to cycyles
);
has 'tag' => (
    is     => 'rw',
    isa    => 'Maybe[Tag]',
    traits => ['DoNotSerialize']    # due to cycyles
);
####################################################################################
sub toString {
    my $self = shift;
    my $str  = $self->freeze;
    $str .= "\n";
    $str .= "\n\t (ENTRY): " . $self->entry->id if defined $self->entry;
    $str .= "\n\t (TEAM): " . $self->tag->id
        if defined $self->tag;
    $str;
}
####################################################################################

=item equals
    In case of any strange problems: this must return 1 or 0! 
=cut

sub equals {
    my $self = shift;
    my $obj  = shift;

    if (    $self->{entry}
        and $self->{tag}
        and $obj->{entry}
        and $obj->{tag} )
    {
        return $self->equals_obj($obj);
    }
    return $self->equals_id($obj);
}
####################################################################################
sub equals_id {
    my $self = shift;
    my $obj  = shift;
    return 0 if $self->{entry_id} != $obj->{entry_id};
    return 0 if $self->{tag_id} != $obj->{tag_id};
    return 1;
}
####################################################################################
sub equals_obj {
    my $self = shift;
    my $obj  = shift;
    return 0 if !$self->{entry}->equals( $obj->{entry} );
    return 0 if !$self->{tag}->equals( $obj->{tag} );
    return 1;
}
####################################################################################
no Moose;
__PACKAGE__->meta->make_immutable;
1;