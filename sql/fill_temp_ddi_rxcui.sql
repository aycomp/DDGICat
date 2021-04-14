--create temp table to keep filtered rxcuis
DROP TABLE IF EXISTS temp_rxcuis;
CREATE TABLE temp_rxcuis AS
    SELECT resource, identifier, parent_key AS drug_id
    FROM public.drug_external_identifiers
    WHERE resource = 'RxCUI'
            AND (
                parent_key IN(SELECT DISTINCT(drug1_id) FROM ddi) OR
                parent_key IN (SELECT DISTINCT(drug2_id) FROM ddi)
                );

--create temp table to keep ddi records which has rxcui
DROP TABLE IF EXISTS temp_ddi_having_rxcuis;
CREATE TABLE temp_ddi_having_rxcuis AS
    SELECT drug1_id, drug2_id
    FROM public.ddi
    WHERE (drug1_id IN (SELECT drug_id FROM temp_rxcuis)
            AND drug2_id IN (SELECT drug_id FROM temp_rxcuis));

--insert into temp_ddi to cary both interacted drugs, and their rxcuis
TRUNCATE temp_ddi;
INSERT INTO temp_ddi
(
    drug1_id,
    drug2_id
)
SELECT *
FROM temp_ddi_having_rxcuis;


/*
INSERT 0 661626

Query returned successfully in 6 secs 288 msec.

*/
