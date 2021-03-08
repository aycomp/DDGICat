library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/CTD/CTD_chem_gene_ixns.csv',  header = T, sep = ',', fill = T, quote = "")
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="rw_CTD")

dbWriteTable(con, "chem_gene_ixns", df)
dbDisconnect(con)
df=NULL