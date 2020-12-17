-- FUNCTION: public."3_import_pharmgkb"()

-- DROP FUNCTION public."3_import_pharmgkb"();

CREATE OR REPLACE FUNCTION public."3_import_pharmgkb"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$begin

--
SELECT
	distinct(split_part(trim(split_part("Chemical", '(', 2), ')'), ')', 1))--, *
FROM public.var_drug_ann --546 distinct drug var
where split_part(trim(split_part("Chemical", '(', 2), ')'), ')', 1)  in (
	select pharmgkb_id from drug_mapper
);

--
--7496 rows inserted.
WITH vda AS (
	SELECT
		dm.drugbank_id as drug_id,
		"Variant" AS snp_id,
		trim(split_part(v."Gene", '(', 1), ')') AS gene_name,
		'Significance: ' || "Significance" || '. Notes: ' || "Notes"
			|| '. Sentence: ' || "Sentence" AS description,
		"PMID" AS pubmed_id
	FROM public.var_drug_ann v
	INNEr JOIN drug_mapper dm
		ON split_part(trim(split_part("Chemical", '(', 2), ')'), ')', 1) = dm.pharmgkb_id
	WHERE dm.drugbank_id || "Variant" || trim(split_part("Gene", '(', 1), ')')
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
)
INSERT INTO drug_snp
(
	drug_id,
	snp_id,
	severity,
	gene_name,
	description,
	pubmed_id
)
SELECT
	drug_id,
	snp_id,
	'',
	gene_name,
	description,
	pubmed_id
FROM vda
ORDER BY drug_id, snp_id, gene_name
ON CONFLICT DO NOTHING;


--950 rows inserted.
WITH vfa AS (
	SELECT
		dm.drugbank_id as drug_id,
		"Variant" AS snp_id,
		trim(split_part("Gene", '(', 1), ' ') AS gene_name,
		'Significance: ' || "Significance" || '. Notes: ' || "Notes"
			|| '. Sentence: ' || "Sentence" AS description,
		"PMID" AS pubmed_id
	FROM public.var_fa_ann v
	INNEr JOIN drug_mapper dm
		ON split_part(trim(split_part("Chemical", '(', 2), ')'), ')', 1) = dm.pharmgkb_id
	WHERE dm.drugbank_id || "Variant" || trim(split_part("Gene", '(', 1), ' ') || "PMID"
		 NOT IN (SELECT drug_id || snp_id || gene_name || pubmed_id FROM drug_snp)
)
INSERT INTO drug_snp
(
	drug_id,
	snp_id,
	severity,
	gene_name,
	description,
	pubmed_id
)
SELECT
	drug_id,
	snp_id,
	'',
	gene_name,
	description,
	pubmed_id
FROM vfa
ORDER BY drug_id, snp_id, gene_name
ON CONFLICT DO NOTHING;


--7495 rows inserted.
WITH vpa AS (
	SELECT
		dm.drugbank_id as drug_id,
		"Variant" AS snp_id,
		trim(split_part("Gene", '(', 1), ' ') AS gene_name,
		'Significance: ' || "Significance" || '. Notes: ' || "Notes"
			|| '. Sentence: ' || "Sentence" AS description,
		"PMID" AS pubmed_id
	FROM public.var_pheno_ann v
	INNEr JOIN drug_mapper dm
		ON split_part(trim(split_part("Chemical", '(', 2), ')'), ')', 1) = dm.pharmgkb_id
	WHERE dm.drugbank_id || "Variant" || trim(split_part("Gene", '(', 1), ' ') || "PMID"
		 NOT IN (SELECT drug_id || snp_id || gene_name || pubmed_id FROM drug_snp)
)
INSERT INTO drug_snp
(
	drug_id,
	snp_id,
	severity,
	gene_name,
	description,
	pubmed_id
)
SELECT
	drug_id,
	snp_id,
	'',
	gene_name,
	description,
	pubmed_id
FROM vpa
ORDER BY drug_id, snp_id, gene_name
ON CONFLICT DO NOTHING;

/*
--records from var_fa_ann
-- rows inserted.
WITH cv AS (
	SELECT
		--dm.drugbank_id as drug_id,
		trim(variant) AS snp_id,
		trim(gene) AS gene_name,
		'Type: ' || type || '. Phenotypes: ' || phenotypes ||
			'. Level of Evidence: '	|| "level.of.evidence" AS description
		--"PMID" AS pubmed_id
	FROM public.clinical_variants cv
	INNEr JOIN drug_mapper dm
		ON  = dm.pharmgkb_id
	WHERE dm.drugbank_id || "Variant" || trim(split_part("Gene", '(', 1), ' ')
		 NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
)
INSERT INTO drug_snp
(
	drug_id,
	snp_id,
	severity,
	gene_name,
	description,
	pubmed_id
)
SELECT
	drug_id,
	snp_id,
	'',
	gene_name,
	description,
	pubmed_id
FROM vfa
ORDER BY drug_id, snp_id, gene_name
ON CONFLICT DO NOTHING;
*/

end;$BODY$;

ALTER FUNCTION public."3_import_pharmgkb"()
    OWNER TO postgres;