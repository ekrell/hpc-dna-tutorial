## TAMU-CC HPC Tutorial: Working with Sequences


### Introduction


**Purpose**

This tutorial is to help you get started working with biological sequence data, such as DNA, on TAMU-CC's high performance computer (HPC) cluster.
The HPC introduces parallel processing and you will be able to take advantage of this to process data quickly by using command line software.



**Intended Readers**

This tutorial will be especially useful to biology students who needs to run bio-informatics software that use FASTA files, such as BLAST, on the HPC. 
Even if you do not work with sequence data, the principles apply to many types of data processing on the HPC. 
It is aimed toward users who have already had some experience working in a command line environment, 
but need to learn how to use the HPC for working with large data. 



**Requirements and Recommendations**

You must have an account on the TAMU-CC HPC.
If you do not have one, you may request an account on the HPC website [1]. 
In addition, VPN access [2] is required if you intend to logon to the HPC from a location outside the school. 
Before starting this tutorial, it is strongly recommended that you read the HPC Quick Start Guide [3].
It will also help to have the Linux Cheat Sheet [4] readily available since not every command is anaylzed in detail. 


**Organization**

1. Introduction

2. Prepare environment

3. Perform basic sequence tasks 

4. Leverage bio-informatics tools

5. Speed up with parallel processing

6. Clean environment


**Notation**

All commands, scripts, and console output are formatted as code blocks like so:

			This is inside a code block.
			
Commands are text that the user inputs (types into) the HPC console and executes (runs) by pressing the "ENTER" key. 

Scripts are text files containing several commands that are saved on the HPC and can then be executed as a single command. 

Console output is what the HPC displays in response to commands. 
You can compare it to your own output to make sure that you are on the right track. 

			$ Lines that start with a dollar sign are commands
			Lines that do not are console output
			
Brackets ([,]) are used to surround text whose contents depend on the user or situation, such as a username.

For example: [username]@islander.tamucc.edu

You would replace [username] with your actual username. 

Mine would be: ekrell@islander.tamucc.edu

			
*File: exampleFile.txt*

			The exception is code blocks that are surrounded by "File: <filename>.txt"
			They are neither commands you directly run nor console outputs.
			They are the content inside a file, such as scripts or data.

*File: exampleFile.txt*


### Anatomy of a FASTA

FASTA files are used to store two types of biological sequence data: proteins and nucleic acids. 

Nucleic acids, such as DNA, are sequences of molecules called nucleotides. 
DNA sequences are made up of the nucleotides adenine, guanine, cytosine, and thymine. 
A sequence can be stored in a computer using the characters "A", "G", "C", and "T".
There are additional characters that may be used when a specific nucleotide is unspecified. 
For example, "R" means "purine" and indicates that the nucleotide could be either "A" or "G". 
Protein sequences are very similar, but are made up of 20 different amino acids.
Each amino acid can also be represented by text characters. 

More information on the FASTA format, including reference charts for all nucleotide and amino acids codes, can be found on Wikipedia [5]. 
This tutorial focuses exclusively on FASTA files containing DNA sequences, 
but the principles apply to any type of proteins or other nucleic acids stored in a FASTA file.

**File: example.fasta**

			>EU827594.1 Eublepharis macularius membrane-bound immunoglobulin upsilon heavy chain region (ighcy) gene and partial cds
			AACTGGGTACACATTTTACTGACCTCGGAAGGATGGAAGGCTGAGTCAACCTTGAGCTGGCTACCTGAAC
			CCGGCTTCCACCAGGACTGAACTCAGATCTTGAGCAGAGCTTGGGCTGCAGTACTGCAGCTTACGACTCT
			GCGACATGGGGCTTGATGTTGGACAATATCCAATCTCGCTACGAGCTGTAAACCGGGGGTGGGGGATGGT
			TCGATACAGTACAGTACGGTATGGCCTGATCTTGTCAGATCTCAAAAGCTAAGGAGGGTCAATACTCAGA
			TAGGGAACCACTGAGGAAGACTCTGCAGAGGAAGGCAAAGGTAAACAACCTCTACTTCTCACTCGCTATC
			CAAATCTCTTTGTTGGAGTTGCCC

**File: example.fasta** [6]


There are two main components of a FASTA sequence entry. 
The first is always the first line of the entry and begins with '>'. This is called the sequence header. 
It usually contains a unique identifier as well as additional information about the sequence. 
In this example, the unique identifier is "EU827594.1".
The second component is the sequence itself, which may take up several lines. 
There is no defined limit on how long any particular line may be, so the sequence may be one very long line or split into multiple lines. 
While this example displays the sequence in upper case, the FASTA format does not specify whether to use upper or lower case.


### Prepare environment

In this step, you will login to the HPC and copy the contents of this project to your Work directory. 
You should be in your computer's terminal to access the HPC and run commands. 
How to access the terminal depends on your operating system, so review the Quick Start Guide to learn how [3].
In the following, `[username]` is your TAMUCC user account name and `[hostname]` is the hostname (or IP address) of the TAMUCC HPC. 
Note that having a TAMUCC account does not automatically give you an account on the HPC. Get in contact if you need one. 

