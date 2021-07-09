library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
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
	COUNT(1)::int AS cnt, 
	code_3, 
	level_3
FROM most_interacted_drugs mid
INNER JOIN drug_atc_codes atc
	ON mid.drug_id = atc.\"drugbank-id\"
GROUP BY code_3, level_3
ORDER BY cnt DESC
LIMIT 10

" 
)

data$cnt <- as.numeric(data$cnt)

hist(data$cnt)

boxplot(data$cnt)
        
theme_set(theme_bw())


ggplot(data, aes(x = reorder(code_3, -cnt), y = cnt, fill = reorder(level_3, -cnt))) +
  geom_col(width = 0.6) +
  labs(x= "ATC 2" , y = "DDI Count", fill = "") +
  theme(
    text = element_text(size=12),
    title = element_text(family= "Times New Roman", size=12, face="bold"),
    legend.position = "bottom",
    legend.direction = "vertical",
    plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
  ggtitle("ATC Level 2")

"ddi_distribution_having_same_atc2.jpeg