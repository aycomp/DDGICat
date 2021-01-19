library(ggplot2)
con=NULL
data=NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"WITH transporter AS(
	SELECT 
		COUNT(drug_id) AS count, transporter_id
	FROM public.drug_transporter
	GROUP BY transporter_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.transporter_name || ' (' || d.gene_name || ')') AS transporter,  
	transporter.count AS count
FROM transporter 
INNER JOIN public.drug_transporter d 
	ON d.transporter_id = transporter.transporter_id
	ORDER BY transporter.count DESC")

#theme_set(theme_bw())

# Draw plot
ggplot(data, aes(x=data$transporter, y=as.integer(data$count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="transporters", y="Drug Count")+
  theme(axis.text.x = element_text(vjust=2, size = 6))

ggsave("transporter_top_10.jpeg")