1. Login to the HPC

		$ ssh [username]@[hostname of HPC]
		
2. Navigate to your Work directory

		$ cd $WORK
		
3. Download this git repository to your Work directory

		$ git clone https://github.com/ekrell/HPC-DNA-tutorial.git

4. Enter project directory

		$ cd HPC-DNA-tutorial

5. Check this file to verify

		$ head README.md
		## TAMU-CC HPC Tutorial: Working with Sequences


		### Introduction


		**Purpose**

		This tutorial is designed to help users get familiar with working with biological sequence data, such as DNA, on TAMU-CC's high performance computer (HPC) cluster.
		Readers will be able to work with large data sets on the FASTA file format using command line tools and then submit jobs to the HPC.

		

### Perform basic sequence tasks

You will use Linux command line tools to process FASTA files.
While there are many useful bio-informatics tools available,
you will almost certainly need to format your files before you can use them.
FASTA sequence headers can store a variety of information. 
Since there is no official guidelines on how such information should be formatted, 
you will have to ensure the header is formatted correctly for a given program.
Also, you have to request software to be installed on the HPC, 
so you might have to process manually using the Linux tools while waiting for installation. 

1. Compare two FASTA files


	Included with this tutorial are three FASTA files. 
	Take a look at a couple and take note of some properties. 

		$ head sample_data/BOLD_sample.fasta
		
		>PARG231X16|Emblemariopsis_arawak|COIX5P|KX140306|942924
		OBtctctcgggcaacctagcccatgcaggggcttccgtggacttaacaattttttctctcca
		cttagcgggggtttcctctattttaggtgcaattaattttattacaacaatcattaatat
		gaagcccccggctacttcacagtatcagacacccctctttgtgtgatctgtactaattac
		agcagttcttcttcttctctctcttcctgttctggcagctggaattactatgttactaac
		ggaccggaatttgaatacaactttctttgaccctgcaggaggaggagatccaatcctgta
		ccaacactt
		>CRIAN429X09|Promachocrinus_kerguelensis|COIX5P|HQ560287|398667
		xactttgtattttctttttggtgcttgggctggtatggttggtactgctttaagaataat
		aattcgtacagaattagctcagcctggttcttttttaggtgatgaccaaatttataaagt

	Using the head command, you displayed the first 10 lines of the file. 
	You can see one complete sequence entry and the first three lines of another. 

	Notice that the neither sequence header have any spaces, 
	but instead separate fields with the pipe ("|") character. 

	The five fields are as follows: Unique Sequence Identifier | Scientific Name | Mitochondrial marker | Genbank Ascension Identifier | NCBI Taxonomic Identifier 


		$ head sample_data/GENBANK.fasta

		>909740163 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Arthropoda, subphylum: Chelicerata, class: Arachnida, subclass: Acari, superorder: Acariformes, species: Sarcoptiformes sp. ; Sarcoptiformes sp. BOLD:ACK7604
		aactttatatttcatatttggagcctgggctggacttttaggttcttctctcagagctct
		tattcgacttgaattaggacaacctggttctttattaggaaacgatcaaatttataacac
		aattgtgacagctcacgcctttgttataattttctttatggtaataccaattataatcgg
		aggattcggtaattgattagtaccaataataatcggagctcaagatatagctttcccacg
		aataaataatataagattttgactactacccccctccctatttcttctagccatttcagc
		ttttgctggaacggggnngggtactggatgaactgtgtaccccccactctctagaagaat
		ttttcaagcagacatttccgtagatctcgccatctttagactacatatagctggtatatc
		ttctattttaggagctatcaactttattacgactattttaaatatatcaaactcacactt
		aacaccagattcaattcctttatttgtatggtcagttttaattacttctgttcttctctt
		
	This output is an equally valid FASTA, but the header is formatted very differently. 
	This one uses key-value pairs to provide detailed information on the organism's taxonomy.


2. Reformat the header


	You might find a program that does not accept any header information in the FASTA past the first whitespace. 
	You need to be able to remove all other data from the header, but still be able to query that header information later. 
	As long as you keep the unique sequence identifier, you will always able to access various versions of that data. 

		$ sed -e 's/ .*$//' sample_data/GENBANK.fasta > header_stripped_test.fasta
		$ head header_stripped_test.fasta

		>909740163
		aactttatatttcatatttggagcctgggctggacttttaggttcttctctcagagctct
		tattcgacttgaattaggacaacctggttctttattaggaaacgatcaaatttataacac
		aattgtgacagctcacgcctttgttataattttctttatggtaataccaattataatcgg
		aggattcggtaattgattagtaccaataataatcggagctcaagatatagctttcccacg
		aataaataatataagattttgactactacccccctccctatttcttctagccatttcagc
		ttttgctggaacggggnngggtactggatgaactgtgtaccccccactctctagaagaat
		ttttcaagcagacatttccgtagatctcgccatctttagactacatatagctggtatatc
		ttctattttaggagctatcaactttattacgactattttaaatatatcaaactcacactt
		aacaccagattcaattcctttatttgtatggtcagttttaattacttctgttcttctctt
		

