library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat_old")
data <- dbGetQuery(con,
"
WITH most_interacted_drugs AS 
(
	SELECT 
		drug1_id AS drug_id, 
		COUNT(1) AS cnt
	FROM public.ddi
	GROUP BY drug1_id
	ORDER BY cnt DESC
)
SELECT 
	COUNT(1) AS cnt, 
	code_2, 
	level_2
FROM most_interacted_drugs mid
INNER JOIN drug_atc_codes atc
	ON mid.drug_id = atc.\"drugbank-id\"
GROUP BY code_2, level_2
ORDER BY cnt DESC
LIMIT 15

" 
)

theme_set(theme_bw())

ggplot(data, aes(x = code_2, y = as.integer(cnt), fill = level_2)) +
  geom_col(width = 0.7) +
  labs(x= "ATC 2" , y = "Count", fill = "") +
  theme(
    text = element_text(size=18),
    legend.position = "bottom",
    legend.direction = "vertical"
  )