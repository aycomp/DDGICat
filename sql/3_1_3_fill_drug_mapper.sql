-- FUNCTION: public."3_1_3_fill_drug_mapper"()

-- DROP FUNCTION public."3_1_3_fill_drug_mapper"();

CREATE OR REPLACE FUNCTION public."3_1_3_fill_drug_mapper"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
	 v_cnt INT;
BEGIN

--********************************DRUG MAPPER FILL FROM NAME SYNONYMS********************************--

--update from pharmgkb primary_chemicals ("Name")
WITH sub AS (
	SELECT
		"PharmGKB.Accession.Id" AS pharmgkb_id,
		LOWER("Name") AS drug_name
	FROM public.primary_chemicals
),
sub2 AS (
	SELECT LOWER(name) AS drug_name, * FROM drug
)
UPDATE drug_mapper
SET pharmgkb_id = sub.pharmgkb_id
FROM sub, sub2
WHERE drug_mapper.drugbank_id = sub2.drug_id
	AND sub.drug_name = sub2.drug_name
	AND drug_mapper.pharmgkb_id IS NULL;
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row for pharmgkbk_id column updated in drug_mapper table.', v_cnt;
END IF;


end;$BODY$;

ALTER FUNCTION public."3_1_3_fill_drug_mapper"()
    OWNER TO postgres;


--run function
SELECT public."3_1_3_fill_drug_mapper"();

/*

OUTPUT:
NOTICE:  329 row for pharmgkbk_id column updated in drug_mapper table.


*/