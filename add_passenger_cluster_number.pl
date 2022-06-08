#!/usr/bin/perl
use strict;



use vars qw ($opt_t);
use Getopt::Std;
getopts ('t:'); 


my $a=1;
my %hash_cluster;
my $num_cluster;
my $clusternumber;


open(FILE,"$ARGV[0]");
open (FILE2, "$ARGV[1]");
open (OUT, ">$ARGV[2]");


while (<FILE>) {

	if (/^>Cluster/){
		
		$num_cluster="cluster_"."$a";
		$a++;


	}
	elsif (/>(\w+)/) {
		$hash_cluster{$1}=$num_cluster;

	}
}







while (<FILE2>) {

	if(/>(\w+)/){
		chomp;
		$clusternumber="$opt_t"."_"."$hash_cluster{$1}";
		print OUT "$_|$clusternumber\n";

	}
	
	else {
		print OUT ;

	}

}

