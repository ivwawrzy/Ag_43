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
my $fasta;
my $ID;


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
open (OUT, ">$ARGV[1]");

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
			$seqprot=undef;
			$seqnucleique=substr($seq,$ligne_info[5]-1,$ligne_info[6]-$ligne_info[5]+1);
		#print "$seqnucleique\n";
			while ($seqnucleique){
				$codon=substr($seqnucleique,0,3);
				$seqprot.=$code_genetique{$codon};
				substr($seqnucleique,0,3)="";
			}
		#print "$seqprot\n";
			$fasta=undef;
			print OUT ">$fichierseq|$ligne_info[1]|positive strand|$ligne_info[2]|$ligne_info[5]|$ligne_info[6]\n";
			while ($seqprot){
				$lignefasta=substr($seqprot,0,60);
				print OUT "$lignefasta\n";
				$lignefasta=substr($seqprot,0,60)="";
			}

		

		}

		else{


			$seqprot=undef;
			$seqnucleique=substr($seq,$ligne_info[6]-1,$ligne_info[5]-$ligne_info[6]+1);
			$seqnucleiqueinvcomp=reverse ($seqnucleique);
			$seqnucleiqueinvcomp=~ tr/ACGT/TGCA/;
			while ($seqnucleiqueinvcomp){
				$codon=substr($seqnucleiqueinvcomp,0,3);
				$seqprot.=$code_genetique{$codon};
				substr($seqnucleiqueinvcomp,0,3)="";
			}
		#print "$seqprot\n";
			$fasta=undef;
			print OUT ">$fichierseq|$ligne_info[1]|negative strand|$ligne_info[2]|$ligne_info[5]|$ligne_info[6]\n";
			while ($seqprot){
				$lignefasta=substr($seqprot,0,60);
				print OUT "$lignefasta\n";
				$lignefasta=substr($seqprot,0,60)="";
			}

		}

		

	}



}





