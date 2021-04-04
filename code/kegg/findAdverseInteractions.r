"
  ddi – find adverse drug-drug interactions
  http://rest.kegg.jp/ddi/<dbentry>
    <dbentry> = Single entry of the following <database>
  Description
    This operation searches against the KEGG MEDICUS drug interaction database, 
    where drug-drug interactions designated as contraindication (CI) and precaution (P) 
    in Japanese drug labels are extracted and standardized by D number and DG number identifiers.
"
library(httr)
library(jsonlite)
library(dplyr)
library(DBI)
library(tidyr)
library(tidyverse)

con = NULL; resultset = NULL; data = NULL;
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
  SELECT
  	DISTINCT(parent_key) AS drug_id,
  	identifier AS kegg_id
  FROM drug_external_identifiers 
  WHERE resource = 'KEGG Drug' 
  	AND parent_key IN (
		WITH sub AS (
			SELECT DISTINCT(drug1_id) AS drug_id FROM ddi 
			UNION ALL
			SELECT DISTINCT(drug2_id) AS drug_id FROM ddi)
		SELECT DISTINCT(drug_id) FROM sub)
  ORDER BY 1;
"
);

i <- 1;

for (i in 1:nrow(data)){
  flag <- TRUE
  result <- NULL
  
  tryCatch({
    
    ids <- list(data$drug_id[i], data$kegg_id[i])
    drugbank_id <- ids[1]
    kegg_id <- ids[2]
    search_key <- kegg_id
    path <- paste("http://rest.kegg.jp/ddi/", kegg_id, sep="")
    r <- GET(url = path)
    r <- content(r, as = "text", encoding = "UTF-8")
    result <- read.table(text = r, sep = '\t')
    
    result <- result %>%
      rename(drug_one_kegg_id = V1, drug_two_kegg_id = V2, severity_level = V3, description = V4)
    
    result$drug_one_kegg_id <- with(result, ifelse(grepl("^dr", result$drug_one_kegg_id), substring(result$drug_one_kegg_id, 4), result$drug_one_kegg_id))
    result$drug_one_kegg_id <- with(result, ifelse(grepl("^cpd", result$drug_one_kegg_id), substring(result$drug_one_kegg_id, 5), result$drug_one_kegg_id))
    result$drug_two_kegg_id <- with(result, ifelse(grepl("^dr", result$drug_two_kegg_id), substring(result$drug_two_kegg_id, 4), result$drug_two_kegg_id))
    result$drug_two_kegg_id <- with(result, ifelse(grepl("^cpd", result$drug_two_kegg_id), substring(result$drug_two_kegg_id, 5), result$drug_two_kegg_id))

        
    con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="KEGG")
    dbWriteTable(con, "ddi", result, append = TRUE, row.names = FALSE) 
    
  }, warning = function(cond) {
    flag<<-FALSE
    message(cond)
  }, error = function(cond) {
    flag<<-FALSE
    message(cond)
  }, finally={
    message(paste("Record:", i, " drug_one_kegg_id:", result$drug_one_kegg_id, "  drug_two_kegg_id:", result$drug_two_kegg_id, 
                  " severity_level:", result$severity_level, "  description:", result$description))
  })
  if (!flag) next()
}
dbDisconnect(con)