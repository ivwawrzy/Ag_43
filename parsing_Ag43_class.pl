#!/usr/bin/perl
use strict;
my $type;


use vars qw ($opt_t);
use Getopt::Std;
getopts ('t:'); 

$/='>';

open (FILE,"$ARGV[0]");
open (OUT,">$ARGV[1]");
#print "$opt_t\n";




while (<FILE>) {
	
	if (/\|$opt_t\|/){
		chomp;
		print OUT ">$_";
	}


}



