# This code was auto-generated using ArchitectureGenerator.pl on 2017-01-15T15:07:35
package RepositoryFacade;
use namespace::autoclean;
use Moose;
use Try::Tiny;

has 'lr' => ( is => 'ro', isa => 'LayeredRepository', required => 1 );


sub hardReset {
    my $self = shift;
    return $self->lr->hardReset;
}

sub _getIdProvider {
    my $self = shift;
    my $type = shift;
    return $self->lr->uidProvider->get_provider($type);
}


#<<< no perltidy here
sub authors_all    { my ($self, @params) = @_; return $self->lr->all('Author', @params);    }
sub authors_count  { my ($self, @params) = @_; return $self->lr->count('Author', @params);  }
sub authors_empty  { my ($self, @params) = @_; return $self->lr->empty('Author', @params);  }
sub authors_exists { my ($self, @params) = @_; return $self->lr->exists('Author', @params); }
sub authors_save   { my ($self, @params) = @_; return $self->lr->save('Author', @params);   }
sub authors_update { my ($self, @params) = @_; return $self->lr->update('Author', @params); }
sub authors_delete { my ($self, @params) = @_; return $self->lr->delete('Author', @params); }
sub authors_filter { my ($self, @params) = @_; return $self->lr->filter('Author', @params); }
sub authors_find   { my ($self, @params) = @_; return $self->lr->find('Author', @params);   }
#>>> 

#<<< no perltidy here
sub authorships_all    { my ($self, @params) = @_; return $self->lr->all('Authorship', @params);    }
sub authorships_count  { my ($self, @params) = @_; return $self->lr->count('Authorship', @params);  }
sub authorships_empty  { my ($self, @params) = @_; return $self->lr->empty('Authorship', @params);  }
sub authorships_exists { my ($self, @params) = @_; return $self->lr->exists('Authorship', @params); }
sub authorships_save   { my ($self, @params) = @_; return $self->lr->save('Authorship', @params);   }
sub authorships_update { my ($self, @params) = @_; return $self->lr->update('Authorship', @params); }
sub authorships_delete { my ($self, @params) = @_; return $self->lr->delete('Authorship', @params); }
sub authorships_filter { my ($self, @params) = @_; return $self->lr->filter('Authorship', @params); }
sub authorships_find   { my ($self, @params) = @_; return $self->lr->find('Authorship', @params);   }
#>>> 

#<<< no perltidy here
sub entries_all    { my ($self, @params) = @_; return $self->lr->all('Entry', @params);    }
sub entries_count  { my ($self, @params) = @_; return $self->lr->count('Entry', @params);  }
sub entries_empty  { my ($self, @params) = @_; return $self->lr->empty('Entry', @params);  }
sub entries_exists { my ($self, @params) = @_; return $self->lr->exists('Entry', @params); }
sub entries_save   { my ($self, @params) = @_; return $self->lr->save('Entry', @params);   }
sub entries_update { my ($self, @params) = @_; return $self->lr->update('Entry', @params); }
sub entries_delete { my ($self, @params) = @_; return $self->lr->delete('Entry', @params); }
sub entries_filter { my ($self, @params) = @_; return $self->lr->filter('Entry', @params); }
sub entries_find   { my ($self, @params) = @_; return $self->lr->find('Entry', @params);   }
#>>> 

#<<< no perltidy here
sub exceptions_all    { my ($self, @params) = @_; return $self->lr->all('Exception', @params);    }
sub exceptions_count  { my ($self, @params) = @_; return $self->lr->count('Exception', @params);  }
sub exceptions_empty  { my ($self, @params) = @_; return $self->lr->empty('Exception', @params);  }
sub exceptions_exists { my ($self, @params) = @_; return $self->lr->exists('Exception', @params); }
sub exceptions_save   { my ($self, @params) = @_; return $self->lr->save('Exception', @params);   }
sub exceptions_update { my ($self, @params) = @_; return $self->lr->update('Exception', @params); }
sub exceptions_delete { my ($self, @params) = @_; return $self->lr->delete('Exception', @params); }
sub exceptions_filter { my ($self, @params) = @_; return $self->lr->filter('Exception', @params); }
sub exceptions_find   { my ($self, @params) = @_; return $self->lr->find('Exception', @params);   }
#>>>

#<<< no perltidy here
sub labelings_all    { my ($self, @params) = @_; return $self->lr->all('Labeling', @params);    }
sub labelings_count  { my ($self, @params) = @_; return $self->lr->count('Labeling', @params);  }
sub labelings_empty  { my ($self, @params) = @_; return $self->lr->empty('Labeling', @params);  }
sub labelings_exists { my ($self, @params) = @_; return $self->lr->exists('Labeling', @params); }
sub labelings_save   { my ($self, @params) = @_; return $self->lr->save('Labeling', @params);   }
sub labelings_update { my ($self, @params) = @_; return $self->lr->update('Labeling', @params); }
sub labelings_delete { my ($self, @params) = @_; return $self->lr->delete('Labeling', @params); }
sub labelings_filter { my ($self, @params) = @_; return $self->lr->filter('Labeling', @params); }
sub labelings_find   { my ($self, @params) = @_; return $self->lr->find('Labeling', @params);   }
#>>>

