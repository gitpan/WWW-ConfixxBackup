package WWW::ConfixxBackup::FTP;

use strict;
use warnings;
use Net::FTP;

our $VERSION = '0.01';

sub new{
  my ($class,%args) = @_;
  my $self = {};
  bless $self,$class;
  
  $self->password($args{password});
  $self->user($args{user});
  $self->server($args{server});
  
  return $self;
}# new

sub login{
  my ($self) = @_;
  if(ref($self->ftp) eq 'Net::FTP'){
    $self->ftp()->login($self->user,$self->password) or return 0;
  }
  else{
    return 0;
  }
  return 1;
}# login

sub download{
  my ($self,$path) = @_;
  $path ||= '.';
  eval{
    $self->ftp()->cwd('/backup');
    for(qw/mysql.tar.gz files.tar.gz html.tar.gz/){
      $self->ftp()->get($_,$path.'/'.$_);
    }
  };
  return undef if($@);
  return 1;
}# download

sub password{
  my ($self,$pwd) = @_;
  $self->{password} = $pwd if(defined $pwd);
  return $self->{password};
}# password

sub user{
  my ($self,$user) = @_;
  $self->{user} = $user if(defined $user);
  return $self->{user};
}# user

sub server{
  my ($self,$server) = @_;
  $self->{server} = $server if(defined $server);
  return $self->{server};
}# server

sub ftp{
  my ($self) = @_;
  unless(ref($self->{ftp}) eq 'Net::FTP'){
    $self->{ftp} = Net::FTP->new($self->server);
  }
  return $self->{ftp};
}# mech

sub DESTROY{
  my ($self) = @_;
  $self->ftp()->quit() if(ref($self->ftp) eq 'Net::FTP');
}

1;

__END__
=pod

=head1 NAME

WWW::ConfixxBackup::FTP - the FTP client for WWW::ConfixxBackup

=head1 SYNOPSIS

  use WWW::ConfixxBackup::FTP;
  
  my $ftp = WWW::ConfixxBackup::FTP->new(server => 'server');
  $ftp->user('username');
  $ftp->password('password');
  
  $ftp->login;
  $ftp->download('/path/for/download');

=head1 METHODS

=head2 new

=head2 user

=head2 password

=head2 server

=head2 login

=head2 download

=head2 ftp

=head1 SEE ALSO

  Net::FTP
  
=head1 AUTHOR

Renee Baecker, E<lt>module@renee-baecker.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Renee Baecker

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.

=cut