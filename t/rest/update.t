use Test::More;

use strict;
use warnings;

use HTTP::Request::Common;
use JSON;

use lib qw(t/lib);

use Test::WWW::Mechanize::Catalyst 'MyApp';

my $mech = Test::WWW::Mechanize::Catalyst->new();

$mech->add_header('Accept' => 'application/json');
my $json;

$mech->get_ok('/users', undef, 'request list of users');
ok($json = JSON::decode_json($mech->content), 'response is JSON response');

{ # create user2 without dummy column
    my $res = $mech->request(POST '/user2', [name => 'bar', password => 'foo']);
    ok($json = JSON::decode_json($res->content), 'response is JSON response');
    is($json->{success}, 'true', 'create dummy user  was successful');
}

{ # get back user
    $mech->get_ok('/user2/1', undef, 'get user 1');
    
    ok($json = JSON::decode_json($mech->content), 'response is JSON response');
   
    is($json->{data}->{name}, 'bar', 'user name is "bar"');
    is($json->{data}->{dummy}, 'bar(1)', 'user dummny is "bar(1)"');
}

{ # update user name, and see if the other fields are updated
    my %user_data = %{$json->{data}};
  

#    my $request = POST '/user2/1', [name => 'bas', password => $user_data{password}];

    my $request = POST '/user2/1', [name => 'bas', password => $user_data{password}];
    $request->method('PUT');  # don't use PUT directly because it won't pick up the form parameters
   
    ok($mech->request($request), 'change user name');
    
    ok($json = JSON::decode_json($mech->content), 'response is JSON response');
    
    is($json->{success}, 'true', 'change was successful');
    
    is($json->{data}->{name}, 'bas', 'user name has changed');
    
    # This is the problem that should be addressed !!!!
    is($json->{data}->{dummy}, 'bas', 'dummy has been updated');
}

{ # update bug ?
    my $request = POST '/user2/1', [name => 'toto'];
    $request->method('PUT');  # don't use PUT directly because it won't pick up the form parameters
    
    # another weird thing
    my $res = $mech->request($request);
    ok( $res->is_success, 'can only change user name ?');
  
   
}



done_testing;
