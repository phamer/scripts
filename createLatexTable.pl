#!/usr/bin/env perl

# required for non-destructive sub (s///r)
use 5.014;

use strict;
use warnings;
use autodie;
use Getopt::Std;

sub Usage()
{
	print STDERR "Usage: createLatexTable.pl [options] inputfile\n";
	print STDERR "              options:\n";
	print STDERR "                      -d delimiter        [\" \"]\n";
	print STDERR "                      -i indent-chars     [\"  \"]\n";
	exit 1;
}

my %args;

getopts( "d:i:", \%args ) or Usage();

my $fname = shift || Usage();

my $delim = $args{d} =~ s/\\t/\t/r || " ";
my $indent = $args{i} =~ s/\\t/\t/r || "  ";

open F, "<", $fname;
my @fcontent = <F>;
close F;
chomp for @fcontent;

my @header = $fcontent[0] =~ m/^#/ ? split /$delim/, shift( @fcontent ) : ();
if( $#header > -1 ) {
	$header[0] =~ s/^# *//;
	shift @header if $header[0] eq '';
}

#
# be a bit smart and assume first col to be some string, rest numbers... :P
print "\\begin{tabular}{r".("l" x ((scalar split /$delim/, $fcontent[0]) -1 ))."}\n";
print $indent."\\toprule\n";
print $indent.join(" & ", @header)." \\\\\n"                         if scalar @header;
print $indent."\\midrule\n"                                             if scalar @header;
print $indent.join( " & ", split( /$delim/, $_ ))." \\\\\n"               for ( @fcontent );
print $indent."\\bottomrule\n";
print "\\end{tabular}\n";

