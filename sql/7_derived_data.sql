--********************************DDI CATEGORY********************************--

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


--484925 + 1077 +
--40812 + 142410 +
--36532 + 183 + 246 + 931 + 1358 + 4682 + 135175 + 24693 + 7594 + 154317 +
--453 + 116470 = 1151858 rows updated.
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



--********************************DDI SAME TARGET, SAME ENZYME, SAME CARRIER, SAME TRANSPORTER********************************--

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