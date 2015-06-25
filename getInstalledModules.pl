#!/usr/bin/env perl

use strict;
use warnings;

use ExtUtils::Installed;

my $inst = ExtUtils::Installed->new();

print $_."\n" foreach $inst->modules();

