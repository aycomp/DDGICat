-- FUNCTION: public."4_import_pharmgkb"()

-- DROP FUNCTION public."4_import_pharmgkb"();

CREATE OR REPLACE FUNCTION public."4_import_pharmgkb"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$BEGIN


/*********************************DRUG MAPPER IMPORT*********************************/
/*
	Note:

SELECT
	distinct(split_part(TRIM(split_part("Chemical", '(', 2), ')'), ')', 1))
FROM public.var_drug_ann --546 distinct drug
WHERE split_part(TRIM(split_part("Chemical", '(', 2), ')'), ')', 1)
	IN (SELECT pharmgkb_id FROM drug_mapper);

*/

/*********************************DRUG SNP IMPORT***********************************/
/*
	Note:
*/
-- records inserted. prev:--7496 rows inserted.
WITH new_drug_snp AS
(
	WITH vd AS (
		SELECT
			"Variant" AS snp_id,
			unnest(string_to_array("Chemical", ',')) as chemical,
			TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
			"Chromosome" AS chromosome,
			split_part(TRIM(split_part(unnest(string_to_array("Chemical", ',')), '(', 2), ')'), ')', 1) AS drug
		FROM public.var_drug_ann
	),
	dm AS (
		SELECT * FROM drug_mapper
	)
	INSERT INTO drug_snp
	(
		drug_id,
		snp_id,
		gene_name,
		chromosome
	)
	SELECT
		dm.drugbank_id AS drug_id,
		snp_id,
		gene_name,
		chromosome
	FROM vd
	INNER JOIN dm
		ON vd.drug = dm.pharmgkb_id
	WHERE dm.drugbank_id || vd.snp_id || vd.gene_name
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	ORDER BY dm.drugbank_id, gene_name, snp_id
	RETURNING id, drug_id, snp_id, gene_name
),
new_drug_snp_detail AS
(
	WITH vd AS (
		SELECT
			"Variant" AS snp_id,
			unnest(string_to_array("Chemical", ',')) as chemical,
			TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
			"Chromosome" AS chromosome,
			"Phenotype.Category" AS phenotype,
			"Significance" AS significance,
			'Sentence: ' || "Sentence" || ' Notes: ' || "Notes" AS description,
			'' AS severity,
			"PMID" AS pubmed_id,
			split_part(TRIM(split_part(unnest(string_to_array("Chemical", ',')), '(', 2), ')'), ')', 1) AS drug
		FROM public.var_drug_ann
	),
	dm AS (
		SELECT * FROM drug_mapper
	)
	SELECT
		dm.drugbank_id AS drug_id,
		snp_id,
		gene_name,
		phenotype,
		significance,
		description,
		severity,
		pubmed_id
	FROM vd
	INNER JOIN dm
		ON vd.drug = dm.pharmgkb_id
	WHERE dm.drugbank_id || vd.snp_id || vd.gene_name
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	ORDER BY dm.drugbank_id, gene_name, snp_id
)
INSERT INTO drug_snp_detail
SELECT
	id,
	phenotype,
	significance,
	description,
	severity,
	pubmed_id
FROM new_drug_snp m
LEFT JOIN new_drug_snp_detail d ON
	m.drug_id = d.drug_id AND
	m.snp_id = d.snp_id AND
	m.gene_name = d.gene_name;



