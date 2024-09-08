#!/bin/bash

# Assigning variables for the input query file, input subject file and output file

query_file=$1
subject_file=$2
output_file=$3

# Running the blastn command, specifying matched sequence IDs and their identity with query file, and the length, along with starts and ends of alignment in query
blastn -query "$query_file" -subject "$subject_file" -task blastn-short -outfmt "6 sseqid sstart send pident length" -out blast_output.txt 

# Storing the number of nucleotides in the query file (which is 28 in our example) in a variable
nucleotide_count=$(tail -n +2 "$query_file" | wc -m)

# Identifying and outputting only perfect matches (Identity should be 100.00 and length should be that of the query sequence, which is stored in the "nucleotide_count variable")
# -v nucleotide_count="$nucleotide_count" will define the variable nucleotide_count within the awk environment, making it accessible within the script. The + prefix is used to convert the variable to a number.
awk -F'\t' -v nucleotide_count="$nucleotide_count" '$4 >= 100.00 && $5 >= +nucleotide_count' blast_output.txt > "$output_file"

# Printing the number of matches to stdout
awk '{sum += 1} END {print "The total number of matches is: " sum}' "$output_file"