#<<< no perltidy here
sub memberships_all    { my ($self, @params) = @_; return $self->lr->all('Membership', @params);    }
sub memberships_count  { my ($self, @params) = @_; return $self->lr->count('Membership', @params);  }
sub memberships_empty  { my ($self, @params) = @_; return $self->lr->empty('Membership', @params);  }
sub memberships_exists { my ($self, @params) = @_; return $self->lr->exists('Membership', @params); }
sub memberships_save   { my ($self, @params) = @_; return $self->lr->save('Membership', @params);   }
sub memberships_update { my ($self, @params) = @_; return $self->lr->update('Membership', @params); }
sub memberships_delete { my ($self, @params) = @_; return $self->lr->delete('Membership', @params); }
sub memberships_filter { my ($self, @params) = @_; return $self->lr->filter('Membership', @params); }
sub memberships_find   { my ($self, @params) = @_; return $self->lr->find('Membership', @params);   }
#>>>

#<<< no perltidy here
sub tags_all    { my ($self, @params) = @_; return $self->lr->all('Tag', @params);    }
sub tags_count  { my ($self, @params) = @_; return $self->lr->count('Tag', @params);  }
sub tags_empty  { my ($self, @params) = @_; return $self->lr->empty('Tag', @params);  }
sub tags_exists { my ($self, @params) = @_; return $self->lr->exists('Tag', @params); }
sub tags_save   { my ($self, @params) = @_; return $self->lr->save('Tag', @params);   }
sub tags_update { my ($self, @params) = @_; return $self->lr->update('Tag', @params); }
sub tags_delete { my ($self, @params) = @_; return $self->lr->delete('Tag', @params); }
sub tags_filter { my ($self, @params) = @_; return $self->lr->filter('Tag', @params); }
sub tags_find   { my ($self, @params) = @_; return $self->lr->find('Tag', @params);   }
#>>>

#<<< no perltidy here
sub tagTypes_all    { my ($self, @params) = @_; return $self->lr->all('TagType', @params);    }
sub tagTypes_count  { my ($self, @params) = @_; return $self->lr->count('TagType', @params);  }
sub tagTypes_empty  { my ($self, @params) = @_; return $self->lr->empty('TagType', @params);  }
sub tagTypes_exists { my ($self, @params) = @_; return $self->lr->exists('TagType', @params); }
sub tagTypes_save   { my ($self, @params) = @_; return $self->lr->save('TagType', @params);   }
sub tagTypes_update { my ($self, @params) = @_; return $self->lr->update('TagType', @params); }
sub tagTypes_delete { my ($self, @params) = @_; return $self->lr->delete('TagType', @params); }
sub tagTypes_filter { my ($self, @params) = @_; return $self->lr->filter('TagType', @params); }
sub tagTypes_find   { my ($self, @params) = @_; return $self->lr->find('TagType', @params);   }
#>>>

#<<< no perltidy here
sub teams_all    { my ($self, @params) = @_; return $self->lr->all('Team', @params);    }
sub teams_count  { my ($self, @params) = @_; return $self->lr->count('Team', @params);  }
sub teams_empty  { my ($self, @params) = @_; return $self->lr->empty('Team', @params);  }
sub teams_exists { my ($self, @params) = @_; return $self->lr->exists('Team', @params); }
sub teams_save   { my ($self, @params) = @_; return $self->lr->save('Team', @params);   }
sub teams_update { my ($self, @params) = @_; return $self->lr->update('Team', @params); }
sub teams_delete { my ($self, @params) = @_; return $self->lr->delete('Team', @params); }
sub teams_filter { my ($self, @params) = @_; return $self->lr->filter('Team', @params); }
sub teams_find   { my ($self, @params) = @_; return $self->lr->find('Team', @params);   }
#>>>

#<<< no perltidy here
sub types_all    { my ($self, @params) = @_; return $self->lr->all('Type', @params);    }
sub types_count  { my ($self, @params) = @_; return $self->lr->count('Type', @params);  }
sub types_empty  { my ($self, @params) = @_; return $self->lr->empty('Type', @params);  }
sub types_exists { my ($self, @params) = @_; return $self->lr->exists('Type', @params); }
sub types_save   { my ($self, @params) = @_; return $self->lr->save('Type', @params);   }
sub types_update { my ($self, @params) = @_; return $self->lr->update('Type', @params); }
sub types_delete { my ($self, @params) = @_; return $self->lr->delete('Type', @params); }
sub types_filter { my ($self, @params) = @_; return $self->lr->filter('Type', @params); }
sub types_find   { my ($self, @params) = @_; return $self->lr->find('Type', @params);   }
#>>>

#<<< no perltidy here
sub users_all    { my ($self, @params) = @_; return $self->lr->all('User', @params);    }
sub users_count  { my ($self, @params) = @_; return $self->lr->count('User', @params);  }
sub users_empty  { my ($self, @params) = @_; return $self->lr->empty('User', @params);  }
sub users_exists { my ($self, @params) = @_; return $self->lr->exists('User', @params); }
sub users_save   { my ($self, @params) = @_; return $self->lr->save('User', @params);   }
sub users_update { my ($self, @params) = @_; return $self->lr->update('User', @params); }
sub users_delete { my ($self, @params) = @_; return $self->lr->delete('User', @params); }
sub users_filter { my ($self, @params) = @_; return $self->lr->filter('User', @params); }
sub users_find   { my ($self, @params) = @_; return $self->lr->find('User', @params);   }
#>>>

__PACKAGE__->meta->make_immutable;
no Moose;
1;
