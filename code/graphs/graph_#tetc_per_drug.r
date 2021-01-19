library(ggplot2)
library(DBI)
library(cowplot)


theme_set(theme_bw())

#####target
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data1 <- dbGetQuery(con,
"WITH target AS (
	SELECT 
		COUNT(target_id) AS target_count, 
		drug_id
	FROM public.drug_target
	GROUP BY drug_id
	ORDER BY target_count
)
SELECT
	COUNT(drug_id) AS number_of_drugs, 
	target_count AS number_of_target
FROM target
WHERE target_count < 11
GROUP BY number_of_target
ORDER BY number_of_drugs DESC, number_of_target")

p1 <- ggplot(data1, aes(x=as.integer(number_of_target), y=as.integer(number_of_drugs))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="# of Targets", y="# of Drugs") + 
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10)) +
  theme(axis.text.x = element_text(vjust=0.6))


###############enzyme
data2 <- dbGetQuery(con,
"WITH enzyme AS (
	SELECT 
		COUNT(enzyme_id) AS enzyme_count, 
		drug_id
	FROM public.drug_enzyme
	GROUP BY drug_id
	ORDER BY enzyme_count
)
SELECT
	COUNT(drug_id) AS number_of_drugs, 
	enzyme_count AS number_of_enzyme
FROM enzyme
WHERE enzyme_count < 11
GROUP BY number_of_enzyme
ORDER BY number_of_drugs DESC, number_of_enzyme")

p2 <- ggplot(data2, aes(x=as.integer(number_of_enzyme), y=as.integer(number_of_drugs))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="# of Enzymes", y="# of Drugs") + 
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10)) +
  theme(axis.text.x = element_text(vjust=0.6))


#########carrier
data3 <- dbGetQuery(con,
"WITH carrier AS (
	SELECT 
		COUNT(carrier_id) AS carrier_count, 
		drug_id
	FROM public.drug_carrier
	GROUP BY drug_id
	ORDER BY carrier_count
)
SELECT
	COUNT(drug_id) AS number_of_drugs, 
	carrier_count AS number_of_carrier
FROM carrier
WHERE carrier_count < 11
GROUP BY number_of_carrier
ORDER BY number_of_drugs DESC, number_of_carrier")

p3 <- ggplot(data3, aes(x=as.integer(number_of_carrier), y=as.integer(number_of_drugs))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="# of  Carriers", y="# of  Drugs") + 
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10)) +
  theme(axis.text.x = element_text(vjust=0.6))


############transporter
data4 <- dbGetQuery(con,
"WITH transporter AS (
	SELECT 
		COUNT(transporter_id) AS transporter_count, 
		drug_id
	FROM public.drug_transporter
	GROUP BY drug_id
	ORDER BY transporter_count
)
SELECT
	COUNT(drug_id) AS number_of_drugs, 
	transporter_count AS number_of_transporter
FROM transporter
WHERE transporter_count < 11
GROUP BY number_of_transporter
ORDER BY number_of_drugs DESC, number_of_transporter")

p4 <- ggplot(data4, aes(x=as.integer(number_of_transporter), y=as.integer(number_of_drugs))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="# of Transporters", y="# of Drugs")+
  scale_x_continuous(breaks=c(1,2,3,4,5,6,7,8,9,10)) +
  theme(axis.text.x = element_text(vjust=0.6))


########################

plot_grid(p1, p2, p3, p4,
          align = "h",
          ncol = 2, nrow=2)

