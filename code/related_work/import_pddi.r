library(dplyr)
library(DBI)

df=NULL
df = read.csv('~/Desktop/temp/CombinedDatasetNotConservative.csv', sep= "\t", header = T, fill = T, quote = "")
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="rw_pddi")

dbWriteTable(con, "CombinedDatasetNotConservative", df)
dbDisconnect(con)
df=NULL








"
if (!requireNamespace(\"BiocManager\", quietly = TRUE))
  install.packages(\"BiocManager\")

BiocManager::install(\"MeSH.db\")

BiocManager::install(\"MeSH.Hsa.eg.db\")

library(\"MeSH.Hsa.eg.db\")

library(\"MeSHDbi\")

example(\"makeGeneMeSHPackage\")
data(PAO1)
data(PAO1)
dbGetQuery(dbconn(MeSH.Hsa.eg.db), \"SELECT * FROM DATA WHERE SOURCEID = '16461020'\" )


dbfile(MeSH.Hsa.eg.db)
"
