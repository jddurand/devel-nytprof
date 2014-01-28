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

package Devel::NYTProf::Data::Plugin::Callgrind::EventTypeMapping;
sub new {
    my ($class, $set) = @_;
    my $self = {
	_set           => $set,
	_isIdentity    => 1,
	_realIndex     => {},
    };
    bless($self, $class);
    return $self;
}

1;
