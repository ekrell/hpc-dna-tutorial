#!/bin/bash

# Number of FASTA file chunks you split it into

#SBATCH --job-name=BLAST_parallel
#SBATCH --partition=normal
#SBATCH --time=02:00:00
#SBATCH --ntasks=20        # Each node has 20 cores, 
                           # so a number over 20 will allocate multiple nodes
#SBATCH --exclusive
#SBATCH --output=BLAST_parallel.%N.%j_test.out
#SBATCH --error=BLAST_parallel.%N.%j_test.err


# Location of BLAST database
# By putting it in a variable, it is easy to find where to
# edit if the location ever changes. 
# This is a good practice for file paths that do not change often
BLAST_DB="/work/GenomicSamples/db/blastdb/BOLD_FULL.fasta"


# Load BLAST and GNU Parallel
module load parallel
module load blast+


# create a sequence from 1 - number of chunks
seq 1 $SLURM_NTASKS > BLAST_parallel.$SLURM_JOB_ID.sequence

cat BLAST_parallel.$SLURM_JOB_ID.sequence | parallel -j $SLURM_NTASKS \
"blastn -query sample_data/GENBANK_large.fasta.{.} -db $BLAST_DB -outfmt 11 \
-out GENBANK.BLAST.{.}"

# "-outfmt 11" gives the most flexable type of output
# because other formats such as CSV can be converted from it later


