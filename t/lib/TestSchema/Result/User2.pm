package
  TestSchema::Result::User2;
our $VERSION = '0.11';

use base 'DBIx::Class';

__PACKAGE__->load_components(qw(Core));

__PACKAGE__->table('user');

__PACKAGE__->add_columns(

    id => { data_type => 'integer' },
    name => { data_type => 'character varying' },
    password => { data_type => 'character varying' },
    
);

__PACKAGE__->set_primary_key('id');

sub dummy { my $self = shift; my $id = $self->id;  $self->name . "($id)"  } 

1;