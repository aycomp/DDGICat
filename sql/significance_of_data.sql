--most druggable SNPs
with a as (
	SELECT snp_id, drug_id, COUNT(1) AS cnt
	FROM public.drug_snp
	GROUP BY snp_id, drug_id
	ORDER BY cnt DESC
)
select
	count(1) as cnt, snp_id
from a
group by snp_id
order by cnt desc


SELECT * FROM public.drug_snp where snp_id = 'rs1045642'
SELECT * FROM public.drug_snp where snp_id = 'rs2032582'
SELECT * FROM public.drug_snp where snp_id = 'rs1128503'

--
SELECT
	COUNT(*)::int AS cnt, polypeptide_uniprot_id AS poly_id, polypeptide_name AS poly_name
FROM public.drug_protein
WHERE polypeptide_uniprot_id IS NOT NULL
GROUP BY polypeptide_uniprot_id, polypeptide_name
ORDER BY cnt DESC

select * FROM public.drug_protein where polypeptide_uniprot_id = 'P08684'
select * FROM public.drug_protein where polypeptide_uniprot_id = 'P08183'


--most used proteins by interacted drug pairs
SELECT drug_protein_id, count(*) as cnt
FROM public.ddi_same_drug_protein
group by drug_protein_id
order by cnt desc

select * from ddi_same_drug_protein where drug_protein_id = 'BE0002638'
select * from ddi_same_drug_protein where drug_protein_id = 'BE0002363'


--Which same drug protein most interact, show with percentages
with total as (
	with  a as (
		SELECT
			drug_protein_type,
			count(*) as cnt
		FROM public.ddi_same_drug_protein
		group by drug_protein_type
		order by cnt desc
	)
	select sum(cnt) as ttl
	from a
),
b as (
	SELECT
		drug_protein_type,
		count(*) as cnt
	FROM public.ddi_same_drug_protein
	group by drug_protein_type
	order by cnt desc
)
select drug_protein_type, ((cnt/ttl)*100) as percentage
from total,b


--total data history
SELECT
	'Drug' AS entity_name,
	COUNT(1) AS count
FROM public.drug
UNION ALL
SELECT
	'Gene' AS entity_name,
	COUNT(1) AS count
FROM public.gene
UNION ALL
SELECT
	'SNP' AS entity_name,
	COUNT(1) AS count
FROM public.snp
UNION ALL
SELECT
	'Drug-Protein' AS entity_name,
	COUNT(1) AS count
FROM public.drug_protein
UNION ALL
SELECT
	'Drug-SNP' AS entity_name,
	COUNT(1) AS count
FROM public.drug_snp
UNION ALL
SELECT
	'DDI' AS entity_name,
	COUNT(1) AS count
FROM public.ddi
UNION ALL
SELECT
	'DDIs grouped by sharing same Drug-Protein' AS entity_name,
	COUNT(1) AS count
FROM public.ddi_same_drug_protein
UNION ALL
SELECT
	'Disease' AS entity_name,
	COUNT(1) AS count
FROM public.disease