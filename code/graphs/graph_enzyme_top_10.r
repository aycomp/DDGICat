con=NULL
data=NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"WITH enzyme AS(
	SELECT 
		COUNT(drug_id) AS count, enzyme_id
	FROM public.drug_enzyme
	GROUP BY enzyme_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.enzyme_name || ' (' || d.gene_name || ')') AS enzyme,  
	enzyme.count AS count
FROM enzyme 
INNER JOIN public.drug_enzyme d 
	ON d.enzyme_id = enzyme.enzyme_id
	ORDER BY enzyme.count DESC")

library(ggplot2)
theme_set(theme_bw())


# Draw plot
ggplot(data, aes(x=data$enzyme, y=as.integer(data$count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="Enzymes", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=0.6))

ggsave("enzyme_top_10.jpeg")


