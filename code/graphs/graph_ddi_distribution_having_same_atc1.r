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
	code_1, 
	level_1
FROM most_interacted_drugs mid
INNER JOIN drug_atc_codes atc
	ON mid.drug_id = atc.\"drugbank-id\"
GROUP BY code_1, level_1
ORDER BY cnt DESC
LIMIT 15

" 
)

theme_set(theme_bw())

ggplot(data, aes(x = code_1, y = as.integer(cnt), fill = level_1)) +
  geom_col(width = 0.7) +
  labs(x= "ATC 1" , y = "Count", fill = "") +
  theme(
    text = element_text(size=18),
    legend.position = "bottom",
    legend.direction = "vertical"
  ) +
  theme(axis.text.x = element_text(angle = 90)) #+
  #guides(fill=guide_legend(ncol=2,bycol=TRUE))
