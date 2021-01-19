con=NULL
data=NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
                   "WITH carrier AS(
	SELECT 
		COUNT(drug_id) AS count, carrier_id
	FROM public.drug_carrier
	GROUP BY carrier_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.carrier_name || ' (' || d.gene_name || ')') AS carrier,  
	carrier.count AS count
FROM carrier 
INNER JOIN public.drug_carrier d 
	ON d.carrier_id = carrier.carrier_id
	ORDER BY carrier.count DESC")

library(ggplot2)
theme_set(theme_bw())

# Draw plot
ggplot(data, aes(x=data$carrier, y=as.integer(data$count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="carriers", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=2, size = 6))

ggsave("carrier_top_10.jpeg")