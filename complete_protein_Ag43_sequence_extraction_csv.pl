#!/usr/bin/perl
use strict;

my @ligne_info;
my $fichierseq ;
my $i;
my $seq;
my $prefix;
my $description;
my $type;
my $seqnucleique;
my $seqprot;
my $codon;
my $lignefasta;
my $seqnucleiqueinvcomp;
my $ID;
my $taille;
my $positionMK;
my $seqprotamont;
my $protfinale;
my $positionstop;
my $positionM;
my $postionprotfinal;
my $position_finale_debut;
my $position_finale_fin;
my $postion_debut_brut;
my $tailleprot;
my $fichier_genbank;
my @liste_CDS=();
my $prediction;


my(%code_genetique) = (
'TCA' => 'S',# Sérine
'TCC' => 'S',# Sérine
'TCG' => 'S',# Sérine
'TCT' => 'S',# Sérine
'TTC' => 'F',# Phénilalanine
'TTT' => 'F',# Phénilalanine
'TTA' => 'L',# Leucine
'TTG' => 'L',# Leucine
'TAC' => 'Y',# Tirosine
'TAT' => 'Y',# Tirosine
'TAA' => '*',# Stop
'TAG' => '*',# Stop
'TGC' => 'C',# Cystéine
'TGT' => 'C',# Cystéine
'TGA' => '*',# Stop
'TGG' => 'W',# Tryptophane
'CTA' => 'L',# Leucine
'CTC' => 'L',# Leucine
'CTG' => 'L',# Leucine
'CTT' => 'L',# Leucine
'CCA' => 'P',# Proline
'CCC' => 'P',# Proline
'CCG' => 'P',# Proline
'CCT' => 'P',# Proline
'CAC' => 'H',# Hystidine
'CAT' => 'H',# Hystidine
'CAA' => 'Q',# Glutamine
'CAG' => 'Q',# Glutamine
'CGA' => 'R',# Arginine
'CGC' => 'R',# Arginine
'CGG' => 'R',# Arginine
'CGT' => 'R',# Arginine
'ATA' => 'I',# IsoLeucine
'ATC' => 'I',# IsoLeucine
'ATT' => 'I',# IsoLeucine
'ATG' => 'M',# Methionine
'ACA' => 'T',# Tréonine
'ACC' => 'T',# Tréonine
'ACG' => 'T',# Tréonine
'ACT' => 'T',# Tréonine
'AAC' => 'N',# Asparagine
'AAT' => 'N',# Asparagine
'AAA' => 'K',# Lisine
'AAG' => 'K',# Lisine
'AGC' => 'S',# Sérine
'AGT' => 'S',# Sérine
'AGA' => 'R',# Arginine
'AGG' => 'R',# Arginine
'GTA' => 'V',# Valine
'GTC' => 'V',# Valine
'GTG' => 'V',# Valine
'GTT' => 'V',# Valine
'GCA' => 'A',# Alanine
'GCC' => 'A',# Alanine
'GCG' => 'A',# Alanine
'GCT' => 'A',# Alanine
'GAC' => 'D',# Acide Aspartique
'GAT' => 'D',# Acide Aspartique
'GAA' => 'E',# Acide Glutamique
'GAG' => 'E',# Acide Glutamique
'GGA' => 'G',# Glycine
'GGC' => 'G',# Glycine
'GGG' => 'G',# Glycine
'GGT' => 'G',# Glycine
);


open(FILE,"$ARGV[0]");
open(OUT,">$ARGV[1]");

