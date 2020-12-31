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


--12 rows inserted.
INSERT INTO description_category (id, category_id, category, description) VALUES (1,  1, 'The risk or severity%', 'The risk or severity of adverse effects can be increased when Drug A is combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (2,  1, 'The risk of a hypersensitivity reaction to%', 'The risk of a hypersensitivity reaction to Drug A is increased when it is combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (3,  2, '%may decrease% and %activities%', 'Drug A may increase/decrease the … activities of Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (4,  2, '%may increase% and %activities%', 'Drug A may increase/decrease the … activities of Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (5,  3, 'The serum concentration of%', 'The serum concentration of Drug A can be increased/decreased when it is combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (6,  3, '%can cause an increase in the absorption of%', 'Drug A can cause an increase in the absorption of Drug B resulting in an increased serum concentration and potentially a worsening adverse effect.');
INSERT INTO description_category (id, category_id, category, description) VALUES (7,  3, 'The absorption of%', 'The absorption of Drug A can be decreased when combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (8,  3, 'The bioavailability of%', 'The bioavailability of Drug A can be increased when combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (9,  3, 'The protein binding of%', 'The protein binding of  Drug A can be decreased when combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (10, 3, 'The excretion of%', 'The excretionof Drug A can be decreased when combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (11, 4, 'The metabolism of%', 'The metabolism of Drug A can be increased/decreased when combined with Drug B.');
INSERT INTO description_category (id, category_id, category, description) VALUES (12, 5, 'The therapeutic efficacy of %', 'The therapeutic efficacy of Drug A can be decreased when used in combination with Drug B.');


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

--484925 + 1077 + 40812 + 142410 + 36532 + 183 + 246 + 931 + 1358 + 4682 + 135175 +
--24693 + 7594 + 154317 + 453 + 116470 = 1151858 rows updated.
UPDATE ddi SET desc_cat = 1 WHERE description like 'The risk or severity%';
UPDATE ddi SET desc_cat = 1 WHERE description like 'The risk of a hypersensitivity reaction to%';
UPDATE ddi SET desc_cat = 2 WHERE description like '%may decrease%' and description like '%activities%';
UPDATE ddi SET desc_cat = 2 WHERE description like '%may increase%' and description like '%activities%';
UPDATE ddi SET desc_cat = 3 WHERE description like 'The serum concentration of%';
UPDATE ddi SET desc_cat = 3 WHERE description like '%can cause an increase in the absorption of%';
UPDATE ddi SET desc_cat = 3 WHERE description like 'The absorption of%';
UPDATE ddi SET desc_cat = 3 WHERE description like 'The bioavailability of%';
UPDATE ddi SET desc_cat = 3 WHERE description like 'The protein binding of%';
UPDATE ddi SET desc_cat = 3 WHERE description like 'The excretion of%';
UPDATE ddi SET desc_cat = 3 WHERE description like '%which could result in a higher serum level.%';
UPDATE ddi SET desc_cat = 3 WHERE description like '%which could result in a lower serum level and potentially a reduction in efficacy%';
UPDATE ddi SET desc_cat = 3 WHERE description like '%resulting in a reduced serum concentration and potentially a decrease in efficacy%';
UPDATE ddi SET desc_cat = 3 WHERE description like '%may decrease effectiveness of%';
UPDATE ddi SET desc_cat = 4 WHERE description like 'The metabolism of%';
UPDATE ddi SET desc_cat = 5 WHERE description like 'The therapeutic efficacy of %';


--93803 records inserted.
WITH same_target AS (
	WITH
	drug1_target AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_target
				WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
				ORDER BY drug_id, target_id
			)
			SELECT
				drug_id, target_id
			FROM y
			GROUP BY drug_id, target_id
			ORDER BY drug_id, target_id
		)
		SELECT
			distinct (d.drug_id || d.target_id),
			d.drug_id,
			d.target_id,
			d.target_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_target d
			ON d.drug_id = x.drug_id
				AND d.target_id = x.target_id
		ORDER BY drug_id, target_id
	),
	drug2_target AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_target
				WHERE drug_id IN (SELECT DISTINCT(drug2_id) FROM ddi)
				ORDER BY drug_id, target_id
			)
			SELECT
				drug_id, target_id
			FROM y
			GROUP BY drug_id, target_id
			ORDER BY drug_id, target_id
		)
		SELECT
			distinct (d.drug_id || d.target_id),
			d.drug_id,
			d.target_id,
			d.target_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_target d
			ON d.drug_id = x.drug_id
				AND d.target_id = x.target_id
		ORDER BY drug_id, target_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.target_id,
		d1.target_name,
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
)
INSERT INTO ddi_same_target
(
	drug1_id,
	drug2_id,
	target_id,
	target_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_desc_cat
)
SELECT targ.*, d.desc_cat
FROM same_target targ
INNER JOIN ddi d
	ON targ.drug1_id = d.drug1_id AND targ.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;


