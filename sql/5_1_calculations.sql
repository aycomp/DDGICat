/*
	NOTE:	What percentages of interacting drugs have the same protein.


*/
-------------TARGET
--CALCULATION: 39684 * 100 / 580673 = 7 %

--etkileşimi olan kayıtlardan 565583 tanesinin target protein kaydı var.
--580673
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 1)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 1)

--39684
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_target

-------------ENZYME
--CALCULATION: 237440 * 100 / 369434 = 64 %

--369434
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 2)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 2)

--237440
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_enzyme


-------------CARRIER
--CALCULATION: 24468 * 100 / 35219 = 69 %

--35219
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 3)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 3)

--24468
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_carrier


-------------TRANSPORTER
--CALCULATION: 62207 * 100 / 369434 = 16 %

--369434
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 4)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_protein WHERE drug_protein_type = 4)

--62207
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_transporter