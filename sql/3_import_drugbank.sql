-- FUNCTION: public."3_import_drugbank"()

-- DROP FUNCTION public."3_import_drugbank"();

CREATE OR REPLACE FUNCTION public."3_import_drugbank"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$begin

--********************************DRUG IMPORT********************************--

--affected organism different from 'Humans', 'Humans and other mammals' are eliminated
--13914 rows inserted
INSERT INTO drug
	(drug_id, name, "type", description, state, indication, toxicity, pharmacodynamics,
	mechanism_of_action, metabolism, absorption, half_life, protein_binding,
	route_of_elimination, volume_of_distribution, clearance)
SELECT
	d.primary_key,
	d.name,
	d.type,
	d.description,
	d.state,
	p.indication,
	p.toxicity,
	p.pharmacodynamics,
	p.mechanism_of_action,
	p.metabolism,
	p.absorption,
	p.half_life,
	p.protein_binding,
	p.route_of_elimination,
	p.volume_of_distribution,
	p.clearance
FROM public.drugs d
INNER JOIN public.drug_pharmacology p
	ON d.primary_key = p.drugbank_id
WHERE d.primary_key NOT IN (
	SELECT drugbank_id
	FROM public.drug_affected_organisms
	WHERE affected_organism NOT IN ('Humans', 'Humans and other mammals'))
ORDER BY d.primary_key;

--fill pubmed_ids
--2812 rows updated.
WITH sub AS (
	SELECT
		parent_key,
		TRIM(TRIM(ARRAY_AGG("pubmed-id")::TEXT, '{'), '}') AS pubmed_ids
	FROM public.drugs_articles
	GROUP BY parent_key
)
UPDATE drug
SET pubmed_id = sub.pubmed_ids
FROM sub
WHERE drug.drug_id = sub.parent_key;


--fill synonyms
--6259 rows updated.
WITH sub AS (
	SELECT
		"drugbank-id" AS drug_id,
		TRIM(TRIM(ARRAY_AGG(synonym)::TEXT, '{'), '}') AS synonym
	FROM public.drug_syn
	WHERE "drugbank-id" IN(SELECT drug_id FROM drug)
		AND language = 'english'
	GROUP BY "drugbank-id"
)
UPDATE drug
SET synonym = sub.synonym
FROM sub
WHERE drug.drug_id = sub.drug_id;


--13914 rows inserted
INSERT INTO drug_mapper
(
	drugbank_id,
	pharmgkb_id
)
SELECT
	d.drug_id AS drugbank_id,
	de.identifier AS pharmgkb_id
FROM public.drug d
LEFT JOIN public.drug_external_identifiers de
	ON d.drug_id = de.parent_key AND de.resource = 'PharmGKB'
ORDER BY 1,2;


--********************************DRUG TARGET, ENZYME, TRANSPORTER, CARRIER IMPORT********************************--

--14230 rows inserted
WITH sub AS (
	SELECT *
	FROM public.targets
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO target
SELECT
	sub.parent_key AS drug_id,
	sub.id AS target_id,
	sub.name AS target_name,
	tp.source AS polypeptide_source,
	tp.id AS polypeptide_uniprot_id,
	tp.name AS polypeptide_name,
	tp.gene_name,
	tp.general_function,
	tp.specific_function
FROM sub
LEFT JOIN public.targets_polypeptides tp
	ON sub.id = tp.parent_id
ORDER BY sub.parent_key;


--4594 rows inserted
WITH sub AS (
	SELECT *
	FROM public.enzymes
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO enzyme
SELECT
	sub.parent_key AS drug_id,
	sub.id,
	sub.name AS enzyme_name,
	ep.source AS polypeptide_source,
	ep.id AS polypeptide_uniprot_id,
	ep.name AS polypeptide_name,
	ep.gene_name,
	ep.general_function,
	ep.specific_function
FROM sub
LEFT JOIN public.enzymes_polypeptides ep
	ON sub.id = ep.parent_id
ORDER BY sub.parent_key;


--2567 rows inserted
WITH sub AS (
	SELECT *
	FROM public.transporters
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO transporter
SELECT
	sub.parent_key AS drug_id,
	sub.id,
	sub.name AS transporter_name,
	tp.source AS polypeptide_source,
	tp.id AS polypeptide_uniprot_id,
	tp.name AS polypeptide_name,
	tp.gene_name,
	tp.general_function,
	tp.specific_function
FROM sub
LEFT JOIN public.transporters_polypeptides tp
	ON sub.id = tp.parent_id
ORDER BY sub.parent_key;


--731 rows inserted
WITH sub AS (
	SELECT *
	FROM public.carriers
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO carrier
SELECT
	sub.parent_key AS drug_id,
	sub.id,
	sub.name AS carrier_name,
	cp.source AS polypeptide_source,
	cp.id AS polypeptide_uniprot_id,
	cp.name AS polypeptide_name,
	cp.gene_name,
	cp.general_function,
	cp.specific_function
FROM sub
LEFT JOIN public.carriers_polypeptides cp
	ON sub.id = cp.parent_id
ORDER BY sub.parent_key;


--********************************DDI IMPORT********************************--

--1151858 rows inserted.
INSERT INTO ddi
(
	drug1_id,
	drug2_id,
	description
)
SELECT
	CASE WHEN parent_key < "drugbank-id" THEN parent_key ELSE "drugbank-id" END AS drug1_id,
	CASE WHEN parent_key < "drugbank-id" THEN "drugbank-id" ELSE parent_key END AS drug2_id,
	description
FROM public.drug_drug_interactions
WHERE (parent_key IN (SELECT drug_id FROM drug)
	AND "drugbank-id" IN (SELECT drug_id FROM drug))
ORDER BY parent_key, "drugbank-id"
ON CONFLICT DO NOTHING;


--********************************DRUG_SNP IMPORT********************************--

--201 records inserted.
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
	parent_key AS drug_id,
	"rs-id" AS snp_id,
	"uniprot-id" AS uniprot_id,
	"gene-symbol" AS gene_name,
	'' AS chromosome,
	'allele: ' || allele AS phenotype,
	'' AS significance,
	description,
	'defining-change' AS description2,
	'Minor' AS severity,
	"pubmed-id" AS pubmed_id
FROM public.drug_snp_effects
WHERE parent_key IN (SELECT drug_id FROM drug)
	AND parent_key || "rs-id" || "gene-symbol"
		NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp);

--113 records inserted.
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
	parent_key AS drug_id,
	"rs-id" AS snp_id,
	"uniprot-id" AS uniprot_id,
	"gene-symbol" AS gene_name,
	'' AS chromosome,
	'allele: ' || allele AS phenotype,
	'' AS significance,
	description,
	'adverse-reaction: ' || 'adverse-reaction' AS description2,
	'Major' AS severity,
	"pubmed-id" AS pubmed_id
FROM public.snp_adverse_reactions
WHERE parent_key IN (SELECT drug_id FROM drug)
	AND parent_key || "rs-id" || "gene-symbol"
		NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp);


end;$BODY$;

ALTER FUNCTION public."3_import_drugbank"()
    OWNER TO postgres;


--run function
SELECT public."3_import_drugbank"();





/* TODO: Will be opened if needed
--drug_dosages table
--83665 records inserted.
DROP TABLE IF EXISTS helper_drug_dosage;
CREATE TABLE helper_drug_dosage AS
SELECT parent_key AS drug_id, form, route, strength
FROM public.drug_dosages
WHERE parent_key IN(SELECT drug_id FROM drug);
*/