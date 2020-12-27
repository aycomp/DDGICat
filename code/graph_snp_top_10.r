library(odbc)

con=NULL
data=NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"WITH snp AS(
	SELECT 
		COUNT(drug_id) AS count, snp_id
	FROM public.drug_snp
	GROUP BY snp_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.snp_id || ' (' || d.gene_name || ')') AS snp,  
	snp.count AS count
FROM snp 
INNER JOIN public.drug_snp d 
	ON d.snp_id = snp.snp_id
	ORDER BY snp.count DESC")

library(ggplot2)
theme_set(theme_bw())


# Draw plot
ggplot(data, aes(x=data$snp, y=as.integer(data$count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="SNPs", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=0.6))

ggsave("snp_top_10.jpeg")


