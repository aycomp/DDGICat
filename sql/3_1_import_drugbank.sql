-- FUNCTION: public."3_1_import_drugbank"()

-- DROP FUNCTION public."3_1_import_drugbank"();

CREATE OR REPLACE FUNCTION public."3_1_import_drugbank"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
	 v_cnt INT;

	 v_target_cnt INT;
	 v_enzyme_cnt INT;
	 v_carrier_cnt INT;
	 v_transporter_cnt INT;
BEGIN

--********************************DRUG IMPORT********************************--

--affected organism different from 'Humans', 'Humans and other mammals' are eliminated
INSERT INTO drug
	(drug_id, name, "type", description, state, indication, toxicity, pharmacodynamics,
	 absorption, half_life, metabolism, mechanism_of_action, volume_of_distribution,
	 protein_binding, route_of_elimination)
SELECT
	d.primary_key,
	d.name,
	d.type,
	d.description,
	d.state,
	p.indication,
	p.toxicity,
	p.pharmacodynamics,
	p.absorption,
	p.half_life,
	p.metabolism,
	p.mechanism_of_action,
	p.volume_of_distribution,
	p.protein_binding,
	p.route_of_elimination
FROM public.drugs d
INNER JOIN public.drug_pharmacology p
	ON d.primary_key = p.drugbank_id
WHERE d.primary_key NOT IN (
	SELECT drugbank_id
	FROM public.drug_affected_organisms
	WHERE affected_organism NOT IN ('Humans', 'Humans and other mammals'))
ORDER BY d.primary_key;
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into drug table', v_cnt;
	v_cnt = 0;
END IF;



--fill pubmed_ids
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
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row updated from drug table - pubmed ids', v_cnt;
    v_cnt = 0;
END IF;

--fill synonyms
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
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row updated from drug table - drug synonyms', v_cnt;
    v_cnt = 0;
END IF;


--********************************DRUG TARGET, ENZYME, TRANSPORTER, CARRIER IMPORT********************************--


WITH target AS (
	WITH sub AS (
		SELECT *
		FROM public.targets
		WHERE parent_key IN(SELECT drug_id FROM drug)
			AND organism in ('Humans', 'Mouse', 'Rat')
	)
	SELECT
		sub.parent_key AS drug_id,
		sub.id AS drug_protein_id,
		1 AS drug_protein_type,
		sub.name AS drug_protein_name,
		tp.source AS polypeptide_source,
		tp.id AS polypeptide_uniprot_id,
		tp.name AS polypeptide_name,
		tp.gene_name,
		tp.general_function,
		tp.specific_function
	FROM sub
	LEFT JOIN public.targets_polypeptides tp
		ON sub.id = tp.parent_id
	ORDER BY sub.parent_key
),
enzyme AS (
	WITH sub AS (
		SELECT *
		FROM public.enzymes
		WHERE parent_key IN(SELECT drug_id FROM drug)
			AND organism in ('Humans', 'Mouse', 'Rat')
	)
	SELECT
		sub.parent_key AS drug_id,
		sub.id AS drug_protein_id,
		2 AS drug_protein_type,
		sub.name AS drug_protein_name,
		ep.source AS polypeptide_source,
		ep.id AS polypeptide_uniprot_id,
		ep.name AS polypeptide_name,
		ep.gene_name,
		ep.general_function,
		ep.specific_function
	FROM sub
	LEFT JOIN public.enzymes_polypeptides ep
		ON sub.id = ep.parent_id
	ORDER BY sub.parent_key
),
carrier AS (
	WITH sub AS (
		SELECT *
		FROM public.carriers
		WHERE parent_key IN(SELECT drug_id FROM drug)
			AND organism in ('Humans', 'Mouse', 'Rat')
	)
	SELECT
		sub.parent_key AS drug_id,
		sub.id AS drug_protein_id,
		3 AS drug_protein_type,
		sub.name AS drug_protein_name,
		cp.source AS polypeptide_source,
		cp.id AS polypeptide_uniprot_id,
		cp.name AS polypeptide_name,
		cp.gene_name,
		cp.general_function,
		cp.specific_function
	FROM sub
	LEFT JOIN public.carriers_polypeptides cp
		ON sub.id = cp.parent_id
	ORDER BY sub.parent_key
),
transporter AS (
	WITH sub AS (
		SELECT *
		FROM public.transporters
		WHERE parent_key IN(SELECT drug_id FROM drug)
			AND organism in ('Humans', 'Mouse', 'Rat')
	)
	SELECT
		sub.parent_key AS drug_id,
		sub.id AS drug_protein_id,
		4 AS drug_protein_type,
		sub.name AS drug_protein_name,
		tp.source AS polypeptide_source,
		tp.id AS polypeptide_uniprot_id,
		tp.name AS polypeptide_name,
		tp.gene_name,
		tp.general_function,
		tp.specific_function
	FROM sub
	LEFT JOIN public.transporters_polypeptides tp
		ON sub.id = tp.parent_id
	ORDER BY sub.parent_key
)
INSERT INTO drug_protein
(
	drug_id,
	drug_protein_id,
	drug_protein_type,
	drug_protein_name,
	polypeptide_source,
	polypeptide_uniprot_id,
	polypeptide_name,
	gene_name,
	general_function,
	specific_function
)
SELECT * FROM target
UNION ALL
SELECT * FROM enzyme
UNION ALL
SELECT * FROM carrier
UNION ALL
SELECT * FROM transporter;


