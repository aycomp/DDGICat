-- FUNCTION: public.helper_textsum(text, text)

-- DROP FUNCTION public.helper_textsum(text, text);

CREATE OR REPLACE FUNCTION public.helper_textsum(
	a text,
	b text)
    RETURNS text
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
        BEGIN
                RETURN CASE WHEN a = '' THEN b ELSE concat_ws(', ', a, b) END;
        END;
$BODY$;

ALTER FUNCTION public.helper_textsum(text, text)
    OWNER TO postgres;
