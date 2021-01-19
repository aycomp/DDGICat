con=NULL
data=NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"WITH target AS(
	SELECT 
		COUNT(drug_id) AS count, target_id
	FROM public.drug_target
	GROUP BY target_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.target_name || ' (' || d.gene_name || ')') AS target,  
	target.count AS count
FROM target 
INNER JOIN public.drug_target d 
	ON d.target_id = target.target_id
ORDER BY target.count DESC")

library(ggplot2)
theme_set(theme_bw())

head(data)

# Draw plot
ggplot(data, aes(x=data$target, y=as.integer(data$count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="Targets", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=0.6))

ggsave("target_top_10.jpeg")


