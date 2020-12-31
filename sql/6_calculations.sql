-------------TARGET
--CALCULATION: 39684 * 100 / 580673 = 7 %

--etkileşimi olan kayıtlardan 565583 tanesinin target protein kaydı var.
--580673
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_target)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_target)

--39684
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_target

-------------ENZYME
--CALCULATION: 237440 * 100 / 369434 = 64 %

--369434
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_enzyme)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_enzyme)

--237440
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_enzyme


-------------CARRIER
--CALCULATION: 24468 * 100 / 35219 = 69 %

--35219
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_carrier)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_carrier)

--24468
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_carrier


-------------TRANSPORTER
--CALCULATION: 62207 * 100 / 369434 = 16 %

--369434
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_transporter)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_transporter)

--62207
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_transporter