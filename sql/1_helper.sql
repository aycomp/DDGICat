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
	drugs, drug_groups, drug_affected_organisms, drug_syn, drug_dosages,drug_articles,drug_external_identifiers, drug_calculated_properties,
	drug_targ, drug_targ_actions, drug_targ_polys, drug_enzymes, drug_enzymes_actions, drug_enzymes_polypeptides,
	drug_transporters, drug_trans_actions, drug_trans_polys, drug_carriers, drug_carriers_actions, drug_carriers_polypeptides,
	drug_pathways, drug_pathways_drugs, drug_pathways_enzyme, drug_drug_interactions, drug_snp_effects, snp_adverse_reactions
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
    primary_genes, primary_drugs, primary_chemicals, drug_external_identifiers, var_drug_ann, var_pheno_ann, var_fa_ann
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
