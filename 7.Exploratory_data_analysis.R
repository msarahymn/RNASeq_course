if (!require("BiocManager", quietly = TRUE))
  install.packages("BiocManager")
BiocManager::install("DESeq2", force = TRUE)

#create DESeq2 Dataset
library(DESeq2)
#Load count and experimental designs
gene_count <- read.table("Documents/RNAseq/genecountpairedend_matrix.txt",
                         header=TRUE, row.names = 1)
gene_count
#create DESeq2 Dataset
colData<- data.frame(
  row.names = colnames(gene_count),
  condition = c("HER2", "HER2", "HER2", 
                "NonTNBC", "NonTNBC", "NonTNBC",
                "Normal", "Normal", "Normal",
                "TNBC", "TNBC", "TNBC")
)
colData$condition <- as.factor(colData$condition)
#Create DESeqDataSet
dds <-DESeqDataSetFromMatrix(
  countData = gene_count,
  colData = colData,
  design = ~ condition
)
dds
#RunDESeq2 analysis
dds <- DESeq(dds)
dds
res <- results(dds)
res
summary(res)
#Normalize the Data
vsd <- vst(dds, blind = TRUE)  #Variance stabilizing transformation
vsd
#Plot PCA
plotPCA(vsd, intgroup="condition")


