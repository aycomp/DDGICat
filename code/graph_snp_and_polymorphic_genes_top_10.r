library(odbc)
library(ggplot2)
theme_set(theme_bw())

con=NULL
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")

#####################gene
data = NULL
data <- dbGetQuery(con,
"SELECT 
	COUNT(snp_id) AS snp_count, 
	gene_name
FROM drug_snp
WHERE gene_name != ''
GROUP BY gene_name
ORDER BY snp_count DESC
LIMIT 10")

p1 <- ggplot(data, aes(x=gene_name, y=as.integer(snp_count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="Gene Name", y="SNP Count") + 
  theme(axis.text.x = element_text(vjust=0.6))


#######################snp
data = NULL
data <- dbGetQuery(con,
"WITH snp AS(
	SELECT 
		COUNT(drug_id) AS count, snp_id
	FROM public.drug_snp
	GROUP BY snp_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.snp_id || ' (' || d.gene_name || ')') AS s,  
	snp.count AS drug_count
FROM snp 
INNER JOIN public.drug_snp d 
	ON d.snp_id = snp.snp_id
ORDER BY drug_count DESC")

p2 <- ggplot(data, aes(x=s, y=as.integer(drug_count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="SNPs", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=0.6))


plot_grid(p1,p2,
          align = "h",
          ncol = 2)

