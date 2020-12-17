library(devtools)
devtools::install_github("ropensci/dbparser")

library(dbparser)
library(dplyr)
library(ggplot2)
library(XML)
library(odbc)
library(DBI)
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DrugBank")

db_path <- "~/Desktop/full database.xml"
dbparser::read_drugbank_xml_db(db_path)
drug_all(save_table = TRUE, database_connection = con)
DBI::dbListTables(con)
DBI::dbDisconnect(con)