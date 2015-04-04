package ParticleNames;

use strict;
use warnings;

use Exporter qw( import );

our @EXPORT_OK = qw( convert );

sub convert 
{
	my $name = shift;

	$name =~ s/psi/\\psi/g;

	$name =~ s/(\*\+|\+|'|0|\*0|-|\*-)/^{$1}/g;
	$name =~ s/_([a-zA-Z]+)/_{$1}/g;
	$name =~ s/(gamma|tau|rho|pi|mu|eta|nu|omega)/\\$1/g;
	
	# special case for KS, KL
	# K0s -> K^{0}s due to upper regex
	# Ks0 is not catched
	# convert both to correct form here
	$name =~ s/K(\^\{0\})*([sSlL])0*/K_{\u$2}^{0}/g;

	# also for Ds 
	# dont have time to test for all cases, so only for ekpfullrecon table right now
	$name =~ s/D([sS])/D_{\l$1}/g;

	return $name;
}

1;
