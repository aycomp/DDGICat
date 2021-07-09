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

ggplot(data1, aes(x = number_of_drugs, y = number_of_target)) +
  geom_point(alpha=0.8) +
  labs(x= "# Drugs" , y = "# Target") +
  theme(
    text = element_text(family= "Times New Roman", size=14, face="bold"),
    title = element_text(family= "Times New Roman", size=14, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
  ggtitle("# Target per # Drug") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method='lm')


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

ggplot(data2, aes(x = number_of_drugs, y = number_of_enzyme)) +
  geom_point(alpha=0.8) +
  labs(x= "# Drugs" , y = "# Enzyme") +
  theme(
    text = element_text(family= "Times New Roman", size=14, face="bold"),
    title = element_text(family= "Times New Roman", size=14, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
  ggtitle("# Enzyme per # Drug") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method='lm')

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

ggplot(data3, aes(x = number_of_drugs, y = number_of_carrier)) +
  geom_point(alpha=0.8) +
  labs(x= "# Drugs" , y = "# Carrier") +
  theme(
    text = element_text(family= "Times New Roman", size=14, face="bold"),
    title = element_text(family= "Times New Roman", size=14, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
  ggtitle("# Carrier per # Drug") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method='lm')


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


ggplot(data4, aes(x = number_of_drugs, y = number_of_transporter)) +
  geom_point(alpha=0.8) +
  labs(x= "# Drugs" , y = "# Transporter") +
  theme(
    text = element_text(family= "Times New Roman", size=14, face="bold"),
    title = element_text(family= "Times New Roman", size=14, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
  ggtitle("# Transporter per # Drug") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method='lm')























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