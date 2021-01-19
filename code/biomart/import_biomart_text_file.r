library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/BioMart/mart_export.txt', header = T, sep = '\t', fill = T, quote = "")
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="BioMart")

dbWriteTable(con, "mart_export", df)
dbDisconnect(con)
df=NULL