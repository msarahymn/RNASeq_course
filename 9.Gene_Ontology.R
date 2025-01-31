#GO over-representation analysis 
BiocManager::install("clusterProfiler")
BiocManager::install("org.Hs.eg.db")
library(org.Hs.eg.db)
library(clusterProfiler)

#NonTNBC vs TNBC
geneid <- rownames(de_genes_TNBC_vs_NonTNBC)
universeid <- rownames(res_TNBC_vs_NonTNBC)
universeid

ego<- enrichGO(gene          = geneid,
                  universe      = universeid,
                  OrgDb         = "org.Hs.eg.db",
                  ont           = "BP",
                  keyType = 'ENSEMBL')
head(ego)
ego

#Bar Plot
library(enrichplot)
library(dplyr)

barplot(ego, showCategory=7)
mutate(ego, qscore = -log(p.adjust, base=7)) %>% 
  barplot(x="qscore")
dotplot(ego, showCategory=7)
