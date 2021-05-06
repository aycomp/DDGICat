-- FUNCTION: public."3_4_import_pharmgkb"()

-- DROP FUNCTION public."3_4_import_pharmgkb"();

CREATE OR REPLACE FUNCTION public."3_4_import_pharmgkb"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
	 v_cnt INT := 0;
BEGIN

/*********************************DRUG SNP IMPORT***********************************/

WITH sub AS (
	SELECT
		split_part(TRIM(split_part(unnest(string_to_array("Related.Chemicals", ';')), '(', 2), ')'), ')', 1) AS drug,
		"Location" AS snp_id,
		TRIM(split_part("Gene", '(', 1), ')') AS gene_name,
		"Chromosome" AS chromosome,
		"Evidence.Count" AS evidence_count,
		"Level.of.Evidence" AS level_of_evidence,
		'CAId:' || "Clinical.Annotation.ID" || 'Text: ' || "Annotation.Text" AS description,
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
	significance,
	description,
	severity,
	pubmed_id
)
SELECT
	dm.drugbank_id AS drug_id,
	snp_id,
	'' AS uniprot_id,
	gene_name,
	chromosome,
	'' AS significance,
	description,
	'' AS severity,
	pubmed_id
FROM sub
INNER JOIN dm
	ON sub.drug = dm.pharmgkb_id
WHERE dm.drugbank_id || sub.snp_id || sub.gene_name
		NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
ORDER BY dm.drugbank_id, gene_name, snp_id;
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into drug_snp table', v_cnt;
END IF;

/*********************************DISEASE IMPORT***********************************/

INSERT INTO disease (id, pharmgkb_id, name) VALUES (1, 'PA443888', 'Diabetes Mellitus, Type 1');
INSERT INTO disease (id, pharmgkb_id, name) VALUES (2, 'PA443890', 'Diabetes Mellitus, Type 2');
INSERT INTO disease (id, pharmgkb_id, name) VALUES (3, 'PA443450', 'Asthma');
INSERT INTO disease (id, pharmgkb_id, name) VALUES (4, 'PA444368', 'Heart Diseases');
INSERT INTO disease (id, pharmgkb_id, name) VALUES (5, 'PA447278', 'Depression');


/*********************************DISEASE DRUG IMPORT***********************************/
--TODO:


/*********************************DISEASE GENE IMPORT***********************************/

INSERT INTO disease_gene
(
	disease_id, gene_name, PMID
)
SELECT
	"Entity1_id", "Entity2_name", "PMIDs"
FROM public.relationships
WHERE "Entity1_id" IN ('PA443888', 'PA443890', 'PA443450', 'PA444368', 'PA447278')
	AND "Entity1_type" = 'Disease'
	AND "Entity2_type" = 'Gene'

/*********************************DISEASE VARIANT IMPORT***********************************/

INSERT INTO disease_variant
(
	disease_id, variant_id, PMID
)
SELECT
	"Entity1_id", "Entity2_name", "PMIDs"
FROM public.relationships
WHERE "Entity1_id" IN ('PA443888', 'PA443890', 'PA443450', 'PA444368', 'PA447278')
	AND "Entity1_type" = 'Disease'
	AND "Entity2_type" = 'Variant'


END;$BODY$;

ALTER FUNCTION public."3_4_import_pharmgkb"()
    OWNER TO postgres;



--run function
SELECT public."3_4_import_pharmgkb"();


/*

OUTPUT:
NOTICE:  5897 row inserted into drug_snp table

Successfully run. Total query runtime: 391 msec.
1 rows affected.


*/