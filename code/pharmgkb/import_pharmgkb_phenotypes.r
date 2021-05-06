library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/PharmGKB/phenotypes/phenotypes.tsv', header = T, sep = '\t', fill = T, quote = "")
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="PharmGKB")

dbWriteTable(con, "primary_phenotypes", df)
dbDisconnect(con)
df=NULL