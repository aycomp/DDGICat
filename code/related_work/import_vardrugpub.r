  library(dplyr)
  library(DBI)
  
  df=NULL
  df = read.table('~/Desktop/2020_Spring/Datasets/RelatedWork/VarDrugPub/VarDrugPub_triplet_withSentences_20170523.txt', header = T, sep = '\t', fill = T, quote = "")
  head(df)
  
  con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="VarDrugPub")
  
  dbWriteTable(con, "triplet_withSentences", df)
  dbDisconnect(con)
  df=NULL