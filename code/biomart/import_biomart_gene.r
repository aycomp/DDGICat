#if (!requireNamespace("BiocManager", quietly = TRUE))
#  install.packages("BiocManager")
#BiocManager::install("biomaRt")

library(biomaRt)
library(DBI)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")

data = NULL
data <- dbGetQuery(con,"SELECT DISTINCT(gene_name) AS gene_name FROM drug_snp");
drug_related_genes = c(data$gene_name)

ensembl = useEnsembl(biomart="ensembl", dataset="hsapiens_gene_ensembl", GRCh = 37)

resultset <- 
  getBM(attributes=c(
    'ensembl_gene_id',
    'ensembl_transcript_id',
    'hgnc_symbol',
    'description',
    'uniprot_gn_id',
    'uniprot_gn_symbol',
    'chromosome_name',
    'start_position',
    'end_position'), 
        filters = 'hgnc_symbol', 
        values = drug_related_genes, 
        mart = ensembl)


dbWriteTable(con, "gene", resultset)
dbDisconnect(con)