3. Count the number of sequences in each file


	Recall that each sequence header begins with the ">" character. 
	You can use this to count how many sequences are in a file. 
	Use a regular expression with the grep command to specify that the target pattern is "the first character in the line is >" 
	and count the number of occurances of that pattern.

	The regular expression '\^>' is used to match that pattern. 
	The up-arrow ('\^') means "start of line", so you will only count the instances where the first character is ">".
	
	The "-c" options tells grep to count how many lines have that pattern.

	Regular expressions [7] are one of the most powerful tools for text processing
	and are used frequently in bio-informatics. 


		$ grep -c '^>' sample_data/BOLD_sample.fasta
		500
		$ grep -c '^>' sample_data/GENBANK.fasta
		10


4. Convert multi-line sequences to single-line


	Storing sequences in multiple lines is very challenging to process.
	Most tools work by analyzing a single line at a time, 
	so you may need to convert mult-line sequences into a single line.

	This can be done using a fairly complicated sed command [8]:

		$ sed ':a; $!N; /^>/!s/\n\([^>]\)/\1/; ta; P; D' sample_data/GENBANK.fasta > GENBANK_single_test.fasta
		$ head -n 4 GENBANK_single_test.fasta
		>909740163 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Arthropoda, subphylum: Chelicerata, class: Arachnida, subclass: Acari, superorder: Acariformes, species: Sarcoptiformes sp. ; Sarcoptiformes sp. BOLD:ACK7604
		aactttatatttcatatttggagcctgggctggacttttaggttcttctctcagagctcttattcgacttgaattaggacaacctggttctttattaggaaacgatcaaatttataacacaattgtgacagctcacgcctttgttataattttctttatggtaataccaattataatcggaggattcggtaattgattagtaccaataataatcggagctcaagatatagctttcccacgaataaataatataagattttgactactacccccctccctatttcttctagccatttcagcttttgctggaacggggnngggtactggatgaactgtgtaccccccactctctagaagaatttttcaagcagacatttccgtagatctcgccatctttagactacatatagctggtatatcttctattttaggagctatcaactttattacgactattttaaatatatcaaactcacacttaacaccagattcaattcctttatttgtatggtcagttttaattacttctgttcttctcttactatctttaccagtcttagctggagctatcacaatactactaacagac

5. Separate header and sequence into two separate files


	If you have a file where every line is a sequence header and another file where every line is a sequence, 
	then you can operate on either sequences or headers independently. 

	If you search the sequence and find a result, 
	you can use the line number of the result to get the corrosponding header since the order is the same.

	With the following grep commands, you do *not* use "-c".
	Instead of counting the lines that match the pattern,
	you want to *print* those lines. 
	Grep is being used to filter the data.
	Using the right arrow (">"), the matched lines are stored in the specified FASTA.
		
	The second grep command uses "-v" which inverts the meaning:
	instead of outputing the match, grep outputs those that *do not* match.
	Here, a line that does not match the pattern is a sequence. 

		$ grep '^>' GENBANK_single_test.fasta > GENBANK_headers_test.fasta
		$ grep '^>' GENBANK_single_test.fasta -v > GENBANK_sequences_test.fasta
		$ head -n 3 GENBANK_headers_test.fasta

		>909740163 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Arthropoda, subphylum: Chelicerata, class: Arachnida, subclass: Acari, superorder: Acariformes, species: Sarcoptiformes sp. ; Sarcoptiformes sp. BOLD:ACK7604
		>327498455 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Chordata, subphylum: Craniata, class: Mammalia, superorder: Laurasiatheria, order: Chiroptera, suborder: Microchiroptera, family: Phyllostomidae, subfamily: Stenodermatinae, genus: Artibeus, species: Artibeus planirostris ; Artibeus planirostris
		>317468521 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Arthropoda, superclass: Hexapoda, class: Insecta, subclass: Neoptera, infraclass: Endopterygota, superorder: Amphiesmenoptera, order: Lepidoptera, suborder: Glossata, infraorder: Neolepidoptera, parvorder: Heteroneura, superfamily: Tortricoidea, family: Tortricidae, subfamily: Olethreutinae, tribe: Eucosmini, genus: Epinotia, species: Epinotia plumbolineana ; Epinotia plumbolineana

		$ head -n 3 GENBANK_sequences_test.fasta
		aactttatatttcatatttggagcctgggctggacttttaggttcttctctcagagctcttattcgacttgaattaggacaacctggttctttattaggaaacgatcaaatttataacacaattgtgacagctcacgcctttgttataattttctttatggtaataccaattataatcggaggattcggtaattgattagtaccaataataatcggagctcaagatatagctttcccacgaataaataatataagattttgactactacccccctccctatttcttctagccatttcagcttttgctggaacggggnngggtactggatgaactgtgtaccccccactctctagaagaatttttcaagcagacatttccgtagatctcgccatctttagactacatatagctggtatatcttctattttaggagctatcaactttattacgactattttaaatatatcaaactcacacttaacaccagattcaattcctttatttgtatggtcagttttaattacttctgttcttctcttactatctttaccagtcttagctggagctatcacaatactactaacagac
		actttatacctattatttggtgcttgagcaggtatagtaggtactgcactaagtcttcttattcgtgcagaacttggccaacctggagccctattaggtgatgatcaaatctataacgtaatcgtaacagctcatgctttcgtaataattttctttatagtaatgcctattataattgggggattcggtaattgattagtaccactaataattggcgcacccgatatagcattcccacgaataaataatataagtttctgactcctcccaccttccttcctacttttacttgcttcctctactgttgaagctggcgtaggaacaggttgaaccgtatacccaccactagccggaaatctagcacatgctggagcttcagttgacctagctattttctctcttcatctagccggagtttcatcaatccttggagctattaatttcattactacaattattaatataaaaccacctgccctctctcaatatcaaacacccttatttgtctgatctgttttaatcaccgctgttttattactcctgtctcttcctgtcttagcagcaggtattactatactcctaacagaccgaaaccttaataccacattctttgatccagctggaggaggagaccccattttatatcaacacctattc
		aacattatattttatttttggaatttgagctggtataattggtacttctttaagattattaattcgtgctgaattaggaaatccaggatctttaattggtgatgatcaaatttataacactattgtaactgcccatgcttttattataattttttttatagttataccaattataattggtgggtttggaaattgattagtacccctaatacttggagcccctgatatagctttcccccgaataaataatataagattttgattattacccccctctattatacttttaatttcaagtagaattgtagaaaatggagcaggtacaggatgaacagtataccccccactttcatccaatattgcacatagaggaagctctgtagatcttgctattttttctttacatttagctggaatttcatcaattttaggagctgttaatttcattacaaccattattaatatacgaccaaataatatatctcttgatcaaatacctttatttgtttgagcagtagggattacagcacttttattacttctttctttacctgtattagcaggagcaattactatactattaacagatcgaaaccttaatacatcattttttgaccctgctggaggaggagaccctattctttatcaacatttattt	


