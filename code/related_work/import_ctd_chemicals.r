library(dplyr)
library(DBI)

df=NULL
df = read.csv('~/Desktop/2020_Spring/Datasets/CTD/CTD_chemicals.csv',  row.names = NULL)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="rw_CTD")

dbWriteTable(con, "chemicals", df)
dbDisconnect(con)
df=NULL