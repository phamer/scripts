#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

my $fname = shift || die;

open my $f, '<', $fname;
my @lines = <$f>;
close $f;

my (@decs, @numbers);
my $sum = 0;

for ( @lines ) {
	if( m/([0-9]+): (.*) \(/ ) {
		my ($n, $dec) = ($1, $2);
		$dec =~ s/ -.*//;
		$sum += $n;
		push @decs, $dec;
		push @numbers, $n;
	}
}

for my $i ( 0 .. $#decs ) {
	# escape!
	my $s = $decs[$i];
	$s =~ s/(\*\+|\+|'|0)/^{$1}/g;
	$s =~ s/_([a-zA-Z]+)/_{$1}/g;
	$s =~ s/(gamma|tau|rho|pi|mu|eta|nu)/\\$1/g;
	printf( "%s\t%.2f\n", $s, $numbers[$i]*100.0/$sum );
}

