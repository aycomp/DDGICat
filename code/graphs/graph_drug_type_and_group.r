library(gridExtra)
library(ggplot2)
library(ggpubr)
library(cowplot)


con = NULL
data = NULL

#jpeg("drug_type_and_group.jpeg")

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"WITH sub AS (
	SELECT COUNT(1) AS total 
	FROM drug
)
SELECT 
	COUNT(1) as drug_count, 
	type as drug_type,
	total
FROM drug, sub
GROUP BY type,total")

bxp <- ggplot(data, aes(x = "", y = as.integer(drug_count), fill = drug_type)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste0((round(as.integer(drug_count)*100/as.integer(total))), "%")), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()



con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"WITH sub AS (
	SELECT COUNT(1) AS total 
	FROM drug
)
SELECT 
	\"group\" AS drug_groups, 
	count(1) AS drug_count,
	total
FROM drug_groups, sub
GROUP BY \"group\", total ")

dp <- ggplot(data, aes(x = "", y = as.integer(drug_count), fill = drug_groups)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste0((round(as.integer(drug_count)*100/as.integer(total))), "%")), 
            position = position_stack(vjust = 0.5),
            angle = c(90, 90, 70, 0, 0, 0, 0))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()

plot_grid(bxp, dp,
          align = "h",
          ncol = 3)
