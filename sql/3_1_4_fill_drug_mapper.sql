-- FUNCTION: public."3_1_4_fill_drug_mapper"()

-- DROP FUNCTION public."3_1_4_fill_drug_mapper"();

CREATE OR REPLACE FUNCTION public."3_1_4_fill_drug_mapper"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$

DECLARE
	cursor_keyword CURSOR
	FOR
	SELECT resource || ':' || identifier || ',' || parent_key AS keyword
	FROM public.drug_external_identifiers
	WHERE parent_key IN(
		SELECT drugbank_id FROM drug_mapper WHERE pharmgkb_id IS NULL
	);
	rec_keyword RECORD;

	v_cnt INT;
	v_total INT;

BEGIN

 OPEN cursor_keyword;

 LOOP
	FETCH cursor_keyword INTO rec_keyword;
	EXIT WHEN NOT FOUND;

	v_cnt := 0;

	WITH sub AS (
		SELECT
			"PharmGKB.Accession.Id" AS pharmgkbk_id
		FROM public.primary_chemicals
		WHERE "Cross.references" LIKE '%' || split_part(rec_keyword.keyword, ',', 1) || '%'
	)
	UPDATE drug_mapper
	SET pharmgkb_id = sub.pharmgkbk_id
	FROM sub
	WHERE drug_mapper.pharmgkb_id IS NULL
		AND drug_mapper.drugbank_id = split_part(rec_keyword.keyword, ',', 2);
	GET DIAGNOSTICS v_cnt = ROW_COUNT;

	IF v_cnt > 0 THEN
		RAISE NOTICE 'Record:  % is updated with: %', split_part(rec_keyword.keyword, ',', 1), split_part(rec_keyword.keyword, ',', 2);
		v_total := v_total + 1;
	END IF;

 END LOOP;

 RAISE NOTICE '% number of rows updated in drug_mapper table', v_total;

 CLOSE cursor_keyword;


end;$BODY$;

ALTER FUNCTION public."3_1_4_fill_drug_mapper"()
    OWNER TO postgres;


--run function
SELECT public."3_1_4_fill_drug_mapper"();

