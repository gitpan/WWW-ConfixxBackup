package WWW::ConfixxBackup::Confixx;

use strict;
use warnings;
use WWW::Mechanize;
use HTTP::Cookies;
use HTTP::Request;

our $VERSION = '0.03';

my %map = (
  'confixx2.0' =>
    {
      backup_id    => '',
      backup_html  => '',
      backup_files => '',
      backup_mysql => '',
      html         =>  1,
      files        =>  1,
      mysql        =>  1,
    },
  'confixx3.0' =>
    {
      'selectAll' => 1,
      'backup[]'  => ['html','files','mysql'],
      action      => 'backup',
      destination => '/backup',
    }
);
my $default_version = 'confixx3.0';

sub new{
  my ($class,%args) = @_;
  my $self = {};
  bless $self,$class;
  
  $self->password($args{password});
  $self->user($args{user});
  $self->server($args{server});
  $self->confixx_version( $args{confixx_version} || $default_version );
  
  return $self;
}# new

sub login{
  my ($self) = @_;
  
  if(ref($self->mech) eq 'WWW::Mechanize'){
    $self->mech->post($self->server . '/login.php',
                                 {username => $self->user, 
                                  password => $self->password,});
    $self->mech->get($self->server . '/user/' . $self->user . '/');
        
    return 0 unless($self->mech->success);
  }
  return 1;
}# login

sub _detect_version{
    my ($self) = @_;
    
    $self->mech->get( $self->server . '/user/' . $self->user . '/tools_backup.php' );
    warn $self->mech->content;
}

sub backup{
  my ($self) = @_;
  $self->mech->post($self->server . '/user/' . $self->user . '/tools_backup2.php',
        $map{$self->confixx_version},
  );
  
  return 0 unless($self->mech->success);
  return 1;
}# create_backup

sub confixx_version{
    my ($self,$version) = @_;
    
    $self->{__version} = $version if defined $version;
    return $self->{__version};
}

sub available_confixx_versions{
    return sort keys %map;
}

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

sub mech{
  my ($self) = @_;
  unless(ref($self->{mechanizer}) eq 'WWW::Mechanize'){
    $self->{cookie_jar} = HTTP::Cookies->new();
    $self->{mechanizer} = WWW::Mechanize->new(
                                    quiet       => 1,
                                    onwarn      => \&mech_warnings,
                                    stack_depth => 1,
                                    cookie_jar  => $self->{cookie_jar},);
    $self->{mechanizer}->get($self->server);
    
    return [] unless($self->{mechanizer}->success);
  }
  return $self->{mechanizer};
}# mech

sub default_version{
    return $default_version;
}

sub mech_warnings{
  #print STDERR "HALLO";
}# mech_warnings

1;

__END__

=pod

=head1 NAME

WWW::ConfixxBackup::Confixx - the Confixx mechanism for WWW::ConfixxBackup

=head1 SYNOPSIS

=head1 METHODS

=head2 new

=head2 user

=head2 password

=head2 server

=head2 backup

=head2 mech_warnings

=head2 mech

=head2 login

=head2 confixx_version

=over 4

=item * confixx2.0

=over 4

=item * backup_id

=item * backup_html

=item * backup_files

=item * backup_mysql

=item * html

=item * files

=item * mysql

=back

=item * confixx3.0

=over 4

=item * selectAll

=item * backup[]

=over 4

=item * html

=item * files

=item * mysql

=back

=item * destination

=item * action

=back

=back

=head2 available_confixx_versions

returns a list of all confixx versions (to be precisely versions of tools_backup2.php) 
that are supported by WWW::ConfixxBackup

=head2 default_version

returns the default value for confixx_version

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
