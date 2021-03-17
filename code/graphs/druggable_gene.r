library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
  SELECT 
  	COUNT(1) AS cnt, gene_name
  FROM public.drug_protein
  GROUP BY gene_name
  ORDER BY cnt DESC
  LIMIT 9;

"
)

theme_set(theme_bw())

ggplot(data, aes(x = gene_name, y = as.integer(cnt))) +
  geom_col(width = 0.7) +
  labs(x= "Gene Name" , y = "Count") +
  theme(text = element_text(size=18))