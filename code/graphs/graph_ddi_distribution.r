library(DBI)
library(ggplot2)
        
con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat_old")
data <- dbGetQuery(con,
"
SELECT 
	COUNT(*) AS cnt
FROM public.ddi
GROUP BY drug1_id
"
)

data$cnt <- as.numeric(data$cnt)

hist(data$cnt, main = "Histogram of DDI Count per Drug", xlab = "Interaction Count", breaks = 10)

boxplot(data$cnt)
plot(density(data$cnt),  main = "Density plot of Age", xlab = "Age", col = "red")