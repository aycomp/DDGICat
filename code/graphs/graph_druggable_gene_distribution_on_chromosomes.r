library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat_old")
data <- dbGetQuery(con,
"
SELECT chromosome_name AS chr, COUNT(1) AS cnt 
FROM public.gene
WHERE uniprot_gn_symbol IN (
	SELECT DISTINCT(gene_name)
	FROM public.drug_protein
	WHERE drug_protein_type in (1,2)
) AND chromosome_name NOT LIKE 'H%'
GROUP BY chromosome_name;

"
)

theme_set(theme_bw())

ggplot(data, aes(x = chr, y = as.integer(cnt))) +
  geom_col(width = 0.7) +
  labs(x= "Chromosome Name" , y = "Count") +
  theme(text = element_text(size=18))