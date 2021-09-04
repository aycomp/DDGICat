library(DBI)
library(ggplot2)
        
con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"
  SELECT 
  	COUNT(*) AS cnt
  FROM public.ddi
  WHERE description LIKE '%The risk or severity%' 
  GROUP BY drug1_id
"
)

data$cnt <- as.numeric(data$cnt)

hist(data$cnt,
     main = "",
     breaks = 10,
     xlab= "Drug Count", 
     ylab="ADDI Count",
     cex.lab=1.5, cex.axis=1)

boxplot(data$cnt,
        xlab= "Drug", 
        ylab="ADDI Count",
        cex.lab=1.5, cex.axis=1)