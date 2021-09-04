  library(DBI)
library(ggplot2)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")

target_row_count <- dbGetQuery(con,"SELECT COUNT(*)	FROM public.ddi_same_target");
enzyme_row_count <- dbGetQuery(con,"SELECT COUNT(*)	FROM public.ddi_same_enzyme");
carrier_row_count <- dbGetQuery(con,"SELECT COUNT(*)	FROM public.ddi_same_carrier");
transporter_row_count <- dbGetQuery(con,"SELECT COUNT(*)	FROM public.ddi_same_transporter");

data = NULL
data <- dbGetQuery(con, DBI::SQL("
WITH
ddi_same_target_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Target'::text AS variable,
		COUNT(1)::text AS value,"::text || target_row_count::text || " AS row_count
	FROM public.ddi_same_target
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_target_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Target'::text AS variable,
		COUNT(1)::text AS value, "::text || target_row_count::text || " AS row_count
	FROM public.ddi_same_target
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_enzyme_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Enzyme'::text AS variable,
		COUNT(1)::text AS value, " || enzyme_row_count::text || " AS row_count
	FROM public.ddi_same_enzyme
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_enzyme_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Enzyme'::text AS variable,
		COUNT(1)::text AS value, " || enzyme_row_count::text || " AS row_count
	FROM public.ddi_same_enzyme
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_carrier_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Carrier'::text AS variable,
		COUNT(1)::text AS value, " || carrier_row_count::text || " AS row_count
	FROM public.ddi_same_carrier
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_carrier_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Carrier'::text AS variable,
		COUNT(1)::text AS value, " || carrier_row_count::text || " AS row_count
	FROM public.ddi_same_carrier
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_transporter_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Transporter'::text AS variable,
		COUNT(1)::text AS value, " || transporter_row_count::text || " AS row_count
	FROM public.ddi_same_transporter
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_transporter_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Transporter'::text AS variable,
		COUNT(1)::text AS value, " || transporter_row_count::text || " AS row_count
	FROM public.ddi_same_transporter
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
)
SELECT * FROM  ddi_same_target_with_snp
UNION ALL
SELECT * FROM  ddi_same_target_without_snp
UNION ALL
SELECT * FROM  ddi_same_enzyme_with_snp
UNION ALL
SELECT * FROM  ddi_same_enzyme_without_snp
UNION ALL
SELECT * FROM  ddi_same_carrier_with_snp
UNION ALL
SELECT * FROM  ddi_same_carrier_without_snp
UNION ALL
SELECT * FROM  ddi_same_transporter_with_snp
UNION ALL
SELECT * FROM  ddi_same_transporter_without_snp
ORDER BY 2,1 DESC;"));
 

ggplot(data, aes(fill=gender, y=(as.integer(value)*100/as.integer(row_count)), x=gender)) + 
  geom_bar(position="stack", stat="identity")


