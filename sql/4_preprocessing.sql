--********************************DDI CATEGORY********************************--

--12 rows inserted.
INSERT INTO ddi_category (id, category_id, category, description) VALUES (1,  1, 'The risk or severity%', 'The risk or severity of adverse effects can be increased when Drug A is combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (2,  1, 'The risk of a hypersensitivity reaction to%', 'The risk of a hypersensitivity reaction to Drug A is increased when it is combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (3,  2, '%may decrease% and %activities%', 'Drug A may increase/decrease the … activities of Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (4,  2, '%may increase% and %activities%', 'Drug A may increase/decrease the … activities of Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (5,  3, 'The serum concentration of%', 'The serum concentration of Drug A can be increased/decreased when it is combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (6,  3, '%can cause an increase in the absorption of%', 'Drug A can cause an increase in the absorption of Drug B resulting in an increased serum concentration and potentially a worsening adverse effect.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (7,  3, 'The absorption of%', 'The absorption of Drug A can be decreased when combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (8,  3, 'The bioavailability of%', 'The bioavailability of Drug A can be increased when combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (9,  3, 'The protein binding of%', 'The protein binding of  Drug A can be decreased when combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (10, 3, 'The excretion of%', 'The excretionof Drug A can be decreased when combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (11, 4, 'The metabolism of%', 'The metabolism of Drug A can be increased/decreased when combined with Drug B.');
INSERT INTO ddi_category (id, category_id, category, description) VALUES (12, 5, 'The therapeutic efficacy of %', 'The therapeutic efficacy of Drug A can be decreased when used in combination with Drug B.');


--484925 + 1077 +
--40812 + 142410 +
--36532 + 183 + 246 + 931 + 1358 + 4682 + 135175 + 24693 + 7594 + 154317 +
--453 + 116470 = 1151858 rows updated.
UPDATE ddi SET category_id = 1 WHERE description like 'The risk or severity%';
UPDATE ddi SET category_id = 1 WHERE description like 'The risk of a hypersensitivity reaction to%';
UPDATE ddi SET category_id = 2 WHERE description like '%may decrease%' and description like '%activities%';
UPDATE ddi SET category_id = 2 WHERE description like '%may increase%' and description like '%activities%';
UPDATE ddi SET category_id = 3 WHERE description like 'The serum concentration of%';
UPDATE ddi SET category_id = 3 WHERE description like '%can cause an increase in the absorption of%';
UPDATE ddi SET category_id = 3 WHERE description like 'The absorption of%';
UPDATE ddi SET category_id = 3 WHERE description like 'The bioavailability of%';
UPDATE ddi SET category_id = 3 WHERE description like 'The protein binding of%';
UPDATE ddi SET category_id = 3 WHERE description like 'The excretion of%';
UPDATE ddi SET category_id = 3 WHERE description like '%which could result in a higher serum level.%';
UPDATE ddi SET category_id = 3 WHERE description like '%which could result in a lower serum level and potentially a reduction in efficacy%';
UPDATE ddi SET category_id = 3 WHERE description like '%resulting in a reduced serum concentration and potentially a decrease in efficacy%';
UPDATE ddi SET category_id = 3 WHERE description like '%may decrease effectiveness of%';
UPDATE ddi SET category_id = 4 WHERE description like 'The metabolism of%';
UPDATE ddi SET category_id = 5 WHERE description like 'The therapeutic efficacy of %';



--********************************DDI SAME TARGET, SAME ENZYME, SAME CARRIER, SAME TRANSPORTER********************************--

--93803 records inserted.
WITH same_protein AS (
	WITH
	drug1_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 1
					AND drug_id IN (SELECT distinct(drug1_id) FROM ddi)
				ORDER BY drug_id, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
				AND d.drug_protein_type = x.drug_protein_type
		ORDER BY drug_id, drug_protein_id
	),
	drug2_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 1
					AND drug_id IN (SELECT distinct(drug2_id) FROM ddi)
				ORDER BY drug_id, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
				AND d.drug_protein_type = x.drug_protein_type
		ORDER BY drug_id, drug_protein_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.drug_protein_type,
		d1.drug_protein_id,
		d1.drug_protein_name,
		d1.polypeptide_source,
		d1.polypeptide_uniprot_id,
		d1.polypeptide_name,
		d1.gene_name,
		d1.general_function,
		d1.specific_function
	FROM drug1_protein d1
	INNER JOIN drug2_protein d2
		ON d1.drug_protein_id = d2.drug_protein_id
			AND d1.drug_id != d2.drug_id
	ORDER BY d1.drug_id, d2.drug_id
)
INSERT INTO ddi_same_drug_protein
(
	drug1_id,
	drug2_id,
	drug_protein_type,
	drug_protein_id,
	drug_protein_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_cat
)
SELECT targ.*, d.category_id
FROM same_protein targ
INNER JOIN ddi d
	ON targ.drug1_id = d.drug1_id
		AND targ.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;


--382293 records inserted.
WITH same_protein AS (
	WITH
	drug1_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 2
					AND drug_id IN (SELECT distinct(drug1_id) FROM ddi)
				ORDER BY drug_id, drug_protein_type, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
				ANd d.drug_protein_type = x.drug_protein_type
		ORDER BY drug_id, drug_protein_id
	),
	drug2_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 2
					AND drug_id IN (SELECT distinct(drug2_id) FROM ddi)
				ORDER BY drug_id, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
				AND d.drug_protein_type = x.drug_protein_type
		ORDER BY drug_id, drug_protein_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.drug_protein_type,
		d1.drug_protein_id,
		d1.drug_protein_name,
		d1.polypeptide_source,
		d1.polypeptide_uniprot_id,
		d1.polypeptide_name,
		d1.gene_name,
		d1.general_function,
		d1.specific_function
	FROM drug1_protein d1
	INNER JOIN drug2_protein d2
		ON d1.drug_protein_id = d2.drug_protein_id
			AND d1.drug_id != d2.drug_id
			AND d1.drug_protein_type = d2.drug_protein_type
	ORDER BY d1.drug_id, d2.drug_id
)
INSERT INTO ddi_same_drug_protein
(
	drug1_id,
	drug2_id,
	drug_protein_type,
	drug_protein_id,
	drug_protein_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_cat
)
SELECT targ.*, d.category_id
FROM same_protein targ
INNER JOIN ddi d
	ON targ.drug1_id = d.drug1_id
		AND targ.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;


--49210 records inserted.
WITH same_protein AS (
	WITH
	drug1_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 3
					AND drug_id IN (SELECT distinct(drug1_id) FROM ddi)
				ORDER BY drug_id, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
				AND d.drug_protein_type = x.drug_protein_type
		ORDER BY drug_id, drug_protein_id
	),
	drug2_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 3
					AND drug_id IN (SELECT distinct(drug2_id) FROM ddi)
				ORDER BY drug_id, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
				AND d.drug_protein_type = x.drug_protein_type
		ORDER BY drug_id, drug_protein_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.drug_protein_type,
		d1.drug_protein_id,
		d1.drug_protein_name,
		d1.polypeptide_source,
		d1.polypeptide_uniprot_id,
		d1.polypeptide_name,
		d1.gene_name,
		d1.general_function,
		d1.specific_function
	FROM drug1_protein d1
	INNER JOIN drug2_protein d2
		ON d1.drug_protein_id = d2.drug_protein_id
			AND d1.drug_id != d2.drug_id
			AND d1.drug_protein_type = d2.drug_protein_type
	ORDER BY d1.drug_id, d2.drug_id
)
INSERT INTO ddi_same_drug_protein
(
	drug1_id,
	drug2_id,
	drug_protein_type,
	drug_protein_id,
	drug_protein_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_cat
)
SELECT targ.*, d.category_id
FROM same_protein targ
INNER JOIN ddi d
	ON targ.drug1_id = d.drug1_id
		AND targ.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;



--139295 records inserted.
WITH same_protein AS (
	WITH
	drug1_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 4
					AND drug_id IN (SELECT distinct(drug1_id) FROM ddi)
				ORDER BY drug_id, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
				AND d.drug_protein_type = x.drug_protein_type
		ORDER BY drug_id, drug_protein_id
	),
	drug2_protein AS (
		WITH x AS(
			WITH y AS (
				SELECT * FROM public.drug_protein
				WHERE drug_protein_type = 4
					AND drug_id IN (SELECT distinct(drug2_id) FROM ddi)
				ORDER BY drug_id, drug_protein_id
			)
			SELECT
				drug_id, drug_protein_type, drug_protein_id
			FROM y
			GROUP BY drug_id, drug_protein_type, drug_protein_id
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			distinct (d.drug_id || d.drug_protein_id),
			d.drug_id,
			d.drug_protein_type,
			d.drug_protein_id,
			d.drug_protein_name,
			d.polypeptide_source,
			d.polypeptide_uniprot_id,
			d.polypeptide_name,
			d.gene_name,
			d.general_function,
			d.specific_function
		FROM x
		INNER JOIN public.drug_protein d
			ON d.drug_id = x.drug_id
				AND d.drug_protein_id = x.drug_protein_id
		ORDER BY drug_id, drug_protein_id
	)
	SELECT
		CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
		CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
		d1.drug_protein_type,
		d1.drug_protein_id,
		d1.drug_protein_name,
		d1.polypeptide_source,
		d1.polypeptide_uniprot_id,
		d1.polypeptide_name,
		d1.gene_name,
		d1.general_function,
		d1.specific_function
	FROM drug1_protein d1
	INNER JOIN drug2_protein d2
		ON d1.drug_protein_id = d2.drug_protein_id
			AND d1.drug_id != d2.drug_id
	ORDER BY d1.drug_id, d2.drug_id
)
INSERT INTO ddi_same_drug_protein
(
	drug1_id,
	drug2_id,
	drug_protein_type,
	drug_protein_id,
	drug_protein_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function,
	ddi_cat
)
SELECT targ.*, d.category_id
FROM same_protein targ
INNER JOIN ddi d
	ON targ.drug1_id = d.drug1_id
		AND targ.drug2_id = d.drug2_id
ON CONFLICT DO NOTHING;