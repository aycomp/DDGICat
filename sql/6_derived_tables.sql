--********************************DDI********************************--
--description category  table
DROP TABLE IF EXISTS description_category;
CREATE TABLE description_category(
	id INT,
	category_id INT,
	category TEXT,
	description TEXT
);
--set primary key
ALTER TABLE description_category ADD PRIMARY KEY (id);


--********************************DDI_SAME_TARGET_ENZYME_CARRIER_TRANSPORTER********************************--

--********************************TARGET
--create ddi_same_target table
DROP TABLE IF EXISTS ddi_same_target;
CREATE TABLE ddi_same_target(
	drug1_id TEXT,
	drug2_id TEXT,
	target_id TEXT,
	target_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	ddi_desc_cat INT
);
--set primary key
ALTER TABLE ddi_same_target ADD PRIMARY KEY (drug1_id, drug2_id, target_id);


--********************************ENZYME
--create ddi_same_enzyme table
DROP TABLE IF EXISTS ddi_same_enzyme;
CREATE TABLE ddi_same_enzyme(
	drug1_id TEXT,
	drug2_id TEXT,
	enzyme_id TEXT,
	enzyme_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	ddi_desc_cat INT
);
--set primary key
ALTER TABLE ddi_same_enzyme ADD PRIMARY KEY (drug1_id, drug2_id, enzyme_id);


--********************************CARRIER
--create ddi_same_carrier table
DROP TABLE IF EXISTS ddi_same_carrier;
CREATE TABLE ddi_same_carrier(
	drug1_id TEXT,
	drug2_id TEXT,
	carrier_id TEXT,
	carrier_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	ddi_desc_cat INT
);
--set primary key
ALTER TABLE ddi_same_carrier ADD PRIMARY KEY (drug1_id, drug2_id, carrier_id);


--********************************TRANSPORTER
--create ddi_same_transporter table
DROP TABLE IF EXISTS ddi_same_transporter;
CREATE TABLE ddi_same_transporter(
	drug1_id TEXT,
	drug2_id TEXT,
	transporter_id TEXT,
	transporter_name TEXT,
	polypeptide_source TEXT,
	polypeptide_uniprot_id TEXT,
	polypeptide_name TEXT,
	gene_name TEXT,
	general_function TEXT,
	specific_function TEXT,
	ddi_desc_cat INT
);
--set primary key
ALTER TABLE ddi_same_transporter ADD PRIMARY KEY (drug1_id, drug2_id, transporter_id);


--********************************SAME_ETC
--create ddi_same_etc table
DROP TABLE IF EXISTS ddi_same_etc;
CREATE TABLE ddi_same_etc(
	drug1_id TEXT,
	drug2_id TEXT
);
--set primary key
ALTER TABLE ddi_same_etc ADD PRIMARY KEY (drug1_id, drug2_id);

--********************************SAME_PATHWAY
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







--********************************MAY_BE_USEFULL_LATER********************************--
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
