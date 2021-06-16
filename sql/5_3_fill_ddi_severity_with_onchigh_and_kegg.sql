-- FUNCTION: public."5_3_fill_ddi_severity_with_onchigh_and_kegg"()

-- DROP FUNCTION public."5_3_fill_ddi_severity_with_onchigh_and_kegg"();

CREATE OR REPLACE FUNCTION public."5_3_fill_ddi_severity_with_onchigh_and_kegg"(
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
        SELECT *
        FROM temp_ddi_rxcui
    ),
    ddi_severity AS (
        SELECT *
        FROM ddi_onchigh
    )
    UPDATE ddi
    SET severity = ddi_severity.severity
    FROM onc
    INNER JOIN ddi_severity
        ON onc.drug1_rxcui = ddi_severity.drug_one_rxcui
            AND onc.drug2_rxcui = ddi_severity.drug_two_rxcui
    WHERE onc.drug1_id = ddi.drug1_id
        AND onc.drug2_id = ddi.drug2_id;



    WITH kegg AS (
        SELECT *
        FROM temp_ddi_kegg
    ),
    ddi_severity AS (
        SELECT *
        FROM ddi_kegg
    )
    UPDATE ddi
    SET severity = ddi_severity.severity_level,
        severity_desc = ddi_severity.description
    FROM kegg
    INNER JOIN ddi_severity
        ON kegg.drug1_kegg = ddi_severity.drug_one_kegg_id
            AND kegg.drug2_kegg = ddi_severity.drug_two_kegg_id
    WHERE kegg.drug1_id = ddi.drug1_id
        AND kegg.drug2_id = ddi.drug2_id;

end;$BODY$;

ALTER FUNCTION public."5_3_fill_ddi_severity_with_onchigh_and_kegg"()
    OWNER TO postgres;


--run function
SELECT public."5_3_fill_ddi_severity_with_onchigh_and_kegg"();



/*
OUTPUT:


UPDATE 26074

Query returned successfully in 1 secs 805 msec.

*/