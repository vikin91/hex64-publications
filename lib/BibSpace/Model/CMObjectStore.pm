package CMObjectStore;


use strict;
use warnings;

use BibSpace::Model::MUser;
use BibSpace::Model::MEntry;
use BibSpace::Model::MTag;
use BibSpace::Model::MAuthor;
use BibSpace::Model::MTeam;
use BibSpace::Model::MTeamMembership;

use List::MoreUtils qw(any uniq);


use Moose;
use MooseX::Storage;
with Storage( 'format' => 'JSON', 'io' => 'File' );

has 'entries' => (
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
        entries_find       => 'first',
        entries_get        => 'get',
        entries_join       => 'join',
        entries_count      => 'count',
        entries_has        => 'count',
        entries_has_no     => 'is_empty',
        entries_sorted     => 'sort',
    },
);

has 'authors' => (
    is      => 'rw',
    isa     => 'ArrayRef[MAuthor]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        authors_all        => 'elements',
        authors_add        => 'push',
        authors_map        => 'map',
        authors_filter     => 'grep',
        authors_find       => 'first',
        authors_find_index => 'first_index',
        authors_delete     => 'delete',
        authors_clear      => 'clear',
        authors_get        => 'get',
        authors_insert_at  => 'set',
        authors_join       => 'join',
        authors_count      => 'count',
        authors_has        => 'count',
        authors_has_no     => 'is_empty',
        authors_sorted     => 'sort',
    },
);
has 'tags' => (
    is      => 'rw',
    isa     => 'ArrayRef[MTag]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        tags_all        => 'elements',
        tags_add        => 'push',
        tags_map        => 'map',
        tags_filter     => 'grep',
        tags_find       => 'first',
        tags_get        => 'get',
        tags_find_index => 'first_index',
        tags_delete     => 'delete',
        tags_clear      => 'clear',
        tags_join       => 'join',
        tags_count      => 'count',
        tags_has        => 'count',
        tags_has_no     => 'is_empty',
        tags_sorted     => 'sort',
    },
);

has 'tagtypes' => (
    is      => 'rw',
    isa     => 'ArrayRef[MTagType]',
    traits  => ['Array'],
    default => sub { [] },
    handles => {
        tagtypes_all        => 'elements',
        tagtypes_add        => 'push',
        tagtypes_map        => 'map',
        tagtypes_filter     => 'grep',
        tagtypes_find       => 'first',
        tagtypes_get        => 'get',
        tagtypes_find_index => 'first_index',
        tagtypes_delete     => 'delete',
        tagtypes_clear      => 'clear',
        tagtypes_join       => 'join',
        tagtypes_count      => 'count',
        tagtypes_has        => 'count',
        tagtypes_has_no     => 'is_empty',
        tagtypes_sorted     => 'sort',
    },
);