--....records inserted. prev: 7495 rows inserted.
WITH new_drug_snp AS
(
	WITH vd AS (
		SELECT
			"Variant" AS snp_id,
			unnest(string_to_array("Chemical", ',')) as chemical,
			TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
			"Chromosome" AS chromosome,
			split_part(TRIM(split_part(unnest(string_to_array("Chemical", ',')), '(', 2), ')'), ')', 1) AS drug
		FROM public.var_pheno_ann
	),
	dm AS (
		SELECT * FROM drug_mapper
	)
	INSERT INTO drug_snp
	(
		drug_id,
		snp_id,
		gene_name,
		chromosome
	)
	SELECT
		dm.drugbank_id AS drug_id,
		snp_id,
		gene_name,
		chromosome
	FROM vd
	INNER JOIN dm
		ON vd.drug = dm.pharmgkb_id
	WHERE dm.drugbank_id || vd.snp_id || vd.gene_name
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	ORDER BY dm.drugbank_id, gene_name, snp_id
	RETURNING id, drug_id, snp_id, gene_name
),
new_drug_snp_detail AS
(
	WITH vd AS (
		SELECT
			"Variant" AS snp_id,
			unnest(string_to_array("Chemical", ',')) as chemical,
			TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
			"Chromosome" AS chromosome,
			"Phenotype.Category" AS phenotype,
			"Significance" AS significance,
			'Sentence: ' || "Sentence" || ' Notes: ' || "Notes" AS description,
			'' AS severity,
			"PMID" AS pubmed_id,
			split_part(TRIM(split_part(unnest(string_to_array("Chemical", ',')), '(', 2), ')'), ')', 1) AS drug
		FROM public.var_pheno_ann
	),
	dm AS (
		SELECT * FROM drug_mapper
	)
	SELECT
		dm.drugbank_id AS drug_id,
		snp_id,
		gene_name,
		phenotype,
		significance,
		description,
		severity,
		pubmed_id
	FROM vd
	INNER JOIN dm
		ON vd.drug = dm.pharmgkb_id
	WHERE dm.drugbank_id || vd.snp_id || vd.gene_name
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	ORDER BY dm.drugbank_id, gene_name, snp_id
)
INSERT INTO drug_snp_detail
SELECT
	id,
	phenotype,
	significance,
	description,
	severity,
	pubmed_id
FROM new_drug_snp m
LEFT JOIN new_drug_snp_detail d ON
	m.drug_id = d.drug_id AND
	m.snp_id = d.snp_id AND
	m.gene_name = d.gene_name;



--... records inserted. prev: 950 rows inserted.
WITH new_drug_snp AS
(
	WITH vd AS (
		SELECT
			"Variant" AS snp_id,
			unnest(string_to_array("Chemical", ',')) as chemical,
			TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
			"Chromosome" AS chromosome,
			split_part(TRIM(split_part(unnest(string_to_array("Chemical", ',')), '(', 2), ')'), ')', 1) AS drug
		FROM public.var_fa_ann
	),
	dm AS (
		SELECT * FROM drug_mapper
	)
	INSERT INTO drug_snp
	(
		drug_id,
		snp_id,
		gene_name,
		chromosome
	)
	SELECT
		dm.drugbank_id AS drug_id,
		snp_id,
		gene_name,
		chromosome
	FROM vd
	INNER JOIN dm
		ON vd.drug = dm.pharmgkb_id
	WHERE dm.drugbank_id || vd.snp_id || vd.gene_name
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	ORDER BY dm.drugbank_id, gene_name, snp_id
	RETURNING id, drug_id, snp_id, gene_name
),
new_drug_snp_detail AS
(
	WITH vd AS (
		SELECT
			"Variant" AS snp_id,
			unnest(string_to_array("Chemical", ',')) as chemical,
			TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
			"Chromosome" AS chromosome,
			"Phenotype.Category" AS phenotype,
			"Significance" AS significance,
			'Sentence: ' || "Sentence" || ' Notes: ' || "Notes" AS description,
			'' AS severity,
			"PMID" AS pubmed_id,
			split_part(TRIM(split_part(unnest(string_to_array("Chemical", ',')), '(', 2), ')'), ')', 1) AS drug
		FROM public.var_fa_ann
	),
	dm AS (
		SELECT * FROM drug_mapper
	)
	SELECT
		dm.drugbank_id AS drug_id,
		snp_id,
		gene_name,
		phenotype,
		significance,
		description,
		severity,
		pubmed_id
	FROM vd
	INNER JOIN dm
		ON vd.drug = dm.pharmgkb_id
	WHERE dm.drugbank_id || vd.snp_id || vd.gene_name
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	ORDER BY dm.drugbank_id, gene_name, snp_id
)
INSERT INTO drug_snp_detail
SELECT
	id,
	phenotype,
	significance,
	description,
	severity,
	pubmed_id
FROM new_drug_snp m
LEFT JOIN new_drug_snp_detail d ON
	m.drug_id = d.drug_id AND
	m.snp_id = d.snp_id AND
	m.gene_name = d.gene_name;


END;$BODY$;

ALTER FUNCTION public."4_import_pharmgkb"()
    OWNER TO postgres;



--run function
SELECT public."4_import_pharmgkb"();