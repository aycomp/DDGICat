-- FUNCTION: public."2_create_tables"()

-- DROP FUNCTION public."2_create_tables"();

CREATE OR REPLACE FUNCTION public."2_create_tables"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$begin

--*******************************************************DRUG***************************************************************************-
--create drug table
DROP TABLE IF EXISTS drug;
CREATE TABLE drug(
    drug_id TEXT,
	name TEXT,
	synonym TEXT,
	type TEXT,
	description TEXT,
	state TEXT,
	indication TEXT,
	toxicity TEXT,
	pharmacodynamics TEXT,
	absorption TEXT,
	half_life TEXT,
	metabolism TEXT,
	mechanism_of_action TEXT,
	volume_of_distribution TEXT,
	protein_binding TEXT,
	clearance TEXT,
	route_of_elimination TEXT,
	pubmed_id TEXT
);

--set primary key
ALTER TABLE drug ADD PRIMARY KEY (drug_id);


--create drug_mapper table
DROP TABLE IF EXISTS drug_mapper;
CREATE TABLE drug_mapper(
    drugbank_id TEXT,
	pharmgkb_id TEXT NULL,
	onchigh_id TEXT NULL,
	kegg_id TEXT NULL
);

--set primary key
ALTER TABLE drug_mapper ADD PRIMARY KEY (drugbank_id);


--************************************************DRUG_PROTEIN************************************************-
--DRUG_PROTEIN_TYPE:
	--TARGET		:1
	--ENZYME		:2
	--CARRIER		:3
	--TRANSPORTER	:4

DROP TABLE IF EXISTS drug_protein;
CREATE TABLE drug_protein(
    drug_id TEXT,
	drug_protein_id TEXT,
	drug_protein_type INT,
	drug_protein_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
	--pubmed_id TEXT TODO: Will be added soon.
);

--set primary key
ALTER TABLE drug_protein ADD PRIMARY KEY (drug_id, drug_protein_id, drug_protein_type);

--************************************************************DDI****************************************************************-
--create  table
DROP TABLE IF EXISTS ddi;
CREATE TABLE ddi(
	drug1_id TEXT,
	drug1_name TEXT,
	drug2_id TEXT,
	drug2_name TEXT,
	severity TEXT,
	severity_desc TEXT,
	description TEXT,
	category_id INT
);
ALTER TABLE ddi ADD PRIMARY KEY (drug1_id, drug2_id);

--ddi category  table
DROP TABLE IF EXISTS ddi_category;
CREATE TABLE ddi_category(
	id INT,
	category_id INT,
	category TEXT,
	description TEXT
);
ALTER TABLE ddi_category ADD PRIMARY KEY (id);


--************************************************************DRUG_SNP****************************************************************-
--create drug_snp table
DROP TABLE IF EXISTS drug_snp;
CREATE TABLE drug_snp(
	drug_id TEXT,
	snp_id TEXT,
	uniprot_id TEXT,
	gene_name TEXT,
	chromosome TEXT,
	significance TEXT,
	description TEXT,
	severity TEXT,
	pubmed_id TEXT
);

--set primary key
--ALTER TABLE drug_snp ADD PRIMARY KEY (drug_id, snp_id, uniprot_id, gene_name, chromosome, description, pubmed_id);
ALTER TABLE drug_snp ADD PRIMARY KEY (drug_id, snp_id, uniprot_id, description, pubmed_id);

--****************************************************************GENE****************************************************************--
--create gene table
DROP TABLE IF EXISTS gene;
CREATE TABLE gene(
	ensembl_id TEXT,
	uniprot_id TEXT,
	name TEXT,
	description TEXT,
	chromosome TEXT,
	start_position TEXT,
	end_position TEXT
);

--set primary key
ALTER TABLE gene ADD PRIMARY KEY (ensembl_id, uniprot_id);

--****************************************************************SNP****************************************************************--
--create snp table
DROP TABLE IF EXISTS snp;
CREATE TABLE snp(
	refsnp_id TEXT,
    refsnp_source TEXT,
    chr_name INT,
    chrom_start INT,
    chrom_end INT,
    chrom_strand INT,
    allele TEXT
);