--382293 records inserted.
WITH same_enzyme AS (
	WITH
	drug1_enzyme AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_enzyme
				WHERE drug_id IN (SELECT DISTINCT(drug1_id) FROM ddi)
				ORDER BY drug_id, enzyme_id
			)
			SELECT
				drug_id, enzyme_id
			FROM y
			GROUP BY drug_id, enzyme_id
			ORDER BY drug_id, enzyme_id
		)
		SELECT
			distinct (d.drug_id || d.enzyme_id),
			d.drug_id,
			d.enzyme_id,
			d.enzyme_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_enzyme d
			ON d.drug_id = x.drug_id
				AND d.enzyme_id = x.enzyme_id
		ORDER BY drug_id, enzyme_id
	),
	drug2_enzyme AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_enzyme
				WHERE drug_id IN (SELECT distinct(drug2_id) FROM ddi)
				ORDER BY drug_id, enzyme_id
			)
			SELECT
				drug_id, enzyme_id
			FROM y
			GROUP BY drug_id, enzyme_id
			ORDER BY drug_id, enzyme_id
		)
		SELECT
			distinct (d.drug_id || d.enzyme_id),
			d.drug_id,
			d.enzyme_id,
			d.enzyme_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_enzyme d
			ON d.drug_id = x.drug_id
				AND d.enzyme_id = x.enzyme_id
		ORDER BY drug_id, enzyme_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.enzyme_id,
		d1.enzyme_name,
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
)
INSERT INTO ddi_same_enzyme
(
	drug1_id,
	drug2_id,
	enzyme_id,
	enzyme_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_desc_cat
)
SELECT e.*, d.desc_cat
FROM same_enzyme e
INNER JOIN ddi d
	ON e.drug1_id = d.drug1_id AND e.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;



--139295 records inserted.
WITH same_transporter AS (
	WITH
	drug1_transporter AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_transporter
				WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
				ORDER BY drug_id, transporter_id
			)
			SELECT
				drug_id, transporter_id
			FROM y
			GROUP BY drug_id, transporter_id
			ORDER BY drug_id, transporter_id
		)
		SELECT
			distinct (d.drug_id || d.transporter_id),
			d.drug_id,
			d.transporter_id,
			d.transporter_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_transporter d
			ON d.drug_id = x.drug_id
				AND d.transporter_id = x.transporter_id
		ORDER BY drug_id, transporter_id
	),
	drug2_transporter AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_transporter
				WHERE drug_id IN (SELECT DISTINCT(drug2_id) FROM ddi)
				ORDER BY drug_id, transporter_id
			)
			SELECT
				drug_id, transporter_id
			FROM y
			GROUP BY drug_id, transporter_id
			ORDER BY drug_id, transporter_id
		)
		SELECT
			distinct (d.drug_id || d.transporter_id),
			d.drug_id,
			d.transporter_id,
			d.transporter_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_transporter d
			ON d.drug_id = x.drug_id
				AND d.transporter_id = x.transporter_id
		ORDER BY drug_id, transporter_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.transporter_id,
		d1.transporter_name,
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
)
INSERT INTO ddi_same_transporter
(
	drug1_id,
	drug2_id,
	transporter_id,
	transporter_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_desc_cat
)
SELECT t.*, d.desc_cat
FROM same_transporter t
INNER JOIN ddi d
	ON t.drug1_id = d.drug1_id AND t.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;


--49210 records inserted.
WITH same_carrier AS (
	WITH
	drug1_carrier AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_carrier
				WHERE drug_id IN (SELECT distinct(drug1_id) FROM ddi)
				ORDER BY drug_id, carrier_id
			)
			SELECT
				drug_id, carrier_id
			FROM y
			GROUP BY drug_id, carrier_id
			ORDER BY drug_id, carrier_id
		)
		SELECT
			distinct (d.drug_id || d.carrier_id),
			d.drug_id,
			d.carrier_id,
			d.carrier_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_carrier d
			ON d.drug_id = x.drug_id
				AND d.carrier_id = x.carrier_id
		ORDER BY drug_id, carrier_id
	),
	drug2_carrier AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_carrier
				WHERE drug_id IN (SELECT DISTINCT(drug2_id) FROM ddi)
				ORDER BY drug_id, carrier_id
			)
			SELECT
				drug_id, carrier_id
			FROM y
			GROUP BY drug_id, carrier_id
			ORDER BY drug_id, carrier_id
		)
		SELECT
			distinct (d.drug_id || d.carrier_id),
			d.drug_id,
			d.carrier_id,
			d.carrier_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER join public.drug_carrier d
			ON d.drug_id = x.drug_id
				AND d.carrier_id = x.carrier_id
		ORDER BY drug_id, carrier_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.carrier_id,
		d1.carrier_name,
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
)
INSERT INTO ddi_same_carrier
(
	drug1_id,
	drug2_id,
	carrier_id,
	carrier_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_desc_cat
)
SELECT c.*, d.desc_cat
FROM same_carrier c
INNER JOIN ddi d
	ON c.drug1_id = d.drug1_id AND c.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;


-- records inserted.
INSERT INTO ddi_same_etc
(
	drug1_id,
	drug2_id
)
SELECT
	DISTINCT
	e.drug1_id,
	e.drug2_id
FROM ddi_same_enzyme e
INNER JOIN ddi_same_transporter t
	ON e.polypeptide_uniprot_id = t.polypeptide_uniprot_id
INNER JOIN ddi_same_carrier c
	ON c.polypeptide_uniprot_id = t.polypeptide_uniprot_id
		AND t.polypeptide_uniprot_id = e.polypeptide_uniprot_id
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