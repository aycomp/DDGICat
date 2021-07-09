library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
WITH biot AS(
	WITH bio AS 
	(
		SELECT drug_id FROM drug WHERE \"type\" = 'biotech'
	)
	SELECT 
		'biotech'::TEXT AS drug_type,
		\"group\",
		COUNT(1) AS count
	FROM \"drug_groups\"
	WHERE \"drugbank-id\" IN (SELECT drug_id FROM bio)
	GROUP BY \"group\"
),
smt AS (
	WITH sm AS 
	(
		SELECT drug_id	FROM drug WHERE \"type\" = 'small molecule'
	)
	SELECT 
		'small molecule'::TEXT AS drug_type,
		\"group\",
		COUNT(1) AS count
	FROM \"drug_groups\"
	WHERE \"drugbank-id\" IN (SELECT drug_id FROM sm)
	GROUP BY \"group\"
)
SELECT \"group\", drug_type, count FROM smt
UNION ALL   
SELECT \"group\", drug_type, count FROM biot;
"
)


theme_set(theme_bw())

ggplot(data, aes(x = group, y = as.integer(count), fill = drug_type)) +
  geom_col(width = 0.8) +
  labs(x= "Drug Status" , y = "Count", fill = "") +
  theme(
        text = element_text(family= "Times New Roman", size=16),
        title = element_text(family= "Times New Roman", size=16, face="bold"),
        legend.position = "bottom",
        legend.direction = "horizontal",
        plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)        ) +
  ggtitle("Drug Type and Status")

#jpeg("drug_type_and_status.jpeg")