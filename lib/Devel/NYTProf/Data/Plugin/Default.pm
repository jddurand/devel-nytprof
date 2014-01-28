use strict;
use warnings FATAL => 'all';

package Devel::NYTProf::Data::Plugin::Default;
use Devel::NYTProf::Data;

=head1 NAME

Devel::NYTProf::Data::Plugin::Default - L<Devel::NYTProf> default data loading and manipulation

=head1 SYNOPSIS

  use Devel::NYTProf::Data::Plugin::Default;

  $profile = Devel::NYTProf::Data::Plugin::Default->new->load_profile_data_from_file(
        $file,
        $callbackHashRef,
  );

=head1 DESCRIPTION

Reads a profile data file written by L<Devel::NYTProf>.

=head1 METHODS

=head2 new($class)

Instantiate a new object.

=cut

sub new {
    return bless {}, shift;
}

=head2 load_profile_data_from_file($self, $file, $callbackHashRef)

Reading profile data written by L<Devel::NYTProf>.

=cut

sub load_profile_data_from_file {
  my $self = shift;
  #
  # This method is in the XS and is a static method, i.e. no
  # class nor instance parameter.
  #
  Devel::NYTProf::Data::load_profile_data_from_file(@_);
  return;
}

=head1 SEE ALSO

L<Devel::NYTProf::Data>

=cut

1;
