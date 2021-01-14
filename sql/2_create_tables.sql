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
	pharmgkb_id TEXT NULL
);

--set primary key
ALTER TABLE drug_mapper ADD PRIMARY KEY (drugbank_id);


--************************************************TARGET, ENZYME, TRANSPORTER, CARRIER************************************************-
--create target table
DROP TABLE IF EXISTS target;
CREATE TABLE target(
    drug_id TEXT,
	target_id TEXT,
	target_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	pubmed_id TEXT
);

--set primary key
ALTER TABLE target ADD PRIMARY KEY (drug_id, target_id);

--create enzyme table
DROP TABLE IF EXISTS enzyme;
CREATE TABLE enzyme(
    drug_id TEXT,
	enzyme_id TEXT,
	enzyme_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	pubmed_id TEXT
);

--set primary key
ALTER TABLE enzyme ADD PRIMARY KEY (drug_id, enzyme_id);

--create transporter table
DROP TABLE IF EXISTS transporter;
CREATE TABLE transporter(
    drug_id TEXT,
	transporter_id TEXT,
	transporter_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	pubmed_id TEXT
);

--set primary key
ALTER TABLE transporter ADD PRIMARY KEY (drug_id, transporter_id);

--create carrier table
DROP TABLE IF EXISTS carrier;
CREATE TABLE carrier(
    drug_id TEXT,
	carrier_id TEXT,
	carrier_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	pubmed_id TEXT
);

--set primary key
ALTER TABLE carrier ADD PRIMARY KEY (drug_id, carrier_id);

--************************************************************DDI****************************************************************-
--create  table
DROP TABLE IF EXISTS ddi;
CREATE TABLE ddi(
	drug1_id TEXT,
	drug2_id TEXT,
	description TEXT,
	category TEXT
);

--set primary key
ALTER TABLE ddi ADD PRIMARY KEY (drug1_id, drug2_id);


--************************************************************DRUG_SNP****************************************************************-
--create drug_snp table
DROP TABLE IF EXISTS drug_snp;
CREATE TABLE drug_snp(
	id SERIAL PRIMARY KEY,
	drug_id TEXT,
	snp_id TEXT,
	uniprot_id TEXT,
	gene_name TEXT,
	chromosome TEXT,
	phenotype TEXT,
	significance TEXT,
	description TEXT,
	description2 TEXT,
	severity TEXT,
	pubmed_id TEXT
);

--set primary key
ALTER TABLE ddi ADD PRIMARY KEY (drug_id, snp_id, pubmed_id);

--****************************************************************GENE****************************************************************--
--create gene table
DROP TABLE IF EXISTS gene;
CREATE TABLE gene(
	ensembl_id TEXT,
	symbol TEXT,
	chromosome TEXT,
	start TEXT,
	end TEXT
);

--set primary key
ALTER TABLE gene ADD PRIMARY KEY (ensembl_id);

--****************************************************************SNP****************************************************************--
--create snp table
DROP TABLE IF EXISTS snp;
CREATE TABLE snp(
	snp_id TEXT,
	allele TEXT
);

--set primary key
ALTER TABLE gene ADD PRIMARY KEY (snp_id, allele);

--****************************************************************GENE_SNP****************************************************************--
--create gene_snp table
DROP TABLE IF EXISTS gene_snp;
CREATE TABLE gene_snp(
	id SERIAL PRIMARY KEY,
	ensembl_id TEXT,
	snp_id TEXT
);
--set primary key
ALTER TABLE gene ADD PRIMARY KEY (ensembl_id, snp_id);


end;$BODY$;

ALTER FUNCTION public."2_create_tables"()
    OWNER TO postgres;

--run function
SELECT public."2_create_tables"();