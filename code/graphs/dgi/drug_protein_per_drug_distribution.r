library(ggplot2)
library(DBI)

theme_set(theme_bw())

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
    
################TARGET  
data1 <- dbGetQuery(con,
"
WITH target AS (
  SELECT  
    COUNT(drug_protein_id) AS target_count, 
    drug_id
  FROM public.drug_protein
  WHERE drug_protein_type = 1
  GROUP BY drug_id
  ORDER BY target_count DESC
)
SELECT
  COUNT(drug_id) AS number_of_drugs, 
  target_count AS number_of_target
FROM target
WHERE target_count < 40
GROUP BY number_of_target
ORDER BY number_of_drugs DESC, number_of_target
"
)

x <- data1$number_of_drugs
y <- data1$number_of_target
plot(x, y, ylab = "# Target", xlab = "# Drug") 


################ENZYME
data2 <- dbGetQuery(con,
"
WITH enzyme AS (
  SELECT 
    COUNT(drug_protein_id) AS enzyme_count, 
    drug_id
  FROM public.drug_protein
  WHERE drug_protein_type = 2
  GROUP BY drug_id
  ORDER BY enzyme_count DESC
)
SELECT
  COUNT(drug_id) AS number_of_drugs, 
  enzyme_count AS number_of_enzyme
FROM enzyme
WHERE enzyme_count < 11
GROUP BY number_of_enzyme
ORDER BY number_of_drugs DESC, number_of_enzyme
"
)

x <- data2$number_of_drugs
y <- data2$number_of_enzyme
plot(x, y, ylab = "# Enzyme", xlab = "# Drug")

################CARRIER
data3 <- dbGetQuery(con,
"
WITH carrier AS (
  SELECT 
    COUNT(drug_protein_id) AS carrier_count, 
    drug_id
  FROM public.drug_protein
  WHERE drug_protein_type = 3
  GROUP BY drug_id
  ORDER BY carrier_count DESC
)
SELECT
  COUNT(drug_id) AS number_of_drugs, 
  carrier_count AS number_of_carrier
FROM carrier
GROUP BY number_of_carrier
ORDER BY number_of_drugs DESC, number_of_carrier
"
)

x <- data3$number_of_drugs
y <- data3$number_of_carrier
plot(x, y, ylab = "# Carrier", xlab = "# Drug")

################TRANSPORTER
data4 <- dbGetQuery(con,
"
WITH transporter AS (
  SELECT 
    COUNT(drug_protein_id) AS transporter_count, 
    drug_id
  FROM public.drug_protein
  WHERE drug_protein_type = 4
  GROUP BY drug_id
  ORDER BY transporter_count DESC
)
SELECT
  COUNT(drug_id) AS number_of_drugs, 
  transporter_count AS number_of_transporter
FROM transporter
GROUP BY number_of_transporter
ORDER BY number_of_drugs DESC, number_of_transporter
"
)

x <- data4$number_of_drugs
y <- data4$number_of_carrier
plot(x, y, ylab = "# Transporter", xlab = "# Drug")






















"
data$cnt <- as.numeric(data$cnt)
ggplot(data) +
  geom_freqpoly()
mean(data$cnt)
median(data$cnt)
sd(data$cnt)

theme_set(theme_bw())

ggplot(data, aes(x=as.integer(number_of_target), y=as.integer(number_of_drugs))) +
  geom_bar(stat='identity')  + xlim(c(0, 11)) + coord_flip() +
  labs(x=\"# of Targets\", y=\"# of Drugs\") + 
  theme(axis.text.x = element_text(vjust=0.6)) +
  theme(text = element_text(size=18))
"