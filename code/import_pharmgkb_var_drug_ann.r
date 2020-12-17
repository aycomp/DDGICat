library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/PharmGKB/annotations/var_drug_ann.tsv',  header = T, sep = '\t', fill = T, quote = "")
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="PharmGKB")

dbWriteTable(con, "var_drug_ann", df)
dbDisconnect(con)
df=NULL