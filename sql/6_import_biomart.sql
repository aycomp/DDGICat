-- FUNCTION: public."5_import_biomart"()

-- DROP FUNCTION public."5_import_biomart"();

CREATE OR REPLACE FUNCTION public."5_import_biomart"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
	 v_cnt INT;
begin

--extract proteins which have drug effect.
INSERT INTO gene
(
    ensembl_id,
	uniprot_id,
	name,
    description,
	chromosome,
	start_position,
	end_position
)
SELECT
	"Gene.stable.ID" AS ensembl_id,
	"UniProtKB.Swiss.Prot.ID" AS uniprot_id,
    "Gene.name" AS name,
	"Gene.description" AS description,
	"Chromosome.scaffold.name" AS chromosome,
	"Gene.start..bp." AS start_position,
	"Gene.end..bp." AS end_position
FROM mart_export
WHERE "UniProtKB.Swiss.Prot.ID" IN (
	SELECT DISTINCT(polypeptide_uniprot_id)
	FROM drug_protein);
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into gene table', v_cnt;
    v_cnt = 0;
END IF;

--extract SNPs related with genes which have drug effect.



end;$BODY$;

ALTER FUNCTION public."5_import_biomart"()
    OWNER TO postgres;


--run function
SELECT public."5_import_biomart"();

/*

OUTPUT:

NOTICE:  3261 row inserted into gene table

Successfully run. Total query runtime: 230 msec.
1 rows affected.

*/