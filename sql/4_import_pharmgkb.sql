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

--5162 records inserted. prev:-- 6460 rows inserted.
WITH sub AS (
	SELECT
		split_part(TRIM(split_part(unnest(string_to_array("Related.Chemicals", ';')), '(', 2), ')'), ')', 1) AS drug,
		"Location" AS snp_id,
		TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
		"Chromosome" AS chromosome,
		"Clinical.Annotation.Types" AS phenotype,
		"Evidence.Count" AS evidence_count,
		"Level.of.Evidence" AS level_of_evidence,
		"Variant.Annotations" AS description,
		"Annotation.Text" AS description2,
		"Related.Diseases" AS related_diseases,
		"Biogeographical.Groups" AS ethnicity,
		"PMIDs" AS pubmed_id
	FROM public.clinical_ann_metadata
),
dm AS (	SELECT * FROM drug_mapper)
INSERT INTO drug_snp
(
	drug_id,
	snp_id,
	uniprot_id,
	gene_name,
	chromosome,
	phenotype,
	significance,
	description,
	description2,
	severity,
	pubmed_id
)
SELECT
	dm.drugbank_id AS drug_id,
	snp_id,
	'',
	gene_name,
	chromosome,
	phenotype,
	'',
	description,
	description2,
	'',
	pubmed_id
FROM sub
INNER JOIN dm
	ON sub.drug = dm.pharmgkb_id
WHERE dm.drugbank_id || sub.snp_id || sub.gene_name
		NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
ORDER BY dm.drugbank_id, gene_name, snp_id;

END;$BODY$;

ALTER FUNCTION public."4_import_pharmgkb"()
    OWNER TO postgres;



--run function
SELECT public."4_import_pharmgkb"();