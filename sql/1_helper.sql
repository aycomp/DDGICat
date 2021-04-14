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
	drugs, drug_pharmacology, drug_groups, drug_affected_organisms, drug_syn,
    drugs_articles, drug_external_identifiers, drug_dosages, drug_atc_codes,
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
    clinical_ann_metadata, drug_external_identifiers,
    primary_chemicals, primary_genes
)
FROM SERVER fdw_server_2 INTO public;


CREATE SERVER fdw_server_3
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'BioMart', port '5432');

CREATE USER MAPPING FOR postgres
SERVER fdw_server_3
OPTIONS (user 'postgres', password 'terlik');

IMPORT FOREIGN SCHEMA public
LIMIT TO
(
    mart_export, geneb, snpb
)
FROM SERVER fdw_server_3 INTO public;


CREATE SERVER  fdw_server_4
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'ONCHigh', port '5432');

CREATE USER MAPPING FOR postgres
SERVER fdw_server_4
OPTIONS (user 'postgres', password 'terlik');

IMPORT FOREIGN SCHEMA public
LIMIT TO
(
	ddi_onchigh
)
FROM SERVER fdw_server_4 INTO public;


CREATE SERVER  fdw_server_5
FOREIGN DATA WRAPPER postgres_fdw
OPTIONS (host 'localhost', dbname 'KEGG', port '5432');

CREATE USER MAPPING FOR postgres
SERVER fdw_server_5
OPTIONS (user 'postgres', password 'terlik');

IMPORT FOREIGN SCHEMA public
LIMIT TO
(
	ddi_kegg
)
FROM SERVER fdw_server_5 INTO public;

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



-- FUNCTION: public.calculate_shared_protein_percentage_of_interacted_drugs(INTEGER)

-- DROP FUNCTION public.calculate_shared_protein_percentage_of_interacted_drugs(INTEGER);

CREATE OR REPLACE FUNCTION public.calculate_shared_protein_percentage_of_interacted_drugs(
	a INTEGER)
    RETURNS DECIMAL
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
cnt_ddi INTEGER;
cnt_same_drug_protein INTEGER;
final_percentage DECIMAL;
    BEGIN

        --CALCULATION: 39684 * 100 / 580673 = 7 %


        --cnt_same_drug_protein : 39684 (interact eden ilaçlardan aynı protein e sahip  ? tane var)
        SELECT COUNT(DISTINCT(drug1_id || drug2_id)) INTO cnt_same_drug_protein
        FROM public.ddi_same_drug_protein WHERE drug_protein_type = a;


        --cnt_ddi : 580673 (interact eden ilaçlardan ? tanesinin drug protein kaydı var)
        SELECT
            COUNT(DISTINCT(drug1_id || drug2_id)) INTO cnt_ddi
        FROM ddi
        WHERE drug1_id IN (SELECT DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = a)
            AND drug2_id IN (SELECT DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = a);



        final_percentage := cnt_same_drug_protein * 100 / cnt_ddi;
        RAISE NOTICE 'cnt_ddi: % , cnt_same_drug_protein: %, final_percentage: %',
                cnt_ddi, cnt_same_drug_protein, final_percentage;

        RETURN final_percentage;
    END;
$BODY$;

ALTER FUNCTION public.calculate_shared_protein_percentage_of_interacted_drugs(INTEGER)
    OWNER TO postgres;



--Run DBLINK Function
SELECT public."1_helper"();