6. Find shortest sequence


	Finding the shortest sequence will be simple now that you have compressed the sequences 
	into a single line and have separated the data into header and sequence files.
	It will be a multi-step operation because you will operate on the sequences 
	and then look up the corrosponding header.

	The following command is really three commands linked together with a pipe ("|").

	Awk lets you print the length and line number of a row using "length" and "NR" respectively. 

	Sort orders the input from smallest to largest. 
	The "-n" option sorts numerically (rather than alphabetically).
	The "-k 1" option tells it to sort using the first field. 
	"-t ',' " means that the separator between fields is a comma. 
	
	Head with "-n 1" means to show only the first line, which will be the shortest thanks to the sorting.

		$ awk '{print length","NR}' GENBANK_sequences_test.fasta | sort -n -k 1 -t ',' | head -n 1
		588,9

	This result tells you that the 9th sequence is the shortest and has 588 nucleotides. 
	Now use that number, 9, to query that sequence's header.

		$ sed -n '9{p;q;}' GENBANK_headers_test.fasta 
		>1051550002 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Arthropoda, superclass: Hexapoda, class: Insecta, subclass: Neoptera, infraclass: Endopterygota, superorder: Amphiesmenoptera, order: Lepidoptera, suborder: Glossata, infraorder: Neolepidoptera, parvorder: Heteroneura, superfamily: Geometroidea, family: Geometridae, subfamily: Larentiinae, genus: Eupithecia, species: Eupithecia virgaureata ; Eupithecia virgaureata

	You can chain up these two commands so that you do not manually have to enter the number. 
	When you run jobs, you will work with large amounts of data and it will be unfeasable to manually intervene. 
	
	Xargs is a very useful command for this. 
	It is assumed that are familiar with using the pipe operator ("|"),
	which uses the output of one command as the input of another. 
	This allows you to chain up operations as you have already seen.
	For example "ls | grep hello" will run ls to list files, but before you see the files, 
	"grep hello" filters for a pattern. 
	You end up seeing only the files that contain "hello".
	However, the *entire* output is being sent through and sometimes you want to process only one line at a time. 
	Xargs lets you do this. In the following example, each number will independenty be sent to the 
	"sed" command so that each instance of "{}" is replaced with a single line from the input. 
	Since each line of the input is the line number, the two-step process above is automated.

		$ awk '{print length","NR}' GENBANK_sequences_test.fasta | sort -n -k 1 -t ',' | head -n 1 | \
		$ awk -F',' '{print $2}' | xargs -I '{}' sed -n "{}{p;q;}" GENBANK_headers_test.fasta
		>1051550002 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Arthropoda, superclass: Hexapoda, class: Insecta, subclass: Neoptera, infraclass: Endopterygota, superorder: Amphiesmenoptera, order: Lepidoptera, suborder: Glossata, infraorder: Neolepidoptera, parvorder: Heteroneura, superfamily: Geometroidea, family: Geometridae, subfamily: Larentiinae, genus: Eupithecia, species: Eupithecia virgaureata ; Eupithecia virgaureata


