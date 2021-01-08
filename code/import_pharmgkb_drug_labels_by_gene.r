library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/PharmGKB/drugLabels/drugLabels.byGene.tsv',  header = T, sep = '\t', fill = T, quote = "")

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="PharmGKB")

dbWriteTable(con, "drug_labels_by_gene_ann", df)
dbDisconnect(con)
df=NULL