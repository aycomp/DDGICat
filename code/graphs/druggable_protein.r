  library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
  SELECT 
  	COUNT(1) AS cnt, polypeptide_uniprot_id AS poly_id, polypeptide_name AS poly_name
  FROM public.drug_protein
  GROUP BY polypeptide_uniprot_id, polypeptide_name
  ORDER BY cnt DESC
  LIMIT 9;
"
)

theme_set(theme_bw())

ggplot(data, aes(x = poly_id, y = as.integer(cnt), fill=poly_name)) +
  geom_col(width = 0.7) +
  labs(x= "Polypeptide Name" , y = "Count", fill="") +
  theme(text = element_text(size=18),
        legend.position = "bottom",
        legend.direction = "horizontal") +
  guides(fill=guide_legend(ncol=2,byrow=TRUE))
  #+  theme(axis.text.x = element_text(angle = 90))