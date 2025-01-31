# Extract DE results for the contrast TNBC vs NonTNBC
res_TNBC_vs_NonTNBC <- results(dds, contrast = c("condition", "TNBC", "NonTNBC"))

# View the results
head(res_TNBC_vs_NonTNBC)

# Summary of the results
summary(res_TNBC_vs_NonTNBC)

# Number of DE genes with padj < 0.05
de_genes_TNBC_vs_NonTNBC <- res_TNBC_vs_NonTNBC[which(res_TNBC_vs_NonTNBC$padj< 0.05), ]
de_genes_TNBC_vs_NonTNBC

# Number of up-regulated genes
up_regulated <- sum(de_genes_TNBC_vs_NonTNBC$log2FoldChange > 0, na.rm = TRUE)
up_regulated
# Number of down-regulated genes
down_regulated <- sum(de_genes_TNBC_vs_NonTNBC$log2FoldChange < 0, na.rm = TRUE)
down_regulated
# Print the results
cat("Up-regulated genes:", up_regulated, "\n")
cat("Down-regulated genes:", down_regulated, "\n")

#anotating the results with gene names

# Ensure AnnotationDbi and org.Hs.eg.db are installed
BiocManager::install(c("AnnotationDbi", "org.Hs.eg.db"))

# Load the libraries
library(AnnotationDbi)
library(org.Hs.eg.db)

#Input the gene name
res_TNBC_vs_NonTNBC$geneName <- mapIds(org.Hs.eg.db,
                                   keys= rownames(res_TNBC_vs_NonTNBC),
                                   column = "SYMBOL",
                                   keytype = "ENSEMBL",
                                   multivals = "first")
res_TNBC_vs_NonTNBC
res_sig <- res_TNBC_vs_NonTNBC[which(res_TNBC_vs_NonTNBC$padj < 0.05 & abs(res_TNBC_vs_NonTNBC$log2FoldChange) > 0), ]
#Getting the top genes with the lowest p-value
genes_interest_ids <- head(rownames(res_TNBC_vs_NonTNBC[order(res_TNBC_vs_NonTNBC$padj),]), 10)
genes_interest_ids <- c(genes_interest_ids, 
                        rownames(res[res$geneName %in% c("SPARC", "APOE"),]))
genes_interest_ids

#subset the vst transformed matrix
vsd_subset <- assay(vst(dds, blind = TRUE))[genes_interest_ids, ]
row.names(vsd_subset) <- res_TNBC_vs_NonTNBC[genes_interest_ids, "geneName"]
#heatmap
pheatmap_anotation_col  <- data.frame(type=colData(dds)[,"condition"])
rownames(pheatmap_anotation_col) <- colnames(assay(ntd))
library(pheatmap)
colnames(vsd_subset) <- c("HER21", "HER22", "HER23",
                          "NonTNBC1", "NonTNBC2", "NonTNBC3",
                          "Normal1", "Normal2", "Normal3",
                          "TNBC1", "TNBC2", "TNBC3")
rownames(pheatmap_anotation_col) <- colnames(vsd_subset)
pheatmap(vsd_subset, 
         cluster_rows=FALSE, 
         show_rownames=TRUE,
         cluster_cols=FALSE, 
         annotation_col=pheatmap_anotation_col, 
         color = colorRampPalette(c("blue", "white", "red"))(50))
BiocManager::install("EnhancedVolcano")
library(ggrepel)
library(EnhancedVolcano)
EnhancedVolcano(res_TNBC_vs_NonTNBC,
                lab = rownames(res),
                x = 'log2FoldChange',
                y = 'pvalue')