while (<FILE>) {

	#print;

	$type=undef;


	@ligne_info=split(/;/,$_);
		if ($ligne_info[0]=~/_blastx/){
			$prefix=$`;

		}
		$description=$ligne_info[1];
		if ($description=~/(^\w+)/){
			$ID=$1;


		}
		$type=$ligne_info[2];
		#print "$type*****\n";
		$fichierseq="$prefix".".fna";

		$fichier_genbank="$prefix".".gbff";

		open (FILEGENBANK,"$fichier_genbank"); 

		@liste_CDS=();


		while (<FILEGENBANK>){
			if(/^\s+CDS\s+(\d+\.\.\d+)/){
				push(@liste_CDS,$1);
			
			}
			elsif (/^\s+CDS\s+complement\((\d+\.\.\d+)/){
				push(@liste_CDS,$1);
			}

		}

		open (FILESEQ,"$fichierseq");
				
			$seq=undef;
				
			while (<FILESEQ>){
			
				if ((/^>/) and (/$ID/) and ($type)){
					$i=1;
					chomp;
					#print "$_!!!!!!!\n";

				}
				elsif (/^>/){
					#$type=undef;
					$i=0;
					#print "*******************$_";
				}
				else {
				 	if($i==1){
				
						chomp;
						$seq.=$_;
					}
				}

			
				

			}

		
		if ($ligne_info[3]){
		#print "$ligne_info[5]!!!! $ligne_info[6]!!!!\n";
			if ($ligne_info[5]<$ligne_info[6]){
				$taille=$ligne_info[6]-$ligne_info[5]+10000;
				$postion_debut_brut=$ligne_info[5]-175;
				$seqnucleique=substr($seq,$ligne_info[5]-175,$taille);
				

				#print "$seqnucleique\n";
				while ($seqnucleique){
					$codon=substr($seqnucleique,0,3);
					$seqprot.=$code_genetique{$codon};
					substr($seqnucleique,0,3)="";
				}
		#print "$seqprot\n";

				$positionMK=index($seqprot,"MK");
					if ($positionMK!=-1){
						$position_finale_debut=$postion_debut_brut+($positionMK*3)+1;
						$seqprotamont=substr($seqprot,$positionMK);
						$positionstop=index($seqprotamont,"*");
						$protfinale=substr($seqprotamont,0,$positionstop);
					}
					else {
						$positionM=index($seqprot,"M");
						$position_finale_debut=$postion_debut_brut+($positionM*3)+1;
						$seqprotamont=substr($seqprot,$positionM);
						$positionstop=index($seqprotamont,"*");
						$protfinale=substr($seqprotamont,0,$positionstop);
					}
					$tailleprot=length($protfinale);
					$position_finale_fin=$position_finale_debut+($tailleprot*3)+2;
					
				

				if(!@liste_CDS){

					$prediction="ANA";
				}

				if (@liste_CDS){
					foreach (@liste_CDS){
						if (/(\d+)\.\.(\d+)/){
							if(($position_finale_debut==$1) and ($position_finale_fin==$2)){

							
							$prediction="WP";
							last;

							}

							elsif (($position_finale_debut!=$1) and ($position_finale_fin==$2)){

							$prediction="M-TIS";
							last;


							}
							elsif ((($position_finale_debut==$1) and ($position_finale_fin!=$2))){
							
							$prediction="FS";

							}


						}

					}
					if (!$prediction){
					
						$prediction="NP";
					}
				}	

				$seqprot=undef;
				if($ligne_info[1]=~/^(\w+)\.?\d*\s*(.+)/){
					print OUT "$fichierseq;$2;$1;$ligne_info[2];$position_finale_debut;$position_finale_fin;+;$prediction;$protfinale\n";
					$prediction=undef;
					
				}

		}

		else{

			$taille=$ligne_info[5]-$ligne_info[6]+2180;
			$seqnucleique=substr($seq,$ligne_info[6]-2000,$taille);
			$postion_debut_brut=$ligne_info[6]-2000 + $taille;
			$seqnucleiqueinvcomp=reverse ($seqnucleique);
			$seqnucleiqueinvcomp=~ tr/ACGT/TGCA/;
			while ($seqnucleiqueinvcomp){
				$codon=substr($seqnucleiqueinvcomp,0,3);
				$seqprot.=$code_genetique{$codon};
				substr($seqnucleiqueinvcomp,0,3)="";
			}



			$positionMK=index($seqprot,"MK");
			if ($positionMK!=-1){
				$position_finale_debut=$postion_debut_brut-($positionMK*3);
				$seqprotamont=substr($seqprot,$positionMK);
				$positionstop=index($seqprotamont,"*");
				$protfinale=substr($seqprotamont,0,$positionstop);
			}
			else {
				$positionM=index($seqprot,"M");
				$position_finale_debut=$postion_debut_brut+($positionM*3);
				$seqprotamont=substr($seqprot,$positionM);
				$positionstop=index($seqprotamont,"*");
				$protfinale=substr($seqprotamont,0,$positionstop);
			}

				$tailleprot=length($protfinale);
				$position_finale_fin=$position_finale_debut-($tailleprot*3)-2;


				if(!@liste_CDS){

					$prediction="ANA";
				}

				if (@liste_CDS){
					foreach (@liste_CDS){
						if (/(\d+)\.\.(\d+)/){
							if(($position_finale_debut==$2) and ($position_finale_fin==$1)){

							
							$prediction="WP";
							last;

							}

							elsif (($position_finale_debut!=$2) and ($position_finale_fin==$1)){

							$prediction="M-TIS";
							last;


							}
							elsif ((($position_finale_debut==$2) and ($position_finale_fin!=$1))){
							
							$prediction="FS";

							}


						}

					}
					if (!$prediction){
					
						$prediction="NP";
					}
				}	





			$seqprot=undef;
			if($ligne_info[1]=~/^(\w+)\.?\d*\s*(.+)/){
				print OUT "$fichierseq;$2;$1;$ligne_info[2];$position_finale_fin;$position_finale_debut;-;$prediction;$protfinale\n";
			
			}

		}

		

	}



}





