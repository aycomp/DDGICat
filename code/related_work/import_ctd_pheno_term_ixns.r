library(dplyr)
library(DBI)

df=NULL
df = read.csv('~/Desktop/2020_Spring/Datasets/CTD/CTD_pheno_term_ixns.csv',  row.names = NULL)
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="rw_CTD")

dbWriteTable(con, "pheno_term_ixns", df)
dbDisconnect(con)
df=NULL