# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl WWW-ConfixxBackup.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 7;
use FindBin ();

use WWW::ConfixxBackup::Confixx;
ok(1); # If we made it this far, we're ok.

my $backup = WWW::ConfixxBackup::Confixx->new();
ok(ref($backup) eq 'WWW::ConfixxBackup::Confixx');


my $t_user           = 'username';
my $t_password       = 'password';
my $t_server         = 'confixx_server';

my %hash;
if(open(my $fh,"<",$FindBin::Bin . '/userfile.txt')){
  while(my $line = <$fh>){
    chomp $line;
    next if($line =~ /^\s*$/);
    my ($key,$value) = split(/=/,$line,2);
    $hash{$key} = $value;
  }
  close $fh;
}

my $user = $hash{user} || $hash{confixx_user} || $hash{ftp_user} || $t_user;
my $pwd = $hash{password} || $hash{confixx_password} || $hash{ftp_password} || $t_password;
my $server = $hash{server} || $hash{confixx_server} || $t_server;

print STDERR sprintf("%s :: %s :: %s",$user,$pwd,$server);

$backup->user($user);
$backup->password($pwd);
$backup->server($server);

ok($backup->user eq $user);
ok($backup->password eq $pwd);
ok($backup->server eq $server);

SKIP: {
  skip "no internet connection",2 if(ref($backup->mech) ne 'WWW::Mechanize');
  
  ok($backup->login() == 1);
  ok($backup->create_backup() == 1);
}
