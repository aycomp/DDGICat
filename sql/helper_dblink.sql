-- FUNCTION: public."helper_dblink"()

-- DROP FUNCTION public."helper_dblink"();

CREATE OR REPLACE FUNCTION public."helper_dblink"(
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
	drugs, drug_affected_organisms, drug_syn, drug_dosages,drug_articles,drug_external_identifiers, drug_calculated_properties,
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
    var_drug_ann, primary_genes, primary_drugs, primary_chemicals, drug_external_identifiers,primary_genes
)
FROM SERVER fdw_server_2 INTO public;

--DROP FOREIGN TABLE drug_pathways


end;$BODY$;

ALTER FUNCTION public."helper_dblink"()
    OWNER TO postgres;