7. Execute a SLURM script to run a job on the HPC


	Now that you have seen some of the ways that you can work with sequences, 
	you are ready to submit a job to the HPC. 
	All job submission is handled by the SLURM job scheduling system. 
	SLURM works as a middle-man between you and the HPC's nodes. 
	To send a job to the HPC nodes, you create a script that has commands
	and information for SLURM to allocate resources properly for your task.

	The following SLURM script has comments that explain the purpose of each line. 

	Recall that comments are lines that begin with the pound symbol ("#"), 
	unless they are directions to the shell itself or SLURM. 
	For example, the very first line, "#!/bin/bash", is not a comment. 
	It ensures that you are executing BASH which is a shell with many features. 
	All of the commands that begin with "SBATCH" are extremely important 
	because they instruct SLURM how to set up and run your job. 

	More information on SLURM is available in the Quick Start Guide [1]. 

	**File: scripts/count_sequence_lengths.slurm**

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

	**File: scripts/count_sequence_lengths.slurm**

	Run the script using the sbatch utility, which tells the system to send the job to SLURM.

		$ sbatch scripts/count_sequence_lengths.slurm

	Check if the job is running. It may be waiting for space on a node to become available. 

	Look up your job by the "NAME" column which should display "Count_Sequence_Lengths". 
	It may print only part of the name, such as "Count_Se". 
		
		$ squeue

	If space is available, it is very likely that the job finishes before you are able to see it in-progress.
	When squeue no longer lists the job, view your results. 
	Both file names are dynamic in that certain parts of the file names are based 
	on the SLURM job ID and the name of the node that created the file. 

	First check out the error file to see if anything went wrong. 
	The file names starts with "count_sequence_length" and the error one ends with ".err".

		$ ls

		$ less count_sequence_length.[generated by HPC].err

	If the file is empty, then there were no errors.
	If the file was not empty, then something is amiss. 
	Make sure that you typed each step correctly. 
	A single typo or skipped step could make the difference. 
	If you feel confident that you did everything correctly, 
	ask for help on the HPC forums where I and other users are glad to be of assistance [9]. 

	Check the output file to see your result. 

		$ head count_sequence_length.[generated by HPC].out

		SEQUENCE_ID,LENGTH
		GBAP3884X13|Salamandrella_keyserlingii|COIX5P|JX508753|288315,1000
		GBHS7024X13|Homo_sapiens|COIX5P|FJ383500|9606,1000
		GBHS8800X13|Homo_sapiens|COIX5P|HM625681|9606,1000
		GBIR3452X13|Myiomela_albiventris|COIX5P|GU644565|958669,1000
		GBIR4543X13|Pterodroma_feae|COIX5P|JX674139|461684,1000
		GBMA6354X13|Potorous_tridactylus_tridactylus|COIX5P|JX111897|223565,1000
		MHPAF279X11|Fabales|matK|JQ587731|72025,1012
		TCAFR430X10|Malvales|matK|KC627729|41938,1049
		GBVI3027X11|Niedenzuella_sericea|matK|HQ247366|1027194,1098



### Leverage bio-informatics tools

In the last section, you used basic Linux commands.
You may have noticed that the complexity of commands quickly rose from the simple grep command to count the number of sequences 
to the much more involved steps it took to find the longest sequence. 
At this rate, it would be extremely difficult to use these tools to perform a complex sequence analysis. 
Fortunately there are numerous bio-informatics tools which accept the FASTA format. 
However, these programs may be picky about headers, upper or lower case sequences, and number of lines in a sequence. 
You may have to use Linux commands to prepare the FASTA files first.

