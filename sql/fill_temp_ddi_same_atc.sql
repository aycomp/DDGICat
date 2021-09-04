
CREATE OR REPLACE FUNCTION public."fill_temp_ddi_same_atc"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$

	DECLARE
		cursor_ddi CURSOR
		FOR
		SELECT (drug1_id || ',' || drug2_id) as drug
		FROM public.ddi
        WHERE severity = 'high';

	rec_ddi RECORD;
	atc TEXT;
    drug1id TEXT;
    drug2id TEXT;

BEGIN

    TRUNCATE TABLE temp_ddi_same_atc1;
    TRUNCATE TABLE temp_ddi_same_atc2;
    TRUNCATE TABLE temp_ddi_same_atc3;
    TRUNCATE TABLE temp_ddi_same_atc4;

    --atc1
    INSERT INTO temp_ddi_same_atc1
    (
    drug1_id, drug2_id, severity
    )
    SELECT drug1_id, drug2_id, severity
    FROM ddi
    WHERE severity = 'high';

    --atc2
    INSERT INTO temp_ddi_same_atc2
    (
    drug1_id, drug2_id, severity
    )
    SELECT drug1_id, drug2_id, severity
    FROM ddi
    WHERE severity = 'high';

    --atc3
    INSERT INTO temp_ddi_same_atc3
    (
    drug1_id, drug2_id, severity
    )
    SELECT drug1_id, drug2_id, severity
    FROM ddi
    WHERE severity = 'high';

    --atc4
    INSERT INTO temp_ddi_same_atc4
    (
    drug1_id, drug2_id, severity
    )
    SELECT drug1_id, drug2_id, severity
    FROM ddi
    WHERE severity = 'high';


 OPEN cursor_ddi;
 LOOP
	FETCH cursor_ddi INTO rec_ddi;
	EXIT WHEN NOT FOUND;

	atc := '';
    drug1id := split_part(rec_ddi.drug, ',', 1);
    drug2id := split_part(rec_ddi.drug, ',', 2);

    RAISE NOTICE '% , %', drug1id, drug2id;

    --atc1
	SELECT code_1 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug1id LIMIT 1;
	UPDATE temp_ddi_same_atc1 SET  drug1_atc = atc WHERE  drug1_id = drug1id;

    RAISE NOTICE 'atc1: %', atc;

    SELECT code_1 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug2id LIMIT 1;
	UPDATE temp_ddi_same_atc1 SET  drug2_atc = atc WHERE drug2_id = drug2id;

    --atc2
	SELECT code_2 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug1id LIMIT 1;
	UPDATE temp_ddi_same_atc2 SET  drug1_atc = atc WHERE drug1_id = drug1id;

	SELECT code_2 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug2id LIMIT 1;
	UPDATE temp_ddi_same_atc2 SET  drug2_atc = atc WHERE drug2_id = drug2id;

    --atc3
	SELECT code_3 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug1id LIMIT 1;
	UPDATE temp_ddi_same_atc3 SET  drug1_atc = atc WHERE drug1_id = drug1id;

	SELECT code_3 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug2id LIMIT 1;
	UPDATE temp_ddi_same_atc3 SET  drug2_atc = atc WHERE drug2_id = drug2id;

    --atc4
	SELECT code_4 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug1id LIMIT 1;
	UPDATE temp_ddi_same_atc4 SET  drug1_atc = atc WHERE drug1_id = drug1id;

	SELECT code_4 INTO atc FROM drug_atc_codes WHERE "drugbank-id" = drug2id LIMIT 1;
	UPDATE temp_ddi_same_atc4 SET  drug2_atc = atc WHERE drug2_id = drug2id;


 END LOOP;
 CLOSE cursor_ddi;


end;$BODY$;

ALTER FUNCTION public."fill_temp_ddi_same_atc"()
    OWNER TO postgres;



--run function
SELECT public."fill_temp_ddi_same_atc"();