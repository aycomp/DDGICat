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
	d.drug_id as drugbank_id,
	de.identifier as pharmgkb_id
from public.drug d
LEFT JOIN public.drug_external_identifiers de
	ON d.drug_id = de.parent_key AND de.resource = 'PharmGKB'
ORDER BY 1,2;




--********************************DRUG TARGET, ENZYME, TRANSPORTER, CARRIER IMPORT********************************--

--	Notes: records from var_drug_ann
--		1)	Severity kismi dusunulecek
--		2)	kromozom eklenebilir
--37095 rows inserted
INSERT INTO drug_target
select
	t.parent_key as drug_id,
	ta.target_id, t.name as target_name, ta.action,
	tp.source as polypeptide_source, tp.id as polypeptide_uniprot_id, tp.name as polypeptide_name,
	tp.gene_name, tp.general_function, tp.specific_function
from public.drug_targ t
inner join public.drug_targ_polys tp on t.id = tp.parent_id
	and t.organism in ('Humans', 'Mouse', 'Rat')
inner join public.drug_targ_actions ta on t.id = ta.target_id
order by t.parent_key;


--16191 rows inserted
INSERT INTO drug_enzyme
select
	e.parent_key as drug_id,
	ea.enzyme_id, e.name as enzyme_name, ea.action,
	ep.source as polypeptide_source, ep.id as polypeptide_uniprot_id, ep.name as polypeptide_name,
	ep.gene_name, ep.general_function, ep.specific_function
from public.drug_enzymes e
inner join public.drug_enzymes_polypeptides ep on e.id = ep.parent_id
	and e.organism in ('Humans', 'Mouse', 'Rat')
inner join public.drug_enzymes_actions ea on e.id = ea.enzyme_id
order by e.parent_key;


--10799 rows inserted
INSERT INTO drug_transporter
select
	tr.parent_key as drug_id,
	tra.transporter_id, tr.name as transporter_name, tra.action,
	trp.source as polypeptide_source, trp.id as polypeptide_uniprot_id, trp.name as polypeptide_name,
	trp.gene_name, trp.general_function, trp.specific_function
from public.drug_transporters tr
inner join public.drug_trans_polys trp on tr.id = trp.parent_id
	and tr.organism in ('Humans', 'Mouse', 'Rat')
inner join public.drug_trans_actions tra on tr.id = tra.transporter_id
order by tr.parent_key;


--3476 rows inserted
--As Organism in all records are Mouse, Humans, Rat, there is no need to eliminate.
INSERT INTO drug_carrier
select
	c.parent_key as drug_id,
	ca.carrier_id, c.name as carrier_name, ca.action,
	cp.source as polypeptide_source, cp.id as polypeptide_uniprot_id, cp.name as polypeptide_name,
	cp.gene_name, cp.general_function, cp.specific_function
from public.drug_carriers c
inner join public.drug_carriers_polypeptides cp on c.id = cp.parent_id
inner join public.drug_carriers_actions ca on c.id = ca.carrier_id
order by c.parent_key;


--71583 rows inserted
INSERT INTO drug_pathway
select
	dp.parent_key as drug_id,
	dp.smpdb_id as pathway_id,
	dp.category,
	dpe.enzyme
from public.drug_pathways dp
inner join public.drug_pathways_drugs dpd on dp.parent_key = dpd."drugbank-id"
	and dp.smpdb_id = dpd.parent_key
inner join public.drug_pathways_enzyme dpe on dp.smpdb_id = dpe.pathway_id
where dp.parent_key in (select drug_id from drug)
order by dp.parent_key, dp.smpdb_id, dp.category, dpe.enzyme;


--1151858 rows inserted. previously --1151858 rows inserted
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


