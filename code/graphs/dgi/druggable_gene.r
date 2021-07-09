  library(DBI)
  library(ggplot2)
  
  con = NULL
  data = NULL
  
  con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
  data <- dbGetQuery(con, "
              SELECT 
              	COUNT(*)::int AS cnt, gene_name
              FROM public.drug_protein
              WHERE gene_name IS NOT NULL
              GROUP BY gene_name
              ORDER BY cnt DESC
              LIMIT 10; "
          )
  
  theme_set(theme_bw())
  
  ggplot(data, aes(x = reorder(gene_name, -cnt), y = cnt)) +
    geom_col(width = 0.8) +
    labs(x= "Gene Name" , y = "Count") +
    theme(
      text = element_text(family= "Times New Roman", size=12, face="bold"),
      title = element_text(family= "Times New Roman", size=14, face="bold"),
      legend.position = "bottom",
      legend.direction = "horizontal",
      plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
    ggtitle("Top 10 Most Drug-Associated Genes")
