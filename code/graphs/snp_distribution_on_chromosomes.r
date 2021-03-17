library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
  SELECT 
   	chromosome_name AS chr,
  	COUNT(1) AS cnt
  FROM public.gene
  WHERE uniprot_gn_id IN (
  	SELECT DISTINCT(gene_name)
  	FROM public.drug_protein
  	WHERE chromosome_name NOT LIKE 'H%')
  GROUP BY chromosome_name;
  --ORDER BY cnt DESC;
"
)

goodChrOrder <- c(1,2,4,5,6,7,9,10,11,12,13,15,16,17,18,19,20,22,"X")
data$chr <- factor(data$chr,levels=goodChrOrder)


theme_set(theme_bw())

ggplot(data, aes(x = chr, y = as.integer(cnt))) +
  geom_col(width = 0.7) +
  labs(x= "Chromosome Name" , y = "SNP Count") +
  theme(text = element_text(size=12))