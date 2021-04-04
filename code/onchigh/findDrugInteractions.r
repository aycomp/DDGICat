library(httr)
library(jsonlite)
library(dplyr)
library(DBI)
library(tidyr)
library(tidyverse)

#retrieve ddi records that have rxcui entry
con = NULL; resultset = NULL; data = NULL;
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
  SELECT  
  	DISTINCT(parent_key) AS drug_id,
  	identifier AS rxcui
  FROM drug_external_identifiers 
  WHERE resource = 'RxCUI' 
  	AND parent_key IN (
		WITH sub  AS (
			SELECT DISTINCT(drug1_id) AS drug_id FROM ddi 
			UNION ALL
			SELECT DISTINCT(drug2_id) AS drug_id FROM ddi)
		SELECT DISTINCT(drug_id) FROM sub )
 ORDER BY 1;
"
);

i <- 1;

#retrieve ddi detail for each drug1_id and drug2_id pair, and insert into rxnav table in DDGICat
for (i in 1:nrow(data)){
  flag <- TRUE
  tryCatch({
    
    ids <- list(data$drug_id[i], data$rxcui[i])
    drug_id <- ids[1]
    rxcui <- ids[2]
    search_key <- rxcui
    path <- paste("https://rxnav.nlm.nih.gov/REST/interaction/interaction.json?rxcui=", rxcui, "&sources=ONCHigh", sep="")
    r <- GET(url = path)
    r <- content(r, as = "text", encoding = "UTF-8")
    
    result <- r %>% 
      fromJSON() %>% 
      map_if(is.data.frame, list) %>% 
      as_tibble() %>% 
      unnest(interactionTypeGroup) %>% 
      unnest(interactionType ) %>% 
      unnest(interactionPair) %>%
      unnest(interactionConcept, names_repair = "unique")
    
    severity_level <- result %>% filter(minConceptItem...7 != search_key) %>% select(severity) 
    drug_one_rxcui <- as.character(rep(rxcui, length(severity_level)))
    drug_two <- result[['minConceptItem...7']] %>% filter(rxcui != search_key)
    drug_two_rxcui <- drug_two$rxcui
    drug_two_name <- drug_two$name
  
    df <- data.frame(drug_one_rxcui, drug_two_rxcui, drug_two_name, severity_level)
    
    con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="ONCHigh")
    dbWriteTable(con, "ddi", df, append = TRUE, row.names = FALSE) 
    
  }, warning = function(cond) {
    flag<<-FALSE
    message(cond)
  }, error = function(cond) {
    flag<<-FALSE
    message(cond)
  }, finally={
    message(paste("Record:", i, " Drug_id:", drug_id, "  RXCUI:", rxcui))
  })
  if (!flag) next()
}
dbDisconnect(con)