--93505 records inserted.
WITH
drug1_target AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_target
			WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
			ORDER BY drug_id, target_id, target_action
		)
		select
			drug_id, target_id, sum(target_action) as drug_action
		from y
		GROUP BY drug_id, target_id
		order by drug_id, target_id
	)
	SELECT
		distinct (d.drug_id || d.target_id), d.drug_id, d.target_id, d.target_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_target d
		on d.drug_id = x.drug_id and d.target_id = x.target_id
	order by drug_id, target_id
),
drug2_target AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_target
			WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
			ORDER BY drug_id, target_id, target_action
		)
		select
			drug_id, target_id, sum(target_action) as drug_action
		from y
		GROUP BY drug_id, target_id
		order by drug_id, target_id
	)
	SELECT
		distinct (d.drug_id || d.target_id), d.drug_id, d.target_id, d.target_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_target d
		on d.drug_id = x.drug_id and d.target_id = x.target_id
	order by drug_id, target_id
)
INSERT INTO ddi_same_target
(
	drug1_id,
	drug2_id,
	target_id,
	target_name,
	drug1_actions,
	drug2_actions,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.target_id,
	d1.target_name,
	d1.drug_action,
	d2.drug_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_target d1
INNER JOIN drug2_target d2
	ON d1.target_id = d2.target_id
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


--510854 records inserted.
WITH
drug1_target AS (
	SELECT
		drug_id, target_id, target_name, target_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_target
	WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
		and target_action != 'other/unknown'
	ORDER BY drug_id
),
drug2_target AS (
	SELECT
		drug_id, target_id, target_name, target_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_target
	WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
		and target_action != 'other/unknown'
	ORDER BY drug_id
)
INSERT INTO ddi_same_target_same_action
(
	drug1_id,
	drug2_id,
	target_id,
	target_name,
	target_action,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.target_id,
	d1.target_name,
	d1.target_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_target d1
INNER JOIN drug2_target d2
	ON d1.target_id = d2.target_id
		AND d1.target_action = d2.target_action
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


--607412 records inserted.
WITH
drug1_enzyme AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_enzyme
			WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
			ORDER BY drug_id, enzyme_id, enzyme_action
		)
		select
			drug_id, enzyme_id, sum(enzyme_action) as drug_action
		from y
		GROUP BY drug_id, enzyme_id
		order by drug_id, enzyme_id
	)
	SELECT
		distinct (d.drug_id || d.enzyme_id), d.drug_id, d.enzyme_id, d.enzyme_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_enzyme d
		on d.drug_id = x.drug_id and d.enzyme_id = x.enzyme_id
	order by drug_id, enzyme_id
),
drug2_enzyme AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_enzyme
			WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
			ORDER BY drug_id, enzyme_id, enzyme_action
		)
		select
			drug_id, enzyme_id, sum(enzyme_action) as drug_action
		from y
		GROUP BY drug_id, enzyme_id
		order by drug_id, enzyme_id
	)
	SELECT
		distinct (d.drug_id || d.enzyme_id), d.drug_id, d.enzyme_id, d.enzyme_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_enzyme d
		on d.drug_id = x.drug_id and d.enzyme_id = x.enzyme_id
	order by drug_id, enzyme_id
)
INSERT INTO ddi_same_enzyme
(
	drug1_id,
	drug2_id,
	enzyme_id,
	enzyme_name,
	drug1_actions,
	drug2_actions,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.enzyme_id,
	d1.enzyme_name,
	d1.drug_action,
	d2.drug_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_enzyme d1
INNER JOIN drug2_enzyme d2
	ON d1.enzyme_id = d2.enzyme_id
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


--2285648 records inserted.
WITH
drug1_enzyme AS (
	SELECT
		drug_id, enzyme_id, enzyme_name, enzyme_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_enzyme
	WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
		and enzyme_action != 'other/unknown'
	ORDER BY drug_id
),
drug2_enzyme AS (
	SELECT
		drug_id, enzyme_id, enzyme_name, enzyme_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_enzyme
	WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
		and enzyme_action != 'other/unknown'
	ORDER BY drug_id
)
INSERT INTO ddi_same_enzyme_same_action
(
	drug1_id,
	drug2_id,
	enzyme_id,
	enzyme_name,
	enzyme_action,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.enzyme_id,
	d1.enzyme_name,
	d1.enzyme_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_enzyme d1
INNER JOIN drug2_enzyme d2
	ON d1.enzyme_id = d2.enzyme_id
		AND d1.enzyme_action = d2.enzyme_action
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


--139284 records inserted.
WITH
drug1_transporter AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_transporter
			WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
			ORDER BY drug_id, transporter_id, transporter_action
		)
		select
			drug_id, transporter_id, sum(transporter_action) as drug_action
		from y
		GROUP BY drug_id, transporter_id
		order by drug_id, transporter_id
	)
	SELECT
		distinct (d.drug_id || d.transporter_id), d.drug_id, d.transporter_id, d.transporter_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_transporter d
		on d.drug_id = x.drug_id and d.transporter_id = x.transporter_id
	order by drug_id, transporter_id
),
drug2_transporter AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_transporter
			WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
			ORDER BY drug_id, transporter_id, transporter_action
		)
		select
			drug_id, transporter_id, sum(transporter_action) as drug_action
		from y
		GROUP BY drug_id, transporter_id
		order by drug_id, transporter_id
	)
	SELECT
		distinct (d.drug_id || d.transporter_id), d.drug_id, d.transporter_id, d.transporter_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_transporter d
		on d.drug_id = x.drug_id and d.transporter_id = x.transporter_id
	order by drug_id, transporter_id
)
INSERT INTO ddi_same_transporter
(
	drug1_id,
	drug2_id,
	transporter_id,
	transporter_name,
	drug1_actions,
	drug2_actions,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.transporter_id,
	d1.transporter_name,
	d1.drug_action,
	d2.drug_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_transporter d1
INNER JOIN drug2_transporter d2
	ON d1.transporter_id = d2.transporter_id
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


--818437 records inserted.
WITH
drug1_transporter AS (
	SELECT
		drug_id, transporter_id, transporter_name, transporter_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_transporter
	WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
		and transporter_action != 'other/unknown'
	ORDER BY drug_id
),
drug2_transporter AS (
	SELECT
		drug_id, transporter_id, transporter_name, transporter_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_transporter
	WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
		and transporter_action != 'other/unknown'
	ORDER BY drug_id
)
INSERT INTO ddi_same_transporter_same_action
(
	drug1_id,
	drug2_id,
	transporter_id,
	transporter_name,
	transporter_action,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.transporter_id,
	d1.transporter_name,
	d1.transporter_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_transporter d1
INNER JOIN drug2_transporter d2
	ON d1.transporter_id = d2.transporter_id
		AND d1.transporter_action = d2.transporter_action
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


--49208 records inserted.
WITH
drug1_carrier AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_carrier
			WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
			ORDER BY drug_id, carrier_id, carrier_action
		)
		select
			drug_id, carrier_id, sum(carrier_action) as drug_action
		from y
		GROUP BY drug_id, carrier_id
		order by drug_id, carrier_id
	)
	SELECT
		distinct (d.drug_id || d.carrier_id), d.drug_id, d.carrier_id, d.carrier_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_carrier d
		on d.drug_id = x.drug_id and d.carrier_id = x.carrier_id
	order by drug_id, carrier_id
),
drug2_carrier AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_carrier
			WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
			ORDER BY drug_id, carrier_id, carrier_action
		)
		select
			drug_id, carrier_id, sum(carrier_action) as drug_action
		from y
		GROUP BY drug_id, carrier_id
		order by drug_id, carrier_id
	)
	SELECT
		distinct (d.drug_id || d.carrier_id), d.drug_id, d.carrier_id, d.carrier_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_carrier d
		on d.drug_id = x.drug_id and d.carrier_id = x.carrier_id
	order by drug_id, carrier_id
)
INSERT INTO ddi_same_carrier
(
	drug1_id,
	drug2_id,
	carrier_id,
	carrier_name,
	drug1_actions,
	drug2_actions,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.carrier_id,
	d1.carrier_name,
	d1.drug_action,
	d2.drug_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_carrier d1
INNER JOIN drug2_carrier d2
	ON d1.carrier_id = d2.carrier_id
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


--240947 records inserted.
WITH
drug1_carrier AS (
	SELECT
		drug_id, carrier_id, carrier_name, carrier_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_carrier
	WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
		and carrier_action != 'other/unknown'
	ORDER BY drug_id
),
drug2_carrier AS (
	SELECT
		drug_id, carrier_id, carrier_name, carrier_action,
		polypeptide_source, polypeptide_uniprot_id, polypeptide_name, gene_name,
		general_function, specific_function
	FROM public.drug_carrier
	WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
		and carrier_action != 'other/unknown'
	ORDER BY drug_id
)
INSERT INTO ddi_same_carrier_same_action
(
	drug1_id,
	drug2_id,
	carrier_id,
	carrier_name,
	carrier_action,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.carrier_id,
	d1.carrier_name,
	d1.carrier_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_carrier d1
INNER JOIN drug2_carrier d2
	ON d1.carrier_id = d2.carrier_id
		AND d1.carrier_action = d2.carrier_action
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;

--3998 records inserted.
WITH
drug1_pathway AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_pathway
			WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
			ORDER BY drug_id, pathway_id, category,enzyme
		)
		select
			drug_id, pathway_id, sum(category) as category, sum(enzyme) as enzyme
		from y
		GROUP BY drug_id, pathway_id
		order by drug_id, pathway_id
	)
	SELECT
		distinct (d.drug_id || d.pathway_id),
		d.drug_id,
		d.pathway_id,
		d.category,
		x.enzyme
	FROM x
	inner join public.drug_pathway d
		on d.drug_id = x.drug_id
			and d.pathway_id = x.pathway_id
	ORDER BY drug_id, pathway_id, category,enzyme
),
drug2_pathway AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_pathway
			WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
			ORDER BY drug_id, pathway_id, category,enzyme
		)
		select
			drug_id, pathway_id, sum(category) as category, sum(enzyme) as enzyme
		from y
		GROUP BY drug_id, pathway_id
		ORDER BY drug_id, pathway_id, category,enzyme
	)
	SELECT
		distinct (d.drug_id || d.pathway_id),
		d.drug_id,
		d.pathway_id,
		d.category,
		x.enzyme
	FROM x
	inner join public.drug_pathway d
		on d.drug_id = x.drug_id
			and d.pathway_id = x.pathway_id
	ORDER BY drug_id, pathway_id, category,enzyme
)
INSERT INTO ddi_same_pathway
(
	drug1_id,
	drug2_id,
	pathway_id,
	drug1_category,
	drug2_category,
	drug1_enzyme,
	drug2_enzyme
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.pathway_id,
	d1.category,
	d2.category,
	d1.enzyme,
	d1.enzyme
FROM drug1_pathway d1
INNER JOIN drug2_pathway d2
	ON d1.pathway_id = d2.pathway_id
		--AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;



--14130 records inserted.
WITH
drug1_enzyme AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_enzyme
			WHERE drug_id NOT IN (SELECT distinct(drug1_id) FROM ddi)
			ORDER BY drug_id, enzyme_id, enzyme_action
		)
		select
			drug_id, enzyme_id, sum(enzyme_action) as drug_action
		from y
		GROUP BY drug_id, enzyme_id
		order by drug_id, enzyme_id
	)
	SELECT
		distinct (d.drug_id || d.enzyme_id), d.drug_id, d.enzyme_id, d.enzyme_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_enzyme d
		on d.drug_id = x.drug_id and d.enzyme_id = x.enzyme_id
	order by drug_id, enzyme_id
),
drug2_enzyme AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_enzyme
			WHERE drug_id NOT IN (SELECT distinct(drug2_id) FROM ddi)
			ORDER BY drug_id, enzyme_id, enzyme_action
		)
		select
			drug_id, enzyme_id, sum(enzyme_action) as drug_action
		from y
		GROUP BY drug_id, enzyme_id
		order by drug_id, enzyme_id
	)
	SELECT
		distinct (d.drug_id || d.enzyme_id), d.drug_id, d.enzyme_id, d.enzyme_name, x.drug_action,
		d.polypeptide_source, d.polypeptide_uniprot_id, d.polypeptide_name, d.gene_name,
		d.general_function, d.specific_function
	FROM x
	inner join public.drug_enzyme d
		on d.drug_id = x.drug_id and d.enzyme_id = x.enzyme_id
	order by drug_id, enzyme_id
)
INSERT INTO ddi_same_enzyme_new
(
	drug1_id,
	drug2_id,
	enzyme_id,
	enzyme_name,
	drug1_actions,
	drug2_actions,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	d1.enzyme_id,
	d1.enzyme_name,
	d1.drug_action,
	d2.drug_action,
	d1.polypeptide_source,
	d1.polypeptide_uniprot_id,
	d1.polypeptide_name,
	d1.gene_name,
	d1.general_function,
	d1.specific_function
FROM drug1_enzyme d1
INNER JOIN drug2_enzyme d2
	ON d1.enzyme_id = d2.enzyme_id
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;


-- records inserted.
INSERT INTO ddi_same_etc
(
	drug1_id,
	drug2_id
)
SELECT
	distinct
	e.drug1_id,
	e.drug2_id
FROM ddi_same_enzyme e
INNER JOIN ddi_same_transporter t
	ON e.polypeptide_uniprot_id = t.polypeptide_uniprot_id
INNER JOIN ddi_same_carrier c
	ON c.polypeptide_uniprot_id = t.polypeptide_uniprot_id
		and t.polypeptide_uniprot_id = e.polypeptide_uniprot_id
ORDER BY e.drug1_id, e.drug2_id
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