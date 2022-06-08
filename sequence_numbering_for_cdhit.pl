#!/usr/bin/perl
use strict;
my $i=1;
my $nom;

open (FILE, "$ARGV[0]");
open (OUT, ">$ARGV[1]");

while (<FILE>){

	if (/^>/){
		$nom="$&"."$i"."$'";
		print OUT "$nom";
		$i++;
	}
	else {
		print OUT;
	}

}
