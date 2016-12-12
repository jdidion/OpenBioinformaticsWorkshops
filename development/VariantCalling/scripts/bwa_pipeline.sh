#!/bin/bash

# This is a shell script. You have three options to run this program:
#
# 1. Call it with bash:
#     bash bwa_pipeline.sh <parameters>
# 2. Call it directly:
#     ./bwa_pipeline.sh <parameters>
# 3. Add the current directory to your PATH and then run it like any other program:
#     CURDIR=`pwd`
#     export PATH=$CURDIR:$PATH
#     bwa_pipeline.sh <parameters>
#
# Note that options 2 and 3 require you to make the script executable. First, make
# sure the script starts with a 'shebang' line (the '#!/bin/bash' at the top of the
# file. Second, set the file's executable flag:
#
#     chmod +x bwa_pipeline.sh

# This particular script runs our BWA alignment pipeline for paired-end reads. You
# call it using three arguments: the two input FASTQ files, and the output BAM file.
#
#     bwa_pipeline.sh FASTQ.1 FASTQ.2 READGROUP BAM

# Here we assign input parameters to names that make more sense
FQ1=$1
FQ2=$2
RG=$3
BAM=$4

# We'll also set a variable to point to our index; you could change the value of
# the variable to point to a different index, or add another paramter to the script
# to pass in the path to the index on the command line
INDEX=~/Desktop/variant/resources/Homo_sapiens_assembly38.fasta.64

# Here's our pipeline.
#
# bwa mem: align the reads
# -M: marks split reads as secondary, which can be necessary for variant calling
# -t: number of threads; you could change this here or add an input parameter to 
#    set it on the command line
# -R: specify the read group
#
# samblaster: mark duplicates
# -M: is required to be compatible with the bwa mem -M flag
#
# sambamba view: convert SAM to BAM
# -S: input is in SAM format
# -f bam: output is in BAM format
# -h: include the header in the output
# /dev/stdin: the input; on linux, this means read from standard input
#
# sambamba sort: coordinate sort alignments
# -o: the output file 
#
# sambamba index: create the BAM index
#
# sambamba flagstat: compute alignment summary statistics
#
# The pipe ('|') character sends output from each program to the input of the
# next program in the pipeline. '&&' means to only run the next command if the
# previous one succeeds.

bwa mem -M -t 1 -R $RG $INDEX $FQ1 $FQ2 | \
samblaster -M | \
sambamba view -S -f bam -h -t 1 /dev/stdin | \
sambamba sort -o $BAM.bam -t 1 /dev/stdin && \
sambamba index $BAM.bam && \
sambamba flagstat $BAM.bam

# To enable variant calling, just replace the samblaster line with
# samblaster -M -e -d $BAM.disc.sam -s $BAM.split.sam

# Then add the following:
#for filetype in disc split
#do
#  sambamba view –S -h -f bam $BAM.$filetype.sam | \
#  sambamba sort -o $BAM.$filetype.bam -t 1 /dev/stdin && \
#  rm $BAM.$filetype.sam && \
#  sambamba index $BAM.$filetype.bam
#done

