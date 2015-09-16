#!/usr/bin/env perl

use strict;
use warnings;

use feature 'say';

use Getopt::Long;

use autodie;

my $s_types = "figure,table";

GetOptions(
	'type|t=s' => \$s_types,
);

# store types as hash, easier to check if that type is wanted
my %types = map { $_ => 1 } split ',', $s_types;

# store envs here, needed for sth like
# figure
#   subfigure
#     caption    <-- maybe not in %types!
#   end-subfigure
#   caption
# end-figure
my @active_envs;

foreach my $filename ( @ARGV ) {
	# first, read file and close it
	#  will be overwritten below
	open my $f_old, '<', $filename;
	my @old_content = <$f_old>;
	close $f_old;

	my @new_content;

	my $in_env = 0;
	# loop over lines
	foreach my $line ( @old_content ) {
		# check if a new environment starts
		if( $line =~ m/\\begin\{([a-z]+)\}/ ) {
			my $env = $1;
			push @active_envs, $env;
		}
		# or ends
		elsif( $line =~ m/\\end\{([a-z]+)\}/ ) {
			if( $1 eq $active_envs[-1] ) {
				my $env = pop @active_envs;
			}
		}

		# check if the current environment is the correct one
		unless( @active_envs && correct_env( $active_envs[ -1 ] ) ) {
			push @new_content, $line;
			next;
		}

		# get new short-caption
		if( $line =~ m/\\caption/ ) {
			chomp $line;
			# get caption parts
			my ($front, $short, $long, $end ) = ( $line =~ m/(.*)\\caption(\[[^\]]*\])?(\{.*\})(.*)/ );

			$short = '' unless defined $short;

			# query for new short-caption
			say "[".$active_envs[-1]."]: caption = ".$long;
			say   "     current short-caption = ".$short;
			print ">>>> new short-caption = ";
			my $new_short = <STDIN>; chomp $new_short;

			# format new short caption correctly
			if( $new_short eq 'keep' || $new_short eq '' ) {
				$new_short = $short;
			} else {
				$new_short = '['.$new_short.']';
			}

			# create new line that will replace the old line
			$line = join '', ( 
				$front,
				'\caption',
				$new_short,
				$long,
				$end,
				"\n"
			);
		}
		push @new_content, $line;
	}

	open my $f_new, '>', $filename;
	print $f_new $_ for @new_content;
	close $f_new;
}

sub correct_env
{
	my $env = shift;
	return exists( $types{ $env } );
}



