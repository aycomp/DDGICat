library(dplyr)
library(DBI)

df = read.table('~/Desktop/phenotypes.tsv', header = T, sep = '\t', fill = T)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="PharmGKB")

dbWriteTable(con, "primary_phenotypes", df)
dbDisconnect(con)