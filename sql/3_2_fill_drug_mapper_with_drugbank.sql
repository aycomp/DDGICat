-- FUNCTION: public."3_1_2_fill_drug_mapper"()

-- DROP FUNCTION public."3_1_2_fill_drug_mapper"();

CREATE OR REPLACE FUNCTION public."3_1_2_fill_drug_mapper"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
	 v_cnt INT;
BEGIN

--********************************DRUG MAPPER DRUGBANK ITEMS INSERT********************************--

--fill drug_mapper
INSERT INTO drug_mapper (drugbank_id)
SELECT drug_id FROM drug
ORDER BY 1;
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
	RAISE NOTICE '% row inserted into drug_mapper', v_cnt;
    v_cnt = 0;
END IF;


--update from drugbank external_identifiers
WITH sub AS (
	SELECT * FROM drug_external_identifiers WHERE resource = 'PharmGKB'
)
UPDATE drug_mapper
SET pharmgkb_id = sub.identifier
FROM sub
WHERE drug_mapper.drugbank_id = sub.parent_key
	AND drug_mapper.pharmgkb_id IS NULL;
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into drug_mapper', v_cnt;
END IF;

end;$BODY$;

ALTER FUNCTION public."3_1_2_fill_drug_mapper"()
    OWNER TO postgres;


--run function
SELECT public."3_1_2_fill_drug_mapper"();

/*

OUTPUT:

NOTICE:  13914 row inserted into drug_mapper
NOTICE:  1531 row inserted into drug_mapper

Successfully run. Total query runtime: 216 msec.
1 rows affected.


*/