1. Convert DNA to RNA 

	RNA is a transciption of DNA used to synthesize proteins, 
	but in an RNA sequence the Thymine nucleotide is replaced with Uracil. 
	You need to replace each "t" with "u".
	This can be accomplished with the fasta_nucleotide_changer tool, 
	which is part of fastx_toolkit [10]. 

		$ module load fastx_toolkit

	Use "-r" to indicate "DNA to RNA".
	Use "-i" to specify the input FASTA file.

		$ fasta_nucleotide_changer -r -i sample_data/GENBANK.fasta 
		fasta_nucleotide_changer: found invalid nucleotide sequence (aactttatatttcatatttggagcctgggctggacttttaggttcttctctcagagctct) on line 2

	"Found invalid nucleotide sequence"? This is our first example of the importance of being to manipulate FASTA files.
	The documentation for the fastx_toolkit specifies that all FASTA sequences must be single-line and upper case. 

	Using the single-line FASTA generated earlier, convert all lower case to upper case with awk [11].

		$ awk '{ if ($0 !~ />/) {print toupper($0)} else {print $0} }' GENBANK_single_test.fasta > GENBANK_single_upper_test.fasta

	Use the newly formatted FASTA file to convert DNA to RNA.

		$ fasta_nucleotide_changer -r -i GENBANK_single_upper_test.fasta > GENBANK_RNA.fasta
		$ head -n 4 GENBANK_RNA.fasta

		>909740163 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Arthropoda, subphylum: Chelicerata, class: Arachnida, subclass: Acari, superorder: Acariformes, species: Sarcoptiformes sp. ; Sarcoptiformes sp. BOLD:ACK7604
		AACUUUAUAUUUCAUAUUUGGAGCCUGGGCUGGACUUUUAGGUUCUUCUCUCAGAGCUCUUAUUCGACUUGAAUUAGGACAACCUGGUUCUUUAUUAGGAAACGAUCAAAUUUAUAACACAAUUGUGACAGCUCACGCCUUUGUUAUAAUUUUCUUUAUGGUAAUACCAAUUAUAAUCGGAGGAUUCGGUAAUUGAUUAGUACCAAUAAUAAUCGGAGCUCAAGAUAUAGCUUUCCCACGAAUAAAUAAUAUAAGAUUUUGACUACUACCCCCCUCCCUAUUUCUUCUAGCCAUUUCAGCUUUUGCUGGAACGGGGNNGGGUACUGGAUGAACUGUGUACCCCCCACUCUCUAGAAGAAUUUUUCAAGCAGACAUUUCCGUAGAUCUCGCCAUCUUUAGACUACAUAUAGCUGGUAUAUCUUCUAUUUUAGGAGCUAUCAACUUUAUUACGACUAUUUUAAAUAUAUCAAACUCACACUUAACACCAGAUUCAAUUCCUUUAUUUGUAUGGUCAGUUUUAAUUACUUCUGUUCUUCUCUUACUAUCUUUACCAGUCUUAGCUGGAGCUAUCACAAUACUACUAACAGAC
		>327498455 count=1; ; superkingdom: Eukaryota, kingdom: Metazoa, phylum: Chordata, subphylum: Craniata, class: Mammalia, superorder: Laurasiatheria, order: Chiroptera, suborder: Microchiroptera, family: Phyllostomidae, subfamily: Stenodermatinae, genus: Artibeus, species: Artibeus planirostris ; Artibeus planirostris
		ACUUUAUACCUAUUAUUUGGUGCUUGAGCAGGUAUAGUAGGUACUGCACUAAGUCUUCUUAUUCGUGCAGAACUUGGCCAACCUGGAGCCCUAUUAGGUGAUGAUCAAAUCUAUAACGUAAUCGUAACAGCUCAUGCUUUCGUAAUAAUUUUCUUUAUAGUAAUGCCUAUUAUAAUUGGGGGAUUCGGUAAUUGAUUAGUACCACUAAUAAUUGGCGCACCCGAUAUAGCAUUCCCACGAAUAAAUAAUAUAAGUUUCUGACUCCUCCCACCUUCCUUCCUACUUUUACUUGCUUCCUCUACUGUUGAAGCUGGCGUAGGAACAGGUUGAACCGUAUACCCACCACUAGCCGGAAAUCUAGCACAUGCUGGAGCUUCAGUUGACCUAGCUAUUUUCUCUCUUCAUCUAGCCGGAGUUUCAUCAAUCCUUGGAGCUAUUAAUUUCAUUACUACAAUUAUUAAUAUAAAACCACCUGCCCUCUCUCAAUAUCAAACACCCUUAUUUGUCUGAUCUGUUUUAAUCACCGCUGUUUUAUUACUCCUGUCUCUUCCUGUCUUAGCAGCAGGUAUUACUAUACUCCUAACAGACCGAAACCUUAAUACCACAUUCUUUGAUCCAGCUGGAGGAGGAGACCCCAUUUUAUAUCAACACCUAUUC


