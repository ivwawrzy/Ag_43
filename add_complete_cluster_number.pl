#!/usr/bin/perl
use strict;



my $refnegative;
my $refpositive;
my @ref;
my $ligne;
my @data_file1;
my $i;


open(FILE,"$ARGV[0]");
open (FILE2, "$ARGV[1]");
open (OUT, ">$ARGV[2]");


while (<FILE>) {

	if (/>\d+/){

		
		@comment_line=split(/\|/,$');
		if ($comment_line[2]=~/negative/){

				$refnegative="$comment_line[0]-"."$comment_line[5]-"."$comment_line[4]-"."$comment_line[6]";
				push (@ref, $refnegative);



		}

		elsif ($comment_line[2]=~/positive/) {
				$refpositive="$comment_line[0]-"."$comment_line[5]-"."$comment_line[4]-"."$comment_line[6]";
				push (@ref, $refpositive);


		}
		
	}
}


while (<FILE2>) {
	chomp;
	$i=0;
	$ligne=$_;
	@sous_partie=split(/;/,$_);

	foreach (@ref){
		@data_file1=split(/-/,$_);
		if (($sous_partie[0] eq $data_file1[0]) and ($sous_partie[4]<$data_file1[1]) and ($sous_partie[5]>$data_file1[2])){
			print OUT "$ligne;$data_file1[3]";
			$i=1;
			last;
		}
		
	}
	if ($i==0){
	print OUT "$ligne\n";
	}
}

