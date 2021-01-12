
--********************************NEWLY PREDICTED DDIs********************************--

--create ddi_same_enzyme_new table
DROP TABLE IF EXISTS ddi_same_enzyme_new;
CREATE TABLE ddi_same_enzyme_new(
	drug1_id TEXT,
	drug2_id TEXT,
	enzyme_id TEXT,
	enzyme_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);


--set primary key
ALTER TABLE ddi_same_enzyme_new ADD PRIMARY KEY (drug1_id, drug2_id, enzyme_id);


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
			drug_id, enzyme_id, sum(enzyme_action) AS drug_action
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
			drug_id, enzyme_id, sum(enzyme_action) AS drug_action
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
