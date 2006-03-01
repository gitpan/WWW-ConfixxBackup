package WWW::ConfixxBackup;

use 5.006001;
use strict;
use warnings;
use WWW::ConfixxBackup::Confixx;
use WWW::ConfixxBackup::FTP;

our $VERSION = '0.01';

sub new{
  my ($class) = @_;
  my $self = {};
  bless $self,$class;
  
  return $self;
}# new

sub ftp_user{
  my ($self,$user) = @_;
  $self->{ftp_user} = $user if(defined $user);
  return $self->{ftp_user};
}# ftp_user

sub ftp_server{
  my ($self,$server) = @_;
  $self->{ftp_server} = $server if(defined $server);
  return $self->{ftp_server};
}# ftp_server

sub ftp_password{
  my ($self,$password) = @_;
  $self->{ftp_password} = $password if(defined $password);
  return $self->{ftp_password};
}#ftp_password

sub user{
  my ($self,$user) = @_;
  if(defined $user){
    $self->ftp_user($user);
    $self->confixx_user($user);
  }
  return $self->ftp_user;
}# user

sub server{
  my ($self,$server) = @_;
  if(defined $server){
    $self->ftp_server($server);
    $self->confixx_server($server);
  }
  return $self->ftp_server;
}# server

sub password{
  my ($self,$password) = @_;
  if(defined $password){
    $self->ftp_password($password);
    $self->confixx_password($password);
  }
  return $self->ftp_password;
}# password

sub confixx_user{
  my ($self,$user) = @_;
  $self->{confixx_user} = $user if(defined $user);
  return $self->{confixx_user};
}# confixx_user

sub confixx_server{
  my ($self,$server) = @_;
  $self->{confixx_server} = $server if(defined $server);
  return $self->{confixx_server};
}# confixx_server

sub confixx_password{
  my ($self,$password) = @_;
  $self->{confixx_password} = $password if(defined $password);
  return $self->{confixx_password};
}# confixx_pasword

sub login{
  my ($self) = @_;
  $self->ftp_login or return undef;
  $self->confixx_login or return undef;
}# login

sub ftp_login{
  my ($self) = @_;
  $self->{FTP} = WWW::ConfixxBackup::FTP->new(user     => $self->ftp_user,
                                              password => $self->ftp_password,
                                              server   => $self->ftp_server,
                                              );
  return undef if(ref($self->{FTP}->ftp) ne 'Net::FTP');
  return 1;
}# ftp_login

sub confixx_login{
  my ($self) = @_;
  $self->{CONFIXX} = WWW::ConfixxBackup::Confixx->new(user     => $self->confixx_user,
                                                      password => $self->confixx_password,
                                                      server   => $self->confixx_server,
                                                     );
  return undef if(ref($self->{CONFIXX}->mech) ne 'WWW::Mechanize');
  return 1;
}# confixx_login

sub backup_download{
  my ($self,$path) = @_;
  unless($self->{CONFIXX}){
    $self->confixx_login;
  }
  unless($self->{FTP}){
    $self->ftp_login;
  }
  if(defined $path && $self->{CONFIXX} && $self->{FTP}){
    $self->{CONFIXX}->backup();
    $self->{FTP}->download($path);
  }
}# backup_download

sub download{
  my ($self,$path) = @_;
  unless($self->{FTP}){
    $self->ftp_login;
  }
  if($self->{FTP}){
    $self->{FTP}->download($path);
  }
}# download

sub backup{
  my ($self) = @_;
  unless($self->{CONFIXX}){
    $self->confixx_login;
  }
  if($self->{CONFIXX}){
    $self->{CONFIXX}->backup;
  }
}# backup


# Preloaded methods go here.

1;

__END__

=head1 NAME

WWW::ConfixxBackup - Create Backups with Confixx and download them via FTP

=head1 SYNOPSIS

  use WWW::ConfixxBackup;
  
  #shortes way (and Confixx and FTP use the same login data)
  my $backup = WWW::ConfixxBackup->new(user => 'user', password => 'user', server => 'server');
  my $path = './backups/today/';
  $backup->backup_download($path);
  
  #longer way (and different Confixx and FTP login data)
  my $backup = WWW::ConfixxBackup();
  $backup->ftp_user('ftp_user');
  $backup->ftp_password('ftp_password');
  $backup->ftp_server('server');
  $backup->ftp_login();
  $backup->confixx_user('confixx_user');
  $backup->confixx_password('confixx_password');
  $backup->confixx_server('confixx_server');
  $backup->confixx_login();
  $backup->backup();
  $backup->download($path);

=head1 DESCRIPTION

This module aims to simplify backups via Confixx and FTP. It logs in Confixx,
creates the backups and downloads the backups via FTP.

=head2 METHODS

=head3 new

  my $backup = WWW::ConfixxBackup->new();
  
creates a new C<WWW::ConfixxBackup> object.

=head3 user

  $backup->user('username');
  print $backup->user();

=head3 password

  $backup->password('password');
  print $backup->password();

=head3 server

  $backup->server('server');
  print $backup->server();

=head3 confixx_user

  $backup->confixx_user('confixx_username');
  print $backup->confixx_user();

=head3 confixx_password

  $backup->confixx_password('confixx_password');
  print $backup->confixx_password();

=head3 confixx_server

  $backup->confixx_server('confixx_server');
  print $backup->confixx_server();

=head3 ftp_user

  $backup->ftp_user('ftp_user');
  print $backup->ftp_user();

=head3 ftp_password

  $backup->ftp_password('ftp_password');
  print $backup->ftp_password();

=head3 ftp_server

  $backup->ftp_server('ftp_server');
  print $backup->ftp_server();

=head3 confixx_login

  $backup->confixx_login();

=head3 ftp_login

  $backup->ftp_login();

login on FTP server

=head3 backup

  $backup->backup();

Logs in to Confixx and creates the backups

=head3 download

  $backup->download('/path/to/directory');

downloads the three files that are created by Confixx:
  * mysql.tar.gz
  * html.tar.gz
  * files.tar.gz

to the given path. If path is omitted, the files are downloaded to the
current directory.

=head3 backup_download

  $backup->backup_download('/path/to/directory/');

logs in to Confixx, create the backup files and downloads the three files that 
are created by Confixx:
  * mysql.tar.gz
  * html.tar.gz
  * files.tar.gz

to the given path. If path is omitted, the files are downloaded to the
current directory.

=head1 SEE ALSO

  WWW::ConfixxBackup::Confixx
  WWW::ConfixxBackup::FTP
  WWW::Mechanize
  Net::FTP

=head1 AUTHOR

Renee Baecker, E<lt>module@renee-baecker.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Renee Baecker

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.6 or,
at your option, any later version of Perl 5 you may have available.


=cut
