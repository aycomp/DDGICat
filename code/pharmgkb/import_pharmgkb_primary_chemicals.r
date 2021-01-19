library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/PharmGKB/primary/chemicals/chemicals.tsv', header = T, sep = '\t', fill = T, quote = "")
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="PharmGKB")

dbWriteTable(con, "primary_chemicals", df)
dbDisconnect(con)
df=NULL