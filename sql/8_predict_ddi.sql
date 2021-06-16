
--********************************************PREDICT DDI********************************************--

--having same enzyme
DROP TABLE IF EXISTS ddi_predicted;
CREATE TABLE ddi_predicted(
	drug1_id TEXT,
	drug2_id TEXT,
	drug_protein_type INT,
	drug_protein_id TEXT,
	drug_protein_name TEXT
);


--set primary key
ALTER TABLE ddi_predicted ADD PRIMARY KEY (drug1_id, drug2_id, drug_protein_type, drug_protein_id);


--14130 records inserted.
WITH
drug1_enzyme AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_protein
			WHERE drug_protein_type = 2
				AND drug_id NOT IN (SELECT DISTINCT(drug1_id) FROM ddi)
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			drug_id, drug_protein_id
		FROM y
		GROUP BY drug_id, drug_protein_id
		ORDER BY drug_id, drug_protein_id
	)
	SELECT
		distinct (d.drug_id || d.drug_protein_id),
		d.drug_id, d.drug_protein_id, d.drug_protein_name
	FROM x
	INNER JOIN public.drug_protein d
		ON d.drug_id = x.drug_id AND d.drug_protein_id = x.drug_protein_id
	ORDER BY drug_id, drug_protein_id
),
drug2_enzyme AS (
	WITH x AS(
		WITH y AS (
			SELECT * FROM public.drug_protein
			WHERE drug_protein_type = 2
				AND drug_id NOT IN (SELECT DISTINCT(drug2_id) FROM ddi)
			ORDER BY drug_id, drug_protein_id
		)
		SELECT
			drug_id, drug_protein_id
		FROM y
		GROUP BY drug_id, drug_protein_id
		ORDER BY drug_id, drug_protein_id
	)
	SELECT
		distinct (d.drug_id || d.drug_protein_id),
		d.drug_id, d.drug_protein_id, d.drug_protein_name
	FROM x
	INNER JOIN public.drug_protein d
		ON d.drug_id = x.drug_id AND d.drug_protein_id = x.drug_protein_id
	ORDER BY drug_id, drug_protein_id
)
INSERT INTO ddi_predicted
(
	drug1_id,
	drug2_id,
	drug_protein_type,
	drug_protein_id,
	drug_protein_name
)
SELECT
	CASE WHEN d1.drug_id < d2.drug_id THEN d1.drug_id ELSE d2.drug_id END AS drug1_id,
	CASE WHEN d1.drug_id < d2.drug_id THEN d2.drug_id ELSE d1.drug_id END AS drug2_id,
	2,
	d1.drug_protein_id,
	d1.drug_protein_name
FROM drug1_enzyme d1
INNER JOIN drug2_enzyme d2
	ON d1.drug_protein_id = d2.drug_protein_id
		AND d1.drug_id != d2.drug_id
ORDER BY d1.drug_id, d2.drug_id
ON CONFLICT DO NOTHING;



/*
	OUTPUT:
	NOTICE:  table "ddi_predicted" does not exist, skipping
	INSERT 0 270

	Query returned successfully in 754 msec.

*/