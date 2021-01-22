/*
    NOTE:   What percentage of [interacting drug pairs having the same protein] have polymorphism.



*/


-------------TARGET
WITH
ddi_same_target_with_snp AS (
	SELECT
		COUNT(gene_name)
	FROM public.ddi_same_target
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_target_without_snp AS (
	SELECT COUNT(gene_name)
	FROM public.ddi_same_target
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
)
SELECT
    with_snp.count AS with_snp_count,
    without_snp.count AS without_snp_count
FROM
    ddi_same_target_with_snp AS with_snp,
    ddi_same_target_without_snp AS without_snp



-------------ENZYME
WITH
ddi_same_enzyme_with_snp AS (
	SELECT
		COUNT(gene_name)
	FROM public.ddi_same_enzyme
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_enzyme_without_snp AS (
	SELECT COUNT(gene_name)
	FROM public.ddi_same_enzyme
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
)
SELECT
    with_snp.count AS with_snp_count,
    without_snp.count AS without_snp_count
FROM
    ddi_same_enzyme_with_snp AS with_snp,
    ddi_same_enzyme_without_snp AS without_snp


-------------CARRIER
WITH
ddi_same_carrier_with_snp AS (
	SELECT
		COUNT(gene_name)
	FROM public.ddi_same_carrier
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_carrier_without_snp AS (
	SELECT COUNT(gene_name)
	FROM public.ddi_same_carrier
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
)
SELECT
    with_snp.count AS with_snp_count,
    without_snp.count AS without_snp_count
FROM
    ddi_same_carrier_with_snp AS with_snp,
    ddi_same_carrier_without_snp AS without_snp


-------------TRANSPORTER
WITH
ddi_same_transporter_with_snp AS (
	SELECT
		COUNT(gene_name)
	FROM public.ddi_same_transporter
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_transporter_without_snp AS (
	SELECT COUNT(gene_name)
	FROM public.ddi_same_transporter
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
)
SELECT
    with_snp.count AS with_snp_count,
    without_snp.count AS without_snp_count
FROM
    ddi_same_transporter_with_snp AS with_snp,
    ddi_same_transporter_without_snp AS without_snp



---------------second form


WITH
ddi_same_target_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Target'::text AS variable,
		COUNT(gene_name) AS value
	FROM public.ddi_same_target
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_target_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Target'::text AS variable,
		COUNT(gene_name) AS value
	FROM public.ddi_same_target
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_enzyme_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Enzyme'::text AS variable,
		COUNT(gene_name) AS value
	FROM public.ddi_same_enzyme
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_enzyme_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Enzyme'::text AS variable,
		COUNT(gene_name) AS value
	FROM public.ddi_same_enzyme
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_carrier_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Carrier'::text AS variable,
		COUNT(gene_name) AS value
	FROM public.ddi_same_carrier
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_carrier_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Carrier'::text AS variable,
		COUNT(gene_name) AS value
	FROM public.ddi_same_carrier
	WHERE gene_name NOT IN(SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_transporter_with_snp AS (
	SELECT
		'With SNP Record'::text AS gender,
		'Transporter'::text AS variable,
		COUNT(gene_name) AS value
	FROM public.ddi_same_transporter
	WHERE gene_name IN (SELECT DISTINCT(gene_name) FROM drug_snp)
),
ddi_same_transporter_without_snp AS (
	SELECT
		'Without SNP Record'::text AS gender,
		'Transporter'::text AS variable,
		COUNT(gene_name) AS value
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
ORDER BY 2,1 DESC;