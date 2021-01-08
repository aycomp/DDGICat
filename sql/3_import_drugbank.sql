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
--13185 rows inserted
INSERT INTO drug
	(drug_id, name, "type", description, state, indication, toxicity, pharmacodynamics,
	mechanism_of_action, metabolism, absorption, half_life, protein_binding,
	route_of_elimination, volume_of_distribution, clearance, articles_count, drug_interactions_count)
SELECT
	d.primary_key,
	d.name,
	d.type,
	d.description,
	d.state,
	d.indication,
	d.toxicity,
	d.pharmacodynamics,
	d.mechanism_of_action,
	d.metabolism,
	d.absorption,
	d.half_life,
	d.protein_binding,
	d.route_of_elimination,
	d.volume_of_distribution,
	d.clearance,
	d.articles_count,
	d.drug_interactions_count
FROM public.drugs d
WHERE d.primary_key NOT IN (
	SELECT drugbank_id
	FROM public.drug_affected_organisms
	WHERE affected_organism NOT IN ('Humans', 'Humans and other mammals'))
ORDER BY d.primary_key;

--TODO: the tables below could be added into main drug table as columns
--drug_synonym table
--26181 records inserted.
DROP TABLE IF EXISTS helper_drug_synonym;
CREATE TABLE helper_drug_synonym AS
SELECT parent_key AS drug_id, synonym, language, coder
FROM public.drug_syn
WHERE parent_key IN(SELECT drug_id FROM drug);

--drug_dosages table
--37350 records inserted.
DROP TABLE IF EXISTS helper_drug_dosage;
CREATE TABLE helper_drug_dosage AS
SELECT parent_key AS drug_id, form, route, strength
FROM public.drug_dosages
WHERE parent_key IN(SELECT drug_id FROM drug);

--drug_article table
--11905 records inserted.
DROP TABLE IF EXISTS helper_drug_article;
CREATE TABLE helper_drug_article AS
SELECT parent_key AS drug_id, "ref-id", "pubmed-id", citation
FROM public.drug_articles
WHERE parent_key IN(SELECT drug_id FROM drug);


--13185 rows inserted
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

--14170 rows inserted
WITH target AS (
	SELECT *
	FROM public.drug_targ
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO drug_target
SELECT
	t.parent_key AS drug_id,
	t.id AS target_id,
	t.name AS target_name,
	tp.source AS polypeptide_source,
	tp.id AS polypeptide_uniprot_id,
	tp.name AS polypeptide_name,
	tp.gene_name,
	tp.general_function,
	tp.specific_function
FROM target t
LEFT JOIN public.drug_targ_polys tp
	ON t.id = tp.parent_id
ORDER BY t.parent_key;


--4522 rows inserted
WITH enzyme AS (
	SELECT *
	FROM public.drug_enzymes
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO drug_enzyme
SELECT
	e.parent_key AS drug_id,
	e.id,
	e.name AS enzyme_name,
	ep.source AS polypeptide_source,
	ep.id AS polypeptide_uniprot_id,
	ep.name AS polypeptide_name,
	ep.gene_name,
	ep.general_function,
	ep.specific_function
FROM enzyme e
LEFT JOIN public.drug_enzymes_polypeptides ep
	ON e.id = ep.parent_id
ORDER BY e.parent_key;


--2528 rows inserted
WITH transporter AS (
	SELECT *
	FROM public.drug_transporters
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO drug_transporter
SELECT
	t.parent_key AS drug_id,
	t.id,
	t.name AS transporter_name,
	tp.source AS polypeptide_source,
	tp.id AS polypeptide_uniprot_id,
	tp.name AS polypeptide_name,
	tp.gene_name,
	tp.general_function,
	tp.specific_function
FROM transporter t
LEFT JOIN public.drug_trans_polys tp
	ON t.id = tp.parent_id
ORDER BY t.parent_key;


--722 rows inserted
WITH carrier AS (
	SELECT *
	FROM public.drug_carriers
	WHERE parent_key IN(SELECT drug_id FROM drug)
		AND organism in ('Humans', 'Mouse', 'Rat')
)
INSERT INTO drug_carrier
SELECT
	c.parent_key AS drug_id,
	c.id,
	c.name AS carrier_name,
	cp.source AS polypeptide_source,
	cp.id AS polypeptide_uniprot_id,
	cp.name AS polypeptide_name,
	cp.gene_name,
	cp.general_function,
	cp.specific_function
FROM carrier c
LEFT JOIN public.drug_carriers_polypeptides cp
	ON c.id = cp.parent_id
ORDER BY c.parent_key;


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

-- records inserted.
WITH new_drug_snp AS
(
	INSERT INTO drug_snp
	(
		drug_id,
		snp_id,
		gene_name,
		chromosome
	)
	SELECT
		parent_key AS drug_id,
		"rs-id" AS snp_id,
		"gene-symbol" AS gene_name,
		"allele"
	FROM public.drug_snp_effects
	WHERE parent_key IN (SELECT drug_id FROM drug)
		AND parent_key || "rs-id" || "gene-symbol"
			NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	RETURNING id, drug_id, snp_id, gene_name
),
new_drug_snp_detail AS
(
	SELECT
		parent_key AS drug_id,
		"rs-id" AS snp_id,
		"gene-symbol" AS gene_name,
		description,
		"defining-change" AS defining_change,
		"pubmed-id" AS pubmed_id
	FROM public.drug_snp_effects
	WHERE parent_key IN (SELECT drug_id FROM drug)
		AND parent_key || "rs-id" || "gene-symbol"
			NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
)
INSERT INTO drug_snp_detail
SELECT
	id,
	defining_change,
	'Minor',
	description,
	'',
	pubmed_id
FROM new_drug_snp m
LEFT JOIN new_drug_snp_detail d ON
	m.drug_id = d.drug_id AND
	m.snp_id = d.snp_id AND
	m.gene_name = d.gene_name;


-- records inserted.
WITH new_drug_snp AS
(
	INSERT INTO drug_snp
	(
		drug_id,
		snp_id,
		gene_name,
		chromosome
	)
	SELECT
		parent_key AS drug_id,
		"rs-id" AS snp_id,
		"gene-symbol" AS gene_name,
		"allele"
	FROM public.snp_adverse_reactions
	WHERE parent_key IN (SELECT drug_id FROM drug)
		AND parent_key || "rs-id" || "gene-symbol"
			NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
	RETURNING id, drug_id, snp_id, gene_name
),
new_drug_snp_detail AS
(
	SELECT
		parent_key AS drug_id,
		"rs-id" AS snp_id,
		"gene-symbol" AS gene_name,
		description,
		"adverse-reaction" AS adverse_reaction,
		"pubmed-id" AS pubmed_id
	FROM public.snp_adverse_reactions
	WHERE parent_key IN (SELECT drug_id FROM drug)
		AND parent_key || "rs-id" || "gene-symbol"
			NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp)
)
INSERT INTO drug_snp_detail
SELECT
	id,
	adverse_reaction,
	'Major',
	description || '. adverse reaction: ' || adverse_reaction,
	'',
	pubmed_id
FROM new_drug_snp m
LEFT JOIN new_drug_snp_detail d ON
	m.drug_id = d.drug_id AND
	m.snp_id = d.snp_id AND
	m.gene_name = d.gene_name;

end;$BODY$;

ALTER FUNCTION public."3_import_drugbank"()
    OWNER TO postgres;


--run function
SELECT public."3_import_drugbank"();