library(dplyr)
library(DBI)

df = read.table('~/Desktop/drugLabels.byGene.tsv', header = T, sep = '\t', fill = T)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="PharmGKB")

dbWriteTable(con, "annotations_drug_labels_by_gene", df)
dbDisconnect(con)