  library(dplyr)
  library(DBI)
  
  df=NULL
  df = read.table('~/Desktop/2020_Spring/Datasets/RelatedWork/DGIdb/interactions.tsv', header = T, sep = '\t', fill = T, quote = "")
  head(df)
  
  con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DGIdb")
  
  dbWriteTable(con, "interactions", df)
  dbDisconnect(con)
  df=NULL