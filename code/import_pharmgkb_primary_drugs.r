library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/PharmGKB/primary/drugs/drugs.tsv',  header = T, sep = '\t', fill = T, quote = "")

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="PharmGKB")

dbWriteTable(con, "drugs", df)
dbDisconnect(con)
df=NULL