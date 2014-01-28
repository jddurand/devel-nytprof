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

package Devel::NYTProf::Data::Plugin::Callgrind::EventType;
use Devel::NYTProf::Data::Plugin::Callgrind::EventTypeSet;
sub new {
    my ($class, $name, $longName, $formula) = @_;

    my $self = {
	_name          => $name,
	_longName      => $longName,
	_formula       => $formula,
	_parsedFormula => undef,
	_set           => 0,
	_parsed        => 0,
	_inParsing     => 0,
	_isReal        => $formula ? 1 : 0,
	_coefficient   => [],
	_realIndex     => -1,
	_knownTypes    => {},
    };

    return bless {}, shift;
}

sub set {
    my ($self) = @_;

    return $self->{_set};
}

sub realIndex {
    my ($self) = @_;

    return $self->{_realIndex};
}

sub isReal {
    my ($self) = @_;

    return $self->{_isReal};
}

sub setFormula {
    my ($self, $formula) = @_;

    $self->{_formula} = $formula;
    $self->{_realIndex} = -1;
    $self->{_parsed} = 0;
    $self->{_isReal} = 0;

    return;
}

sub setEventTypeSet {
    my ($self, $m) = @_;

    $self->{_parsed} = 0;
    $self->{_set} = $m;

    return;
}

sub setRealIndex {
    my ($self, $i) = @_;   

    $i = -1 if ($i < 0);
    $self->{_realIndex} = $i;
    $self->{_formula} = '';
    $self->{_isReal} = 1;

    return;
}

sub parseFormula {
    my ($self) = @_;

    return 1 if ($self->isReal());
    return 1 if ($self->{_parsed});

    if ($self->{_inParsing}) {
	warn "TraceEventType::parseFormula: Recursion detected.";
	return 0;
    }

    if (! $self->{_set}) {
	warn "TraceEventType::parseFormula: Container of this event type unknown!";
	return 0;
    }

    $self->{_inParsing} = 1;

    $self->{_coefficient} = [];
    $self->{_parsedFormula} = '';

    my $found = 0;    # how many types are referenced in formula
    my $matching = 0; # how many types actually are defined in profile data
    my $pos = 0;
    while ($self->{_formula} =~ m/((?:\+|\-)?)\s*(\d*)\s*\*?\s*(\w+)/g) {
	$found++;

	my $costName = substr($self->{_formula}, $-[3], $+[3] - $-[3]);
	my $eventType = $self->{_set}->type($costName);
	if (! $eventType) {
	    next;
	}

	my $factor = ($+[2] > 0) ? int(substr($self->{_formula}, $-[2], $+[2] - $-[2])) : 1;
	$factor = -$factor if ($+[1] > 0 && substr($self->{_formula}, $-[1], $+[1] - $-[1]) eq '-') ;
	if ($factor == 0) {
	    next;
	}

	$matching++;

	if (! $self->{_parsedFormula}) {
	    $self->{_parsedFormula} .= sprintf(" %s ", ($factor>0) ? '+':'-');
	}
	elsif ($factor<0) {
	    $self->{_parsedFormula} .= '- ';
	}
	if (($factor!=-1) && ($factor!=1)) {
	    $self->{_parsedFormula} .= ( ($factor>0)?$factor:-$factor ) . ' ';
	}
	$self->{_parsedFormula} .= $costName;

	if ($eventType->isReal()) {
	    $self->{_coefficient}[$eventType->realIndex()] += $factor;
	} else {
	    $eventType->parseFormula();
	    for (my $i=0; $i<$#{$self->{_coefficient}};$i++) {
		$self->{_coefficient}[$i] += $factor * $eventType->{_coefficient}[$i];
	    }
	}
    }

    $self->{_inParsing} = 0;
    if ($found == 0) {
	# empty formula
	$self->{_parsedFormula} = '0';
	$self->{_parsed} = 1;
	return 1;
    }
    if ($matching>0) {
	$self->{_parsed} = 1;
	return 1;
    }
    return 0;
}

1;
