#!/bin/bash

#SBATCH --job-name=Count_Sequence_Lengths
#SBATCH --partition=serial
#SBATCH --time=02:00:00
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --output=count_sequence_length.%N.%j_test.out
#SBATCH --error=count_sequence_length.%N.%j_test.err

# Make each sequence a single row
sed ':a; $!N; /^>/!s/\n\([^>]\)/\1/; ta; P; D' sample_data/BOLD_sample.fasta > BOLD_single_test.fasta

# Separate headers and sequences into separate files
grep '^>' BOLD_single_test.fasta > BOLD_headers_test.fasta
grep '^>' BOLD_single_test.fasta -v > BOLD_sequences_test.fasta

# Grab the first field of the each header, which is the unique sequence identifier
awk '{print $1}' BOLD_headers_test.fasta | sed -e 's/>//' > temp1.%N.%j_test.dat

# Compute each sequence length, save to temporary file
awk '{print length}' BOLD_sequences_test.fasta > temp2.%N.%j_test.dat


# Print the names of the columns of the data set being created
echo "SEQUENCE_ID,LENGTH"

# Combine the temp files to create a CSV with a header column and length column
paste temp1.%N.%j_test.dat temp2.%N.%j_test.dat -d ',' | sort -t ',' -k 2

