#!/bin/bash

#SBATCH --job-name=BLAST_serial
#SBATCH --partition=serial
#SBATCH --time=04:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=BLAST_serial.%N.%j_test.out
#SBATCH --error=BLAST_serial.%N.%j_test.err


# Location of BLAST database
# By putting it in a variable, it is easy to find where to
# edit if the location ever changes. 
# This is a good practice for file paths that do not change often
BLAST_DB="/work/GenomicSamples/db/blastdb/BOLD_FULL.fasta"


# Load BLAST program
module load blast+


# "-outfmt 11" gives the most flexable type of output
# because other formats such as CSV can be converted from it later
blastn -query sample_data/GENBANK.fasta -db $BLAST_DB -outfmt 11


