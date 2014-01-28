use strict;
use warnings FATAL => 'all';

############################################################################
# Note: I could have used Regexp::Grammars, Marpa. But kcachegrind already
# did the job very nicely, so I just reproduce here in perl what has been
# done there.
# Therefore the full logic belongs to kcachegrind. De-facto the license
# is the kcachegrind one.
############################################################################
# This file is a perl version of kcachegrind. Its license is:
#
# This file is part of KCachegrind.
#  Copyright (C) 2002 - 2010 Josef Weidendorfer <Josef.Weidendorfer@gmx.de>
#
#  KCachegrind is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public
#  License as published by the Free Software Foundation, version 2.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#  General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; see the file COPYING.  If not, write to
#  the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
#  Boston, MA 02110-1301, USA.
############################################################################

# --------------------------------------------------------------------------


# --------------------------------------------------------------------------


# --------------------------------------------------------------------------

package Devel::NYTProf::Data::Plugin::Callgrind;

use constant {
    SelfCost => 0,
    CallCost => 1,
    BoringJump => 2,
    CondJump => 3
};
use constant {
    _emptyString => '',
};

=head1 NAME

Devel::NYTProf::Data::Plugin::Callgrind - L<Devel::NYTProf> callgrind data loading and manipulation

=head1 SYNOPSIS

  use Devel::NYTProf::Data::Plugin::Callgrind;

  $profile = Devel::NYTProf::Data::Callgrind::Default->new->load_profile_data_from_file(
        $file,
        $callbackHashRef,
  );

=head1 DESCRIPTION

Reads a profile data file written by L<callgrind|http://valgrind.org/docs/manual/cl-manual.html>.

=head1 METHODS

=head2 new($class)

Instanciate a new object.

=cut

sub new {
    my ($class, $set) = @_;
    my $self = {
    };
    bless $self, $class;
    return $self;
}


=head2 load_profile_data_from_file($self, $file, $callbackHashRef)

Reading profile data written by L<callgrind|http://valgrind.org/docs/manual/cl-manual.html>.

=cut

sub load_profile_data_from_file {
  my ($self, $filename, $callbacks) = @_;

  return $self->loadInternal($filename, $callbacks);
}

sub loadInternal {
  my ($self, $filename, $callbacks) = @_;

  my $lineNo = 0;
  my $_part = 0;
  my $partsAdded = 0;

}

=head1 SEE ALSO

L<Devel::NYTProf>

L<callgrind|http://valgrind.org/docs/manual/cl-manual.html>

=cut

1;
