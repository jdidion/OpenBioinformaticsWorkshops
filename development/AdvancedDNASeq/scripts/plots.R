install.packages(c('dplyr', 'tidyr', 'ggplot2', 'devtools'))
devtools::install_github("rlbarter/superheat")
source("https://bioconductor.org/biocLite.R")
biocLite("GWASTools")
library(ggplot2)

pheno <- read.table('disease.phe', header=TRUE, stringsAsFactors=FALSE)

# Missing genotypes per SNP
snp.missing <- read.table("plink.lmiss", header=TRUE, stringsAsFactors=FALSE)
ggplot(snp.missing, aes(F_MISS)) + geom_histogram(binwidth=0.01)
sum(snp.missing$F_MISS > 0.1) / nrow(snp.missing)

# Missing genotypes per individual
indiv.missing <- read.table("plink.imiss", header=TRUE, stringsAsFactors=FALSE)
ggplot(indiv.missing, aes(F_MISS)) + geom_histogram(binwidth=0.001)
sum(indiv.missing$F_MISS > 0.1) / nrow(indiv.missing)

# Population-stratified allele frequencies
af <- read.table("plink.frq.strat", header=TRUE, stringsAsFactors=FALSE)
af$CLST <- factor(
    plyr::revalue(as.character(af$CLST), c('1'='HCB', '2'='JPT')),
    levels=c('HCB', 'JPT'))
af <- af %>% dplyr::select(SNP, CLST, MAF) %>% dplyr::filter(SNP!='.') %>% tidyr::spread('CLST', 'MAF')
ggplot(af, aes(HCB, JPT)) + geom_point(alpha=0.2) + geom_smooth(method='lm')

# Hardy-Weinberg
hw <- read.table("plink.hwe", header=TRUE, stringsAsFactors=FALSE)
for (status in c('AFF', 'UNAFF')) {
    hw.status <- hw %>% dplyr::filter(TEST==status) %>% dplyr::mutate(PADJ=p.adjust(P))
    ggplot(hw.status, aes(P)) + geom_histogram()
    ggplot(hw.status, aes(PADJ)) + geom_histogram()
}

# Relationship matrix
ids <- read.table('plink.rel.id')
rel <- read.table('plink.rel')
dimnames(rel) <- list(ids[,1], ids[,1])
diag(rel) <- 0
superheat::superheat(
    rel, left.label.text.size = 2, 
    bottom.label.text.size = 2, bottom.label.text.angle = 90, 
    pretty.order.rows = TRUE, pretty.order.cols = TRUE)

# IBD
ibd <- read.table('plink.genome', header=TRUE, stringsAsFactors=FALSE)
ibd <- dplyr::mutate(ibd, pop_pair=factor(paste0(substr(FID1,1,3), '_', pop2=factor(substr(FID2,1,3)))))
ggplot(ibd, aes(pop_pair, PI_HAT)) + geom_boxplot()

# Clustering
clusters <- read.table('plink.cluster2', header=FALSE, stringsAsFactors=FALSE)
clusters <- clusters[match(mds$FID, clusters[,1]),]
pheno2 <- pheno[match(mds$FID, pheno$FID),]

mds <- read.table('plink.mds', header=TRUE, stringsAsFactors=FALSE)
mds <- dplyr::mutate(mds, pop=factor(substr(FID,1,3)))
ggplot(mds, aes(C1,C2, colour=pop)) + geom_point()
ggplot(mds, aes(C1,C3, colour=pop)) + geom_point()
ggplot(mds, aes(C2,C3, colour=pop)) + geom_point()
mds %>% dplyr::filter(pop=='JPT') %>% dplyr::arrange(C1) # JPT253 is the outlier

# Association
assoc <- read.table('hapmap1.assoc', header=TRUE, stringsAsFactors=FALSE)
GWASTools::manhattanPlot(assoc$P, assoc$CHR)

assoc.adj <- read.table('hapmap1.assoc.adjusted', header=TRUE, stringsAsFactors=FALSE)
assoc.adj <- dplyr::arrange(assoc.adj, CHR, SNP)
GWASTools::manhattanPlot(assoc.adj$FDR_BH, assoc.adj$CHR, signif=0.05, ylim=c(0, 2))

assoc.perm <- read.table('hapmap1.assoc.perm', header=TRUE, stringsAsFactors=FALSE)
GWASTools::manhattanPlot(assoc.perm$EMP1, assoc.perm$CHR)

assoc.cond <- read.table('hapmap1_cond.cmh.adjusted', header=TRUE, stringsAsFactors=FALSE)
assoc.cond <- dplyr::arrange(assoc.cond, CHR, SNP)
GWASTools::manhattanPlot(assoc.cond$FDR_BH, assoc.cond$CHR, signif=0.05, ylim=c(0, 3))

assoc.qt.perm <- read.table('hapmap1_qt_cond.qassoc.perm', header=TRUE, stringsAsFactors=FALSE)
GWASTools::manhattanPlot(assoc.qt.perm$EMP1, assoc.qt.perm$CHR)

assoc.qt.cond <- read.table('hapmap1_qt_cond.qassoc.adjusted', header=TRUE, stringsAsFactors=FALSE)
assoc.qt.cond <- dplyr::arrange(assoc.qt.cond, CHR, SNP)
GWASTools::manhattanPlot(assoc.qt.cond$FDR_BH, assoc.qt.cond$CHR, signif=0.05, ylim=c(0, 4))

# Convert quantitative association output to summary statistics (Z-scores)
assoc.qt <- read.table('hapmap1_qt_cond.qassoc', header=TRUE, stringsAsFactors=FALSE)
assoc.summary <- assoc.qt %>% dplyr::mutate(Z=BETA/SE) %>% dplyr::select(CHR, BP, SNP, Z)
