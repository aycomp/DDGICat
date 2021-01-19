library(ggplot2)
library(DBI)


theme_set(theme_bw())


#####target
con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data1 <- dbGetQuery(con,
"WITH target AS(
	SELECT 
		COUNT(drug_id) AS count, target_id
	FROM public.drug_target
	GROUP BY target_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.target_name || ' (' || d.gene_name || ')') AS target,  
	target.count AS count
FROM target 
INNER JOIN public.drug_target d 
	ON d.target_id = target.target_id
ORDER BY target.count DESC")

p1 <- ggplot(data1, aes(x=target, y=as.integer(count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="Targets", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=0.6))


###############enzyme
data2 <- dbGetQuery(con,
"WITH enzyme AS(
	SELECT 
		COUNT(drug_id) AS count, enzyme_id
	FROM public.drug_enzyme
	GROUP BY enzyme_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.enzyme_name || ' (' || d.gene_name || ')') AS enzyme,  
	enzyme.count AS count
FROM enzyme 
INNER JOIN public.drug_enzyme d 
	ON d.enzyme_id = enzyme.enzyme_id
	ORDER BY enzyme.count DESC")

p2 <- ggplot(data2, aes(x=enzyme, y=as.integer(count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="Enzymes", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=0.6))


#########carrier
data3 <- dbGetQuery(con,
"WITH carrier AS(
	SELECT 
		COUNT(drug_id) AS count, carrier_id
	FROM public.drug_carrier
	GROUP BY carrier_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.carrier_name || ' (' || d.gene_name || ')') AS carrier,  
	carrier.count AS count
FROM carrier 
INNER JOIN public.drug_carrier d 
	ON d.carrier_id = carrier.carrier_id
	ORDER BY carrier.count DESC")

p3 <- ggplot(data3, aes(x=carrier, y=as.integer(count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="carriers", y="Drug Count") + 
  theme(axis.text.x = element_text(vjust=0.6))

############transporter
data4 <- dbGetQuery(con,
"WITH transporter AS(
	SELECT 
		COUNT(drug_id) AS count, transporter_id
	FROM public.drug_transporter
	GROUP BY transporter_id
	ORDER BY count DESC LIMIT 10
)
SELECT  
	DISTINCT(d.transporter_name || ' (' || d.gene_name || ')') AS transporter,  
	transporter.count AS count
FROM transporter 
INNER JOIN public.drug_transporter d 
	ON d.transporter_id = transporter.transporter_id
	ORDER BY transporter.count DESC")

p4 <- ggplot(data4, aes(x=transporter, y=as.integer(count))) +
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(x="transporters", y="Drug Count")+
  theme(axis.text.x = element_text(vjust=0.6))


########################

plot_grid(p1, p2, p3, p4,
          align = "h",
          ncol = 2, nrow=2)

