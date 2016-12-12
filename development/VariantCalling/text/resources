# Sequencing

* Lists of methods/protocols
    * http://www.illumina.com/science/sequencing-method-explorer.html?sciid=2015257IBN2
    * https://www.abmgood.com/marketing/knowledge_base/next_generation_sequencing_experimental_design.php
* Library prep review: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4351865/
* Evaluation of bias in library prep: http://www.pnas.org/content/112/45/14024.abstract
* Synthetic long-read alternatives: http://www.illumina.com/techniques/sequencing/dna-sequencing/whole-genome-sequencing/de-novo-sequencing.html

# Converting SAM/BAM to FASTQ

This conversion uses Picard Tools (https://broadinstitute.github.io/picard/), a collection of useful tools for NGS data analysis.

After installing Picard (which requires Java), run the following command to convert SAM/BAM to FASTQ:

    java -jar picard.jar SamToFASTQ I=input.bam \
    FASTQ=read.1.fastq SECOND_END_FASTQ=read.2.fastq

# Alignment

* Burroughs-Wheeler Transform https://en.wikipedia.org/wiki/Burrows%E2%80%93Wheeler_transform
* Sambamba filtering "mini-language": https://github.com/lomereiter/sambamba/wiki/%5Bsambamba-view%5D-Filter-expression-syntax
* IGV: http://software.broadinstitute.org/software/igv/
* SAM format specification: https://samtools.github.io/hts-specs/SAMv1.pdf
* Explanation of SAM flags: http://djf604.github.io/SAM-flags-explained-improved/

# Reference genomes

Sources for non-human reference genomes:
* M. musculus (http://www.informatics.jax.org)
* C. elegans (http://www.wormbase.org)
* D. melanogaster (http://flybase.org)

# Variant calling

* VCF spec: https://samtools.github.io/hts-specs/VCFv4.1.pdf

## Creating a whitelist

This uses bedtools (http://bedtools.readthedocs.io/en/latest/)

1. Download the blacklist for your species: https://sites.google.com/site/anshulkundaje/projects/blacklists
2. Generate the complement BED file:

    bedtools complement -g REFERENCE -i BLACKLIST > whitelist.bed

## Parallelize FreeBayes

FreeBayes can be parallelized using the included freebayes-parallel script. Note the use of process substitution, which is similar to using pipes.

$ freebayes-parallel <(fasta_generate_regions.py REF.fai 50000) THREADS -f REF BAM_FILE | bgzip > var.vcf.gz

# Example (human) data sets

* Genome in a Bottle (https://sites.stanford.edu/abms/giab)
* Illumina Platinum Genomes (http://www.illumina.com/platinumgenomes/)

# Command line

* Cheat sheet https://www.cheatography.com/davechild/cheat-sheets/linux-command-line/

# Online help

* SEQANSWERS forum (http://seqanswers.com) for next-gen sequencing questions
* BIOSTARS forum (https://www.biostars.org) for bioinformatics questions
* STACK OVERFLOW (http://stackoverflow.com) for Linux/programming questions
* BCBIO (https://bcbio.wordpress.com) for software benchmarking,
variant-calling pipelines
* OMICTOOLS (https://omictools.com/) lists of alternative tools by application