/*

OUTPUT:
NOTICE:  Record:  ChemSpider:5864 is updated with: DB01488
NOTICE:  Record:  PubChem Compound:13308 is updated with: DB01541
NOTICE:  Record:  PubChem Compound:7339 is updated with: DB01632
NOTICE:  Record:  PubChem Compound:9700 is updated with: DB01643
NOTICE:  Record:  PubChem Compound:19 is updated with: DB01672
NOTICE:  Record:  ChemSpider:2244 is updated with: DB01681
NOTICE:  Record:  PubChem Compound:547 is updated with: DB01702
NOTICE:  Record:  PubChem Compound:1015 is updated with: DB01738
NOTICE:  Record:  PubChem Compound:439155 is updated with: DB01752
NOTICE:  Record:  PubChem Compound:96 is updated with: DB01762
NOTICE:  Record:  ChemSpider:650 is updated with: DB01775
NOTICE:  Record:  PubChem Compound:988 is updated with: DB01783
NOTICE:  Record:  PubChem Compound:647 is updated with: DB01785
NOTICE:  Record:  ChemSpider:1037 is updated with: DB01796
NOTICE:  Record:  PubChem Compound:385 is updated with: DB01856
NOTICE:  Record:  PubChem Compound:8629 is updated with: DB01861
NOTICE:  Record:  BindingDB:358 is updated with: DB01887
NOTICE:  Record:  BindingDB:4 is updated with: DB01909
NOTICE:  Record:  PubChem Compound:1779 is updated with: DB01931
NOTICE:  Record:  ChemSpider:2310 is updated with: DB01946
NOTICE:  Record:  PubChem Compound:3537 is updated with: DB01958
NOTICE:  Record:  PubChem Compound:30819 is updated with: DB01962
NOTICE:  Record:  PDB:G is updated with: DB01972
NOTICE:  Record:  PubChem Compound:107 is updated with: DB02024
NOTICE:  Record:  ChemSpider:1389 is updated with: DB02044
NOTICE:  Record:  PubChem Compound:77982 is updated with: DB02053
NOTICE:  Record:  BindingDB:6 is updated with: DB02060
NOTICE:  Record:  PubChem Compound:91493 is updated with: DB02076
NOTICE:  Record:  ChemSpider:280 is updated with: DB02079
NOTICE:  Record:  PubChem Compound:673 is updated with: DB02083
NOTICE:  Record:  PubChem Compound:535 is updated with: DB02085
NOTICE:  Record:  PubChem Compound:218 is updated with: DB02119
NOTICE:  Record:  PubChem Compound:1053 is updated with: DB02142
NOTICE:  Record:  PubChem Compound:289 is updated with: DB02232
NOTICE:  Record:  PubChem Compound:5139 is updated with: DB02234
NOTICE:  Record:  PubChem Compound:473 is updated with: DB02238
NOTICE:  Record:  PDB:QUM is updated with: DB02240
NOTICE:  Record:  PubChem Compound:955 is updated with: DB02251
NOTICE:  Record:  PubChem Compound:1021 is updated with: DB02272
NOTICE:  Record:  PubChem Compound:5287971 is updated with: DB02306
NOTICE:  Record:  PubChem Compound:5884 is updated with: DB02338
NOTICE:  Record:  PubChem Compound:1318 is updated with: DB02365
NOTICE:  Record:  PubChem Compound:1667 is updated with: DB02395
NOTICE:  Record:  ChemSpider:1457 is updated with: DB02463
NOTICE:  Record:  PubChem Compound:6590 is updated with: DB02531
NOTICE:  Record:  PubChem Compound:445992 is updated with: DB02544
NOTICE:  Record:  PubChem Compound:675 is updated with: DB02591
NOTICE:  Record:  BindingDB:359 is updated with: DB02629
NOTICE:  Record:  ChemSpider:1874 is updated with: DB02642
NOTICE:  Record:  PubChem Compound:9864 is updated with: DB02679
NOTICE:  Record:  PubChem Compound:529 is updated with: DB02726
NOTICE:  Record:  BindingDB:155 is updated with: DB02729
NOTICE:  Record:  PubChem Compound:178 is updated with: DB02736
NOTICE:  Record:  PubChem Compound:1017 is updated with: DB02746
NOTICE:  Record:  PubChem Compound:763 is updated with: DB02751
NOTICE:  Record:  PubChem Compound:1048 is updated with: DB02757
NOTICE:  Record:  ChemSpider:13615 is updated with: DB02776
NOTICE:  Record:  BindingDB:194 is updated with: DB02804
NOTICE:  Record:  PubChem Compound:546 is updated with: DB02823
NOTICE:  Record:  PubChem Compound:1003 is updated with: DB02831
NOTICE:  Record:  PDB:KAR is updated with: DB02868
NOTICE:  Record:  ChemSpider:181 is updated with: DB02897
NOTICE:  Record:  PDB:DHT is updated with: DB02901
NOTICE:  Record:  PubChem Compound:254 is updated with: DB02923
NOTICE:  Record:  PubChem Compound:1715 is updated with: DB02929
NOTICE:  Record:  ChemSpider:50614 is updated with: DB02932
NOTICE:  Record:  ChemSpider:555 is updated with: DB02948
NOTICE:  Record:  PubChem Compound:964 is updated with: DB02951
NOTICE:  Record:  PDB:XED is updated with: DB03034
NOTICE:  Record:  PDB:168 is updated with: DB03045
NOTICE:  Record:  PubChem Compound:92153 is updated with: DB03059
NOTICE:  Record:  PubChem Compound:6380 is updated with: DB03095
NOTICE:  Record:  ChemSpider:1876 is updated with: DB03098
NOTICE:  Record:  PubChem Compound:239 is updated with: DB03107
NOTICE:  Record:  ChemSpider:1331 is updated with: DB03121
NOTICE:  Record:  ChemSpider:1105 is updated with: DB03145
NOTICE:  Record:  PubChem Compound:490 is updated with: DB03174
NOTICE:  Record:  PubChem Compound:5281 is updated with: DB03193
NOTICE:  Record:  PubChem Compound:70 is updated with: DB03229
NOTICE:  Record:  PubChem Compound:171 is updated with: DB03304
NOTICE:  Record:  PubChem Compound:65359 is updated with: DB03310
NOTICE:  Record:  PubChem Compound:6535 is updated with: DB03347
NOTICE:  Record:  PubChem Compound:3991 is updated with: DB03359
NOTICE:  Record:  ChemSpider:5485 is updated with: DB03365
NOTICE:  Record:  PubChem Compound:984 is updated with: DB03381
NOTICE:  Record:  PubChem Compound:439456 is updated with: DB03401
NOTICE:  Record:  PDB:169 is updated with: DB03417
NOTICE:  Record:  PubChem Compound:340 is updated with: DB03454
NOTICE:  Record:  PubChem Compound:332 is updated with: DB03514
NOTICE:  Record:  PDB:CAZ is updated with: DB03530
NOTICE:  Record:  PubChem Compound:126 is updated with: DB03560
NOTICE:  Record:  PubChem Compound:86 is updated with: DB03644
NOTICE:  Record:  PDB:760 is updated with: DB03672
NOTICE:  Record:  PubChem Compound:4359 is updated with: DB03677
NOTICE:  Record:  PubChem Compound:44 is updated with: DB03680
NOTICE:  Record:  ChemSpider:5808 is updated with: DB03685
NOTICE:  Record:  PubChem Compound:92133 is updated with: DB03699
NOTICE:  Record:  ChemSpider:3337 is updated with: DB03701
NOTICE:  Record:  BindingDB:5 is updated with: DB03703
NOTICE:  Record:  PubChem Compound:11 is updated with: DB03733
NOTICE:  Record:  PDB:FL2 is updated with: DB03753
NOTICE:  Record:  PubChem Compound:1032 is updated with: DB03766
NOTICE:  Record:  PubChem Compound:64727 is updated with: DB03785
NOTICE:  Record:  PubChem Compound:38 is updated with: DB03795
NOTICE:  Record:  PubChem Compound:985 is updated with: DB03796
NOTICE:  Record:  PubChem Compound:273 is updated with: DB03854
NOTICE:  Record:  PubChem Compound:5438 is updated with: DB03876
NOTICE:  Record:  PubChem Compound:997 is updated with: DB03884
NOTICE:  Record:  PubChem Compound:983 is updated with: DB03896
NOTICE:  Record:  ChemSpider:946 is updated with: DB03902
NOTICE:  Record:  ChemSpider:1291 is updated with: DB03910
NOTICE:  Record:  PubChem Compound:446307 is updated with: DB03927
NOTICE:  Record:  ChemSpider:949 is updated with: DB03940
NOTICE:  Record:  PubChem Compound:1014 is updated with: DB03945
NOTICE:  Record:  PubChem Compound:72 is updated with: DB03946
NOTICE:  Record:  PubChem Compound:5172 is updated with: DB03980
NOTICE:  Record:  BindingDB:11 is updated with: DB03995
NOTICE:  Record:  PubChem Compound:1511 is updated with: DB04010
NOTICE:  Record:  PubChem Compound:49 is updated with: DB04074
NOTICE:  Record:  PubChem Compound:1290 is updated with: DB04123
NOTICE:  Record:  PubChem Compound:6830 is updated with: DB04137
NOTICE:  Record:  PubChem Compound:6578 is updated with: DB04161
NOTICE:  Record:  PubChem Compound:487 is updated with: DB04183
NOTICE:  Record:  PubChem Compound:378 is updated with: DB04214
NOTICE:  Record:  PubChem Compound:135 is updated with: DB04242
NOTICE:  Record:  PubChem Compound:277 is updated with: DB04261
NOTICE:  Record:  PubChem Compound:36 is updated with: DB04279
NOTICE:  Record:  PubChem Compound:8977 is updated with: DB04315
NOTICE:  Record:  PubChem Compound:1001 is updated with: DB04325
NOTICE:  Record:  PubChem Compound:668 is updated with: DB04326
NOTICE:  Record:  PubChem Compound:6675 is updated with: DB04348
NOTICE:  Record:  PubChem Compound:2359 is updated with: DB04360
NOTICE:  Record:  PubChem Compound:612 is updated with: DB04398
NOTICE:  Record:  PubChem Compound:249 is updated with: DB04401
NOTICE:  Record:  PubChem Compound:1629 is updated with: DB04406
NOTICE:  Record:  PubChem Compound:980 is updated with: DB04417
NOTICE:  Record:  PubChem Compound:248 is updated with: DB04455
NOTICE:  Record:  PubChem Compound:545 is updated with: DB04456
NOTICE:  Record:  PubChem Compound:1609 is updated with: DB04459
NOTICE:  Record:  PubChem Compound:321 is updated with: DB04461
NOTICE:  Record:  PubChem Compound:449459 is updated with: DB04468
NOTICE:  Record:  BindingDB:1 is updated with: DB04485
NOTICE:  Record:  ChemSpider:5479 is updated with: DB04513
NOTICE:  Record:  PubChem Compound:1493 is updated with: DB04528
NOTICE:  Record:  PubChem Compound:58 is updated with: DB04553
NOTICE:  Record:  PubChem Compound:1698 is updated with: DB04560
NOTICE:  Record:  PubChem Compound:8582 is updated with: DB04566
NOTICE:  Record:  PubChem Compound:5753 is updated with: DB04652
NOTICE:  Record:  PubChem Compound:1195 is updated with: DB04714
NOTICE:  Record:  PubChem Compound:2406 is updated with: DB04813
NOTICE:  Record:  PubChem Compound:4472 is updated with: DB04820
NOTICE:  Record:  PubChem Compound:4619 is updated with: DB04822
NOTICE:  Record:  ChemSpider:1621 is updated with: DB05105
NOTICE:  Record:  PubChem Compound:1082 is updated with: DB05446
NOTICE:  Record:  PubChem Compound:104842 is updated with: DB05482
NOTICE:  Record:  ChemSpider:3571 is updated with: DB06255
NOTICE:  Record:  PubChem Compound:3058751 is updated with: DB06731
NOTICE:  Record:  ChemSpider:2271 is updated with: DB06732
NOTICE:  Record:  PubChem Compound:247 is updated with: DB06756
NOTICE:  Record:  PubChem Compound:44564 is updated with: DB06794
NOTICE:  Record:  ChemSpider:5135 is updated with: DB06821
NOTICE:  Record:  PubChem Compound:1712 is updated with: DB06844
NOTICE:  Record:  PubChem Compound:4300 is updated with: DB06857
NOTICE:  Record:  BindingDB:152 is updated with: DB06910
NOTICE:  Record:  ChemSpider:1485 is updated with: DB06948
NOTICE:  Record:  PubChem Compound:1701 is updated with: DB07347
NOTICE:  Record:  ChemSpider:2169 is updated with: DB07392
NOTICE:  Record:  PubChem Compound:255 is updated with: DB07418
NOTICE:  Record:  PubChem Compound:979 is updated with: DB07718
NOTICE:  Record:  PubChem Compound:4447 is updated with: DB07816
NOTICE:  Record:  ChemSpider:3339 is updated with: DB07820
NOTICE:  Record:  ChemSpider:1810 is updated with: DB07862
NOTICE:  Record:  PubChem Compound:802 is updated with: DB07950
NOTICE:  Record:  BindingDB:2581 is updated with: DB08036
NOTICE:  Record:  PubChem Compound:780 is updated with: DB08327
NOTICE:  Record:  PDB:CEF is updated with: DB08375
NOTICE:  Record:  PubChem Compound:1028 is updated with: DB08427
NOTICE:  Record:  PubChem Compound:5894 is updated with: DB08473
NOTICE:  Record:  PubChem Compound:4369 is updated with: DB08491
NOTICE:  Record:  PubChem Compound:397 is updated with: DB08652
NOTICE:  Record:  PubChem Compound:4462 is updated with: DB08689
NOTICE:  Record:  PubChem Compound:1498 is updated with: DB08713
NOTICE:  Record:  PubChem Compound:1613 is updated with: DB08772
NOTICE:  Record:  PubChem Compound:98614 is updated with: DB08777
NOTICE:  Record:  PubChem Compound:199 is updated with: DB08838
NOTICE:  Record:  ChemSpider:50 is updated with: DB08845
NOTICE:  Record:  KEGG Drug:D09675 is updated with: DB08876
NOTICE:  Record:  PubChem Compound:3374 is updated with: DB08972
NOTICE:  Record:  PubChem Compound:6469 is updated with: DB08988
NOTICE:  Record:  ChemSpider:3123 is updated with: DB08992
NOTICE:  Record:  PubChem Compound:6475 is updated with: DB09007
NOTICE:  Record:  PubChem Compound:2577 is updated with: DB09010
NOTICE:  Record:  PubChem Compound:2391 is updated with: DB09020
NOTICE:  Record:  PDB:CTC is updated with: DB09093
NOTICE:  Record:  PubChem Compound:598 is updated with: DB09110
NOTICE:  Record:  PubChem Compound:6104 is updated with: DB09121
NOTICE:  Record:  ChemSpider:3612 is updated with: DB09135
NOTICE:  Record:  PubChem Compound:4260 is updated with: DB09205
NOTICE:  Record:  PubChem Compound:28718 is updated with: DB09218
NOTICE:  Record:  PubChem Compound:5736 is updated with: DB09225
NOTICE:  Record:  ChemSpider:4645 is updated with: DB09242
NOTICE:  Record:  PubChem Compound:68802 is updated with: DB09244
NOTICE:  Record:  PubChem Compound:297 is updated with: DB09278
NOTICE:  Record:  PDB:EAL is updated with: DB09477
NOTICE:  Record:  PubChem Compound:1089 is updated with: DB11068
NOTICE:  Record:  PubChem Compound:2723 is updated with: DB11121
NOTICE:  Record:  PubChem Compound:1091 is updated with: DB11127
NOTICE:  Record:  PubChem Compound:2482 is updated with: DB11148
NOTICE:  Record:  PubChem Compound:2202 is updated with: DB11157
NOTICE:  Record:  PDB:XYL is updated with: DB11195
NOTICE:  Record:  PDB:F is updated with: DB11257
NOTICE:  Record:  PubChem Compound:6880 is updated with: DB11323
NOTICE:  Record:  PubChem Compound:460 is updated with: DB11359
NOTICE:  Record:  ChemSpider:4925 is updated with: DB11458
NOTICE:  Record:  PubChem Compound:281 is updated with: DB11588
NOTICE:  Record:  PubChem Compound:10090 is updated with: DB11609
NOTICE:  Record:  PubChem Compound:6674 is updated with: DB11622
NOTICE:  Record:  PubChem Compound:457 is updated with: DB11710
NOTICE:  Record:  PDB:PZQ is updated with: DB11749
NOTICE:  Record:  PubChem Compound:6 is updated with: DB11831
NOTICE:  Record:  PubChem Compound:4261 is updated with: DB11841
NOTICE:  Record:  PubChem Compound:588 is updated with: DB11846
NOTICE:  Record:  PubChem Compound:3885 is updated with: DB11948
NOTICE:  Record:  PubChem Compound:5663 is updated with: DB12082
NOTICE:  Record:  PDB:GD is updated with: DB12091
NOTICE:  Record:  PubChem Compound:4418 is updated with: DB12092
NOTICE:  Record:  PubChem Compound:1355 is updated with: DB12110
NOTICE:  Record:  PubChem Compound:10850 is updated with: DB12176
NOTICE:  Record:  ChemSpider:5199 is updated with: DB12231
NOTICE:  Record:  PubChem Compound:4450 is updated with: DB12293
NOTICE:  Record:  PubChem Compound:4410 is updated with: DB12447
NOTICE:  Record:  PubChem Compound:957 is updated with: DB12452
NOTICE:  Record:  PubChem Compound:2214 is updated with: DB12618
NOTICE:  Record:  PubChem Compound:525 is updated with: DB12751
NOTICE:  Record:  PubChem Compound:16685 is updated with: DB12838
NOTICE:  Record:  ChemSpider:3581 is updated with: DB12881
NOTICE:  Record:  PubChem Compound:359 is updated with: DB12944
NOTICE:  Record:  PubChem Compound:18343 is updated with: DB12947
NOTICE:  Record:  PubChem Compound:5467 is updated with: DB13025
NOTICE:  Record:  PubChem Compound:5524 is updated with: DB13064
NOTICE:  Record:  PubChem Compound:10114 is updated with: DB13089
NOTICE:  Record:  ChemSpider:567 is updated with: DB13191
NOTICE:  Record:  ChemSpider:2204 is updated with: DB13206
NOTICE:  Record:  ChemSpider:1997 is updated with: DB13233
NOTICE:  Record:  ChemSpider:5999 is updated with: DB13304
NOTICE:  Record:  ChemSpider:2236 is updated with: DB13309
NOTICE:  Record:  ChemSpider:307 is updated with: DB13366
NOTICE:  Record:  KEGG Compound:C04623 is updated with: DB13424
NOTICE:  Record:  ChemSpider:3901 is updated with: DB13437
NOTICE:  Record:  ChemSpider:4321 is updated with: DB13441
NOTICE:  Record:  ChemSpider:6506 is updated with: DB13469
NOTICE:  Record:  ChemSpider:2373 is updated with: DB13510
NOTICE:  Record:  ChemSpider:4719 is updated with: DB13514
NOTICE:  Record:  ChemSpider:3919 is updated with: DB13583
NOTICE:  Record:  ChemSpider:3899 is updated with: DB13758
NOTICE:  Record:  ChemSpider:3057 is updated with: DB13785
NOTICE:  Record:  ChemSpider:8271 is updated with: DB13819
NOTICE:  Record:  ChemSpider:3160 is updated with: DB13845
NOTICE:  Record:  PubChem Compound:2194 is updated with: DB13853
NOTICE:  Record:  PubChem Compound:44571 is updated with: DB13876
NOTICE:  Record:  KEGG Compound:C01733 is updated with: DB13972
NOTICE:  Record:  ChemSpider:3812 is updated with: DB14065
NOTICE:  Record:  ChemSpider:22757 is updated with: DB14135
NOTICE:  Record:  ChemSpider:392 is updated with: DB14144
NOTICE:  Record:  PDB:NI is updated with: DB14204
NOTICE:  Record:  PDB:CO is updated with: DB14205
NOTICE:  Record:  ChemSpider:170 is updated with: DB14511
NOTICE:  Record:  PDB:MOF is updated with: DB14512
NOTICE:  Record:  PDB:NA is updated with: DB14516
NOTICE:  Record:  PDB:AL is updated with: DB14519
NOTICE:  Record:  PDB:AG is updated with: DB14521
NOTICE:  Record:  ChemSpider:936 is updated with: DB14522
NOTICE:  Record:  PDB:GA is updated with: DB14524
NOTICE:  Record:  PDB:CR is updated with: DB14525
NOTICE:  Record:  BindingDB:16 is updated with: DB14532
NOTICE:  Record:  ChemSpider:1085 is updated with: DB14546
NOTICE:  Record:  ChemSpider:306 is updated with: DB14547
NOTICE:  Record:  PDB:LA is updated with: DB14579
NOTICE:  Record:  ChemSpider:18400 is updated with: DB14638
NOTICE:  Record:  PDB:SIM is updated with: DB14714
NOTICE:  Record:  ChemSpider:1101 is updated with: DB15429
NOTICE:  Record:  ChemSpider:46 is updated with: DB15831
NOTICE:  Record:  ChemSpider:291 is updated with: DB15994
NOTICE:  Record:  ChemSpider:919 is updated with: DB15995
NOTICE:  <NULL> number of rows updated in drug_mapper table

Successfully run. Total query runtime: 12 min 43 secs.
1 rows affected.

*/