--set primary key
ALTER TABLE snp ADD PRIMARY KEY (refsnp_id);

--****************************************************************GENE_SNP****************************************************************--
--create gene_snp table
DROP TABLE IF EXISTS gene_snp;
CREATE TABLE gene_snp(
	ensembl_id TEXT,
	uniprot_id TEXT,
	snp_id TEXT
);
--set primary key
ALTER TABLE gene_snp ADD PRIMARY KEY (ensembl_id, uniprot_id, snp_id);


--*********************************************DDI_SAME_DRUG_PROTEIN*********************************************--


DROP TABLE IF EXISTS ddi_same_drug_protein;
CREATE TABLE ddi_same_drug_protein(
	drug1_id TEXT,
	drug2_id TEXT,
	drug_protein_type INT,
	drug_protein_id TEXT,
	drug_protein_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	ddi_cat INT
);
--set primary key
ALTER TABLE ddi_same_drug_protein ADD PRIMARY KEY (drug1_id, drug2_id, drug_protein_type, drug_protein_id);


--**********************************************DISEASE***************************************************************--

--create disease table
DROP TABLE IF EXISTS disease;
CREATE TABLE disease(
	id INT,
	pharmgkb_id TEXT,
	name TEXT
);
--set primary key
ALTER TABLE disease ADD PRIMARY KEY (id);

--**********************************************DISEASE_DRUG***************************************************************--

--create disease_drug table
DROP TABLE IF EXISTS disease_drug;
CREATE TABLE disease_drug(
	disease_id INT,
	drug_id TEXT
);
--set primary key
ALTER TABLE disease_drug ADD PRIMARY KEY (disease_id, drug_id);

--**********************************************DISEASE_GENE***************************************************************--

--create disease_gene table
DROP TABLE IF EXISTS disease_gene;
CREATE TABLE disease_gene(
	disease_id TEXT,
	gene_name TEXT,
	PMID TEXT
);
--set primary key
ALTER TABLE disease_gene ADD PRIMARY KEY (disease_id, gene_name);

--**********************************************DISEASE_VARIANT***************************************************************--

--create disease_variant table
DROP TABLE IF EXISTS disease_variant;
CREATE TABLE disease_variant(
	disease_id TEXT,
	variant_id TEXT,
	PMID TEXT
);
--set primary key
ALTER TABLE disease_variant ADD PRIMARY KEY (disease_id, variant_id);

--**********************************************DRUG_DRUG_GENE***************************************************************--

--create ddgi table
DROP TABLE IF EXISTS ddgi;
CREATE TABLE ddgi(
	drug1_id TEXT,
	drug2_id TEXT,
	snp TEXT,
	interaction_severity TEXT
);
--set primary key
ALTER TABLE ddgi ADD PRIMARY KEY (drug1_id, drug2_id, snp, interaction_severity);


--**********************************************TEMP_DDI***************************************************************--

--create temp_ddi_rxcui temporary table
DROP TABLE IF EXISTS temp_ddi_rxcui;
CREATE TABLE temp_ddi_rxcui(
	drug1_id TEXT,
	drug2_id TEXT,
	drug1_rxcui TEXT,
	drug2_rxcui TEXT
);
--set primary key
ALTER TABLE temp_ddi_rxcui ADD PRIMARY KEY (drug1_id, drug2_id);


--create temp_ddi_kegg temporary table
DROP TABLE IF EXISTS temp_ddi_kegg;
CREATE TABLE temp_ddi_kegg(
	drug1_id TEXT,
	drug2_id TEXT,
	drug1_kegg TEXT,
	drug2_kegg TEXT
);
--set primary key
ALTER TABLE temp_ddi_kegg ADD PRIMARY KEY (drug1_id, drug2_id);

end;$BODY$;

ALTER FUNCTION public."2_create_tables"()
    OWNER TO postgres;

--run function
SELECT public."2_create_tables"();