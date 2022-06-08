#!/usr/bin/perl
use strict;
my $fichier;
my $query;
my $chemin_fichier;
my $type ;
my $similarite;
my $taille;
my $position_debut;
my $position_fin;
my @tabtype;
my @tabsimilarite;
my @tabtaille;
my @tabposition_debut;
my @tabposition_fin;
my $i=0;
my $j=0;
my $k=0;
my $l=0;
my $m=0;


open (FILE, "ls -R $ARGV[0] |");
open (OUT, ">$ARGV[1]");

while (<FILE>)
{
	if (/(_blastx)/){
		chomp;
		$fichier=$_;
		$chemin_fichier="$ARGV[0]"."$fichier";
		open (FILE2, "$chemin_fichier");
			while (<FILE2>){
				if (/Query:\s+/){
					$query=$';
					chomp $query;
					$m=1;
					@tabtype=();
					@tabsimilarite=();
					@tabtaille=();
					@tabposition_debut=();
					@tabposition_fin=();
					$i=1;
				
				}
				
				elsif ((/(G\d)\s+([\d\.]+)\s+(\d+)\s+\d+\s+\d+\s+(\d+)\s+(\d+)/) and ($i==1)){
					$i=0;
					$type=$1;
					$similarite=$2;
					$taille=$3;
					$position_debut=$4;
					$position_fin=$5;
						if (($type=~/G[12]/) and ($taille > 410) and ($similarite > 90)){
						
							push(@tabtype,$type);
							push(@tabsimilarite, $similarite);
							push(@tabtaille,$taille);
							push(@tabposition_debut, $position_debut);
							push(@tabposition_fin,$position_fin);
							
						}
						elsif (($type=~/G[34]/) and ($taille > 480) and ($similarite > 90)){
							push(@tabtype,$type);
							push(@tabsimilarite, $similarite);
							push(@tabtaille,$taille);
							push(@tabposition_debut, $position_debut);
							push(@tabposition_fin,$position_fin);
						}
				}

				elsif ((/(G\d)\s+([\d\.]+)\s+(\d+)\s+\d+\s+\d+\s+(\d+)\s+(\d+)/) and ($i==0)){
					$type=$1;
					$j=0;
					$similarite=$2;
					$taille=$3;
					$position_debut=$4;
					$position_fin=$5;
						if (($type=~/G[12]/) and ($taille > 410) and ($similarite > 90)){
							
							foreach (@tabposition_debut){
								if ($position_debut==$_){
									$j=1;
									last;
								}
							}
							foreach (@tabposition_fin){
								if ($position_fin==$_){
									$j=1;
									last;
								}
							
							}
							if ($j==0){
							
								push(@tabtype,$type);
								push(@tabtaille,$taille);
								push(@tabsimilarite, $similarite);
								push(@tabposition_debut, $position_debut);
								push(@tabposition_fin,$position_fin);

							}
	

							
						}
						elsif (($type=~/G[34]/) and ($taille > 480) and ($similarite > 90)){
						
							foreach (@tabposition_debut){
								if ($position_debut==$_){
									$j=1;
									last;
								}
							}
							foreach (@tabposition_fin){
								if ($position_fin==$_){
									$j=1;
									last;
								}
							}
							if ($j==0){
								push(@tabtype,$type);
								push(@tabsimilarite, $similarite);
								push(@tabtaille,$taille);
								push(@tabposition_debut, $position_debut);
								push(@tabposition_fin,$position_fin);

							}

						}
				}
				elsif ((/BLASTX 2\.7\.1+/)and ($m==1)){
					
					print OUT "$fichier;$query;";
					foreach (@tabtype){
						if ($l==0){
							print OUT "$tabtype[$l];$tabsimilarite[$l];$tabtaille[$l];$tabposition_debut[$l];$tabposition_fin[$l];\n";
						}
						else {
							print OUT "$fichier;$query;$tabtype[$l];$tabsimilarite[$l];$tabtaille[$l];$tabposition_debut[$l];$tabposition_fin[$l];\n";

						}
						$l++;

					}
					print OUT "\n";
					
					$query=undef;
					$m=0,
					$l=0;
					
				
				}
				elsif ((/BLAST processed/)and ($m==1)){
					
					print OUT "$fichier;$query;";

					foreach (@tabtype){

						if ($l==0){
							print OUT "$tabtype[$l];$tabsimilarite[$l];$tabtaille[$l];$tabposition_debut[$l];$tabposition_fin[$l];\n";
						}
						else {
							print OUT "$fichier;$query;$tabtype[$l];$tabsimilarite[$l];$tabtaille[$l];$tabposition_debut[$l];$tabposition_fin[$l];\n";
						}
						$l++;

					}
					print OUT "\n";
				
					$query=undef;
					$m=0,
					$l=0;
					
				
				}				

			}

			


	}


}



