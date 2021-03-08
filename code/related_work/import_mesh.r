require(XML)
data <- xmlParse("~/Desktop/2020_Spring/Datasets/MESH/desc2021.xml")




org        <- xpathApply(xml_data,"//iati-activity/reporting-org",xmlValue)

location <- as.list(xml_data[["data"]][["location"]][["point"]])





org        <- xpathApply(xml,"//iati-activity/reporting-org",xmlValue)
id         <- xpathApply(xml,"//iati-activity/iati-identifier",xmlValue)
title      <- xpathApply(xml,"//iati-activity/title",xmlValue)
desc.1     <- xpathApply(xml,"//iati-activity/description[@type='1']",xmlValue)
desc.2     <- xpathApply(xml,"//iati-activity/description[@type='2']",xmlValue)
status     <- xpathApply(xml,"//iati-activity/activity-status",xmlValue)
start.planned <- xpathApply(xml,"//iati-activity/activity-date[@type='start-planned']",xmlValue)
start.actual  <- xpathApply(xml,"//iati-activity/activity-date[@type='start-actual']",xmlValue)
end.planned   <- xpathApply(xml,"//iati-activity/activity-date[@type='end-planned']",xmlValue)
end.actual    <- xpathApply(xml,"//iati-activity/activity-date[@type='end-actual']",xmlValue)

df <- data.frame(cbind(org,id, title, status, 
                       start.planned, start.actual, end.planned, end.actual,
                       desc.1, desc.2))

library(dplyr)
library(DBI)

df=NULL
df = read.table('~/Desktop/2020_Spring/Datasets/MESH/desc2021.xml',  header = T, sep = ',', fill = T, quote = "")
head(df)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="rw_MESH")

dbWriteTable(con, "desc2021", df)
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
