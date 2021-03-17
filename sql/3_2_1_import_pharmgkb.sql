-- FUNCTION: public."3_2_1_import_pharmgkb"()

-- DROP FUNCTION public."3_2_1_import_pharmgkb"();

CREATE OR REPLACE FUNCTION public."3_2_1_import_pharmgkb"(
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

END;$BODY$;

ALTER FUNCTION public."3_2_1_import_pharmgkb"()
    OWNER TO postgres;



--run function
SELECT public."3_2_1_import_pharmgkb"();


/*

OUTPUT:
NOTICE:  5897 row inserted into drug_snp table

Successfully run. Total query runtime: 391 msec.
1 rows affected.


*/