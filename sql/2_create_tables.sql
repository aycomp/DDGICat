-- FUNCTION: public."2_create_tables"()

-- DROP FUNCTION public."2_create_tables"();

CREATE OR REPLACE FUNCTION public."2_create_tables"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$begin

--********************************DRUG EXTRACTION********************************--
--create drug table
DROP TABLE IF EXISTS drug;
CREATE TABLE drug(
    drug_id TEXT,
	name TEXT,
	type TEXT,
	description TEXT,
	state TEXT,
	indication TEXT,
	toxicity TEXT,
	pharmacodynamics TEXT,
	mechanism_of_action TEXT,
	metabolism TEXT,
	absorption TEXT,
	half_life TEXT,
	protein_binding TEXT,
	route_of_elimination TEXT,
	volume_of_distribution TEXT,
	clearance TEXT,
	articles_count INT,
	drug_interactions_count INT
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


--********************************DRUG TARGET, ENZYME, TRANSPORTER, CARRIER, PATHWAY EXTRACTION********************************--

--create drug_target table
DROP TABLE IF EXISTS drug_target;
CREATE TABLE drug_target(
    drug_id TEXT,
	target_id TEXT,
	target_name TEXT,
	target_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE drug_target ADD PRIMARY KEY (drug_id, target_id, target_action);

--create drug_enzyme table
DROP TABLE IF EXISTS drug_enzyme;
CREATE TABLE drug_enzyme(
    drug_id TEXT,
	enzyme_id TEXT,
	enzyme_name TEXT,
	enzyme_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE drug_enzyme ADD PRIMARY KEY (drug_id, enzyme_id, enzyme_action);

--create drug_transporter table
DROP TABLE IF EXISTS drug_transporter;
CREATE TABLE drug_transporter(
    drug_id TEXT,
	transporter_id TEXT,
	transporter_name TEXT,
	transporter_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE drug_transporter ADD PRIMARY KEY (drug_id, transporter_id, transporter_action);

--create drug_carrier table
DROP TABLE IF EXISTS drug_carrier;
CREATE TABLE drug_carrier(
    drug_id TEXT,
	carrier_id TEXT,
	carrier_name TEXT,
	carrier_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE drug_carrier ADD PRIMARY KEY (drug_id, carrier_id, carrier_action);

--pathway extraction

--create drug_pathway table
DROP TABLE IF EXISTS drug_pathway;
CREATE TABLE drug_pathway(
    drug_id TEXT,
	pathway_id TEXT,
	category TEXT,
	enzyme TEXT
);

--set primary key
ALTER TABLE drug_pathway ADD PRIMARY KEY (drug_id, pathway_id, category, enzyme);

--********************************DDI EXTRACTION********************************--

--create  table
DROP TABLE IF EXISTS ddi;
CREATE TABLE ddi(
	drug1_id TEXT,
	drug2_id TEXT,
	description TEXT
);

--set primary key
ALTER TABLE ddi ADD PRIMARY KEY (drug1_id, drug2_id);


--create ddi_same_target table
DROP TABLE IF EXISTS ddi_same_target;
CREATE TABLE ddi_same_target(
	drug1_id TEXT,
	drug2_id TEXT,
	target_id TEXT,
	target_name TEXT,
	drug1_actions TEXT,
	drug2_actions TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_target ADD PRIMARY KEY (drug1_id, drug2_id, target_id);


--create ddi_same_target_same_action table
DROP TABLE IF EXISTS ddi_same_target_same_action;
CREATE TABLE ddi_same_target_same_action(
	drug1_id TEXT,
	drug2_id TEXT,
	target_id TEXT,
	target_name TEXT,
	target_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_target_same_action ADD PRIMARY KEY (drug1_id, drug2_id, target_id, target_action);


--create ddi_same_enzyme table
DROP TABLE IF EXISTS ddi_same_enzyme;
CREATE TABLE ddi_same_enzyme(
	drug1_id TEXT,
	drug2_id TEXT,
	enzyme_id TEXT,
	enzyme_name TEXT,
	drug1_actions TEXT,
	drug2_actions TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_enzyme ADD PRIMARY KEY (drug1_id, drug2_id, enzyme_id);


--create ddi_same_enzyme_same_action table
DROP TABLE IF EXISTS ddi_same_enzyme_same_action;
CREATE TABLE ddi_same_enzyme_same_action(
	drug1_id TEXT,
	drug2_id TEXT,
	enzyme_id TEXT,
	enzyme_name TEXT,
	enzyme_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_enzyme_same_action ADD PRIMARY KEY (drug1_id, drug2_id, enzyme_id, enzyme_action);


--create ddi_same_transporter table
DROP TABLE IF EXISTS ddi_same_transporter;
CREATE TABLE ddi_same_transporter(
	drug1_id TEXT,
	drug2_id TEXT,
	transporter_id TEXT,
	transporter_name TEXT,
	drug1_actions TEXT,
	drug2_actions TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_transporter ADD PRIMARY KEY (drug1_id, drug2_id, transporter_id);


--create ddi_same_transporter_same_action table
DROP TABLE IF EXISTS ddi_same_transporter_same_action;
CREATE TABLE ddi_same_transporter_same_action(
	drug1_id TEXT,
	drug2_id TEXT,
	transporter_id TEXT,
	transporter_name TEXT,
	transporter_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_transporter_same_action ADD PRIMARY KEY (drug1_id, drug2_id, transporter_id, transporter_action);


--create ddi_same_carrier table
DROP TABLE IF EXISTS ddi_same_carrier;
CREATE TABLE ddi_same_carrier(
	drug1_id TEXT,
	drug2_id TEXT,
	carrier_id TEXT,
	carrier_name TEXT,
	drug1_actions TEXT,
	drug2_actions TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_carrier ADD PRIMARY KEY (drug1_id, drug2_id, carrier_id);


--create ddi_same_carrier_same_action table
DROP TABLE IF EXISTS ddi_same_carrier_same_action;
CREATE TABLE ddi_same_carrier_same_action(
	drug1_id TEXT,
	drug2_id TEXT,
	carrier_id TEXT,
	carrier_name TEXT,
	carrier_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);

--set primary key
ALTER TABLE ddi_same_carrier_same_action ADD PRIMARY KEY (drug1_id, drug2_id, carrier_id, carrier_action);


--create ddi_same_pathway table
DROP TABLE IF EXISTS ddi_same_pathway;
CREATE TABLE ddi_same_pathway(
	drug1_id TEXT,
	drug2_id TEXT,
	pathway_id TEXT,
	drug1_category TEXT,
	drug2_category TEXT,
	drug1_enzyme TEXT,
	drug2_enzyme TEXT
);

--set primary key
ALTER TABLE ddi_same_pathway ADD PRIMARY KEY (drug1_id, drug2_id, pathway_id);


	/*
--create ddi_same_pathway_same_category table
DROP TABLE IF EXISTS ddi_same_pathway_same_category;
CREATE TABLE ddi_same_pathway(
	drug1_id TEXT,
	drug2_id TEXT,
	pathway_id TEXT,
	category TEXT,
	enzyme TEXT
);

--set primary key
ALTER TABLE ddi_same_pathway ADD PRIMARY KEY (drug1_id, drug2_id, pathway_id, category);



--create ddi_same_pathway table
DROP TABLE IF EXISTS ddi_same_pathway_same_category_same_enzyme;
CREATE TABLE ddi_same_pathway_same_category_same_enzyme(
	drug1_id TEXT,
	drug2_id TEXT,
	pathway_id TEXT,
	category TEXT,
	enzyme TEXT
);

--set primary key
ALTER TABLE ddi_same_pathway ADD PRIMARY KEY (drug1_id, drug2_id, pathway_id, category, enzyme);
*/

--********************************NEWLY PREDICTED DDIs********************************--

--create ddi_same_enzyme_new table
DROP TABLE IF EXISTS ddi_same_enzyme_new;
CREATE TABLE ddi_same_enzyme_new(
	drug1_id TEXT,
	drug2_id TEXT,
	enzyme_id TEXT,
	enzyme_name TEXT,
	drug1_actions TEXT,
	drug2_actions TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT
);


--set primary key
ALTER TABLE ddi_same_enzyme_new ADD PRIMARY KEY (drug1_id, drug2_id, enzyme_id);


--create ddi_same_etc table
DROP TABLE IF EXISTS ddi_same_etc;
CREATE TABLE ddi_same_etc(
	drug1_id TEXT,
	drug2_id TEXT/*,
	carrier_id TEXT,
	carrier_name TEXT,
	carrier_action TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT*/
);

--set primary key
ALTER TABLE ddi_same_etc ADD PRIMARY KEY (drug1_id, drug2_id);


--********************************DRUG_SNP EXTRACTION********************************--

--create drug_snp table
DROP TABLE IF EXISTS drug_snp;
CREATE TABLE drug_snp(
	id SERIAL PRIMARY KEY,
	drug_id TEXT,
	snp_id TEXT,
	gene_name TEXT,
	chromosome TEXT
);

--TODO: create unique index
--CREATE UNIQUE INDEX CONCURRENTLY unique_drug_snp ON drug_snp (drug_id, snp_id, gene_name, chromosome);

--create drug_snp_detail table
DROP TABLE IF EXISTS drug_snp_detail;
CREATE TABLE drug_snp_detail(
	drug_snp_id INT REFERENCES drug_snp,
	phenotype TEXT,
	significance TEXT,
	description TEXT,
	severity TEXT,
	pubmed_id TEXT
);


--********************************DRUG_DRUG_GENE EXTRACTION********************************--

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


end;$BODY$;

ALTER FUNCTION public."2_create_tables"()
    OWNER TO postgres;

--run function
SELECT public."2_create_tables"();