library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
  SELECT 
   	gene_name,
  	COUNT(1) AS cnt
  FROM public.drug_snp
  WHERE gene_name IN (
  	SELECT DISTINCT(gene_name)
  	FROM public.drug_protein
  	  WHERE snp_id NOT LIKE '')
  GROUP BY gene_name
  ORDER BY cnt DESC 
  LIMIT 7;

"
)

theme_set(theme_bw())

ggplot(data, aes(x = gene_name, y = as.integer(cnt))) +
  geom_col(width = 0.5) +
  labs(x= "Gene Name" , y = "SNP Count") +
  theme(text = element_text(size=12))