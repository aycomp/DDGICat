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

")


theme_set(theme_bw())

ggplot(data, aes(x = group, y = as.integer(count), fill = drug_type)) +
  geom_col(width = 0.7) +
  labs(x= "Drug Status" , y = "Count", fill = "") +
  theme(
        text = element_text(size=18),
        legend.position = "bottom",
        legend.direction = "horizontal"
        )

#jpeg("drug_type_and_group.jpeg")