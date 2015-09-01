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
	print STDERR "              if inputfile is '-', reads from STDIN\n";
	print STDERR "              options:\n";
	print STDERR "                      -d delimiter        [\" \"]\n";
	print STDERR "                      -i indent-chars     [\"  \"]\n";
	print STDERR "                      -n : surround numbers by \$\$\n";
	exit 1;
}

my %args;

getopts( "d:i:n", \%args ) or Usage();

my $fname = shift || Usage();

my $delim = " ";
my $indent = "  ";

$delim = $args{d} =~ s/\\t/\t/r if $args{d};
$indent = $args{i} =~ s/\\t/\t/r if $args{i};

my @fcontent;
if( $fname eq '-' ) {
	@fcontent = <STDIN>;
} else {
	open my $f, "<", $fname;
	@fcontent = <$f>;
	close $f;
}
chomp for @fcontent;

# remove blank lines at the beginning
shift( @fcontent ) while $fcontent[0] =~ m/^\s*$/;

my @header = $fcontent[0] =~ m/^#/ ? split /$delim/, shift( @fcontent ) : ();
if( $#header > -1 ) {
	$header[0] =~ s/^# *//;
	shift @header if $header[0] eq '';
}

# use surrounding $ for numbers?
if( $args{n} ) {
	foreach my $entry (@fcontent) {
		my @values = split /$delim/, $entry;
		foreach my $value (@values ) {
			$value = "\$".$value."\$" if $value =~ m/^[0-9,\.\-\+ \/]+$/;
			$value =~ s{\+/-}{\\pm}g;
		}
		$entry = join "$delim", @values;
	}
}

#
# be a bit smart and assume first col to be some string, rest numbers... :P
print "\\begin{tabular}{l".("r" x ((scalar split /$delim/, $fcontent[0]) -1 ))."}\n";
print $indent."\\toprule\n";
print $indent.join(" & ", @header)." \\\\\n"                         if scalar @header;
print $indent."\\midrule\n"                                             if scalar @header;
print $indent.join( " & ", split( /$delim/, $_ ))." \\\\\n"               for ( @fcontent );
print $indent."\\bottomrule\n";
print "\\end{tabular}\n";

