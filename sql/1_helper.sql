-- FUNCTION: public."1_helper"()

-- DROP FUNCTION public."1_helper"();

CREATE OR REPLACE FUNCTION public."1_helper"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$begin

CREATE EXTENSION IF NOT EXISTS postgres_fdw;

CREATE SERVER  fdw_server
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'DrugBank', port '5432');

CREATE USER MAPPING FOR postgres
SERVER fdw_server
OPTIONS (user 'postgres', password 'terlik');

IMPORT FOREIGN SCHEMA public
LIMIT TO
(
	drugs, drug_pharmacology, drug_groups, drug_affected_organisms, drug_syn, drugs_articles, drug_external_identifiers, drug_dosages,
	targets, targets_actions, targets_polypeptides, drug_targ_articles,
    enzymes, enzymes_polypeptides, enzymes_actions, drug_enzymes_articles,
    transporters, transporters_polypeptides, transporters_actions, drug_trans_articles,
    carriers, carriers_polypeptides, carriers_actions, drug_carriers_articles,
    drug_drug_interactions, drug_snp_effects, snp_adverse_reactions
)
FROM SERVER fdw_server INTO public;


CREATE SERVER fdw_server_2
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'PharmGKB', port '5432');

CREATE USER MAPPING FOR postgres
SERVER fdw_server_2
OPTIONS (user 'postgres', password 'terlik');

IMPORT FOREIGN SCHEMA public
LIMIT TO
(
    clinical_ann_metadata, drug_external_identifiers
)
FROM SERVER fdw_server_2 INTO public;

--DROP FOREIGN TABLE drug_pathways


end;$BODY$;

ALTER FUNCTION public."1_helper"()
    OWNER TO postgres;


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


CREATE AGGREGATE sum (text)
(
    sfunc = helper_textsum,
    stype = text,
    initcond = ''
);



--Run DBLINK Function
SELECT public."1_helper"();
