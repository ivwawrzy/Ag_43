#!/usr/bin/perl
use strict;
my $fichier;
my $fichier_sortie;


open (FILE, "ls -R $ARGV[0] |");

while (<FILE>)
{
	if (/(.fna)/){
		chomp;
		$fichier="$ARGV[0]/"."$_";
		$fichier_sortie="$ARGV[0]/"."$`"."_blastx";
		print "$fichier\n";
		print "$fichier_sortie\n\n";

	}

	system ("blastx -query $fichier -db ~/blastdb/domaine_passager -evalue 1e-100 -out $fichier_sortie -outfmt 7");
}
