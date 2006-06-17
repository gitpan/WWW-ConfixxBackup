# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl WWW-ConfixxBackup.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 6;
use WWW::ConfixxBackup::Confixx;
ok(1); # If we made it this far, we're ok.

my $confixx = WWW::ConfixxBackup::Confixx->new();
ok(ref($confixx) eq 'WWW::ConfixxBackup::Confixx');

$confixx->user('user');
$confixx->server('server');
$confixx->password('password');

ok($confixx->user eq 'user');
ok($confixx->server eq 'server');
ok($confixx->password eq 'password');

my @methods = qw(
                  new
                  login
                  create_backup
                  user
                  password
                  server
                  mech
                );

can_ok($confixx,@methods);