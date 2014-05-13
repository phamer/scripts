#!/usr/bin/env perl

my %cols;
my $maxcol = 30;
while( <> ) {
	my @tmp = split /-/, $_, 2;
	if( $tmp[1] =~ m/^ \[([0-9a-zA-Z:,\._]+)\] (.*)/ ) {
		my ($topic, $rest) = ($1, $2);
		if( ! exists $cols{$topic} ) {
			$maxcol = ( $maxcol + 1 > 36 ) ? 31 : $maxcol+1;
			$cols{$topic} = $maxcol;
		}
		$topic = "\e[1;".$cols{$topic}."m[".$topic."]\e[0m";
		$tmp[1] = " ".$topic." ".$rest."\n";
	}
	print join "-", @tmp;

}