PERFORM v_target_cnt = COUNT(1) FROM drug_protein WHERE drug_protein_type = 1;
PERFORM v_enzyme_cnt = COUNT(1) FROM drug_protein WHERE drug_protein_type = 2;
PERFORM v_carrier_cnt = COUNT(1) FROM drug_protein WHERE drug_protein_type = 3;
PERFORM v_transporter_cnt = COUNT(1) FROM drug_protein WHERE drug_protein_type = 4;

--Raise imported record counts
IF v_target_cnt > 0 THEN
    RAISE NOTICE '% target record imported into drug_protein table', v_target_cnt;
END IF;

IF v_enzyme_cnt > 0 THEN
    RAISE NOTICE '% enzyme record imported into drug_protein table', v_enzyme_cnt;
END IF;

IF v_carrier_cnt > 0 THEN
    RAISE NOTICE '% carrier record imported into drug_protein table', v_carrier_cnt;
END IF;

IF v_transporter_cnt > 0 THEN
    RAISE NOTICE '% transporter record imported into drug_protein table', v_transporter_cnt;
END IF;



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
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into ddi table', v_cnt;
    v_cnt = 0;
END IF;

UPDATE ddi
SET drug1_name = drug.name
FROM drug
WHERE drug.drug_id = ddi.drug1_id;

UPDATE ddi
SET drug2_name = drug.name
FROM drug
WHERE drug.drug_id = ddi.drug2_id;

--********************************DRUG_SNP IMPORT********************************--

--drug_snp_effects
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
	parent_key AS drug_id,
	"rs-id" AS snp_id,
	"uniprot-id" AS uniprot_id,
	"gene-symbol" AS gene_name,
	'' AS chromosome,
	'' AS significance,
	description || 'allele: ' || allele || 'defining-change: ' || "defining-change" AS description,
	'Minor' AS severity,
	"pubmed-id" AS pubmed_id
FROM public.drug_snp_effects
WHERE parent_key IN (SELECT drug_id FROM drug)
	AND "rs-id" != ''
	AND parent_key || "rs-id" || "gene-symbol"
		NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp);
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into drup_snp table from drug_snp_effects', v_cnt;
    v_cnt = 0;
END IF;


--snp_adverse_reactions
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
	parent_key AS drug_id,
	"rs-id" AS snp_id,
	"uniprot-id" AS uniprot_id,
	"gene-symbol" AS gene_name,
	'' AS chromosome,
	'' AS significance,
	description || 'allele: ' || allele || 'adverse-reaction: ' || "adverse-reaction" AS description,
	'Major' AS severity,
	"pubmed-id" AS pubmed_id
FROM public.snp_adverse_reactions
WHERE parent_key IN (SELECT drug_id FROM drug)
	AND "rs-id" != ''
	AND parent_key || "rs-id" || "gene-symbol"
		NOT IN (SELECT drug_id || snp_id || gene_name FROM drug_snp);
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into drup_snp table from snp_adverse_reactions', v_cnt;
    v_cnt = 0;
END IF;


--********************************GENE IMPORT********************************--
--gene
INSERT INTO gene
(
	ensembl_id,
	hgnc_symbol,
	description,
	uniprot_id,
	uniprot_symbol,
	chromosome,
	start_position,
	end_position
)
SELECT
	DISTINCT(ensembl_gene_id),
	hgnc_symbol,
	description,
	uniprot_gn_id,
	uniprot_gn_symbol,
	chromosome_name,
	start_position,
	end_position
FROM public.geneb
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into gene table from biomart gene table', v_cnt;
    v_cnt = 0;
END IF;
----------------------


--********************************SNP IMPORT********************************--
--snp
INSERT INTO snp
(
 	refsnp_id,
    refsnp_source,
    chr_name,
    chrom_start,
    chrom_end,
    chrom_strand,
    allele
)
SELECT
	DISTINCT(refsnp_id),
	refsnp_source,
    chr_name,
    chrom_start,
    chrom_end,
    chrom_strand,
    allele
FROM public.snpb
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into snp table from biomart snp table', v_cnt;
    v_cnt = 0;
END IF;
----------------------

end;$BODY$;

ALTER FUNCTION public."3_1_import_drugbank"()
    OWNER TO postgres;


--run function
SELECT public."3_1_import_drugbank"();



/*

OUTPUT:

NOTICE:  13914 row inserted into drug table
NOTICE:  2812 row updated from drug table - pubmed ids
NOTICE:  6259 row updated from drug table - drug synonyms
NOTICE:  1154667 row inserted into ddi table
NOTICE:  201 row inserted into drup_snp table from drug_snp_effects
NOTICE:  107 row inserted into drup_snp table from snp_adverse_reactions

Successfully run. Total query runtime: 1 min 18 secs.
1 rows affected.

*/
