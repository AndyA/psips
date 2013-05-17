#!/usr/bin/env perl

use strict;
use warnings;

while ( my $f = shift ) {
  chomp(
    my $ver = do {
      local $/;
      open my $fh, '<', $f or die "Can't read $f: $!\n";
      <$fh>;
     }
  );
  die "Malformed version: $ver" unless $ver =~ /^\d+\.\d\d$/;
  my ( $maj, $min ) = split( /\./, $ver, 2 );
  if ( ++$min > 99 ) { $min = 0; ++$maj }
  {
    open my $fh, '>', $f or die "Can't write $f: $!\n";
    printf $fh "%d.%02d\n", $maj, $min;
  }
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

