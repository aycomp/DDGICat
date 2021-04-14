--create temp table to keep filtered kegg
DROP TABLE IF EXISTS temp_kegg;
CREATE TABLE temp_kegg AS
    SELECT resource, identifier, parent_key AS drug_id
    FROM public.drug_external_identifiers
    WHERE resource = 'KEGG Drug'
            AND (
                parent_key IN(SELECT DISTINCT(drug1_id) FROM ddi) OR
                parent_key IN (SELECT DISTINCT(drug2_id) FROM ddi)
                );

--create temp table to keep ddi records which has kegg
DROP TABLE IF EXISTS temp_ddi_having_kegg;
CREATE TABLE temp_ddi_having_kegg AS
    SELECT drug1_id, drug2_id
    FROM public.ddi
    WHERE (drug1_id IN (SELECT drug_id FROM temp_kegg)
            AND drug2_id IN (SELECT drug_id FROM temp_kegg));

--insert into temp_ddi to cary both interacted drugs, and their kegg
TRUNCATE temp_ddi_kegg;
INSERT INTO temp_ddi_kegg
(
    drug1_id,
    drug2_id
)
SELECT *
FROM temp_ddi_having_kegg;



/*
NOTICE:  table "temp_kegg" does not exist, skipping
NOTICE:  table "temp_ddi_having_kegg" does not exist, skipping
INSERT 0 370072

Query returned successfully in 5 secs 184 msec.

*/
