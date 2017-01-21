# This code was auto-generated using ArchitectureGenerator.pl on 2017-01-14T17:02:11
package BibSpace::Model::DAO::MySQL::TypeMySQLDAO;

use namespace::autoclean;
use Moose;
use BibSpace::Model::DAO::Interface::ITypeDAO;
use BibSpace::Model::Type;
with 'BibSpace::Model::DAO::Interface::ITypeDAO';

# Inherited fields from BibSpace::Model::DAO::Interface::ITypeDAO Mixin:
# has 'logger' => ( is => 'ro', does => 'BibSpace::Model::ILogger', required => 1);
# has 'handle' => ( is => 'ro', required => 1);

=item all
    Method documentation placeholder.
=cut 
sub all {
  my ($self) = @_;

  my $dbh  = shift;

  my $qry = "SELECT bibtex_type, our_type, landing, description
         FROM OurType_to_Type";

  my $sth = $dbh->prepare($qry);
  $sth->execute();

  # key = our_type
  # values = bibtex_types
  my %data_bibtex;
  my %data_desc;
  my %data_landing;

  while ( my $row = $sth->fetchrow_hashref() ) {
    if( $data_bibtex{$row->{our_type}} ){
      push @{ $data_bibtex{$row->{our_type}} }, $row->{bibtex_type};
    }
    else{
      $data_bibtex{$row->{our_type}} = [ $row->{bibtex_type} ];
    }
    $data_desc{$row->{our_type}} = $row->{decription};
    $data_landing{$row->{our_type}} = $row->{landing};
  }
  
  my @mappings;
  foreach my $k (keys %data_bibtex){
    my @bibtex_types = @{ $data_bibtex{$k} };
    my $desc         = $data_desc{$k};
    my $landing      = $data_landing{$k};

    my $obj = MTypeMapping->new( 
      our_type=>$k,
      description => $desc,
      landing => $landing
    );
    $obj->bibtexTypes_add(@bibtex_types);
    push @mappings, $obj;
  }
  return @mappings;
}
before 'all' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->all" ); };
after 'all' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->all" ); };

=item count
    Method documentation placeholder.
    This method takes no arguments and returns array or scalar.
=cut 

sub count {
    my ($self) = @_;

    die "" . __PACKAGE__ . "->count not implemented.";

    # TODO: auto-generated method stub. Implement me!

}
before 'count' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->count" ); };
after 'count' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->count" ); };

=item empty
    Method documentation placeholder.
    This method takes no arguments and returns array or scalar.
=cut 

sub empty {
    my ($self) = @_;

    die "" . __PACKAGE__ . "->empty not implemented.";

    # TODO: auto-generated method stub. Implement me!

}
before 'empty' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->empty" ); };
after 'empty' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->empty" ); };

=item exists
    Method documentation placeholder.
    This method takes single object as argument and returns a scalar.
=cut 

sub exists {
    my ( $self, $object ) = @_;

    die "" . __PACKAGE__ . "->exists not implemented.";

    # TODO: auto-generated method stub. Implement me!

}
before 'exists' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->exists" ); };
after 'exists' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->exists" ); };

=item save
    Method documentation placeholder.
    This method takes single object or array of objects as argument and returns nothing.
=cut 

sub save {
    my ( $self, @objects ) = @_;

    die ""
        . __PACKAGE__
        . "->save not implemented. Method was instructed to save "
        . scalar(@objects)
        . " objects.";

    # TODO: auto-generated method stub. Implement me!

}
before 'save' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->save" ); };
after 'save' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->save" ); };

=item update
    Method documentation placeholder.
    This method takes single object or array of objects as argument and returns nothing.
=cut 

sub update {
    my ( $self, @objects ) = @_;

    die ""
        . __PACKAGE__
        . "->update not implemented. Method was instructed to update "
        . scalar(@objects)
        . " objects.";

    # TODO: auto-generated method stub. Implement me!

}
before 'update' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->update" ); };
after 'update' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->update" ); };

=item delete
    Method documentation placeholder.
    This method takes single object or array of objects as argument and returns nothing.
=cut 

sub delete {
    my ( $self, @objects ) = @_;

    die ""
        . __PACKAGE__
        . "->delete not implemented. Method was instructed to delete "
        . scalar(@objects)
        . " objects.";

    # TODO: auto-generated method stub. Implement me!

}
before 'delete' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->delete" ); };
after 'delete' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->delete" ); };

=item filter
    Method documentation placeholder.
=cut 

sub filter {
    my ( $self, $coderef ) = @_;
    die ""
        . __PACKAGE__
        . "->filter incorrect type of argument. Got: '"
        . ref($coderef)
        . "', expected: "
        . ( ref sub { } ) . "."
        unless ( ref $coderef eq ref sub { } );

    die "" . __PACKAGE__ . "->filter not implemented.";

    # TODO: auto-generated method stub. Implement me!

}
before 'filter' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->filter" ); };
after 'filter' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->filter" ); };

=item find
    Method documentation placeholder.
=cut 

sub find {
    my ( $self, $coderef ) = @_;
    die ""
        . __PACKAGE__
        . "->find incorrect type of argument. Got: '"
        . ref($coderef)
        . "', expected: "
        . ( ref sub { } ) . "."
        unless ( ref $coderef eq ref sub { } );

    die "" . __PACKAGE__ . "->find not implemented.";

    # TODO: auto-generated method stub. Implement me!

}
before 'find' =>
    sub { shift->logger->entering( "", "" . __PACKAGE__ . "->find" ); };
after 'find' =>
    sub { shift->logger->exiting( "", "" . __PACKAGE__ . "->find" ); };
__PACKAGE__->meta->make_immutable;
no Moose;
1;