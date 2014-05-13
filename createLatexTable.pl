#!/usr/bin/env perl

use strict;
use warnings;
use autodie;

sub Usage()
{
	print STDERR "Usage: createLatexTable.pl inputfile\n";
	exit 1;
}

my $fname = shift || Usage();

open F, "<", $fname;
my @fcontent = <F>;
close F;
chomp for @fcontent;

my @header = $fcontent[0] =~ m/^#/ ? split / /, shift( @fcontent ) : ();
if( $#header > -1 ) {
	$header[0] =~ s/^# *//;
	shift @header if $header[0] eq '';
}

#
# be a bit smart and assume first col to be some string, rest numbers... :P
print "\\begin{tabular}{r".("l" x ((scalar split / /, $fcontent[0]) -1 ))."}\n";
print " \\toprule\n";
print " ".join(" & ", @header)." \\\\\n"                         if scalar @header;
print " \\midrule\n"                                             if scalar @header;
print " ".join( " & ", split( / /, $_ ))." \\\\\n"               for ( @fcontent );
print " \\bottomrule\n";
print "\\end{tabular}\n";

