#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

use HEP::Names::LaTeX qw( particle_to_latex );

my $fname = shift || die;

open my $f, '<', $fname;
my @lines = <$f>;
close $f;

my (@decs, @numbers);
my $sum = 0;

for ( @lines ) {
	if( m/([0-9.]+): (.*) \(/ ) {
		my ($n, $dec) = ($1, $2);
		$dec =~ s/ -.*//;
		$sum += $n;
		push @decs, $dec;
		push @numbers, $n;
	}
}

for my $i ( 0 .. $#decs ) {
	my $s = particle_to_latex( $decs[$i] );
	printf( "\$%s\$\t%.2f\n", $s, $numbers[$i]*100.0/$sum );
}
print "sum\t$sum\n";

