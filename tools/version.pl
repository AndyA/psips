#!/usr/bin/env perl

use strict;
use warnings;

use POSIX qw( strftime );

sub define($$) {
  my ( $n, $v ) = @_;
  print "#define $n \"$v\"\n";
}

sub slurp($) {
  local $/;
  open my $fh, '<', $_[0] or die "Can't read $_[0]: $!\n";
  <$fh>;
}

my %v = (
  V_GIT_HASH => `git rev-parse HEAD`,
  V_DATE     => strftime( '%Y-%m-%d', gmtime ),
  V_VERSION  => slurp 'VERSION',
);

chomp for values %v;

my %h = (
  defines => sub {
    while ( my ( $n, $v ) = each %v ) {
      define $n, $v;
    }
    define V_INFO => "$v{V_VERSION} ($v{V_DATE}, $v{V_GIT_HASH})";
  }
);

while (<DATA>) {
  if (/^\.(\w+)(?:\s+(.*))?$/) {
    my ( $inc, $arg ) = ( $1, $2 );
    ( $h{$inc} || die "$inc?\n" )->( split ' ', $arg );
    next;
  }
  print;
}

__DATA__
/* version.h */

#ifndef __VERSION_H
#define __VERSION_H

.defines

#endif
