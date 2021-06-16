-- FUNCTION: public."5_2_fill_drug_mapper_with_onchigh_and_kegg"()

-- DROP FUNCTION public."5_2_fill_drug_mapper_with_onchigh_and_kegg"();

CREATE OR REPLACE FUNCTION public."5_2_fill_drug_mapper_with_onchigh_and_kegg"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
	 v_cnt INT;
BEGIN


WITH onc AS (
	SELECT
		identifier AS rxcui,
		parent_key AS drugbank_id
	FROM drug_external_identifiers
	WHERE resource = 'RxCUI'
)
UPDATE public.drug_mapper d
SET onchigh_id = onc.rxcui
FROM onc
WHERE d.drugbank_id = onc.drugbank_id;
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row updated', v_cnt;
    v_cnt = 0;
END IF;



WITH kegg AS (
	SELECT
		identifier AS kegg_id,
		parent_key AS drugbank_id
	FROM drug_external_identifiers
	WHERE resource = 'KEGG Drug'
)
UPDATE public.drug_mapper d
SET kegg_id = kegg.kegg_id
FROM kegg
WHERE d.drugbank_id = kegg.drugbank_id;
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row updated', v_cnt;
    v_cnt = 0;
END IF;


END;$BODY$;

ALTER FUNCTION public."5_2_fill_drug_mapper_with_onchigh_and_kegg"()
    OWNER TO postgres;


--run function1
SELECT public."5_2_fill_drug_mapper_with_onchigh_and_kegg"();

/* OUTPUT:



*/