has 'teams' => (
    is      => 'rw',
    isa     => 'ArrayRef[MTeam]',
    traits  => ['Array'],
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
has 'teamMemberships' => (
    is      => 'rw',
    isa     => 'ArrayRef[MTeamMembership]',
    traits  => ['Array'],
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
####################################################################################################
sub delete {
    my $self = shift;
    my $obj  = shift;
    return $self->deleteObj($obj);
}
####################################################################################################
sub deleteObj {
    my $self = shift;
    my $obj  = shift;

    if ( !blessed($obj) ) {
        warn "Object not blessed!";
        return 0;
    }

    # warn "Deleting ".ref($obj);

    if ( $obj->isa("MEntry") ) {
        my $index = $self->entries_find_index( sub { $_->equals($obj) } );
        if ( $index > -1 ) {
            $self->entries_delete($index);
            return 1;
        }
    }
    elsif ( $obj->isa("MAuthor") ) {
        my $index = $self->authors_find_index( sub { $_->equals($obj) } );
        if ( $index > -1 ) {
            $self->authors_delete($index);
            return 1;
        }
    }
    elsif ( $obj->isa("MTeam") ) {
        my $index = $self->teams_find_index( sub { $_->equals($obj) } );
        if ( $index > -1 ) {
            $self->teams_delete($index);
            return 1;
        }
    }
    elsif ( $obj->isa("MTag") ) {
        my $index = $self->tags_find_index( sub { $_->equals($obj) } );
        if ( $index > -1 ) {
            $self->tags_delete($index);
            return 1;
        }
    }
    elsif ( $obj->isa("MTagType") ) {
        my $index = $self->tagtypes_find_index( sub { $_->equals($obj) } );
        if ( $index > -1 ) {
            $self->tagtypes_delete($index);
            return 1;
        }
    }
    elsif ( $obj->isa("MTeamMembership") ) {
        my $index
            = $self->teamMemberships_find_index( sub { $_->equals($obj) } );
        if ( $index > -1 ) {
            $self->teamMemberships_delete($index);
            return 1;
        }
    }
    else {
        warn "Cannot delete " . ref($obj) . " – unknown type!";
        return 0;
    }

    warn "Cannot delete " . ref($obj) . " – object not found!";
    return 0;
}
####################################################################################################
sub add {
    my $self = shift;
    my $obj  = shift;
    return $self->addObj($obj);
}
####################################################################################################
sub addObj {
    my $self = shift;
    my $obj  = shift;

    if ( !blessed($obj) ) {
        warn "Object not blessed!";
        return 0;
    }

    # warn "\tAdding ".ref($obj);
    my $index = -1;

    if ( $obj->isa("MEntry") ) {
        $index = $self->entries_find_index( sub { $_->equals($obj) } );
        if ( $index < 0 ) {
            $self->entries_add($obj);
            return 1;
        }
    }
    elsif ( $obj->isa("MAuthor") ) {
        $index = $self->authors_find_index( sub { $_->equals($obj) } );
        if ( $index < 0 ) {
            $self->authors_add($obj);
            return 1;
        }
    }
    elsif ( $obj->isa("MTeam") ) {
        $index = $self->teams_find_index( sub { $_->equals($obj) } );
        if ( $index < 0 ) {
            $self->teams_add($obj);
            return 1;
        }
    }
    elsif ( $obj->isa("MTag") ) {
        $index = $self->tags_find_index( sub { $_->equals($obj) } );
        if ( $index < 0 ) {
            $self->tags_add($obj);
            return 1;
        }
    }
    elsif ( $obj->isa("MTagType") ) {
        $index = $self->tagtypes_find_index( sub { $_->equals($obj) } );
        if ( $index < 0 ) {
            $self->tagtypes_add($obj);
            return 1;
        }
    }
    elsif ( $obj->isa("MTeamMembership") ) {
        my $index
            = $self->teamMemberships_find_index( sub { $_->equals($obj) } );
        if ( $index < 0 ) {
            $self->tagtypes_add($obj);
            return 1;
        }
    }
    else {
        warn "Cannot add " . ref($obj) . " – unknown type!";
        return 0;
    }

    warn "Cannot add "
        . ref($obj)
        . " – object already exists on index $index!";
    return 0;
}

####################################################################################################
sub loadData {
    my $self = shift;
    my $dbh  = shift;

    print "CMObjectStore is loading data from DB...\n";

    # fetch objects from DB
    my @allEntries     = MEntry->static_all($dbh);
    my @allTagTypes    = MTagType->static_all($dbh);
    my @allTags        = MTag->static_all($dbh);
    my @allTeams       = MTeam->static_all($dbh);
    my @allAuthors     = MAuthor->static_all($dbh);
    my @allMemberships = MTeamMembership->static_all($dbh);

    # discover relations between objects - based on data from DB
    map { $_->load($dbh) } @allEntries;
    map { $_->load($dbh) } @allTagTypes;
    map { $_->load($dbh) } @allTags;
    map { $_->load($dbh) } @allTeams;
    map { $_->load($dbh) } @allAuthors;
    map { $_->load($dbh) } @allMemberships;

    # put into object storage
    $self->entries( \@allEntries );
    $self->tagtypes( \@allTagTypes );
    $self->tags( \@allTags );
    $self->teams( \@allTeams );
    $self->authors( \@allAuthors );
    $self->teamMemberships( \@allMemberships );
 

    print "CMObjectStore finished loading data from DB.\n";

    # my $entry   = $self->entries_find( sub { $_->{id} == 913 });
    # print "\n" . $entry->toString;

    
    # map { print $_->toString . "\n" } @allMemberships;
    # map { print $_->toString . "\n" } @allAuthors;
    # map { print $_->toString . "\n" } @allEntries;
    # map { print $_->toString . "\n" if $_->id == 913 } @allEntries;
    # map { print $_->toString . "\n" } @allTags;

    # map { $_->load($dbh) } @allTeams;

    # push @{ $self->storage }, @allEntries;
}


####################################################################################
sub add_entry_authors {
    my $self    = shift;
    my $entry = shift;
    my $create_new = shift // 1;
   
    my @bibtex_authors = $entry->get_authors_from_bibtex(); 

    my @authors;
    for my $a (@bibtex_authors){

        my $author_form_storage = $self->authors_find( sub { $_->equals($a) });

        if( defined $author_form_storage ){
            my $master = $author_form_storage->get_master;
            push @authors, $author_form_storage;
        }
        elsif( $create_new ){
            $self->add($a);
            push @authors, $a;
        }
    } 

    my $num_authors_created = 0;
    if( @authors ){
        $num_authors_created = $entry->assign_author( @authors );
    }
    return $num_authors_created;
}
####################################################################################
=item add_entry_tags
    Processes tags from bibtex and adds them to entry. 
    It skips the duplicates that already exist in the entry.    
    If no tagType is specified, it adds it as type 1.
    Returns number of added tags
=cut
sub add_entry_tags {
    my $self = shift;
    my $entry = shift;
    my $tagType = shift;

    my $tagTypeId = 1;

    if( defined $tagType ){
        $tagTypeId = $tagType->id;
    }

    my @bibtex_tags = $entry->get_tags_from_bibtex();

    my @tags;
    for my $tag (@bibtex_tags){

        my $tag_form_storage = $self->tags_find( sub { $_->equals($tag) });

        if( $tag_form_storage ){
            push @tags, $tag_form_storage;
        }
        else{
            $tag->type($tagTypeId); 
            $self->add($tag);
            push @tags, $tag;
        }
    }
    my $num_tags_assigned = 0;
    if( @tags ){
        $num_tags_assigned = $entry->assign_tag( @tags );
    }
    return $num_tags_assigned;
}
####################################################################################
no Moose;
__PACKAGE__->meta->make_immutable;
1;