2. BLAST

	There is a very good chance that you are reading this tutorial because a professor told you to BLAST some sequences.
	BLAST, or Basic Local Alignment Search Tool [12], 
	compares the sequences in a FASTA file to those in a reference database.
	The program finds similar regions between a query and reference sequence and computes a similarity score. 
	BLAST returns the closest matches for each sequence in your FASTA. 
	The amount of sequences in your FASTA do not matter since each is a completely independent computation. 


	**File: scripts/blast_serial.slurm**

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

	**File: scripts/blast_serial.slurm**

	Submit the job.

		$ sbatch scripts/blast_serial.slurm

	Use squeue to check the progress.

		$ squeue

	If it is ready, check your results.

		$ head BLAST_serial.[HPC generated]_test.err
		$ head -n 20 BLAST_serial.[HPC generated]_test.out
		Blast4-archive ::= {
		  request {
		    ident "2.4.0+",
		    body queue-search {
		      program "blastn",
		      service "megablast",
		      queries bioseq-set {
			seq-set {
			  seq {
			    id {
			      local str "Query_1"
			    },
			    descr {
			      user {
				type str "CFastaReader",
				data {
				  {
				    label str "DefLine",
				    data str ">909740163 count=1; ; superkingdom: Eukaryota,
		 kingdom: Metazoa, phylum: Arthropoda, subphylum: Chelicerata, class:


	This type of BLAST result is very intimidating to read and process.
	It is an archival format ("-outfmt 11") that lets you convert it friendlier formats.

		$ module load blast+
		$ blast_formatter -archive BLAST_serial.[HPC Generated]_test.out \
		$ -outfmt "10 qacc sacc evalue qstart qend sstart send" > BLAST_GENBANK_test.csv
		$ head BLAST_GENBANK_test.csv
		909740163,GBMA7435X13|Thomomys_umbrinus|COIX5P|KC589037|50725;,589,49,636
		909740163,GBMA7465X13|Thomomys_umbrinus|COIX5P|JX520526|50725;,589,118,636
		909740163,ABSA049X06|Zygodontomys_brevicauda|COIX5P|JF492747|157541;,589,59,588
		909740163,ABSA054X06|Zygodontomys_brevicauda|COIX5P|JF492743|157541;,589,59,588
		909740163,ABSA053X06|Zygodontomys_brevicauda|COIX5P|JF492744|157541;,589,59,588
		909740163,ABSA050X06|Zygodontomys_brevicauda|COIX5P|JF492746|157541;,589,59,588
		909740163,GBSP5441X13|Nemertea|COIX5P|EU255629|6217;,577,39,556
		909740163,GBMA3817X12|Phyllomys_mantiqueirensis|COIX5P|JF297671|466157;,589,1,588
		909740163,ABMXB220X06|Handleyomys_melanotis|COIX5P|JQ600315|1499497;,589,1,588
		909740163,RBCMI557X14|Octopoda|COIX5P|6638;,579,62,579


### Speed up With parallel processing

While the previous BLAST job completed quickly, it was using a FASTA containing only 10 sequences.
Another other FASTA file, GENBANK_large.fasta, has 500 sequences. 
As mentioned earlier, each sequence is processed indepedently.
This means that it is a perfect candidate for parallel processing. 
We call these independent tasks "embarrasingly parallel" 
since you can simply divide the data into multiple smaller files 
and run the program with each file at the same time. 

Each parallel node has 20 CPU cores. 
You will split up the file into 20 chunks so that each core can process a one of the twenty.

1. Split up FASTA

	The genometools suite [13] has a utility for splitting a FASTA into a specified number of smaller files.

		$ module load genometools
		$ gt splitfasta -numfiles 20 sample_data/GENBANK_large.fasta
		$ ls sample_data
		BOLD_sample.fasta       GENBANK_large.fasta.13  GENBANK_large.fasta.20
		BOLD_small.fasta        GENBANK_large.fasta.14  GENBANK_large.fasta.3
		GENBANK.fasta           GENBANK_large.fasta.15  GENBANK_large.fasta.4
		GENBANK_large.fasta     GENBANK_large.fasta.16  GENBANK_large.fasta.5
		GENBANK_large.fasta.1   GENBANK_large.fasta.17  GENBANK_large.fasta.6
		GENBANK_large.fasta.10  GENBANK_large.fasta.18  GENBANK_large.fasta.7
		GENBANK_large.fasta.11  GENBANK_large.fasta.19  GENBANK_large.fasta.8
		GENBANK_large.fasta.12  GENBANK_large.fasta.2   GENBANK_large.fasta.9


2. Submit parallel BLAST job

	Now that you split the file into 20 chunks, you need a mechanism for running 20 instances of BLAST in parallel. 
	It is easy to implement this when jobs are "embarassingly parallel", such as in the case of BLAST.
	
	You will use the program GNU Parallel to do this. 
	Notice that each FASTA file chunk ends in a number. 
	You can use this number as an index and supply GNU Parallel with a sequence of numbers.

	This is demonstrated with the following script:

	**File: scripts/blast_parallel.slurm**
	
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

			
	**File: scripts/blast_parallel.slurm**

	Execute the SLURM job.
	
		$ sbatch scripts/blast_parallel.slurm
		
	This job may take a while. In my test, it took ~10 minutes to complete.

	You can monitor the progress as you did before. 

		$ squeue

	When it no longer appears in the queue, the job is complete. 
	A simple way to see if it produced results is to list the files and examine the file size. 

		$ ls -l | grep GENBANK.BLAST
		-rw-r--r-- 1 ekrell GenomicSamples 14206008 Oct 28 01:48 GENBANK.BLAST.1
		-rw-r--r-- 1 ekrell GenomicSamples 14566774 Oct 28 01:48 GENBANK.BLAST.10
		-rw-r--r-- 1 ekrell GenomicSamples 11986845 Oct 28 01:48 GENBANK.BLAST.11
		-rw-r--r-- 1 ekrell GenomicSamples 15756123 Oct 28 01:48 GENBANK.BLAST.12
		-rw-r--r-- 1 ekrell GenomicSamples 14409369 Oct 28 01:48 GENBANK.BLAST.13
		-rw-r--r-- 1 ekrell GenomicSamples 13149579 Oct 28 01:48 GENBANK.BLAST.14
		-rw-r--r-- 1 ekrell GenomicSamples 13292173 Oct 28 01:48 GENBANK.BLAST.15
		-rw-r--r-- 1 ekrell GenomicSamples 13821994 Oct 28 01:48 GENBANK.BLAST.16
		-rw-r--r-- 1 ekrell GenomicSamples 12331337 Oct 28 01:48 GENBANK.BLAST.17
		-rw-r--r-- 1 ekrell GenomicSamples 15440850 Oct 28 01:48 GENBANK.BLAST.18
		-rw-r--r-- 1 ekrell GenomicSamples 14719707 Oct 28 01:48 GENBANK.BLAST.19
		-rw-r--r-- 1 ekrell GenomicSamples 13727646 Oct 28 01:48 GENBANK.BLAST.2
		-rw-r--r-- 1 ekrell GenomicSamples  1727170 Oct 28 01:46 GENBANK.BLAST.20
		-rw-r--r-- 1 ekrell GenomicSamples 11141514 Oct 28 01:48 GENBANK.BLAST.3
		-rw-r--r-- 1 ekrell GenomicSamples 13914698 Oct 28 01:48 GENBANK.BLAST.4
		-rw-r--r-- 1 ekrell GenomicSamples 12200232 Oct 28 01:48 GENBANK.BLAST.5
		-rw-r--r-- 1 ekrell GenomicSamples 13775421 Oct 28 01:48 GENBANK.BLAST.6
		-rw-r--r-- 1 ekrell GenomicSamples 13969303 Oct 28 01:48 GENBANK.BLAST.7
		-rw-r--r-- 1 ekrell GenomicSamples 13824919 Oct 28 01:48 GENBANK.BLAST.8
		-rw-r--r-- 1 ekrell GenomicSamples 13099031 Oct 28 01:48 GENBANK.BLAST.9


	The fifth column is the size. These would have a size of 0 if they were empty. 

	Examine one of the resulting files. 

		$ blast_formatter -archive GENBANK.BLAST.1 -outfmt 10 | head

		933504075,CFWIE353X10|Turbellaria|COIX5P|166384;,84.475,657,102,0,2,658,2,658,0.0,649
		933504075,THBL057X14|Anthomedusae|COIX5P|406427;,84.275,655,99,4,6,658,6,658,1.16e-180,636
		933504075,GBMIX876X14|Tricladida|COIX5P|6159;,83.156,659,109,2,1,658,1,658,4.25e-170,601
		933504075,PHDIP360X11|Ctenophora_dorsalis|COIX5P|KT118918|1473747;,83.056,661,106,6,1,658,1,658,1.98e-168,595
		933504075,PHDIP349X11|Ctenophora_dorsalis|COIX5P|KT112154|1473747;,83.056,661,106,6,1,658,1,658,1.98e-168,595
		933504075,ERPIR156X12|Ctenophora_dorsalis|COIX5P|KR635670|1473747;,83.056,661,106,6,1,658,1,658,1.98e-168,595
		933504075,PHMTV001X10|Ctenophora_dorsalis|COIX5P|KR750821|1473747;,83.056,661,106,6,1,658,1,658,1.98e-168,595
		933504075,PHDIP357X11|Ctenophora_dorsalis|COIX5P|KT111761|1473747;,83.056,661,106,6,1,658,1,658,1.98e-168,595
		933504075,PHDIP346X11|Ctenophora_dorsalis|COIX5P|KT102378|1473747;,83.056,661,106,6,1,658,1,658,1.98e-168,595
		933504075,PHDIP362X11|Ctenophora_dorsalis|COIX5P|KT107425|1473747;,83.056,661,106,6,1,658,1,658,1.98e-168,595
	
	
	If everything went as expected, you have successfully completed a parallel job on the HPC.
	
	Now that you have learned how to split up files and run programs in parallel, 
	it is extremely important to understand when using parallel is appropriate.
	If the sequences in the FASTA are *not* processed independently,
	then you may not get the same result when you split up the input data. 
	For example, if you are using a program such as RAxML [14] to generate phylogenetic trees from your data, 
	then all of the data needs to be available to a single instance of the program.
	You need to analyze your situation and understand the nature of what you are processing 
	to determine if this technique is appropriate. 
	If you are having trouble deciding if it is okay, feel free to ask for advice on the HPC forum [9].
	

### Clean environment

You have generated several test files throughout this tutorial.
Since those outputs are just examples, it is recommended that you delete them to save disk space. 
To make it easy, almost every file generated has "test" somewhere in the file name. 
	
List all files that contain "test" in the name, and check that there is nothing that you do not want deleted.
	
		$ ls | grep test

If everything is okay to delete, do so.

		$ rm *test*

Do the same for the BLAST results
	
		$ rm BLAST_parallel.* GENBANK.BLAST.*

	
You have completed the tutorial! 
Processing data on the HPC presents a variety of challenges, 
but you now have some examples you can refer to and build off of as
you explore and put the HPC to work. 



### References:

[1] TAMU-CC HPC: https://hpc.tamucc.edu/

[2] TAMU-CC VPN: https://it.tamucc.edu/vpn/index.html

[3] HPC Quick Start Guide: https://hpc.tamucc.edu/forum/viewtopic.php?f=3&t=8

[4] Linux Cheat Sheet: http://genomics.tamucc.edu/assets/file/Cheat%20Sheet%2010-4-14.pdf

[5] FASTA Format reference: https://en.wikipedia.org/wiki/FASTA_format

[6] NCBI Taxonomy Browser: https://www.ncbi.nlm.nih.gov/nuccore/EU827594.1

[7] Regular expressions reference: http://regexr.com/

[8] Sed command source: http://stackoverflow.com/a/15857951

[9] HPC Forum: https://hpc.tamucc.edu/forum/

[10] FASTX-Toolkit: http://hannonlab.cshl.edu/fastx_toolkit/

[11] Awk command source: http://some-hints.blogspot.com/2013/07/how-to-convert-fasta-file-to.html

[12] BLAST: https://blast.ncbi.nlm.nih.gov/Blast.cgi

[13] GenomeTools: http://genometools.org/

[14] RAxML: http://sco.h-its.org/exelixis/web/software/raxml/index.html

