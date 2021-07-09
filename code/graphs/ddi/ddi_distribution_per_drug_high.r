  library(DBI)
  library(ggplot2)
  
  con = NULL
  data = NULL
  
  con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
  data <- dbGetQuery(con, "
            WITH ddi AS (
              SELECT 
                COUNT(*) AS ddi_count, 
                drug1_id
              FROM public.ddi
              WHERE severity = 'high'
              GROUP BY drug1_id
              ORDER BY ddi_count DESC
            )
            SELECT
              COUNT(drug1_id)::int AS number_of_drugs, 
              ddi_count::int AS number_of_ddi
            FROM ddi
            GROUP BY number_of_ddi
            ORDER BY number_of_drugs DESC, number_of_ddi"
  )
  
  
  ggplot(data, aes(x = number_of_drugs, y = number_of_ddi)) +
    geom_point(alpha=0.8) +
    labs(x= "# Drugs" , y = "# DDI") +
    theme(
      text = element_text(family= "Times New Roman", size=14, face="bold"),
      title = element_text(family= "Times New Roman", size=14, face="bold"),
      legend.position = "bottom",
      legend.direction = "horizontal",
      plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
    ggtitle("# DDI per # Drug") +
    scale_x_log10() + 
    scale_y_log10() +
    geom_smooth(method='lm')
  
