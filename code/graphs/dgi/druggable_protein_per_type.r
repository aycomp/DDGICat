    library(DBI)
  library(ggplot2)
  
  con = NULL
  data = NULL
  
  con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
  data <- dbGetQuery(con, "
        SELECT 
        	COUNT(*)::int AS cnt,
    			CASE 
    			  WHEN drug_protein_type = 1 THEN 'Target'
    			  WHEN drug_protein_type = 2 THEN 'Enzyme'
    			  WHEN drug_protein_type = 3 THEN 'Carrier'
    			  WHEN drug_protein_type = 4 THEN 'Transporter'
    			END AS drug_protein_type
        FROM public.drug_protein
        GROUP BY drug_protein_type
        ORDER BY cnt DESC "
  )
  
  theme_set(theme_bw())
  
  ggplot(data, aes(x = reorder(drug_protein_type, -cnt), y = cnt)) +
    geom_col(width = 0.8) +
    labs(x= "Protein Type" , y = "Count") +
    theme(
      text = element_text(family= "Times New Roman", size=12, face="bold"),
      title = element_text(family= "Times New Roman", size=13, face="bold"),
      legend.position = "bottom",
      legend.direction = "horizontal",
      plot.title = element_text(family= "Times New Roman", size=14, face="bold", hjust = 0.5)) +
    ggtitle("Protein Types per Drug Association")
  
