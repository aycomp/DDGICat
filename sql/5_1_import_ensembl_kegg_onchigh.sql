-- FUNCTION: public."5_1_import_ensembl_kegg_onchigh"()

-- DROP FUNCTION public."5_1_import_ensembl_kegg_onchigh"();

CREATE OR REPLACE FUNCTION public."5_1_import_ensembl_kegg_onchigh"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$
DECLARE
	 v_cnt INT;

BEGIN

--********************************ENSEMBL GENE IMPORT*********************************--
--gene
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
	DISTINCT(ensembl_gene_id),
	uniprot_gn_id,
	hgnc_symbol,
	description,
	chromosome_name,
	start_position,
	end_position
FROM public.geneb
WHERE (chromosome_name >= '1' AND chromosome_name <= '23')
    OR (chromosome_name IN ('X', 'Y'))
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into gene table from biomart gene table', v_cnt;
    v_cnt = 0;
END IF;
----------------------

--********************************ENSEMBL SNP IMPORT*********************************--
--snp
INSERT INTO snp
(
 	refsnp_id,
    refsnp_source,
    chr_name,
    chrom_start,
    chrom_end,
    chrom_strand,
    allele
)
SELECT
	DISTINCT(refsnp_id),
	refsnp_source,
    chr_name,
    chrom_start,
    chrom_end,
    chrom_strand,
    allele
FROM public.snpb
GET DIAGNOSTICS v_cnt = ROW_COUNT;

IF v_cnt > 0 THEN
    RAISE NOTICE '% row inserted into snp table from biomart snp table', v_cnt;
    v_cnt = 0;
END IF;
----------------------


end;$BODY$;

ALTER FUNCTION public."5_1_import_ensembl_kegg_onchigh"()
    OWNER TO postgres;


--run function
SELECT public."5_1_import_ensembl_kegg_onchigh"();



/*

OUTPUT:


*/
