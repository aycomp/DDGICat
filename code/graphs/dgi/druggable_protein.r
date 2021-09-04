    library(DBI)
    library(ggplot2)
    
    con = NULL
    data = NULL
    
    con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
    data <- dbGetQuery(con, "
              SELECT 
              	COUNT(*)::int AS cnt, 
              	CASE WHEN drug_protein_type = 1 THEN 'Target'
              	     WHEN drug_protein_type = 2 THEN 'Enzyme'
              	     WHEN drug_protein_type = 3 THEN 'Carrier'
              	     WHEN drug_protein_type = 4 THEN 'Transporter'
              	END AS drug_protein_type,
              	drug_protein_name AS protein_name
                FROM public.drug_protein
              --WHERE drug_protein_name IS NOT NULL
              GROUP BY drug_protein_type, drug_protein_name
              ORDER BY cnt DESC
            LIMIT 10; "
    )
    
    theme_set(theme_bw())
    
    ggplot(data, aes(x = reorder(protein_name, -cnt), y = cnt, 
                     fill=reorder(drug_protein_type, -cnt))) +
    geom_col(width = 0.7) +
    labs(x= "Protein Name" , y = "Count", fill="") +
    theme(
      text = element_text(family= "Times New Roman", size=10, face="bold"),
      axis.text.x = element_text(angle = 20),
      title = element_text(family= "Times New Roman", size=12, face="bold"),
      legend.position = "bottom",
      legend.direction = "horizontal",
      plot.title = element_text(family= "Times New Roman", size=14, face="bold", hjust = 0.5)) +
    ggtitle("Top Drug-Interacting Proteins") +
    guides(fill=guide_legend())
    
