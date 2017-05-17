# fastqc_dataset1:

First 10,000 reads from U0a_CGATGT_L001, a library in the 300x NA12878 data set generated by the Genome in a Bottle (GIAB) consortium.

Paper: http://www.nature.com/articles/sdata201625

> wget -q -O - ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/131219_D00360_005_BH814YADXX/Project_RM8398/Sample_U0a/U0a_CGATGT_L001_R1_001.fastq.gz | zcat | head -40000 | gzip > fastqc_dataset1.fq.gz
> wget -q -O - ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/131219_D00360_005_BH814YADXX/Project_RM8398/Sample_U0a/U0a_CGATGT_L001_R2_001.fastq.gz | zcat | head -40000 | gzip > fastqc_dataset2.fq.gz

# dataset_2

First 10,000 reads from SRR521458, an RNA-seq library with high error rate

> mkdir dataset_2
> # requires the sra toolkit
> fastq-dump --split-files -A SRR521458
> mv SRR521459_1.fastq dataset_2/d2raw.1.fq.gz
> mv SRR521459_2.fastq dataset_2/d2raw.2.fq.gz
> echo ">adapter1\nAGATCGGAAGAGCGGTTCAGCAGGAATGCCGAGACCGATATCGTATGCCGTCTTCTGCTTG" > adapter1.fa
> echo ">adapter2\nAGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT" > adapter2.fa

# dataset_3

First 100,000 reads from the ENCODE GM12878 WGBS library.

> mkdir -p dataset_3
> wget -qO- https://www.encodeproject.org/files/ENCFF798RSS/@@download/ENCFF798RSS.fastq.gz | gunzip | head -4000000 | gzip > dataset_3/d3raw.1.fq.gz
> wget -qO- https://www.encodeproject.org/files/ENCFF113KRQ/@@download/ENCFF113KRQ.fastq.gz | gunzip | head -4000000 | gzip > dataset_3/d3raw.2.fq.gz
> echo "adapter1\nAGATCGGAAGAGCACACGTCTGAACTCCAGTCACCAGATCATCTCGTATGCCGTCTTCTGCTTG" > adatper1.fa
> echo "adapter2\nAGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTAGATCTCGGTGGTCGCCGTATCATT" > adapter2.fa

# aligner_input

Same as fastqc_dataset1, except 100k reads rather than 10k

# aligner_output

> BAM="ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/NHGRI_Illumina300X_novoalign_bams/HG001.GRCh38_full_plus_hs38d1_analysis_set_minus_alts.300x.bam"
> samtools view -hb $BAM chr1:10000000-11000000 > aligner_output.bam

# somatic

Matched tumor-normal whole exome sequencing sample TCRBOA1 from Texas Cancer Research Biobank

Paper: http://www.nature.com/articles/sdata201610

It is necessary to sign up for sftp access to the data: http://txcrb.org/open.html
Once the data is downloaded, extract a short slice of the BAMs where we know there are some somatic mutations:

> SLICE=chr1:16899000-16920000
> samtools view -hb $NORMAL $SLICE > normal.bam
> samtools view -hb $TUMOR $SLICE > tumor.bam

For variant calling, this requires the GRCh37 lite reference: http://www.bcgsc.ca/downloads/genomes/9606/hg19/1000genomes/bwa_ind/genome/

Another example dataset from SRA:

* normal: https://www.ncbi.nlm.nih.gov/sra/SRX151860[accn]
* tumor: https://www.ncbi.nlm.nih.gov/sra/SRX151861[accn]

# trio

* son: ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG002_NA24385_son/NIST_Illumina_2x250bps/novoalign_bams/HG002.GRCh38.2x250.bam
* father: ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG003_NA24149_father/NIST_Illumina_2x250bps/novoalign_bams/HG003.GRCh38.2x250.bam
* mother: ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/AshkenazimTrio/HG004_NA24143_mother/NIST_Illumina_2x250bps/novoalign_bams/HG004.GRCh38.2x250.bam

For each file grab a slice of the BAM:

> samtools view -hb $SON chr1:10000000-11000000 > son.bam
> samtools view -hb $FATHER chr1:10000000-11000000 > father.bam
> samtools view -hb $MOTHER chr1:10000000-11000000 > mother.bam

Another example dataset: http://bcb.io/2014/05/12/wgs-trio-variant-evaluation/

# annotation

dbSNP chr1:10M-20M

> tabix -h ftp://ftp.ncbi.nih.gov/snp/organisms/human_9606/VCF/All_20160527.vcf.gz 1:10000000-20000000 | bgzip > annotations.vcf.gz

# SVs

We use the GIAB NA12878 dataset. We select a small region that contains 5 high-confidence SVs according to the svclassify paper.

Paper: http://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-016-2366-2

> BAM="ftp://ftp-trace.ncbi.nlm.nih.gov/giab/ftp/data/NA12878/NIST_NA12878_HG001_HiSeq_300x/NHGRI_Illumina300X_novoalign_bams/HG001.GRCh38_full_plus_hs38d1_analysis_set_minus_alts.300x.bam"
> samtools view -hb $BAM 1:69800000-71000000 > sv.bam