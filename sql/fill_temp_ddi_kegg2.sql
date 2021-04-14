-- FUNCTION: public."fill_temp_ddi_kegg2"()

-- DROP FUNCTION public."fill_temp_ddi_kegg2"();

CREATE OR REPLACE FUNCTION public."fill_temp_ddi_kegg2"(
	)
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
AS $BODY$

	--retrieve records from ddi which has kegg record
	DECLARE
		cursor_kegg1 CURSOR
		FOR
		SELECT DISTINCT(drug1_id)
		FROM public.temp_ddi_kegg;

	DECLARE
		cursor_kegg2 CURSOR
		FOR
		SELECT DISTINCT(drug2_id)
		FROM public.temp_ddi_kegg;

	rec_kegg1 RECORD;
	rec_kegg2 RECORD;
	v_cnt1 INT;
	v_cnt2 INT;
	resource1 TEXT;
	resource2 TEXT;

BEGIN

	OPEN cursor_kegg1;
	LOOP
		FETCH cursor_kegg1 INTO rec_kegg1;
		EXIT WHEN NOT FOUND;

		v_cnt1 := 0;
		resource1 := '';

		SELECT identifier INTO resource1 FROM temp_kegg WHERE drug_id = rec_kegg1.drug1_id;

		UPDATE temp_ddi_kegg SET drug1_kegg = resource1 WHERE drug1_kegg IS NULL AND drug1_id = rec_kegg1.drug1_id;
		GET DIAGNOSTICS v_cnt1 = ROW_COUNT;

		IF v_cnt1 > 0 THEN
			RAISE NOTICE 'Drug1 Kegg id:  % is inserted: %', rec_kegg1.drug1_id, resource1;
		END IF;
	END LOOP;
	CLOSE cursor_kegg1;


	OPEN cursor_kegg2;
	LOOP
		FETCH cursor_kegg2 INTO rec_kegg2;
		EXIT WHEN NOT FOUND;

		v_cnt2 := 0;
		resource2 := '';

		SELECT identifier INTO resource2 FROM temp_kegg WHERE drug_id = rec_kegg2.drug2_id;

		UPDATE temp_ddi_kegg SET drug2_kegg = resource2 WHERE drug2_kegg IS NULL AND drug2_id = rec_kegg2.drug2_id;
		GET DIAGNOSTICS v_cnt2 = ROW_COUNT;

		IF v_cnt2 > 0 THEN
			RAISE NOTICE 'Drug2 RxCUI:  % is inserted: %', rec_kegg2.drug2_id, resource2;
		END IF;
	END LOOP;
	CLOSE cursor_kegg2;

	DROP TABLE IF EXISTS temp_ddi_having_kegg;
	DROP TABLE IF EXISTS temp_kegg;

end;$BODY$;

ALTER FUNCTION public."fill_temp_ddi_kegg2"()
    OWNER TO postgres;



--run function
SELECT public."fill_temp_ddi_kegg2"();

/*
NOTICE:  Drug1 Kegg id:  DB00001 is inserted: D06880
NOTICE:  Drug1 Kegg id:  DB00002 is inserted: D03455
NOTICE:  Drug1 Kegg id:  DB00005 is inserted: D00742
NOTICE:  Drug1 Kegg id:  DB00006 is inserted: D03136
NOTICE:  Drug1 Kegg id:  DB00007 is inserted: D08113
NOTICE:  Drug1 Kegg id:  DB00009 is inserted: D02837
NOTICE:  Drug1 Kegg id:  DB00014 is inserted: D00573
NOTICE:  Drug1 Kegg id:  DB00017 is inserted: D00249
NOTICE:  Drug1 Kegg id:  DB00019 is inserted: D06889
NOTICE:  Drug1 Kegg id:  DB00026 is inserted: D02934
NOTICE:  Drug1 Kegg id:  DB00030 is inserted: D03230
NOTICE:  Drug1 Kegg id:  DB00031 is inserted: D06070
NOTICE:  Drug1 Kegg id:  DB00035 is inserted: D00291
NOTICE:  Drug1 Kegg id:  DB00036 is inserted: D00172
NOTICE:  Drug1 Kegg id:  DB00040 is inserted: D00116
NOTICE:  Drug1 Kegg id:  DB00042 is inserted: D02735
NOTICE:  Drug1 Kegg id:  DB00046 is inserted: D04477
NOTICE:  Drug1 Kegg id:  DB00047 is inserted: D03250
NOTICE:  Drug1 Kegg id:  DB00051 is inserted: D02597
NOTICE:  Drug1 Kegg id:  DB00054 is inserted: D02778
NOTICE:  Drug1 Kegg id:  DB00067 is inserted: D00101
NOTICE:  Drug1 Kegg id:  DB00068 is inserted: D00746
NOTICE:  Drug1 Kegg id:  DB00072 is inserted: D03257
NOTICE:  Drug1 Kegg id:  DB00075 is inserted: D05092
NOTICE:  Drug1 Kegg id:  DB00083 is inserted: D00783
NOTICE:  Drug1 Kegg id:  DB00085 is inserted: D05349
NOTICE:  Drug1 Kegg id:  DB00091 is inserted: D00184
NOTICE:  Drug1 Kegg id:  DB00099 is inserted: D03235
NOTICE:  Drug1 Kegg id:  DB00104 is inserted: D00442
NOTICE:  Drug1 Kegg id:  DB00107 is inserted: D00089
NOTICE:  Drug1 Kegg id:  DB00111 is inserted: D03639
NOTICE:  Drug1 Kegg id:  DB00115 is inserted: D00166
NOTICE:  Drug1 Kegg id:  DB00120 is inserted: D00021
NOTICE:  Drug1 Kegg id:  DB00122 is inserted: D07690
NOTICE:  Drug1 Kegg id:  DB00126 is inserted: D00018
NOTICE:  Drug1 Kegg id:  DB00130 is inserted: D00015
NOTICE:  Drug1 Kegg id:  DB00134 is inserted: D00019
NOTICE:  Drug1 Kegg id:  DB00136 is inserted: D00129
NOTICE:  Drug1 Kegg id:  DB00140 is inserted: D00050
NOTICE:  Drug1 Kegg id:  DB00142 is inserted: D00007
NOTICE:  Drug1 Kegg id:  DB00145 is inserted: D00011
NOTICE:  Drug1 Kegg id:  DB00150 is inserted: D00020
NOTICE:  Drug1 Kegg id:  DB00152 is inserted: D08580
NOTICE:  Drug1 Kegg id:  DB00153 is inserted: D00187
NOTICE:  Drug1 Kegg id:  DB00155 is inserted: D07706
NOTICE:  Drug1 Kegg id:  DB00158 is inserted: D00070
NOTICE:  Drug1 Kegg id:  DB00159 is inserted: D08061
NOTICE:  Drug1 Kegg id:  DB00162 is inserted: D00069
NOTICE:  Drug1 Kegg id:  DB00166 is inserted: D00086
NOTICE:  Drug1 Kegg id:  DB00168 is inserted: D02381
NOTICE:  Drug1 Kegg id:  DB00169 is inserted: D00188
NOTICE:  Drug1 Kegg id:  DB00170 is inserted: D02335
NOTICE:  Drug1 Kegg id:  DB00173 is inserted: D00034
NOTICE:  Drug1 Kegg id:  DB00175 is inserted: D08410
NOTICE:  Drug1 Kegg id:  DB00177 is inserted: D00400
NOTICE:  Drug1 Kegg id:  DB00178 is inserted: D00421
NOTICE:  Drug1 Kegg id:  DB00179 is inserted: D04862
NOTICE:  Drug1 Kegg id:  DB00181 is inserted: D00241
NOTICE:  Drug1 Kegg id:  DB00182 is inserted: D07445
NOTICE:  Drug1 Kegg id:  DB00184 is inserted: D03365
NOTICE:  Drug1 Kegg id:  DB00185 is inserted: D00661
NOTICE:  Drug1 Kegg id:  DB00186 is inserted: D00365
NOTICE:  Drug1 Kegg id:  DB00187 is inserted: D07916
NOTICE:  Drug1 Kegg id:  DB00188 is inserted: D03150
NOTICE:  Drug1 Kegg id:  DB00189 is inserted: D00704
NOTICE:  Drug1 Kegg id:  DB00190 is inserted: D00558
NOTICE:  Drug1 Kegg id:  DB00191 is inserted: D05458
NOTICE:  Drug1 Kegg id:  DB00193 is inserted: D08623
NOTICE:  Drug1 Kegg id:  DB00197 is inserted: D00395
NOTICE:  Drug1 Kegg id:  DB00200 is inserted: D01027
NOTICE:  Drug1 Kegg id:  DB00201 is inserted: D00528
NOTICE:  Drug1 Kegg id:  DB00203 is inserted: D08514
NOTICE:  Drug1 Kegg id:  DB00204 is inserted: D00647
NOTICE:  Drug1 Kegg id:  DB00206 is inserted: D00197
NOTICE:  Drug1 Kegg id:  DB00208 is inserted: D08594
NOTICE:  Drug1 Kegg id:  DB00209 is inserted: D01103
NOTICE:  Drug1 Kegg id:  DB00210 is inserted: D01112
NOTICE:  Drug1 Kegg id:  DB00211 is inserted: D08220
NOTICE:  Drug1 Kegg id:  DB00213 is inserted: D05353
NOTICE:  Drug1 Kegg id:  DB00214 is inserted: D00382
NOTICE:  Drug1 Kegg id:  DB00215 is inserted: D07704
NOTICE:  Drug1 Kegg id:  DB00216 is inserted: D07887
NOTICE:  Drug1 Kegg id:  DB00217 is inserted: D01603
NOTICE:  Drug1 Kegg id:  DB00221 is inserted: D04625
NOTICE:  Drug1 Kegg id:  DB00222 is inserted: D00593
NOTICE:  Drug1 Kegg id:  DB00223 is inserted: D07827
NOTICE:  Drug1 Kegg id:  DB00226 is inserted: D08029
NOTICE:  Drug1 Kegg id:  DB00227 is inserted: D00359
NOTICE:  Drug1 Kegg id:  DB00228 is inserted: D00543
NOTICE:  Drug1 Kegg id:  DB00230 is inserted: D02716
NOTICE:  Drug1 Kegg id:  DB00231 is inserted: D00370
NOTICE:  Drug1 Kegg id:  DB00232 is inserted: D00656
NOTICE:  Drug1 Kegg id:  DB00235 is inserted: D00417
NOTICE:  Drug1 Kegg id:  DB00236 is inserted: D00467
NOTICE:  Drug1 Kegg id:  DB00237 is inserted: D03180
NOTICE:  Drug1 Kegg id:  DB00240 is inserted: D07116
NOTICE:  Drug1 Kegg id:  DB00241 is inserted: D03182
NOTICE:  Drug1 Kegg id:  DB00242 is inserted: D01370
NOTICE:  Drug1 Kegg id:  DB00244 is inserted: D00377
NOTICE:  Drug1 Kegg id:  DB00245 is inserted: D07511
NOTICE:  Drug1 Kegg id:  DB00246 is inserted: D08687
NOTICE:  Drug1 Kegg id:  DB00247 is inserted: D02357
NOTICE:  Drug1 Kegg id:  DB00248 is inserted: D00987
NOTICE:  Drug1 Kegg id:  DB00252 is inserted: D00512
NOTICE:  Drug1 Kegg id:  DB00253 is inserted: D02289
NOTICE:  Drug1 Kegg id:  DB00254 is inserted: D07876
NOTICE:  Drug1 Kegg id:  DB00255 is inserted: D00577
NOTICE:  Drug1 Kegg id:  DB00258 is inserted: D00931
NOTICE:  Drug1 Kegg id:  DB00261 is inserted: D07455
NOTICE:  Drug1 Kegg id:  DB00262 is inserted: D00254
NOTICE:  Drug1 Kegg id:  DB00264 is inserted: D02358
NOTICE:  Drug1 Kegg id:  DB00266 is inserted: D03798
NOTICE:  Drug1 Kegg id:  DB00268 is inserted: D08489
NOTICE:  Drug1 Kegg id:  DB00269 is inserted: D00269
NOTICE:  Drug1 Kegg id:  DB00270 is inserted: D00349
NOTICE:  Drug1 Kegg id:  DB00271 is inserted: D01013
NOTICE:  Drug1 Kegg id:  DB00273 is inserted: D00537
NOTICE:  Drug1 Kegg id:  DB00275 is inserted: D01204
NOTICE:  Drug1 Kegg id:  DB00276 is inserted: D02321
NOTICE:  Drug1 Kegg id:  DB00277 is inserted: D00371
NOTICE:  Drug1 Kegg id:  DB00280 is inserted: D00303
NOTICE:  Drug1 Kegg id:  DB00281 is inserted: D00358
NOTICE:  Drug1 Kegg id:  DB00282 is inserted: D07281
NOTICE:  Drug1 Kegg id:  DB00283 is inserted: D03535
NOTICE:  Drug1 Kegg id:  DB00284 is inserted: D00216
NOTICE:  Drug1 Kegg id:  DB00285 is inserted: D08670
NOTICE:  Drug1 Kegg id:  DB00286 is inserted: D04070
NOTICE:  Drug1 Kegg id:  DB00287 is inserted: D01964
NOTICE:  Drug1 Kegg id:  DB00288 is inserted: D01387
NOTICE:  Drug1 Kegg id:  DB00289 is inserted: D07473
NOTICE:  Drug1 Kegg id:  DB00291 is inserted: D00266
NOTICE:  Drug1 Kegg id:  DB00292 is inserted: D00548
NOTICE:  Drug1 Kegg id:  DB00293 is inserted: D01064
NOTICE:  Drug1 Kegg id:  DB00295 is inserted: D08233
NOTICE:  Drug1 Kegg id:  DB00298 is inserted: D07775
NOTICE:  Drug1 Kegg id:  DB00302 is inserted: D01136
NOTICE:  Drug1 Kegg id:  DB00304 is inserted: D02367
NOTICE:  Drug1 Kegg id:  DB00305 is inserted: D00208
NOTICE:  Drug1 Kegg id:  DB00306 is inserted: D06887
NOTICE:  Drug1 Kegg id:  DB00307 is inserted: D03106
NOTICE:  Drug1 Kegg id:  DB00308 is inserted: D00648
NOTICE:  Drug1 Kegg id:  DB00309 is inserted: D01769
NOTICE:  Drug1 Kegg id:  DB00310 is inserted: D00272
NOTICE:  Drug1 Kegg id:  DB00311 is inserted: D02441
NOTICE:  Drug1 Kegg id:  DB00312 is inserted: D00499
NOTICE:  Drug1 Kegg id:  DB00313 is inserted: D00399
NOTICE:  Drug1 Kegg id:  DB00315 is inserted: D00415
NOTICE:  Drug1 Kegg id:  DB00316 is inserted: D00217
NOTICE:  Drug1 Kegg id:  DB00317 is inserted: D01977
NOTICE:  Drug1 Kegg id:  DB00318 is inserted: D03580
NOTICE:  Drug1 Kegg id:  DB00321 is inserted: D07448
NOTICE:  Drug1 Kegg id:  DB00322 is inserted: D04197
NOTICE:  Drug1 Kegg id:  DB00323 is inserted: D00786
NOTICE:  Drug1 Kegg id:  DB00324 is inserted: D01367
NOTICE:  Drug1 Kegg id:  DB00326 is inserted: D00934
NOTICE:  Drug1 Kegg id:  DB00328 is inserted: D00141
NOTICE:  Drug1 Kegg id:  DB00331 is inserted: D04966
NOTICE:  Drug1 Kegg id:  DB00333 is inserted: D08195
NOTICE:  Drug1 Kegg id:  DB00334 is inserted: D00454
NOTICE:  Drug1 Kegg id:  DB00335 is inserted: D00235
NOTICE:  Drug1 Kegg id:  DB00338 is inserted: D00455
NOTICE:  Drug1 Kegg id:  DB00340 is inserted: D01871
NOTICE:  Drug1 Kegg id:  DB00342 is inserted: D00521
NOTICE:  Drug1 Kegg id:  DB00343 is inserted: D07845
NOTICE:  Drug1 Kegg id:  DB00344 is inserted: D08447
NOTICE:  Drug1 Kegg id:  DB00345 is inserted: D06890
NOTICE:  Drug1 Kegg id:  DB00346 is inserted: D07124
NOTICE:  Drug1 Kegg id:  DB00347 is inserted: D00392
NOTICE:  Drug1 Kegg id:  DB00349 is inserted: D01253
NOTICE:  Drug1 Kegg id:  DB00350 is inserted: D00418
NOTICE:  Drug1 Kegg id:  DB00351 is inserted: D00952
NOTICE:  Drug1 Kegg id:  DB00352 is inserted: D08603
NOTICE:  Drug1 Kegg id:  DB00353 is inserted: D00680
NOTICE:  Drug1 Kegg id:  DB00354 is inserted: D07547
NOTICE:  Drug1 Kegg id:  DB00356 is inserted: D00771
NOTICE:  Drug1 Kegg id:  DB00357 is inserted: D00574
NOTICE:  Drug1 Kegg id:  DB00360 is inserted: D08505
NOTICE:  Drug1 Kegg id:  DB00361 is inserted: D08680
NOTICE:  Drug1 Kegg id:  DB00363 is inserted: D00283
NOTICE:  Drug1 Kegg id:  DB00366 is inserted: D02327
NOTICE:  Drug1 Kegg id:  DB00367 is inserted: D00950
NOTICE:  Drug1 Kegg id:  DB00368 is inserted: D00076
NOTICE:  Drug1 Kegg id:  DB00370 is inserted: D00563
NOTICE:  Drug1 Kegg id:  DB00371 is inserted: D00376
NOTICE:  Drug1 Kegg id:  DB00372 is inserted: D02354
NOTICE:  Drug1 Kegg id:  DB00376 is inserted: D08638
NOTICE:  Drug1 Kegg id:  DB00377 is inserted: D07175
NOTICE:  Drug1 Kegg id:  DB00378 is inserted: D01217
NOTICE:  Drug1 Kegg id:  DB00380 is inserted: D03730
NOTICE:  Drug1 Kegg id:  DB00381 is inserted: D07450
NOTICE:  Drug1 Kegg id:  DB00382 is inserted: D08555
NOTICE:  Drug1 Kegg id:  DB00383 is inserted: D08325
NOTICE:  Drug1 Kegg id:  DB00384 is inserted: D00386
NOTICE:  Drug1 Kegg id:  DB00387 is inserted: D08425
NOTICE:  Drug1 Kegg id:  DB00388 is inserted: D08365
NOTICE:  Drug1 Kegg id:  DB00389 is inserted: D07616
NOTICE:  Drug1 Kegg id:  DB00390 is inserted: D00298
NOTICE:  Drug1 Kegg id:  DB00391 is inserted: D01226
NOTICE:  Drug1 Kegg id:  DB00392 is inserted: D01118
NOTICE:  Drug1 Kegg id:  DB00393 is inserted: D00438
NOTICE:  Drug1 Kegg id:  DB00394 is inserted: D07495
NOTICE:  Drug1 Kegg id:  DB00395 is inserted: D00768
NOTICE:  Drug1 Kegg id:  DB00396 is inserted: D00066
NOTICE:  Drug1 Kegg id:  DB00398 is inserted: D08524
NOTICE:  Drug1 Kegg id:  DB00399 is inserted: D01968
NOTICE:  Drug1 Kegg id:  DB00401 is inserted: D00618
NOTICE:  Drug1 Kegg id:  DB00404 is inserted: D00225
NOTICE:  Drug1 Kegg id:  DB00407 is inserted: D02980
NOTICE:  Drug1 Kegg id:  DB00408 is inserted: D02340
NOTICE:  Drug1 Kegg id:  DB00411 is inserted: D00524
NOTICE:  Drug1 Kegg id:  DB00412 is inserted: D00596
NOTICE:  Drug1 Kegg id:  DB00413 is inserted: D00559
NOTICE:  Drug1 Kegg id:  DB00414 is inserted: D00219
NOTICE:  Drug1 Kegg id:  DB00416 is inserted: D00761
NOTICE:  Drug1 Kegg id:  DB00418 is inserted: D00430
NOTICE:  Drug1 Kegg id:  DB00420 is inserted: D08430
NOTICE:  Drug1 Kegg id:  DB00421 is inserted: D00443
NOTICE:  Drug1 Kegg id:  DB00422 is inserted: D04999
NOTICE:  Drug1 Kegg id:  DB00423 is inserted: D00402
NOTICE:  Drug1 Kegg id:  DB00424 is inserted: D00147
NOTICE:  Drug1 Kegg id:  DB00427 is inserted: D01782
NOTICE:  Drug1 Kegg id:  DB00428 is inserted: D05932
NOTICE:  Drug1 Kegg id:  DB00429 is inserted: D00682
NOTICE:  Drug1 Kegg id:  DB00433 is inserted: D00493
NOTICE:  Drug1 Kegg id:  DB00435 is inserted: D00074
NOTICE:  Drug1 Kegg id:  DB00436 is inserted: D00650
NOTICE:  Drug1 Kegg id:  DB00437 is inserted: D00224
NOTICE:  Drug1 Kegg id:  DB00441 is inserted: D02368
NOTICE:  Drug1 Kegg id:  DB00443 is inserted: D00244
NOTICE:  Drug1 Kegg id:  DB00444 is inserted: D02698
NOTICE:  Drug1 Kegg id:  DB00448 is inserted: D00355
NOTICE:  Drug1 Kegg id:  DB00449 is inserted: D02349
NOTICE:  Drug1 Kegg id:  DB00450 is inserted: D00308
NOTICE:  Drug1 Kegg id:  DB00451 is inserted: D08125
NOTICE:  Drug1 Kegg id:  DB00454 is inserted: D08343
NOTICE:  Drug1 Kegg id:  DB00455 is inserted: D00364
NOTICE:  Drug1 Kegg id:  DB00457 is inserted: D08411
NOTICE:  Drug1 Kegg id:  DB00458 is inserted: D08070
NOTICE:  Drug1 Kegg id:  DB00459 is inserted: D02754
NOTICE:  Drug1 Kegg id:  DB00460 is inserted: D01162
NOTICE:  Drug1 Kegg id:  DB00461 is inserted: D00425
NOTICE:  Drug1 Kegg id:  DB00462 is inserted: D00715
NOTICE:  Drug1 Kegg id:  DB00463 is inserted: D01382
NOTICE:  Drug1 Kegg id:  DB00469 is inserted: D01767
NOTICE:  Drug1 Kegg id:  DB00470 is inserted: D00306
NOTICE:  Drug1 Kegg id:  DB00471 is inserted: D08229
NOTICE:  Drug1 Kegg id:  DB00472 is inserted: D00823
NOTICE:  Drug1 Kegg id:  DB00474 is inserted: D04985
NOTICE:  Drug1 Kegg id:  DB00475 is inserted: D00267
NOTICE:  Drug1 Kegg id:  DB00477 is inserted: D00270
NOTICE:  Drug1 Kegg id:  DB00480 is inserted: D04687
NOTICE:  Drug1 Kegg id:  DB00482 is inserted: D00567
NOTICE:  Drug1 Kegg id:  DB00484 is inserted: D07540
NOTICE:  Drug1 Kegg id:  DB00486 is inserted: D05099
NOTICE:  Drug1 Kegg id:  DB00490 is inserted: D07593
NOTICE:  Drug1 Kegg id:  DB00491 is inserted: D00625
NOTICE:  Drug1 Kegg id:  DB00492 is inserted: D07992
NOTICE:  Drug1 Kegg id:  DB00494 is inserted: D00781
NOTICE:  Drug1 Kegg id:  DB00496 is inserted: D01699
NOTICE:  Drug1 Kegg id:  DB00497 is inserted: D05312
NOTICE:  Drug1 Kegg id:  DB00498 is inserted: D08354
NOTICE:  Drug1 Kegg id:  DB00499 is inserted: D00586
NOTICE:  Drug1 Kegg id:  DB00501 is inserted: D00295
NOTICE:  Drug1 Kegg id:  DB00502 is inserted: D00136
NOTICE:  Drug1 Kegg id:  DB00508 is inserted: D00390
NOTICE:  Drug1 Kegg id:  DB00511 is inserted: D06881
NOTICE:  Drug1 Kegg id:  DB00513 is inserted: D00160
NOTICE:  Drug1 Kegg id:  DB00514 is inserted: D03742
NOTICE:  Drug1 Kegg id:  DB00515 is inserted: D00275
NOTICE:  Drug1 Kegg id:  DB00517 is inserted: D00232
NOTICE:  Drug1 Kegg id:  DB00519 is inserted: D00383
NOTICE:  Drug1 Kegg id:  DB00521 is inserted: D07624
NOTICE:  Drug1 Kegg id:  DB00523 is inserted: D02815
NOTICE:  Drug1 Kegg id:  DB00524 is inserted: D00431
NOTICE:  Drug1 Kegg id:  DB00526 is inserted: D01790
NOTICE:  Drug1 Kegg id:  DB00527 is inserted: D00733
NOTICE:  Drug1 Kegg id:  DB00530 is inserted: D07907
NOTICE:  Drug1 Kegg id:  DB00531 is inserted: D07760
NOTICE:  Drug1 Kegg id:  DB00532 is inserted: D00375
NOTICE:  Drug1 Kegg id:  DB00533 is inserted: D00568
NOTICE:  Drug1 Kegg id:  DB00535 is inserted: D00917
NOTICE:  Drug1 Kegg id:  DB00540 is inserted: D08288
NOTICE:  Drug1 Kegg id:  DB00541 is inserted: D08679
NOTICE:  Drug1 Kegg id:  DB00542 is inserted: D07499
NOTICE:  Drug1 Kegg id:  DB00543 is inserted: D00228
NOTICE:  Drug1 Kegg id:  DB00544 is inserted: D00584
NOTICE:  Drug1 Kegg id:  DB00545 is inserted: D00487
NOTICE:  Drug1 Kegg id:  DB00546 is inserted: D02770
NOTICE:  Drug1 Kegg id:  DB00549 is inserted: D00411
NOTICE:  Drug1 Kegg id:  DB00550 is inserted: D00562
NOTICE:  Drug1 Kegg id:  DB00553 is inserted: D00139
NOTICE:  Drug1 Kegg id:  DB00554 is inserted: D00127
NOTICE:  Drug1 Kegg id:  DB00555 is inserted: D00354
NOTICE:  Drug1 Kegg id:  DB00556 is inserted: D01738
NOTICE:  Drug1 Kegg id:  DB00557 is inserted: D08054
NOTICE:  Drug1 Kegg id:  DB00559 is inserted: D01227
NOTICE:  Drug1 Kegg id:  DB00561 is inserted: D07873
NOTICE:  Drug1 Kegg id:  DB00562 is inserted: D00651
NOTICE:  Drug1 Kegg id:  DB00563 is inserted: D00142
NOTICE:  Drug1 Kegg id:  DB00564 is inserted: D00252
NOTICE:  Drug1 Kegg id:  DB00566 is inserted: D00572
NOTICE:  Drug1 Kegg id:  DB00568 is inserted: D01295
NOTICE:  Drug1 Kegg id:  DB00571 is inserted: D08443
NOTICE:  Drug1 Kegg id:  DB00572 is inserted: D00113
NOTICE:  Drug1 Kegg id:  DB00573 is inserted: D00968
NOTICE:  Drug1 Kegg id:  DB00574 is inserted: D07945
NOTICE:  Drug1 Kegg id:  DB00575 is inserted: D00281
NOTICE:  Drug1 Kegg id:  DB00579 is inserted: D00367
NOTICE:  Drug1 Kegg id:  DB00581 is inserted: D00352
NOTICE:  Drug1 Kegg id:  DB00583 is inserted: D02176
NOTICE:  Drug1 Kegg id:  DB00584 is inserted: D07892
NOTICE:  Drug1 Kegg id:  DB00585 is inserted: D00440
NOTICE:  Drug1 Kegg id:  DB00586 is inserted: D07816
NOTICE:  Drug1 Kegg id:  DB00588 is inserted: D01708
NOTICE:  Drug1 Kegg id:  DB00589 is inserted: D08132
NOTICE:  Drug1 Kegg id:  DB00590 is inserted: D07874
NOTICE:  Drug1 Kegg id:  DB00591 is inserted: D01825
NOTICE:  Drug1 Kegg id:  DB00593 is inserted: D00539
NOTICE:  Drug1 Kegg id:  DB00594 is inserted: D07447
NOTICE:  Drug1 Kegg id:  DB00597 is inserted: D01137
NOTICE:  Drug1 Kegg id:  DB00598 is inserted: D08106
NOTICE:  Drug1 Kegg id:  DB00603 is inserted: D00951
NOTICE:  Drug1 Kegg id:  DB00604 is inserted: D00274
NOTICE:  Drug1 Kegg id:  DB00605 is inserted: D00120
NOTICE:  Drug1 Kegg id:  DB00606 is inserted: D01256
NOTICE:  Drug1 Kegg id:  DB00611 is inserted: D00837
NOTICE:  Drug1 Kegg id:  DB00612 is inserted: D02342
NOTICE:  Drug1 Kegg id:  DB00616 is inserted: D01070
NOTICE:  Drug1 Kegg id:  DB00617 is inserted: D00495
NOTICE:  Drug1 Kegg id:  DB00619 is inserted: D01441
NOTICE:  Drug1 Kegg id:  DB00620 is inserted: D00385
NOTICE:  Drug1 Kegg id:  DB00621 is inserted: D00462
NOTICE:  Drug1 Kegg id:  DB00623 is inserted: D07977
NOTICE:  Drug1 Kegg id:  DB00624 is inserted: D00075
NOTICE:  Drug1 Kegg id:  DB00627 is inserted: D00049
NOTICE:  Drug1 Kegg id:  DB00628 is inserted: D00694
NOTICE:  Drug1 Kegg id:  DB00629 is inserted: D04375
NOTICE:  Drug1 Kegg id:  DB00633 is inserted: D00514
NOTICE:  Drug1 Kegg id:  DB00635 is inserted: D00473
NOTICE:  Drug1 Kegg id:  DB00636 is inserted: D00279
NOTICE:  Drug1 Kegg id:  DB00637 is inserted: D00234
NOTICE:  Drug1 Kegg id:  DB00640 is inserted: D00045
NOTICE:  Drug1 Kegg id:  DB00641 is inserted: D00434
NOTICE:  Drug1 Kegg id:  DB00642 is inserted: D07472
NOTICE:  Drug1 Kegg id:  DB00647 is inserted: D07809
NOTICE:  Drug1 Kegg id:  DB00648 is inserted: D00420
NOTICE:  Drug1 Kegg id:  DB00650 is inserted: D07986
NOTICE:  Drug1 Kegg id:  DB00651 is inserted: D00691
NOTICE:  Drug1 Kegg id:  DB00652 is inserted: D00498
NOTICE:  Drug1 Kegg id:  DB00653 is inserted: D01108
NOTICE:  Drug1 Kegg id:  DB00654 is inserted: D00356
NOTICE:  Drug1 Kegg id:  DB00655 is inserted: D00067
NOTICE:  Drug1 Kegg id:  DB00656 is inserted: D08626
NOTICE:  Drug1 Kegg id:  DB00658 is inserted: D01983
NOTICE:  Drug1 Kegg id:  DB00660 is inserted: D00773
NOTICE:  Drug1 Kegg id:  DB00661 is inserted: D02356
NOTICE:  Drug1 Kegg id:  DB00662 is inserted: D08643
NOTICE:  Drug1 Kegg id:  DB00663 is inserted: D04208
NOTICE:  Drug1 Kegg id:  DB00665 is inserted: D00965
NOTICE:  Drug1 Kegg id:  DB00668 is inserted: D00095
NOTICE:  Drug1 Kegg id:  DB00669 is inserted: D00451
NOTICE:  Drug1 Kegg id:  DB00670 is inserted: D08389
NOTICE:  Drug1 Kegg id:  DB00672 is inserted: D00271
NOTICE:  Drug1 Kegg id:  DB00673 is inserted: D02968
NOTICE:  Drug1 Kegg id:  DB00674 is inserted: D04292
NOTICE:  Drug1 Kegg id:  DB00675 is inserted: D08559
NOTICE:  Drug1 Kegg id:  DB00677 is inserted: D00043
NOTICE:  Drug1 Kegg id:  DB00678 is inserted: D08146
NOTICE:  Drug1 Kegg id:  DB00679 is inserted: D00373
NOTICE:  Drug1 Kegg id:  DB00680 is inserted: D05077
NOTICE:  Drug1 Kegg id:  DB00683 is inserted: D00550
NOTICE:  Drug1 Kegg id:  DB00687 is inserted: D07967
NOTICE:  Drug1 Kegg id:  DB00688 is inserted: D00752
NOTICE:  Drug1 Kegg id:  DB00690 is inserted: D00329
NOTICE:  Drug1 Kegg id:  DB00693 is inserted: D01261
NOTICE:  Drug1 Kegg id:  DB00694 is inserted: D07776
NOTICE:  Drug1 Kegg id:  DB00695 is inserted: D00331
NOTICE:  Drug1 Kegg id:  DB00696 is inserted: D07906
NOTICE:  Drug1 Kegg id:  DB00699 is inserted: D01290
NOTICE:  Drug1 Kegg id:  DB00700 is inserted: D01115
NOTICE:  Drug1 Kegg id:  DB00703 is inserted: D00655
NOTICE:  Drug1 Kegg id:  DB00704 is inserted: D05113
NOTICE:  Drug1 Kegg id:  DB00708 is inserted: D05938
NOTICE:  Drug1 Kegg id:  DB00712 is inserted: D00330
NOTICE:  Drug1 Kegg id:  DB00714 is inserted: D07460
NOTICE:  Drug1 Kegg id:  DB00715 is inserted: D02362
NOTICE:  Drug1 Kegg id:  DB00716 is inserted: D05129
NOTICE:  Drug1 Kegg id:  DB00717 is inserted: D00182
NOTICE:  Drug1 Kegg id:  DB00721 is inserted: D08422
NOTICE:  Drug1 Kegg id:  DB00722 is inserted: D00362
NOTICE:  Drug1 Kegg id:  DB00723 is inserted: D08201
NOTICE:  Drug1 Kegg id:  DB00724 is inserted: D02500
NOTICE:  Drug1 Kegg id:  DB00725 is inserted: D02070
NOTICE:  Drug1 Kegg id:  DB00726 is inserted: D00394
NOTICE:  Drug1 Kegg id:  DB00727 is inserted: D00515
NOTICE:  Drug1 Kegg id:  DB00728 is inserted: D00765
NOTICE:  Drug1 Kegg id:  DB00731 is inserted: D01111
NOTICE:  Drug1 Kegg id:  DB00732 is inserted: D00758
NOTICE:  Drug1 Kegg id:  DB00734 is inserted: D00426
NOTICE:  Drug1 Kegg id:  DB00736 is inserted: D07917
NOTICE:  Drug1 Kegg id:  DB00737 is inserted: D08163
NOTICE:  Drug1 Kegg id:  DB00740 is inserted: D00775
NOTICE:  Drug1 Kegg id:  DB00741 is inserted: D00088
NOTICE:  Drug1 Kegg id:  DB00742 is inserted: D00062
NOTICE:  Drug1 Kegg id:  DB00743 is inserted: D08018
NOTICE:  Drug1 Kegg id:  DB00744 is inserted: D00414
NOTICE:  Drug1 Kegg id:  DB00745 is inserted: D01832
NOTICE:  Drug1 Kegg id:  DB00746 is inserted: D03670
NOTICE:  Drug1 Kegg id:  DB00747 is inserted: D00138
NOTICE:  Drug1 Kegg id:  DB00749 is inserted: D00315
NOTICE:  Drug1 Kegg id:  DB00750 is inserted: D00553
NOTICE:  Drug1 Kegg id:  DB00751 is inserted: D01713
NOTICE:  Drug1 Kegg id:  DB00752 is inserted: D08625
NOTICE:  Drug1 Kegg id:  DB00753 is inserted: D00545
NOTICE:  Drug1 Kegg id:  DB00754 is inserted: D00708
NOTICE:  Drug1 Kegg id:  DB00755 is inserted: D00094
NOTICE:  Drug1 Kegg id:  DB00758 is inserted: D00769
NOTICE:  Drug1 Kegg id:  DB00761 is inserted: D02060
NOTICE:  Drug1 Kegg id:  DB00762 is inserted: D08086
NOTICE:  Drug1 Kegg id:  DB00763 is inserted: D00401
NOTICE:  Drug1 Kegg id:  DB00764 is inserted: D08227
NOTICE:  Drug1 Kegg id:  DB00765 is inserted: D00762
NOTICE:  Drug1 Kegg id:  DB00767 is inserted: D00243
NOTICE:  Drug1 Kegg id:  DB00770 is inserted: D00180
NOTICE:  Drug1 Kegg id:  DB00773 is inserted: D00125
NOTICE:  Drug1 Kegg id:  DB00774 is inserted: D00654
NOTICE:  Drug1 Kegg id:  DB00776 is inserted: D00533
NOTICE:  Drug1 Kegg id:  DB00777 is inserted: D02361
NOTICE:  Drug1 Kegg id:  DB00780 is inserted: D08349
NOTICE:  Drug1 Kegg id:  DB00783 is inserted: D00105
NOTICE:  Drug1 Kegg id:  DB00784 is inserted: D00151
NOTICE:  Drug1 Kegg id:  DB00788 is inserted: D00118
NOTICE:  Drug1 Kegg id:  DB00790 is inserted: D03753
NOTICE:  Drug1 Kegg id:  DB00791 is inserted: D06265
NOTICE:  Drug1 Kegg id:  DB00794 is inserted: D00474
NOTICE:  Drug1 Kegg id:  DB00795 is inserted: D00448
NOTICE:  Drug1 Kegg id:  DB00796 is inserted: D00626
NOTICE:  Drug1 Kegg id:  DB00799 is inserted: D01132
NOTICE:  Drug1 Kegg id:  DB00800 is inserted: D00613
NOTICE:  Drug1 Kegg id:  DB00801 is inserted: D00338
NOTICE:  Drug1 Kegg id:  DB00802 is inserted: D07122
NOTICE:  Drug1 Kegg id:  DB00805 is inserted: D05039
NOTICE:  Drug1 Kegg id:  DB00806 is inserted: D00501
NOTICE:  Drug1 Kegg id:  DB00807 is inserted: D08448
NOTICE:  Drug1 Kegg id:  DB00808 is inserted: D00345
NOTICE:  Drug1 Kegg id:  DB00809 is inserted: D00397
NOTICE:  Drug1 Kegg id:  DB00810 is inserted: D00779
NOTICE:  Drug1 Kegg id:  DB00812 is inserted: D00510
NOTICE:  Drug1 Kegg id:  DB00813 is inserted: D00320
NOTICE:  Drug1 Kegg id:  DB00814 is inserted: D00969
NOTICE:  Drug1 Kegg id:  DB00816 is inserted: D00685
NOTICE:  Drug1 Kegg id:  DB00818 is inserted: D00549
NOTICE:  Drug1 Kegg id:  DB00819 is inserted: D00218
NOTICE:  Drug1 Kegg id:  DB00820 is inserted: D02008
NOTICE:  Drug1 Kegg id:  DB00822 is inserted: D00131
NOTICE:  Drug1 Kegg id:  DB00823 is inserted: D01294
NOTICE:  Drug1 Kegg id:  DB00825 is inserted: D00064
NOTICE:  Drug1 Kegg id:  DB00829 is inserted: D00293
NOTICE:  Drug1 Kegg id:  DB00831 is inserted: D08636
NOTICE:  Drug1 Kegg id:  DB00832 is inserted: D00508
NOTICE:  Drug1 Kegg id:  DB00834 is inserted: D00585
NOTICE:  Drug1 Kegg id:  DB00835 is inserted: D07543
NOTICE:  Drug1 Kegg id:  DB00836 is inserted: D08144
NOTICE:  Drug1 Kegg id:  DB00837 is inserted: D05621
NOTICE:  Drug1 Kegg id:  DB00838 is inserted: D07719
NOTICE:  Drug1 Kegg id:  DB00839 is inserted: D00379
NOTICE:  Drug1 Kegg id:  DB00841 is inserted: D03879
NOTICE:  Drug1 Kegg id:  DB00842 is inserted: D00464
NOTICE:  Drug1 Kegg id:  DB00843 is inserted: D00670
NOTICE:  Drug1 Kegg id:  DB00844 is inserted: D08246
NOTICE:  Drug1 Kegg id:  DB00846 is inserted: D00328
NOTICE:  Drug1 Kegg id:  DB00847 is inserted: D03634
NOTICE:  Drug1 Kegg id:  DB00849 is inserted: D00700
NOTICE:  Drug1 Kegg id:  DB00850 is inserted: D00503
NOTICE:  Drug1 Kegg id:  DB00851 is inserted: D00288
NOTICE:  Drug1 Kegg id:  DB00852 is inserted: D08449
NOTICE:  Drug1 Kegg id:  DB00853 is inserted: D06067
NOTICE:  Drug1 Kegg id:  DB00854 is inserted: D08123
NOTICE:  Drug1 Kegg id:  DB00859 is inserted: D00496
NOTICE:  Drug1 Kegg id:  DB00860 is inserted: D00472
NOTICE:  Drug1 Kegg id:  DB00861 is inserted: D00130
NOTICE:  Drug1 Kegg id:  DB00862 is inserted: D08668
NOTICE:  Drug1 Kegg id:  DB00863 is inserted: D00422
NOTICE:  Drug1 Kegg id:  DB00864 is inserted: D00107
NOTICE:  Drug1 Kegg id:  DB00866 is inserted: D07156
NOTICE:  Drug1 Kegg id:  DB00867 is inserted: D02359
NOTICE:  Drug1 Kegg id:  DB00869 is inserted: D07871
NOTICE:  Drug1 Kegg id:  DB00870 is inserted: D00452
NOTICE:  Drug1 Kegg id:  DB00872 is inserted: D07748
NOTICE:  Drug1 Kegg id:  DB00875 is inserted: D01044
NOTICE:  Drug1 Kegg id:  DB00876 is inserted: D04040
NOTICE:  Drug1 Kegg id:  DB00877 is inserted: D00753
NOTICE:  Drug1 Kegg id:  DB00880 is inserted: D00519
NOTICE:  Drug1 Kegg id:  DB00881 is inserted: D03752
NOTICE:  Drug1 Kegg id:  DB00882 is inserted: D07726
NOTICE:  Drug1 Kegg id:  DB00883 is inserted: D00516
NOTICE:  Drug1 Kegg id:  DB00884 is inserted: D08484
NOTICE:  Drug1 Kegg id:  DB00886 is inserted: D01970
NOTICE:  Drug1 Kegg id:  DB00887 is inserted: D00247
NOTICE:  Drug1 Kegg id:  DB00888 is inserted: D07671
NOTICE:  Drug1 Kegg id:  DB00889 is inserted: D04370
NOTICE:  Drug1 Kegg id:  DB00890 is inserted: D00898
NOTICE:  Drug1 Kegg id:  DB00891 is inserted: D02434
NOTICE:  Drug1 Kegg id:  DB00892 is inserted: D08319
NOTICE:  Drug1 Kegg id:  DB00893 is inserted: D02141
NOTICE:  Drug1 Kegg id:  DB00894 is inserted: D00153
NOTICE:  Drug1 Kegg id:  DB00896 is inserted: D05729
NOTICE:  Drug1 Kegg id:  DB00897 is inserted: D00387
NOTICE:  Drug1 Kegg id:  DB00898 is inserted: D00068
NOTICE:  Drug1 Kegg id:  DB00899 is inserted: D08473
NOTICE:  Drug1 Kegg id:  DB00901 is inserted: D07534
NOTICE:  Drug1 Kegg id:  DB00902 is inserted: D04979
NOTICE:  Drug1 Kegg id:  DB00903 is inserted: D00313
NOTICE:  Drug1 Kegg id:  DB00904 is inserted: D00456
NOTICE:  Drug1 Kegg id:  DB00905 is inserted: D02724
NOTICE:  Drug1 Kegg id:  DB00907 is inserted: D00110
NOTICE:  Drug1 Kegg id:  DB00908 is inserted: D08458
NOTICE:  Drug1 Kegg id:  DB00909 is inserted: D00538
NOTICE:  Drug1 Kegg id:  DB00910 is inserted: D00930
NOTICE:  Drug1 Kegg id:  DB00912 is inserted: D00594
NOTICE:  Drug1 Kegg id:  DB00913 is inserted: D02941
NOTICE:  Drug1 Kegg id:  DB00914 is inserted: D08351
NOTICE:  Drug1 Kegg id:  DB00917 is inserted: D00079
NOTICE:  Drug1 Kegg id:  DB00920 is inserted: D01332
NOTICE:  Drug1 Kegg id:  DB00921 is inserted: D07132
NOTICE:  Drug1 Kegg id:  DB00922 is inserted: D04720
NOTICE:  Drug1 Kegg id:  DB00924 is inserted: D07758
NOTICE:  Drug1 Kegg id:  DB00926 is inserted: D00316
NOTICE:  Drug1 Kegg id:  DB00927 is inserted: D00318
NOTICE:  Drug1 Kegg id:  DB00928 is inserted: D03021
NOTICE:  Drug1 Kegg id:  DB00929 is inserted: D00419
NOTICE:  Drug1 Kegg id:  DB00933 is inserted: D02671
NOTICE:  Drug1 Kegg id:  DB00934 is inserted: D02566
NOTICE:  Drug1 Kegg id:  DB00935 is inserted: D08322
NOTICE:  Drug1 Kegg id:  DB00936 is inserted: D00097
NOTICE:  Drug1 Kegg id:  DB00937 is inserted: D07444
NOTICE:  Drug1 Kegg id:  DB00938 is inserted: D05792
NOTICE:  Drug1 Kegg id:  DB00939 is inserted: D02341
NOTICE:  Drug1 Kegg id:  DB00941 is inserted: D04435
NOTICE:  Drug1 Kegg id:  DB00944 is inserted: D00667
NOTICE:  Drug1 Kegg id:  DB00945 is inserted: D00109
NOTICE:  Drug1 Kegg id:  DB00946 is inserted: D05457
NOTICE:  Drug1 Kegg id:  DB00947 is inserted: D01161
NOTICE:  Drug1 Kegg id:  DB00949 is inserted: D00536
NOTICE:  Drug1 Kegg id:  DB00950 is inserted: D07958
NOTICE:  Drug1 Kegg id:  DB00952 is inserted: D08255
NOTICE:  Drug1 Kegg id:  DB00953 is inserted: D00675
NOTICE:  Drug1 Kegg id:  DB00956 is inserted: D08045
NOTICE:  Drug1 Kegg id:  DB00957 is inserted: D05209
NOTICE:  Drug1 Kegg id:  DB00958 is inserted: D01363
NOTICE:  Drug1 Kegg id:  DB00959 is inserted: D00407
NOTICE:  Drug1 Kegg id:  DB00960 is inserted: D00513
NOTICE:  Drug1 Kegg id:  DB00961 is inserted: D08181
NOTICE:  Drug1 Kegg id:  DB00962 is inserted: D00530
NOTICE:  Drug1 Kegg id:  DB00963 is inserted: D07541
NOTICE:  Drug1 Kegg id:  DB00966 is inserted: D00627
NOTICE:  Drug1 Kegg id:  DB00967 is inserted: D03693
NOTICE:  Drug1 Kegg id:  DB00968 is inserted: D08205
NOTICE:  Drug1 Kegg id:  DB00969 is inserted: D07129
NOTICE:  Drug1 Kegg id:  DB00970 is inserted: D00214
NOTICE:  Drug1 Kegg id:  DB00972 is inserted: D07483
NOTICE:  Drug1 Kegg id:  DB00973 is inserted: D01966
NOTICE:  Drug1 Kegg id:  DB00974 is inserted: D00052
NOTICE:  Drug1 Kegg id:  DB00975 is inserted: D00302
NOTICE:  Drug1 Kegg id:  DB00977 is inserted: D00554
NOTICE:  Drug1 Kegg id:  DB00981 is inserted: D00196
NOTICE:  Drug1 Kegg id:  DB00982 is inserted: D00348
NOTICE:  Drug1 Kegg id:  DB00983 is inserted: D07990
NOTICE:  Drug1 Kegg id:  DB00984 is inserted: D00956
NOTICE:  Drug1 Kegg id:  DB00985 is inserted: D00520
NOTICE:  Drug1 Kegg id:  DB00986 is inserted: D00540
NOTICE:  Drug1 Kegg id:  DB00987 is inserted: D00168
NOTICE:  Drug1 Kegg id:  DB00988 is inserted: D07870
NOTICE:  Drug1 Kegg id:  DB00989 is inserted: D03822
NOTICE:  Drug1 Kegg id:  DB00990 is inserted: D00963
NOTICE:  Drug1 Kegg id:  DB00991 is inserted: D00463
NOTICE:  Drug1 Kegg id:  DB00993 is inserted: D00238
NOTICE:  Drug1 Kegg id:  DB00995 is inserted: D00237
NOTICE:  Drug1 Kegg id:  DB00996 is inserted: D00332
NOTICE:  Drug1 Kegg id:  DB00997 is inserted: D03899
NOTICE:  Drug1 Kegg id:  DB00998 is inserted: D07997
NOTICE:  Drug1 Kegg id:  DB00999 is inserted: D00340
NOTICE:  Drug1 Kegg id:  DB01001 is inserted: D02147
NOTICE:  Drug1 Kegg id:  DB01002 is inserted: D08116
NOTICE:  Drug1 Kegg id:  DB01005 is inserted: D00341
NOTICE:  Drug1 Kegg id:  DB01006 is inserted: D00964
NOTICE:  Drug1 Kegg id:  DB01008 is inserted: D00248
NOTICE:  Drug1 Kegg id:  DB01009 is inserted: D00132
NOTICE:  Drug1 Kegg id:  DB01011 is inserted: D00410
NOTICE:  Drug1 Kegg id:  DB01012 is inserted: D03504
NOTICE:  Drug1 Kegg id:  DB01013 is inserted: D01272
NOTICE:  Drug1 Kegg id:  DB01014 is inserted: D07488
NOTICE:  Drug1 Kegg id:  DB01016 is inserted: D00336
NOTICE:  Drug1 Kegg id:  DB01018 is inserted: D08031
NOTICE:  Drug1 Kegg id:  DB01020 is inserted: D00630
NOTICE:  Drug1 Kegg id:  DB01021 is inserted: D00658
NOTICE:  Drug1 Kegg id:  DB01022 is inserted: D00148
NOTICE:  Drug1 Kegg id:  DB01023 is inserted: D00319
NOTICE:  Drug1 Kegg id:  DB01026 is inserted: D00351
NOTICE:  Drug1 Kegg id:  DB01028 is inserted: D00544
NOTICE:  Drug1 Kegg id:  DB01029 is inserted: D00523
NOTICE:  Drug1 Kegg id:  DB01030 is inserted: D08618
NOTICE:  Drug1 Kegg id:  DB01032 is inserted: D00475
NOTICE:  Drug1 Kegg id:  DB01033 is inserted: D04931
NOTICE:  Drug1 Kegg id:  DB01036 is inserted: D00646
NOTICE:  Drug1 Kegg id:  DB01037 is inserted: D03731
NOTICE:  Drug1 Kegg id:  DB01039 is inserted: D00565
NOTICE:  Drug1 Kegg id:  DB01041 is inserted: D00754
NOTICE:  Drug1 Kegg id:  DB01042 is inserted: D00369
NOTICE:  Drug1 Kegg id:  DB01043 is inserted: D08174
NOTICE:  Drug1 Kegg id:  DB01046 is inserted: D04790
NOTICE:  Drug1 Kegg id:  DB01047 is inserted: D00325
NOTICE:  Drug1 Kegg id:  DB01049 is inserted: D02268
NOTICE:  Drug1 Kegg id:  DB01050 is inserted: D00126
NOTICE:  Drug1 Kegg id:  DB01054 is inserted: D00629
NOTICE:  Drug1 Kegg id:  DB01056 is inserted: D06172
NOTICE:  Drug1 Kegg id:  DB01058 is inserted: D00471
NOTICE:  Drug1 Kegg id:  DB01062 is inserted: D00465
NOTICE:  Drug1 Kegg id:  DB01065 is inserted: D08170
NOTICE:  Drug1 Kegg id:  DB01067 is inserted: D00335
NOTICE:  Drug1 Kegg id:  DB01068 is inserted: D00280
NOTICE:  Drug1 Kegg id:  DB01069 is inserted: D00494
NOTICE:  Drug1 Kegg id:  DB01070 is inserted: D00299
NOTICE:  Drug1 Kegg id:  DB01071 is inserted: D01324
NOTICE:  Drug1 Kegg id:  DB01073 is inserted: D01907
NOTICE:  Drug1 Kegg id:  DB01075 is inserted: D00300
NOTICE:  Drug1 Kegg id:  DB01076 is inserted: D07474
NOTICE:  Drug1 Kegg id:  DB01077 is inserted: D02373
NOTICE:  Drug1 Kegg id:  DB01078 is inserted: D01240
NOTICE:  Drug1 Kegg id:  DB01079 is inserted: D06056
NOTICE:  Drug1 Kegg id:  DB01080 is inserted: D00535
NOTICE:  Drug1 Kegg id:  DB01081 is inserted: D00301
NOTICE:  Drug1 Kegg id:  DB01084 is inserted: D07890
NOTICE:  Drug1 Kegg id:  DB01085 is inserted: D00525
NOTICE:  Drug1 Kegg id:  DB01086 is inserted: D00552
NOTICE:  Drug1 Kegg id:  DB01089 is inserted: D08194
NOTICE:  Drug1 Kegg id:  DB01092 is inserted: D00112
NOTICE:  Drug1 Kegg id:  DB01093 is inserted: D01043
NOTICE:  Drug1 Kegg id:  DB01095 is inserted: D07983
NOTICE:  Drug1 Kegg id:  DB01097 is inserted: D00749
NOTICE:  Drug1 Kegg id:  DB01098 is inserted: D08492
NOTICE:  Drug1 Kegg id:  DB01100 is inserted: D00560
NOTICE:  Drug1 Kegg id:  DB01101 is inserted: D01223
NOTICE:  Drug1 Kegg id:  DB01102 is inserted: D02976
NOTICE:  Drug1 Kegg id:  DB01104 is inserted: D02360
NOTICE:  Drug1 Kegg id:  DB01105 is inserted: D08513
NOTICE:  Drug1 Kegg id:  DB01106 is inserted: D01717
NOTICE:  Drug1 Kegg id:  DB01107 is inserted: D01150
NOTICE:  Drug1 Kegg id:  DB01108 is inserted: D01180
NOTICE:  Drug1 Kegg id:  DB01113 is inserted: D07425
NOTICE:  Drug1 Kegg id:  DB01114 is inserted: D07398
NOTICE:  Drug1 Kegg id:  DB01115 is inserted: D00437
NOTICE:  Drug1 Kegg id:  DB01118 is inserted: D02910
NOTICE:  Drug1 Kegg id:  DB01119 is inserted: D00294
NOTICE:  Drug1 Kegg id:  DB01120 is inserted: D01599
NOTICE:  Drug1 Kegg id:  DB01121 is inserted: D00504
NOTICE:  Drug1 Kegg id:  DB01124 is inserted: D00380
NOTICE:  Drug1 Kegg id:  DB01126 is inserted: D03820
NOTICE:  Drug1 Kegg id:  DB01128 is inserted: D00961
NOTICE:  Drug1 Kegg id:  DB01129 is inserted: D08463
NOTICE:  Drug1 Kegg id:  DB01132 is inserted: D08378
NOTICE:  Drug1 Kegg id:  DB01135 is inserted: D00760
NOTICE:  Drug1 Kegg id:  DB01136 is inserted: D00255
NOTICE:  Drug1 Kegg id:  DB01138 is inserted: D00449
NOTICE:  Drug1 Kegg id:  DB01142 is inserted: D07875
NOTICE:  Drug1 Kegg id:  DB01144 is inserted: D00518
NOTICE:  Drug1 Kegg id:  DB01146 is inserted: D07862
NOTICE:  Drug1 Kegg id:  DB01149 is inserted: D08257
NOTICE:  Drug1 Kegg id:  DB01151 is inserted: D07791
NOTICE:  Drug1 Kegg id:  DB01154 is inserted: D06106
NOTICE:  Drug1 Kegg id:  DB01156 is inserted: D07591
NOTICE:  Drug1 Kegg id:  DB01158 is inserted: D00645
NOTICE:  Drug1 Kegg id:  DB01159 is inserted: D00542
NOTICE:  Drug1 Kegg id:  DB01160 is inserted: D01352
NOTICE:  Drug1 Kegg id:  DB01161 is inserted: D07678
NOTICE:  Drug1 Kegg id:  DB01162 is inserted: D08569
NOTICE:  Drug1 Kegg id:  DB01166 is inserted: D01896
NOTICE:  Drug1 Kegg id:  DB01168 is inserted: D08423
NOTICE:  Drug1 Kegg id:  DB01169 is inserted: D02106
NOTICE:  Drug1 Kegg id:  DB01170 is inserted: D02237
NOTICE:  Drug1 Kegg id:  DB01171 is inserted: D02561
NOTICE:  Drug1 Kegg id:  DB01173 is inserted: D08305
NOTICE:  Drug1 Kegg id:  DB01174 is inserted: D00506
NOTICE:  Drug1 Kegg id:  DB01176 is inserted: D03621
NOTICE:  Drug1 Kegg id:  DB01178 is inserted: D00268
NOTICE:  Drug1 Kegg id:  DB01180 is inserted: D00198
NOTICE:  Drug1 Kegg id:  DB01181 is inserted: D00343
NOTICE:  Drug1 Kegg id:  DB01182 is inserted: D08435
NOTICE:  Drug1 Kegg id:  DB01183 is inserted: D08249
NOTICE:  Drug1 Kegg id:  DB01184 is inserted: D01745
NOTICE:  Drug1 Kegg id:  DB01185 is inserted: D00327
NOTICE:  Drug1 Kegg id:  DB01189 is inserted: D00546
NOTICE:  Drug1 Kegg id:  DB01191 is inserted: D07805
NOTICE:  Drug1 Kegg id:  DB01192 is inserted: D08323
NOTICE:  Drug1 Kegg id:  DB01193 is inserted: D02338
NOTICE:  Drug1 Kegg id:  DB01194 is inserted: D00652
NOTICE:  Drug1 Kegg id:  DB01195 is inserted: D07962
NOTICE:  Drug1 Kegg id:  DB01196 is inserted: D04066
NOTICE:  Drug1 Kegg id:  DB01197 is inserted: D00251
NOTICE:  Drug1 Kegg id:  DB01198 is inserted: D01372
NOTICE:  Drug1 Kegg id:  DB01200 is inserted: D03165
NOTICE:  Drug1 Kegg id:  DB01202 is inserted: D00709
NOTICE:  Drug1 Kegg id:  DB01203 is inserted: D00432
NOTICE:  Drug1 Kegg id:  DB01204 is inserted: D08224
NOTICE:  Drug1 Kegg id:  DB01205 is inserted: D00697
NOTICE:  Drug1 Kegg id:  DB01206 is inserted: D00363
NOTICE:  Drug1 Kegg id:  DB01209 is inserted: D00838
NOTICE:  Drug1 Kegg id:  DB01213 is inserted: D00707
NOTICE:  Drug1 Kegg id:  DB01214 is inserted: D02374
NOTICE:  Drug1 Kegg id:  DB01215 is inserted: D00311
NOTICE:  Drug1 Kegg id:  DB01216 is inserted: D00321
NOTICE:  Drug1 Kegg id:  DB01217 is inserted: D00960
NOTICE:  Drug1 Kegg id:  DB01219 is inserted: D02347
NOTICE:  Drug1 Kegg id:  DB01221 is inserted: D08098
NOTICE:  Drug1 Kegg id:  DB01222 is inserted: D00246
NOTICE:  Drug1 Kegg id:  DB01223 is inserted: D00227
NOTICE:  Drug1 Kegg id:  DB01224 is inserted: D08456
NOTICE:  Drug1 Kegg id:  DB01225 is inserted: D07510
NOTICE:  Drug1 Kegg id:  DB01227 is inserted: D04716
NOTICE:  Drug1 Kegg id:  DB01228 is inserted: D07894
NOTICE:  Drug1 Kegg id:  DB01229 is inserted: D00491
NOTICE:  Drug1 Kegg id:  DB01231 is inserted: D03858
NOTICE:  Drug1 Kegg id:  DB01233 is inserted: D00726
NOTICE:  Drug1 Kegg id:  DB01234 is inserted: D00292
NOTICE:  Drug1 Kegg id:  DB01235 is inserted: D00059
NOTICE:  Drug1 Kegg id:  DB01236 is inserted: D00547
NOTICE:  Drug1 Kegg id:  DB01238 is inserted: D01164
NOTICE:  Drug1 Kegg id:  DB01239 is inserted: D00790
NOTICE:  Drug1 Kegg id:  DB01240 is inserted: D00106
NOTICE:  Drug1 Kegg id:  DB01241 is inserted: D00334
NOTICE:  Drug1 Kegg id:  DB01242 is inserted: D00811
NOTICE:  Drug1 Kegg id:  DB01244 is inserted: D07520
NOTICE:  Drug1 Kegg id:  DB01246 is inserted: D07125
NOTICE:  Drug1 Kegg id:  DB01247 is inserted: D02580
NOTICE:  Drug1 Kegg id:  DB01248 is inserted: D02165
NOTICE:  Drug1 Kegg id:  DB01249 is inserted: D01474
NOTICE:  Drug1 Kegg id:  DB01250 is inserted: D00727
NOTICE:  Drug1 Kegg id:  DB01251 is inserted: D02430
NOTICE:  Drug1 Kegg id:  DB01252 is inserted: D01854
NOTICE:  Drug1 Kegg id:  DB01253 is inserted: D07905
NOTICE:  Drug1 Kegg id:  DB01254 is inserted: D03658
NOTICE:  Drug1 Kegg id:  DB01259 is inserted: D04024
NOTICE:  Drug1 Kegg id:  DB01260 is inserted: D03696
NOTICE:  Drug1 Kegg id:  DB01261 is inserted: D08516
NOTICE:  Drug1 Kegg id:  DB01262 is inserted: D03665
NOTICE:  Drug1 Kegg id:  DB01267 is inserted: D05339
NOTICE:  Drug1 Kegg id:  DB01268 is inserted: D06402
NOTICE:  Drug1 Kegg id:  DB01270 is inserted: D05697
NOTICE:  Drug1 Kegg id:  DB01274 is inserted: D07463
NOTICE:  Drug1 Kegg id:  DB01275 is inserted: D08044
NOTICE:  Drug1 Kegg id:  DB01276 is inserted: D04121
NOTICE:  Drug1 Kegg id:  DB01277 is inserted: D04870
NOTICE:  Drug1 Kegg id:  DB01278 is inserted: D05595
NOTICE:  Drug1 Kegg id:  DB01280 is inserted: D05134
NOTICE:  Drug1 Kegg id:  DB01281 is inserted: D03203
NOTICE:  Drug1 Kegg id:  DB01282 is inserted: D07229
NOTICE:  Drug1 Kegg id:  DB01283 is inserted: D03714
NOTICE:  Drug1 Kegg id:  DB01284 is inserted: D00284
NOTICE:  Drug1 Kegg id:  DB01285 is inserted: D00146
NOTICE:  Drug1 Kegg id:  DB01288 is inserted: D04157
NOTICE:  Drug1 Kegg id:  DB01294 is inserted: D00728
NOTICE:  Drug1 Kegg id:  DB01296 is inserted: D04334
NOTICE:  Drug1 Kegg id:  DB01297 is inserted: D05587
NOTICE:  Drug1 Kegg id:  DB01299 is inserted: D00580
NOTICE:  Drug1 Kegg id:  DB01301 is inserted: D02282
NOTICE:  Drug1 Kegg id:  DB01303 is inserted: D02017
NOTICE:  Drug1 Kegg id:  DB01306 is inserted: D04475
NOTICE:  Drug1 Kegg id:  DB01307 is inserted: D04539
NOTICE:  Drug1 Kegg id:  DB01309 is inserted: D04540
NOTICE:  Drug1 Kegg id:  DB01320 is inserted: D07993
NOTICE:  Drug1 Kegg id:  DB01324 is inserted: D00657
NOTICE:  Drug1 Kegg id:  DB01325 is inserted: D00461
NOTICE:  Drug1 Kegg id:  DB01333 is inserted: D00264
NOTICE:  Drug1 Kegg id:  DB01340 is inserted: D07699
NOTICE:  Drug1 Kegg id:  DB01342 is inserted: D04243
NOTICE:  Drug1 Kegg id:  DB01345 is inserted: D08403
NOTICE:  Drug1 Kegg id:  DB01348 is inserted: D08529
NOTICE:  Drug1 Kegg id:  DB01351 is inserted: D00555
NOTICE:  Drug1 Kegg id:  DB01352 is inserted: D00698
NOTICE:  Drug1 Kegg id:  DB01353 is inserted: D02618
NOTICE:  Drug1 Kegg id:  DB01355 is inserted: D01071
NOTICE:  Drug1 Kegg id:  DB01357 is inserted: D00575
NOTICE:  Drug1 Kegg id:  DB01359 is inserted: D08074
NOTICE:  Drug1 Kegg id:  DB01362 is inserted: D01817
NOTICE:  Drug1 Kegg id:  DB01364 is inserted: D00124
NOTICE:  Drug1 Kegg id:  DB01365 is inserted: D08180
NOTICE:  Drug1 Kegg id:  DB01367 is inserted: D08469
NOTICE:  Drug1 Kegg id:  DB01377 is inserted: D01167
NOTICE:  Drug1 Kegg id:  DB01380 is inserted: D00973
NOTICE:  Drug1 Kegg id:  DB01384 is inserted: D07464
NOTICE:  Drug1 Kegg id:  DB01390 is inserted: D01203
NOTICE:  Drug1 Kegg id:  DB01393 is inserted: D01366
NOTICE:  Drug1 Kegg id:  DB01394 is inserted: D00570
NOTICE:  Drug1 Kegg id:  DB01395 is inserted: D03917
NOTICE:  Drug1 Kegg id:  DB01396 is inserted: D00297
NOTICE:  Drug1 Kegg id:  DB01399 is inserted: D00428
NOTICE:  Drug1 Kegg id:  DB01400 is inserted: D08261
NOTICE:  Drug1 Kegg id:  DB01403 is inserted: D00403
NOTICE:  Drug1 Kegg id:  DB01406 is inserted: D00289
NOTICE:  Drug1 Kegg id:  DB01408 is inserted: D07377
NOTICE:  Drug1 Kegg id:  DB01410 is inserted: D01703
NOTICE:  Drug1 Kegg id:  DB01418 is inserted: D07064
NOTICE:  Drug1 Kegg id:  DB01420 is inserted: D00959
NOTICE:  Drug1 Kegg id:  DB01424 is inserted: D00556
NOTICE:  Drug1 Kegg id:  DB01426 is inserted: D00199
NOTICE:  Drug1 Kegg id:  DB01427 is inserted: D00231
NOTICE:  Drug1 Kegg id:  DB01428 is inserted: D05309
NOTICE:  Drug1 Kegg id:  DB01429 is inserted: D01326
NOTICE:  Drug1 Kegg id:  DB01431 is inserted: D01374
NOTICE:  Drug1 Kegg id:  DB01435 is inserted: D01776
NOTICE:  Drug1 Kegg id:  DB01436 is inserted: D01518
NOTICE:  Drug1 Kegg id:  DB01437 is inserted: D00532
NOTICE:  Drug1 Kegg id:  DB01438 is inserted: D08346
NOTICE:  Drug1 Kegg id:  DB01452 is inserted: D07286
NOTICE:  Drug1 Kegg id:  DB01466 is inserted: D07929
NOTICE:  Drug1 Kegg id:  DB01471 is inserted: D03144
NOTICE:  Drug1 Kegg id:  DB01489 is inserted: D07315
NOTICE:  Drug1 Kegg id:  DB01501 is inserted: D03809
NOTICE:  Drug1 Kegg id:  DB01511 is inserted: D07784
NOTICE:  Drug1 Kegg id:  DB01521 is inserted: D07731
NOTICE:  Drug1 Kegg id:  DB01524 is inserted: D00179
NOTICE:  Drug1 Kegg id:  DB01529 is inserted: D07287
NOTICE:  Drug1 Kegg id:  DB01534 is inserted: D07325
NOTICE:  Drug1 Kegg id:  DB01536 is inserted: D00051
NOTICE:  Drug1 Kegg id:  DB01541 is inserted: D07536
NOTICE:  Drug1 Kegg id:  DB01544 is inserted: D01230
NOTICE:  Drug1 Kegg id:  DB01545 is inserted: D01293
NOTICE:  Drug1 Kegg id:  DB01547 is inserted: D01496
NOTICE:  Drug1 Kegg id:  DB01550 is inserted: D07947
NOTICE:  Drug1 Kegg id:  DB01551 is inserted: D01481
NOTICE:  Drug1 Kegg id:  DB01553 is inserted: D01268
NOTICE:  Drug1 Kegg id:  DB01558 is inserted: D01245
NOTICE:  Drug1 Kegg id:  DB01559 is inserted: D01328
NOTICE:  Drug1 Kegg id:  DB01563 is inserted: D00265
NOTICE:  Drug1 Kegg id:  DB01567 is inserted: D01354
NOTICE:  Drug1 Kegg id:  DB01576 is inserted: D03740
NOTICE:  Drug1 Kegg id:  DB01579 is inserted: D08347
NOTICE:  Drug1 Kegg id:  DB01581 is inserted: D02435
NOTICE:  Drug1 Kegg id:  DB01583 is inserted: D00361
NOTICE:  Drug1 Kegg id:  DB01586 is inserted: D00734
NOTICE:  Drug1 Kegg id:  DB01588 is inserted: D00470
NOTICE:  Drug1 Kegg id:  DB01589 is inserted: D00457
NOTICE:  Drug1 Kegg id:  DB01590 is inserted: D02714
NOTICE:  Drug1 Kegg id:  DB01591 is inserted: D08522
NOTICE:  Drug1 Kegg id:  DB01594 is inserted: D07328
NOTICE:  Drug1 Kegg id:  DB01595 is inserted: D00531
NOTICE:  Drug1 Kegg id:  DB01597 is inserted: D07698
NOTICE:  Drug1 Kegg id:  DB01599 is inserted: D00476
NOTICE:  Drug1 Kegg id:  DB01606 is inserted: D00660
NOTICE:  Drug1 Kegg id:  DB01608 is inserted: D01485
NOTICE:  Drug1 Kegg id:  DB01609 is inserted: D03669
NOTICE:  Drug1 Kegg id:  DB01612 is inserted: D00517
NOTICE:  Drug1 Kegg id:  DB01614 is inserted: D07065
NOTICE:  Drug1 Kegg id:  DB01616 is inserted: D07440
NOTICE:  Drug1 Kegg id:  DB01618 is inserted: D08226
NOTICE:  Drug1 Kegg id:  DB01619 is inserted: D08353
NOTICE:  Drug1 Kegg id:  DB01621 is inserted: D08385
NOTICE:  Drug1 Kegg id:  DB01622 is inserted: D08585
NOTICE:  Drug1 Kegg id:  DB01623 is inserted: D00374
NOTICE:  Drug1 Kegg id:  DB01624 is inserted: D03556
NOTICE:  Drug1 Kegg id:  DB01626 is inserted: D08453
NOTICE:  Drug1 Kegg id:  DB01628 is inserted: D03710
NOTICE:  Drug1 Kegg id:  DB01638 is inserted: D00096
NOTICE:  Drug1 Kegg id:  DB01656 is inserted: D05744
NOTICE:  Drug1 Kegg id:  DB01708 is inserted: D08409
NOTICE:  Drug1 Kegg id:  DB01783 is inserted: D07413
NOTICE:  Drug1 Kegg id:  DB01791 is inserted: D05474
NOTICE:  Drug1 Kegg id:  DB01839 is inserted: D00078
NOTICE:  Drug1 Kegg id:  DB01954 is inserted: D01783
NOTICE:  Drug1 Kegg id:  DB02187 is inserted: D04041
NOTICE:  Drug1 Kegg id:  DB02300 is inserted: D01125
NOTICE:  Drug1 Kegg id:  DB02546 is inserted: D06320
NOTICE:  Drug1 Kegg id:  DB02659 is inserted: D10699
NOTICE:  Drug1 Kegg id:  DB02701 is inserted: D00036
NOTICE:  Drug1 Kegg id:  DB02789 is inserted: D00143
NOTICE:  Drug1 Kegg id:  DB02901 is inserted: D07456
NOTICE:  Drug1 Kegg id:  DB02925 is inserted: D01634
NOTICE:  Drug1 Kegg id:  DB02959 is inserted: D07339
NOTICE:  Drug1 Kegg id:  DB03255 is inserted: D00033
NOTICE:  Drug1 Kegg id:  DB03395 is inserted: D03738
NOTICE:  Drug1 Kegg id:  DB03419 is inserted: D00027
NOTICE:  Drug1 Kegg id:  DB03783 is inserted: D00569
NOTICE:  Drug1 Kegg id:  DB03793 is inserted: D00038
NOTICE:  Drug1 Kegg id:  DB03843 is inserted: D00017
NOTICE:  Drug1 Kegg id:  DB03849 is inserted: D01704
NOTICE:  Drug1 Kegg id:  DB03880 is inserted: D03061
NOTICE:  Drug1 Kegg id:  DB04017 is inserted: D03248
NOTICE:  Drug1 Kegg id:  DB04272 is inserted: D00037
NOTICE:  Drug1 Kegg id:  DB04339 is inserted: D00175
NOTICE:  Drug1 Kegg id:  DB04468 is inserted: D06551
NOTICE:  Drug1 Kegg id:  DB04519 is inserted: D05220
NOTICE:  Drug1 Kegg id:  DB04540 is inserted: D00040
NOTICE:  Drug1 Kegg id:  DB04552 is inserted: D08275
NOTICE:  Drug1 Kegg id:  DB04570 is inserted: D08109
NOTICE:  Drug1 Kegg id:  DB04571 is inserted: D01034
NOTICE:  Drug1 Kegg id:  DB04572 is inserted: D00583
NOTICE:  Drug1 Kegg id:  DB04573 is inserted: D00185
NOTICE:  Drug1 Kegg id:  DB04575 is inserted: D00576
NOTICE:  Drug1 Kegg id:  DB04576 is inserted: D01716
NOTICE:  Drug1 Kegg id:  DB04599 is inserted: D01883
NOTICE:  Drug1 Kegg id:  DB04743 is inserted: D01049
NOTICE:  Drug1 Kegg id:  DB04812 is inserted: D03080
NOTICE:  Drug1 Kegg id:  DB04816 is inserted: D07107
NOTICE:  Drug1 Kegg id:  DB04817 is inserted: D08188
NOTICE:  Drug1 Kegg id:  DB04818 is inserted: D02579
NOTICE:  Drug1 Kegg id:  DB04824 is inserted: D05456
NOTICE:  Drug1 Kegg id:  DB04825 is inserted: D02383
NOTICE:  Drug1 Kegg id:  DB04830 is inserted: D00595
NOTICE:  Drug1 Kegg id:  DB04831 is inserted: D02386
NOTICE:  Drug1 Kegg id:  DB04833 is inserted: D00557
NOTICE:  Drug1 Kegg id:  DB04836 is inserted: D07335
NOTICE:  Drug1 Kegg id:  DB04839 is inserted: D01368
NOTICE:  Drug1 Kegg id:  DB04841 is inserted: D01303
NOTICE:  Drug1 Kegg id:  DB04842 is inserted: D02629
NOTICE:  Drug1 Kegg id:  DB04844 is inserted: D08575
NOTICE:  Drug1 Kegg id:  DB04845 is inserted: D04645
NOTICE:  Drug1 Kegg id:  DB04846 is inserted: D07660
NOTICE:  Drug1 Kegg id:  DB04851 is inserted: D03128
NOTICE:  Drug1 Kegg id:  DB04854 is inserted: D01206
NOTICE:  Drug1 Kegg id:  DB04855 is inserted: D02537
NOTICE:  Drug1 Kegg id:  DB04858 is inserted: D06167
NOTICE:  Drug1 Kegg id:  DB04861 is inserted: D05127
NOTICE:  Drug1 Kegg id:  DB04865 is inserted: D08956
NOTICE:  Drug1 Kegg id:  DB04868 is inserted: D08953
NOTICE:  Drug1 Kegg id:  DB04871 is inserted: D06613
NOTICE:  Drug1 Kegg id:  DB04878 is inserted: D01665
NOTICE:  Drug1 Kegg id:  DB04880 is inserted: D04004
NOTICE:  Drug1 Kegg id:  DB04881 is inserted: D03968
NOTICE:  Drug1 Kegg id:  DB04884 is inserted: D03649
NOTICE:  Drug1 Kegg id:  DB04885 is inserted: D03495
NOTICE:  Drug1 Kegg id:  DB04889 is inserted: D03110
NOTICE:  Drug1 Kegg id:  DB04890 is inserted: D01654
NOTICE:  Drug1 Kegg id:  DB04894 is inserted: D06281
NOTICE:  Drug1 Kegg id:  DB04896 is inserted: D08222
NOTICE:  Drug1 Kegg id:  DB04901 is inserted: D04295
NOTICE:  Drug1 Kegg id:  DB04908 is inserted: D02577
NOTICE:  Drug1 Kegg id:  DB04920 is inserted: D08892
NOTICE:  Drug1 Kegg id:  DB04938 is inserted: D08958
NOTICE:  Drug1 Kegg id:  DB04946 is inserted: D02666
NOTICE:  Drug1 Kegg id:  DB04953 is inserted: D09569
NOTICE:  Drug1 Kegg id:  DB05016 is inserted: D09323
NOTICE:  Drug1 Kegg id:  DB05039 is inserted: D09318
NOTICE:  Drug1 Kegg id:  DB05076 is inserted: D04162
NOTICE:  Drug1 Kegg id:  DB05099 is inserted: D02938
NOTICE:  Drug1 Kegg id:  DB05137 is inserted: D02364
NOTICE:  Drug1 Kegg id:  DB05239 is inserted: D10405
NOTICE:  Drug1 Kegg id:  DB05246 is inserted: D00404
NOTICE:  Drug1 Kegg id:  DB05265 is inserted: D07885
NOTICE:  Drug1 Kegg id:  DB05271 is inserted: D05768
NOTICE:  Drug1 Kegg id:  DB05294 is inserted: D06407
NOTICE:  Drug1 Kegg id:  DB05381 is inserted: D08040
NOTICE:  Drug1 Kegg id:  DB05528 is inserted: D08946
NOTICE:  Drug1 Kegg id:  DB05541 is inserted: D08879
NOTICE:  Drug1 Kegg id:  DB05578 is inserted: D09371
NOTICE:  Drug1 Kegg id:  DB05595 is inserted: D09343
NOTICE:  Drug1 Kegg id:  DB05676 is inserted: D08860
NOTICE:  Drug1 Kegg id:  DB05679 is inserted: D09214
NOTICE:  Drug1 Kegg id:  DB05773 is inserted: D09980
NOTICE:  Drug1 Kegg id:  DB05812 is inserted: D09701
NOTICE:  Drug1 Kegg id:  DB05885 is inserted: D05817
NOTICE:  Drug1 Kegg id:  DB05990 is inserted: D09360
NOTICE:  Drug1 Kegg id:  DB06013 is inserted: D10383
NOTICE:  Drug1 Kegg id:  DB06016 is inserted: D09997
NOTICE:  Drug1 Kegg id:  DB06043 is inserted: D09939
NOTICE:  Drug1 Kegg id:  DB06144 is inserted: D00561
NOTICE:  Drug1 Kegg id:  DB06150 is inserted: D01142
NOTICE:  Drug1 Kegg id:  DB06151 is inserted: D00221
NOTICE:  Drug1 Kegg id:  DB06154 is inserted: D01721
NOTICE:  Drug1 Kegg id:  DB06155 is inserted: D05731
NOTICE:  Drug1 Kegg id:  DB06159 is inserted: D04031
NOTICE:  Drug1 Kegg id:  DB06168 is inserted: D09315
NOTICE:  Drug1 Kegg id:  DB06176 is inserted: D06637
NOTICE:  Drug1 Kegg id:  DB06186 is inserted: D04603
NOTICE:  Drug1 Kegg id:  DB06196 is inserted: D04492
NOTICE:  Drug1 Kegg id:  DB06201 is inserted: D05775
NOTICE:  Drug1 Kegg id:  DB06203 is inserted: D06553
NOTICE:  Drug1 Kegg id:  DB06204 is inserted: D06007
NOTICE:  Drug1 Kegg id:  DB06206 is inserted: D05940
NOTICE:  Drug1 Kegg id:  DB06207 is inserted: D01965
NOTICE:  Drug1 Kegg id:  DB06209 is inserted: D05597
NOTICE:  Drug1 Kegg id:  DB06210 is inserted: D03978
NOTICE:  Drug1 Kegg id:  DB06212 is inserted: D01213
NOTICE:  Drug1 Kegg id:  DB06213 is inserted: D05711
NOTICE:  Drug1 Kegg id:  DB06215 is inserted: D04177
NOTICE:  Drug1 Kegg id:  DB06216 is inserted: D02995
NOTICE:  Drug1 Kegg id:  DB06217 is inserted: D06665
NOTICE:  Drug1 Kegg id:  DB06218 is inserted: D07299
NOTICE:  Drug1 Kegg id:  DB06228 is inserted: D07086
NOTICE:  Drug1 Kegg id:  DB06230 is inserted: D05111
NOTICE:  Drug1 Kegg id:  DB06237 is inserted: D03217
NOTICE:  Drug1 Kegg id:  DB06262 is inserted: D01277
NOTICE:  Drug1 Kegg id:  DB06264 is inserted: D08617
NOTICE:  Drug1 Kegg id:  DB06266 is inserted: D07257
NOTICE:  Drug1 Kegg id:  DB06267 is inserted: D10027
NOTICE:  Drug1 Kegg id:  DB06268 is inserted: D07171
NOTICE:  Drug1 Kegg id:  DB06271 is inserted: D08547
NOTICE:  Drug1 Kegg id:  DB06273 is inserted: D02596
NOTICE:  Drug1 Kegg id:  DB06274 is inserted: D02878
NOTICE:  Drug1 Kegg id:  DB06282 is inserted: D07402
NOTICE:  Drug1 Kegg id:  DB06283 is inserted: D06363
NOTICE:  Drug1 Kegg id:  DB06285 is inserted: D06078
NOTICE:  Drug1 Kegg id:  DB06287 is inserted: D06068
NOTICE:  Drug1 Kegg id:  DB06288 is inserted: D07310
NOTICE:  Drug1 Kegg id:  DB06292 is inserted: D08897
NOTICE:  Drug1 Kegg id:  DB06317 is inserted: D09337
NOTICE:  Drug1 Kegg id:  DB06335 is inserted: D08996
NOTICE:  Drug1 Kegg id:  DB06366 is inserted: D05446
NOTICE:  Drug1 Kegg id:  DB06372 is inserted: D06635
NOTICE:  Drug1 Kegg id:  DB06401 is inserted: D03062
NOTICE:  Drug1 Kegg id:  DB06410 is inserted: D01009
NOTICE:  Drug1 Kegg id:  DB06412 is inserted: D00490
NOTICE:  Drug1 Kegg id:  DB06413 is inserted: D03215
NOTICE:  Drug1 Kegg id:  DB06414 is inserted: D04112
NOTICE:  Drug1 Kegg id:  DB06415 is inserted: D03317
NOTICE:  Drug1 Kegg id:  DB06440 is inserted: D02556
NOTICE:  Drug1 Kegg id:  DB06441 is inserted: D03359
NOTICE:  Drug1 Kegg id:  DB06527 is inserted: D06202
NOTICE:  Drug1 Kegg id:  DB06554 is inserted: D04282
NOTICE:  Drug1 Kegg id:  DB06589 is inserted: D05380
NOTICE:  Drug1 Kegg id:  DB06594 is inserted: D02578
NOTICE:  Drug1 Kegg id:  DB06595 is inserted: D05029
NOTICE:  Drug1 Kegg id:  DB06603 is inserted: D10019
NOTICE:  Drug1 Kegg id:  DB06605 is inserted: D03213
NOTICE:  Drug1 Kegg id:  DB06611 is inserted: D05393
NOTICE:  Drug1 Kegg id:  DB06612 is inserted: D04923
NOTICE:  Drug1 Kegg id:  DB06616 is inserted: D03252
NOTICE:  Drug1 Kegg id:  DB06623 is inserted: D07978
NOTICE:  Drug1 Kegg id:  DB06626 is inserted: D03218
NOTICE:  Drug1 Kegg id:  DB06637 is inserted: D04127
NOTICE:  Drug1 Kegg id:  DB06643 is inserted: D03684
NOTICE:  Drug1 Kegg id:  DB06650 is inserted: D09314
NOTICE:  Drug1 Kegg id:  DB06655 is inserted: D06404
NOTICE:  Drug1 Kegg id:  DB06663 is inserted: D10147
NOTICE:  Drug1 Kegg id:  DB06674 is inserted: D04358
NOTICE:  Drug1 Kegg id:  DB06681 is inserted: D03222
NOTICE:  Drug1 Kegg id:  DB06684 is inserted: D09698
NOTICE:  Drug1 Kegg id:  DB06688 is inserted: D06644
NOTICE:  Drug1 Kegg id:  DB06690 is inserted: D00102
NOTICE:  Drug1 Kegg id:  DB06691 is inserted: D08183
NOTICE:  Drug1 Kegg id:  DB06692 is inserted: D02971
NOTICE:  Drug1 Kegg id:  DB06694 is inserted: D08684
NOTICE:  Drug1 Kegg id:  DB06695 is inserted: D07144
NOTICE:  Drug1 Kegg id:  DB06698 is inserted: D07522
NOTICE:  Drug1 Kegg id:  DB06699 is inserted: D08901
NOTICE:  Drug1 Kegg id:  DB06700 is inserted: D07793
NOTICE:  Drug1 Kegg id:  DB06702 is inserted: D07226
NOTICE:  Drug1 Kegg id:  DB06704 is inserted: D04559
NOTICE:  Drug1 Kegg id:  DB06705 is inserted: D04286
NOTICE:  Drug1 Kegg id:  DB06707 is inserted: D02388
NOTICE:  Drug1 Kegg id:  DB06710 is inserted: D00408
NOTICE:  Drug1 Kegg id:  DB06711 is inserted: D08253
NOTICE:  Drug1 Kegg id:  DB06712 is inserted: D01908
NOTICE:  Drug1 Kegg id:  DB06713 is inserted: D05205
NOTICE:  Drug1 Kegg id:  DB06715 is inserted: D01016
NOTICE:  Drug1 Kegg id:  DB06716 is inserted: D04257
NOTICE:  Drug1 Kegg id:  DB06717 is inserted: D06597
NOTICE:  Drug1 Kegg id:  DB06718 is inserted: D00444
NOTICE:  Drug1 Kegg id:  DB06719 is inserted: D01831
NOTICE:  Drug1 Kegg id:  DB06724 is inserted: D00932
NOTICE:  Drug1 Kegg id:  DB06725 is inserted: D01866
NOTICE:  Drug1 Kegg id:  DB06727 is inserted: D01041
NOTICE:  Drug1 Kegg id:  DB06736 is inserted: D01545
NOTICE:  Drug1 Kegg id:  DB06737 is inserted: D01547
NOTICE:  Drug1 Kegg id:  DB06738 is inserted: D08100
NOTICE:  Drug1 Kegg id:  DB06739 is inserted: D01123
NOTICE:  Drug1 Kegg id:  DB06753 is inserted: D08634
NOTICE:  Drug1 Kegg id:  DB06756 is inserted: D07523
NOTICE:  Drug1 Kegg id:  DB06761 is inserted: D03096
NOTICE:  Drug1 Kegg id:  DB06764 is inserted: D08578
NOTICE:  Drug1 Kegg id:  DB06769 is inserted: D07085
NOTICE:  Drug1 Kegg id:  DB06772 is inserted: D09755
NOTICE:  Drug1 Kegg id:  DB06774 is inserted: D00250
NOTICE:  Drug1 Kegg id:  DB06777 is inserted: D00163
NOTICE:  Drug1 Kegg id:  DB06779 is inserted: D03353
NOTICE:  Drug1 Kegg id:  DB06780 is inserted: D03698
NOTICE:  Drug1 Kegg id:  DB06781 is inserted: D01266
NOTICE:  Drug1 Kegg id:  DB06782 is inserted: D00167
NOTICE:  Drug1 Kegg id:  DB06786 is inserted: D01308
NOTICE:  Drug1 Kegg id:  DB06788 is inserted: D02369
NOTICE:  Drug1 Kegg id:  DB06789 is inserted: D00949
NOTICE:  Drug1 Kegg id:  DB06791 is inserted: D04666
NOTICE:  Drug1 Kegg id:  DB06797 is inserted: D01807
NOTICE:  Drug1 Kegg id:  DB06800 is inserted: D06618
NOTICE:  Drug1 Kegg id:  DB06802 is inserted: D05143
NOTICE:  Drug1 Kegg id:  DB06804 is inserted: D06490
NOTICE:  Drug1 Kegg id:  DB06809 is inserted: D08971
NOTICE:  Drug1 Kegg id:  DB06810 is inserted: D00468
NOTICE:  Drug1 Kegg id:  DB06811 is inserted: D01993
NOTICE:  Drug1 Kegg id:  DB06813 is inserted: D05589
NOTICE:  Drug1 Kegg id:  DB06819 is inserted: D05868
NOTICE:  Drug1 Kegg id:  DB06821 is inserted: D02517
NOTICE:  Drug1 Kegg id:  DB06822 is inserted: D06398
NOTICE:  Drug1 Kegg id:  DB06823 is inserted: D01430
NOTICE:  Drug1 Kegg id:  DB06825 is inserted: D06247
NOTICE:  Drug1 Kegg id:  DB07402 is inserted: D02966
NOTICE:  Drug1 Kegg id:  DB07615 is inserted: D02027
NOTICE:  Drug1 Kegg id:  DB08313 is inserted: D05197
NOTICE:  Drug1 Kegg id:  DB08439 is inserted: D02709
NOTICE:  Drug1 Kegg id:  DB08797 is inserted: D01811
NOTICE:  Drug1 Kegg id:  DB08799 is inserted: D07458
NOTICE:  Drug1 Kegg id:  DB08800 is inserted: D07195
NOTICE:  Drug1 Kegg id:  DB08801 is inserted: D07853
NOTICE:  Drug1 Kegg id:  DB08804 is inserted: D00955
NOTICE:  Drug1 Kegg id:  DB08805 is inserted: D05004
NOTICE:  Drug1 Kegg id:  DB08806 is inserted: D08495
NOTICE:  Drug1 Kegg id:  DB08807 is inserted: D07537
NOTICE:  Drug1 Kegg id:  DB08808 is inserted: D07590
NOTICE:  Drug1 Kegg id:  DB08810 is inserted: D07700
NOTICE:  Drug1 Kegg id:  DB08811 is inserted: D01254
NOTICE:  Drug1 Kegg id:  DB08815 is inserted: D04820
NOTICE:  Drug1 Kegg id:  DB08816 is inserted: D09017
NOTICE:  Drug1 Kegg id:  DB08819 is inserted: D06274
NOTICE:  Drug1 Kegg id:  DB08820 is inserted: D09916
NOTICE:  Drug1 Kegg id:  DB08822 is inserted: D08865
NOTICE:  Drug1 Kegg id:  DB08824 is inserted: D10014
NOTICE:  Drug1 Kegg id:  DB08826 is inserted: D07416
NOTICE:  Drug1 Kegg id:  DB08827 is inserted: D09637
NOTICE:  Drug1 Kegg id:  DB08828 is inserted: D09992
NOTICE:  Drug1 Kegg id:  DB08836 is inserted: D08566
NOTICE:  Drug1 Kegg id:  DB08860 is inserted: D01862
NOTICE:  Drug1 Kegg id:  DB08865 is inserted: D09731
NOTICE:  Drug1 Kegg id:  DB08867 is inserted: D09567
NOTICE:  Drug1 Kegg id:  DB08868 is inserted: D10001
NOTICE:  Drug1 Kegg id:  DB08870 is inserted: D09587
NOTICE:  Drug1 Kegg id:  DB08871 is inserted: D08914
NOTICE:  Drug1 Kegg id:  DB08872 is inserted: D09539
NOTICE:  Drug1 Kegg id:  DB08875 is inserted: D10062
NOTICE:  Drug1 Kegg id:  DB08877 is inserted: D09959
NOTICE:  Drug1 Kegg id:  DB08878 is inserted: D02527
NOTICE:  Drug1 Kegg id:  DB08879 is inserted: D03068
NOTICE:  Drug1 Kegg id:  DB08880 is inserted: D10172
NOTICE:  Drug1 Kegg id:  DB08881 is inserted: D09996
NOTICE:  Drug1 Kegg id:  DB08882 is inserted: D09566
NOTICE:  Drug1 Kegg id:  DB08883 is inserted: D08964
NOTICE:  Drug1 Kegg id:  DB08884 is inserted: D04288
NOTICE:  Drug1 Kegg id:  DB08886 is inserted: D02997
NOTICE:  Drug1 Kegg id:  DB08887 is inserted: D01892
NOTICE:  Drug1 Kegg id:  DB08889 is inserted: D08880
NOTICE:  Drug1 Kegg id:  DB08890 is inserted: D09355
NOTICE:  Drug1 Kegg id:  DB08892 is inserted: D08861
NOTICE:  Drug1 Kegg id:  DB08893 is inserted: D09535
NOTICE:  Drug1 Kegg id:  DB08894 is inserted: D09947
NOTICE:  Drug1 Kegg id:  DB08895 is inserted: D09970
NOTICE:  Drug1 Kegg id:  DB08896 is inserted: D10138
NOTICE:  Drug1 Kegg id:  DB08897 is inserted: D08837
NOTICE:  Drug1 Kegg id:  DB08898 is inserted: D10260
NOTICE:  Drug1 Kegg id:  DB08899 is inserted: D10218
NOTICE:  Drug1 Kegg id:  DB08900 is inserted: D06053
NOTICE:  Drug1 Kegg id:  DB08901 is inserted: D09950
NOTICE:  Drug1 Kegg id:  DB08904 is inserted: D03441
NOTICE:  Drug1 Kegg id:  DB08905 is inserted: D07260
NOTICE:  Drug1 Kegg id:  DB08906 is inserted: D06315
NOTICE:  Drug1 Kegg id:  DB08907 is inserted: D09592
NOTICE:  Drug1 Kegg id:  DB08908 is inserted: D03846
NOTICE:  Drug1 Kegg id:  DB08909 is inserted: D10127
NOTICE:  Drug1 Kegg id:  DB08910 is inserted: D08976
NOTICE:  Drug1 Kegg id:  DB08911 is inserted: D10175
NOTICE:  Drug1 Kegg id:  DB08912 is inserted: D10064
NOTICE:  Drug1 Kegg id:  DB08916 is inserted: D09724
NOTICE:  Drug1 Kegg id:  DB08917 is inserted: D08920
NOTICE:  Drug1 Kegg id:  DB08918 is inserted: D10072
NOTICE:  Drug1 Kegg id:  DB08925 is inserted: D07348
NOTICE:  Drug1 Kegg id:  DB08931 is inserted: D09572
NOTICE:  Drug1 Kegg id:  DB08932 is inserted: D10135
NOTICE:  Drug1 Kegg id:  DB08935 is inserted: D09321
NOTICE:  Drug1 Kegg id:  DB08938 is inserted: D04832
NOTICE:  Drug1 Kegg id:  DB08940 is inserted: D01567
NOTICE:  Drug1 Kegg id:  DB08942 is inserted: D04639
NOTICE:  Drug1 Kegg id:  DB08950 is inserted: D04531
NOTICE:  Drug1 Kegg id:  DB08951 is inserted: D04530
NOTICE:  Drug1 Kegg id:  DB08952 is inserted: D08078
NOTICE:  Drug1 Kegg id:  DB08954 is inserted: D08064
NOTICE:  Drug1 Kegg id:  DB08955 is inserted: D07268
NOTICE:  Drug1 Kegg id:  DB08962 is inserted: D02427
NOTICE:  Drug1 Kegg id:  DB08980 is inserted: D07185
NOTICE:  Drug1 Kegg id:  DB08981 is inserted: D01344
NOTICE:  Drug1 Kegg id:  DB08983 is inserted: D07187
NOTICE:  Drug1 Kegg id:  DB08984 is inserted: D04102
NOTICE:  Drug1 Kegg id:  DB08985 is inserted: D07931
NOTICE:  Drug1 Kegg id:  DB08986 is inserted: D07320
NOTICE:  Drug1 Kegg id:  DB08987 is inserted: D04095
NOTICE:  Drug1 Kegg id:  DB08991 is inserted: D01394
NOTICE:  Drug1 Kegg id:  DB08992 is inserted: D01671
NOTICE:  Drug1 Kegg id:  DB08994 is inserted: D07138
NOTICE:  Drug1 Kegg id:  DB08996 is inserted: D02565
NOTICE:  Drug1 Kegg id:  DB08999 is inserted: D07370
NOTICE:  Drug1 Kegg id:  DB09000 is inserted: D07307
NOTICE:  Drug1 Kegg id:  DB09007 is inserted: D07198
NOTICE:  Drug1 Kegg id:  DB09008 is inserted: D01075
NOTICE:  Drug1 Kegg id:  DB09009 is inserted: D07468
NOTICE:  Drug1 Kegg id:  DB09011 is inserted: D07300
NOTICE:  Drug1 Kegg id:  DB09014 is inserted: D07316
NOTICE:  Drug1 Kegg id:  DB09016 is inserted: D07601
NOTICE:  Drug1 Kegg id:  DB09017 is inserted: D01744
NOTICE:  Drug1 Kegg id:  DB09018 is inserted: D07101
NOTICE:  Drug1 Kegg id:  DB09020 is inserted: D00245
NOTICE:  Drug1 Kegg id:  DB09021 is inserted: D03089
NOTICE:  Drug1 Kegg id:  DB09022 is inserted: D07192
NOTICE:  Drug1 Kegg id:  DB09023 is inserted: D07498
NOTICE:  Drug1 Kegg id:  DB09026 is inserted: D03208
NOTICE:  Drug1 Kegg id:  DB09029 is inserted: D09967
NOTICE:  Drug1 Kegg id:  DB09030 is inserted: D09765
NOTICE:  Drug1 Kegg id:  DB09033 is inserted: D08083
NOTICE:  Drug1 Kegg id:  DB09034 is inserted: D10082
NOTICE:  Drug1 Kegg id:  DB09035 is inserted: D10316
NOTICE:  Drug1 Kegg id:  DB09036 is inserted: D09669
NOTICE:  Drug1 Kegg id:  DB09037 is inserted: D10574
NOTICE:  Drug1 Kegg id:  DB09038 is inserted: D10459
NOTICE:  Drug1 Kegg id:  DB09039 is inserted: D09893
NOTICE:  Drug1 Kegg id:  DB09043 is inserted: D08843
NOTICE:  Drug1 Kegg id:  DB09045 is inserted: D09889
NOTICE:  Drug1 Kegg id:  DB09046 is inserted: D05014
NOTICE:  Drug1 Kegg id:  DB09048 is inserted: D10572
NOTICE:  Drug1 Kegg id:  DB09049 is inserted: D10479
NOTICE:  Drug1 Kegg id:  DB09050 is inserted: D10097
NOTICE:  Drug1 Kegg id:  DB09052 is inserted: D09325
NOTICE:  Drug1 Kegg id:  DB09053 is inserted: D10223
NOTICE:  Drug1 Kegg id:  DB09054 is inserted: D10560
NOTICE:  Drug1 Kegg id:  DB09055 is inserted: D07190
NOTICE:  Drug1 Kegg id:  DB09059 is inserted: D03008
NOTICE:  Drug1 Kegg id:  DB09062 is inserted: D07642
NOTICE:  Drug1 Kegg id:  DB09063 is inserted: D10551
NOTICE:  Drug1 Kegg id:  DB09064 is inserted: D03521
NOTICE:  Drug1 Kegg id:  DB09065 is inserted: D09881
NOTICE:  Drug1 Kegg id:  DB09067 is inserted: D03592
NOTICE:  Drug1 Kegg id:  DB09068 is inserted: D10184
NOTICE:  Drug1 Kegg id:  DB09070 is inserted: D01639
NOTICE:  Drug1 Kegg id:  DB09071 is inserted: D09388
NOTICE:  Drug1 Kegg id:  DB09073 is inserted: D10372
NOTICE:  Drug1 Kegg id:  DB09074 is inserted: D09730
NOTICE:  Drug1 Kegg id:  DB09075 is inserted: D09546
NOTICE:  Drug1 Kegg id:  DB09076 is inserted: D10180
NOTICE:  Drug1 Kegg id:  DB09077 is inserted: D10559
NOTICE:  Drug1 Kegg id:  DB09078 is inserted: D09919
NOTICE:  Drug1 Kegg id:  DB09079 is inserted: D10481
NOTICE:  Drug1 Kegg id:  DB09080 is inserted: D10145
NOTICE:  Drug1 Kegg id:  DB09081 is inserted: D01750
NOTICE:  Drug1 Kegg id:  DB09082 is inserted: D09696
NOTICE:  Drug1 Kegg id:  DB09083 is inserted: D07165
NOTICE:  Drug1 Kegg id:  DB09085 is inserted: D00551
NOTICE:  Drug1 Kegg id:  DB09098 is inserted: D05884
NOTICE:  Drug1 Kegg id:  DB09099 is inserted: D07431
NOTICE:  Drug1 Kegg id:  DB09105 is inserted: D10595
NOTICE:  Drug1 Kegg id:  DB09106 is inserted: D03335
NOTICE:  Drug1 Kegg id:  DB09113 is inserted: D08402
NOTICE:  Drug1 Kegg id:  DB09119 is inserted: D09612
NOTICE:  Drug1 Kegg id:  DB09121 is inserted: D00991
NOTICE:  Drug1 Kegg id:  DB09122 is inserted: D10483
NOTICE:  Drug1 Kegg id:  DB09128 is inserted: D10309
NOTICE:  Drug1 Kegg id:  DB09132 is inserted: D08007
NOTICE:  Drug1 Kegg id:  DB09133 is inserted: D01258
NOTICE:  Drug1 Kegg id:  DB09134 is inserted: D01555
NOTICE:  Drug1 Kegg id:  DB09135 is inserted: D02161
NOTICE:  Drug1 Kegg id:  DB09137 is inserted: D06037
NOTICE:  Drug1 Kegg id:  DB09139 is inserted: D06041
NOTICE:  Drug1 Kegg id:  DB09142 is inserted: D05845
NOTICE:  Drug1 Kegg id:  DB09143 is inserted: D10119
NOTICE:  Drug1 Kegg id:  DB09148 is inserted: D10002
NOTICE:  Drug1 Kegg id:  DB09149 is inserted: D09617
NOTICE:  Drug1 Kegg id:  DB09154 is inserted: D05855
NOTICE:  Drug1 Kegg id:  DB09156 is inserted: D01893
NOTICE:  Drug1 Kegg id:  DB09161 is inserted: D01060
NOTICE:  Drug1 Kegg id:  DB09163 is inserted: D02284
NOTICE:  Drug1 Kegg id:  DB09166 is inserted: D01514
NOTICE:  Drug1 Kegg id:  DB09167 is inserted: D07872
NOTICE:  Drug1 Kegg id:  DB09185 is inserted: D08673
NOTICE:  Drug1 Kegg id:  DB09186 is inserted: D05173
NOTICE:  Drug1 Kegg id:  DB09187 is inserted: D04781
NOTICE:  Drug1 Kegg id:  DB09199 is inserted: D05150
NOTICE:  Drug1 Kegg id:  DB09201 is inserted: D03493
NOTICE:  Drug1 Kegg id:  DB09203 is inserted: D07148
NOTICE:  Drug1 Kegg id:  DB09204 is inserted: D07465
NOTICE:  Drug1 Kegg id:  DB09205 is inserted: D08239
NOTICE:  Drug1 Kegg id:  DB09208 is inserted: D09316
NOTICE:  Drug1 Kegg id:  DB09209 is inserted: D07385
NOTICE:  Drug1 Kegg id:  DB09211 is inserted: D02722
NOTICE:  Drug1 Kegg id:  DB09212 is inserted: D08149
NOTICE:  Drug1 Kegg id:  DB09213 is inserted: D03715
NOTICE:  Drug1 Kegg id:  DB09214 is inserted: D07269
NOTICE:  Drug1 Kegg id:  DB09215 is inserted: D07267
NOTICE:  Drug1 Kegg id:  DB09216 is inserted: D01183
NOTICE:  Drug1 Kegg id:  DB09217 is inserted: D03712
NOTICE:  Drug1 Kegg id:  DB09218 is inserted: D03555
NOTICE:  Drug1 Kegg id:  DB09220 is inserted: D01810
NOTICE:  Drug1 Kegg id:  DB09221 is inserted: D01611
NOTICE:  Drug1 Kegg id:  DB09223 is inserted: D01176
NOTICE:  Drug1 Kegg id:  DB09224 is inserted: D07309
NOTICE:  Drug1 Kegg id:  DB09225 is inserted: D01321
NOTICE:  Drug1 Kegg id:  DB09229 is inserted: D01562
NOTICE:  Drug1 Kegg id:  DB09230 is inserted: D01145
NOTICE:  Drug1 Kegg id:  DB09232 is inserted: D01173
NOTICE:  Drug1 Kegg id:  DB09236 is inserted: D04657
NOTICE:  Drug1 Kegg id:  DB09242 is inserted: D05087
NOTICE:  Drug1 Kegg id:  DB09244 is inserted: D08392
NOTICE:  Drug1 Kegg id:  DB09245 is inserted: D02559
NOTICE:  Drug1 Kegg id:  DB09247 is inserted: D07338
NOTICE:  Drug1 Kegg id:  DB09255 is inserted: D00060
NOTICE:  Drug1 Kegg id:  DB09256 is inserted: D01244
NOTICE:  Drug1 Kegg id:  DB09257 is inserted: D01846
NOTICE:  Drug1 Kegg id:  DB09259 is inserted: D03337
NOTICE:  Drug1 Kegg id:  DB09264 is inserted: D10741
NOTICE:  Drug1 Kegg id:  DB09265 is inserted: D09729
NOTICE:  Drug1 Kegg id:  DB09270 is inserted: D01065
NOTICE:  Drug1 Kegg id:  DB09271 is inserted: D07099
NOTICE:  Drug1 Kegg id:  DB09272 is inserted: D10403
NOTICE:  Drug1 Kegg id:  DB09273 is inserted: D03898
NOTICE:  Drug1 Kegg id:  DB09280 is inserted: D10134
NOTICE:  Drug1 Kegg id:  DB09281 is inserted: D03271
NOTICE:  Drug1 Kegg id:  DB09282 is inserted: D01320
NOTICE:  Drug1 Kegg id:  DB09285 is inserted: D05078
NOTICE:  Drug1 Kegg id:  DB09286 is inserted: D02622
NOTICE:  Drug1 Kegg id:  DB09287 is inserted: D03370
NOTICE:  Drug1 Kegg id:  DB09288 is inserted: D07294
NOTICE:  Drug1 Kegg id:  DB09289 is inserted: D02575
NOTICE:  Drug1 Kegg id:  DB09290 is inserted: D08466
NOTICE:  Drug1 Kegg id:  DB09291 is inserted: D10742
NOTICE:  Drug1 Kegg id:  DB09292 is inserted: D10225
NOTICE:  Drug1 Kegg id:  DB09295 is inserted: D02701
NOTICE:  Drug1 Kegg id:  DB09296 is inserted: D10745
NOTICE:  Drug1 Kegg id:  DB09298 is inserted: D08515
NOTICE:  Drug1 Kegg id:  DB09300 is inserted: D01451
NOTICE:  Drug1 Kegg id:  DB09301 is inserted: D00080
NOTICE:  Drug1 Kegg id:  DB09302 is inserted: D10335
NOTICE:  Drug1 Kegg id:  DB09303 is inserted: D10557
NOTICE:  Drug1 Kegg id:  DB09304 is inserted: D08511
NOTICE:  Drug1 Kegg id:  DB09310 is inserted: D10532
NOTICE:  Drug1 Kegg id:  DB09311 is inserted: D03306
NOTICE:  Drug1 Kegg id:  DB09312 is inserted: D08808
NOTICE:  Drug1 Kegg id:  DB09318 is inserted: D05987
NOTICE:  Drug1 Kegg id:  DB09321 is inserted: D01170
NOTICE:  Drug1 Kegg id:  DB09357 is inserted: D00193
NOTICE:  Drug1 Kegg id:  DB09369 is inserted: D07434
NOTICE:  Drug1 Kegg id:  DB09371 is inserted: D05207
NOTICE:  Drug1 Kegg id:  DB09374 is inserted: D01342
NOTICE:  Drug1 Kegg id:  DB09378 is inserted: D04227
NOTICE:  Drug1 Kegg id:  DB09389 is inserted: D00954
NOTICE:  Drug1 Kegg id:  DB09421 is inserted: D00176
NOTICE:  Drug1 Kegg id:  DB09462 is inserted: D00028
NOTICE:  Drug1 Kegg id:  DB09472 is inserted: D01732
NOTICE:  Drug1 Kegg id:  DB09477 is inserted: D03769
NOTICE:  Drug1 Kegg id:  DB09484 is inserted: D05864
NOTICE:  Drug1 Kegg id:  DB09488 is inserted: D02760
NOTICE:  Drug1 Kegg id:  DB09496 is inserted: D05225
NOTICE:  Drug1 Kegg id:  DB09527 is inserted: D02021
NOTICE:  Drug1 Kegg id:  DB09543 is inserted: D01087
NOTICE:  Drug1 Kegg id:  DB09559 is inserted: D10018
NOTICE:  Drug1 Kegg id:  DB09564 is inserted: D09727
NOTICE:  Drug1 Kegg id:  DB09570 is inserted: D10130
NOTICE:  Drug1 Kegg id:  DB11085 is inserted: D00133
NOTICE:  Drug1 Kegg id:  DB11089 is inserted: D00305
NOTICE:  Drug1 Kegg id:  DB11100 is inserted: D00121
NOTICE:  Drug1 Kegg id:  DB11107 is inserted: D01561
NOTICE:  Drug1 Kegg id:  DB11121 is inserted: D03473
NOTICE:  Drug1 Kegg id:  DB11153 is inserted: D01168
NOTICE:  Drug1 Kegg id:  DB11156 is inserted: D08451
NOTICE:  Drug1 Kegg id:  DB11228 is inserted: D04996
NOTICE:  Drug1 Kegg id:  DB11312 is inserted: D08796
NOTICE:  Drug1 Kegg id:  DB11362 is inserted: D09994
NOTICE:  Drug1 Kegg id:  DB11363 is inserted: D10542
NOTICE:  Drug1 Kegg id:  DB11364 is inserted: D07261
NOTICE:  Drug1 Kegg id:  DB11371 is inserted: D07282
NOTICE:  Drug1 Kegg id:  DB11372 is inserted: D02840
NOTICE:  Drug1 Kegg id:  DB11373 is inserted: D02380
NOTICE:  Drug1 Kegg id:  DB11376 is inserted: D02620
NOTICE:  Drug1 Kegg id:  DB11389 is inserted: D03565
NOTICE:  Drug1 Kegg id:  DB11390 is inserted: D07750
NOTICE:  Drug1 Kegg id:  DB11397 is inserted: D03791
NOTICE:  Drug1 Kegg id:  DB11404 is inserted: D02473
NOTICE:  Drug1 Kegg id:  DB11405 is inserted: D04037
NOTICE:  Drug1 Kegg id:  DB11411 is inserted: D04160
NOTICE:  Drug1 Kegg id:  DB11412 is inserted: D07950
NOTICE:  Drug1 Kegg id:  DB11425 is inserted: D08151
NOTICE:  Drug1 Kegg id:  DB11428 is inserted: D08165
NOTICE:  Drug1 Kegg id:  DB11429 is inserted: D05025
NOTICE:  Drug1 Kegg id:  DB11443 is inserted: D08299
NOTICE:  Drug1 Kegg id:  DB11447 is inserted: D02601
NOTICE:  Drug1 Kegg id:  DB11448 is inserted: D08372
NOTICE:  Drug1 Kegg id:  DB11454 is inserted: D05642
NOTICE:  Drug1 Kegg id:  DB11461 is inserted: D05948
NOTICE:  Drug1 Kegg id:  DB11463 is inserted: D05951
NOTICE:  Drug1 Kegg id:  DB11464 is inserted: D05952
NOTICE:  Drug1 Kegg id:  DB11466 is inserted: D06075
NOTICE:  Drug1 Kegg id:  DB11471 is inserted: D02492
NOTICE:  Drug1 Kegg id:  DB11473 is inserted: D00805
NOTICE:  Drug1 Kegg id:  DB11475 is inserted: D02490
NOTICE:  Drug1 Kegg id:  DB11477 is inserted: D08683
NOTICE:  Drug1 Kegg id:  DB11478 is inserted: D06362
NOTICE:  Drug1 Kegg id:  DB11481 is inserted: D03002
NOTICE:  Drug1 Kegg id:  DB11490 is inserted: D08247
NOTICE:  Drug1 Kegg id:  DB11511 is inserted: D07828
NOTICE:  Drug1 Kegg id:  DB11512 is inserted: D07840
NOTICE:  Drug1 Kegg id:  DB11518 is inserted: D04215
NOTICE:  Drug1 Kegg id:  DB11537 is inserted: D08391
NOTICE:  Drug1 Kegg id:  DB11543 is inserted: D08487
NOTICE:  Drug1 Kegg id:  DB11549 is inserted: D08596
NOTICE:  Drug1 Kegg id:  DB11552 is inserted: D08632
NOTICE:  Drug1 Kegg id:  DB11556 is inserted: D07795
NOTICE:  Drug1 Kegg id:  DB11560 is inserted: D09921
NOTICE:  Drug1 Kegg id:  DB11569 is inserted: D10071
NOTICE:  Drug1 Kegg id:  DB11576 is inserted: D04168
NOTICE:  Drug1 Kegg id:  DB11581 is inserted: D10679
NOTICE:  Drug1 Kegg id:  DB11582 is inserted: D07276
NOTICE:  Drug1 Kegg id:  DB11595 is inserted: D10773
NOTICE:  Drug1 Kegg id:  DB11596 is inserted: D04715
NOTICE:  Drug1 Kegg id:  DB11609 is inserted: D07384
NOTICE:  Drug1 Kegg id:  DB11616 is inserted: D01885
NOTICE:  Drug1 Kegg id:  DB11619 is inserted: D04317
NOTICE:  Drug1 Kegg id:  DB11622 is inserted: D01693
NOTICE:  Drug1 Kegg id:  DB11636 is inserted: D07222
NOTICE:  Drug1 Kegg id:  DB11644 is inserted: D09673
NOTICE:  Drug1 Kegg id:  DB11689 is inserted: D09666
NOTICE:  Drug1 Kegg id:  DB11712 is inserted: D11041
NOTICE:  Drug1 Kegg id:  DB11714 is inserted: D10808
NOTICE:  Drug1 Kegg id:  DB11730 is inserted: D10883
NOTICE:  Drug1 Kegg id:  DB11776 is inserted: D10061
NOTICE:  Drug1 Kegg id:  DB11817 is inserted: D10308
NOTICE:  Drug1 Kegg id:  DB11823 is inserted: D07283
NOTICE:  Drug1 Kegg id:  DB11921 is inserted: D03671
NOTICE:  Drug1 Kegg id:  DB11952 is inserted: D10555
NOTICE:  Drug1 Kegg id:  DB11963 is inserted: D09883
NOTICE:  Drug1 Kegg id:  DB11988 is inserted: D05218
NOTICE:  Drug1 Kegg id:  DB12202 is inserted: D10031
NOTICE:  Drug1 Kegg id:  DB12243 is inserted: D01552
NOTICE:  Drug1 Kegg id:  DB12245 is inserted: D07364
NOTICE:  Drug1 Kegg id:  DB12278 is inserted: D08441
NOTICE:  Drug1 Kegg id:  DB12319 is inserted: D01056
NOTICE:  Drug1 Kegg id:  DB12332 is inserted: D10079
NOTICE:  Drug1 Kegg id:  DB12712 is inserted: D08377
NOTICE:  Drug1 Kegg id:  DB12770 is inserted: D01131
NOTICE:  Drug1 Kegg id:  DB12783 is inserted: D03082
NOTICE:  Drug1 Kegg id:  DB12877 is inserted: D01773
NOTICE:  Drug1 Kegg id:  DB12942 is inserted: D08266
NOTICE:  Drug1 Kegg id:  DB12947 is inserted: D01309
NOTICE:  Drug1 Kegg id:  DB13025 is inserted: D08590
NOTICE:  Drug1 Kegg id:  DB13074 is inserted: D10563
NOTICE:  Drug1 Kegg id:  DB13139 is inserted: D08124
NOTICE:  Drug1 Kegg id:  DB13145 is inserted: D01416
NOTICE:  Drug1 Kegg id:  DB13156 is inserted: D01995
NOTICE:  Drug1 Kegg id:  DB13158 is inserted: D07717
NOTICE:  Drug1 Kegg id:  DB13166 is inserted: D08688
NOTICE:  Drug1 Kegg id:  DB13167 is inserted: D01252
NOTICE:  Drug1 Kegg id:  DB13178 is inserted: D08079
NOTICE:  Drug1 Kegg id:  DB13209 is inserted: D01642
NOTICE:  Drug1 Kegg id:  DB13217 is inserted: D01975
NOTICE:  Drug1 Kegg id:  DB13223 is inserted: D07972
NOTICE:  Drug1 Kegg id:  DB13232 is inserted: D01289
NOTICE:  Drug1 Kegg id:  DB13233 is inserted: D02787
NOTICE:  Drug1 Kegg id:  DB13264 is inserted: D07233
NOTICE:  Drug1 Kegg id:  DB13266 is inserted: D02406
NOTICE:  Drug1 Kegg id:  DB13314 is inserted: D01513
NOTICE:  Drug1 Kegg id:  DB13328 is inserted: D07284
NOTICE:  Drug1 Kegg id:  DB13345 is inserted: D07834
NOTICE:  Drug1 Kegg id:  DB13346 is inserted: D01271
NOTICE:  Drug1 Kegg id:  DB13362 is inserted: D01190
NOTICE:  Drug1 Kegg id:  DB13381 is inserted: D07145
NOTICE:  Drug1 Kegg id:  DB13399 is inserted: D01348
NOTICE:  Drug1 Kegg id:  DB13443 is inserted: D01471
NOTICE:  Drug1 Kegg id:  DB13452 is inserted: D01804
NOTICE:  Drug1 Kegg id:  DB13470 is inserted: D07643
NOTICE:  Drug1 Kegg id:  DB13504 is inserted: D03424
NOTICE:  Drug1 Kegg id:  DB13520 is inserted: D07218
NOTICE:  Drug1 Kegg id:  DB13524 is inserted: D01380
NOTICE:  Drug1 Kegg id:  DB13527 is inserted: D08427
NOTICE:  Drug1 Kegg id:  DB13544 is inserted: D01466
NOTICE:  Drug1 Kegg id:  DB13595 is inserted: D07419
NOTICE:  Drug1 Kegg id:  DB13616 is inserted: D07143
NOTICE:  Drug1 Kegg id:  DB13620 is inserted: D01298
NOTICE:  Drug1 Kegg id:  DB13627 is inserted: D02301
NOTICE:  Drug1 Kegg id:  DB13667 is inserted: D01052
NOTICE:  Drug1 Kegg id:  DB13682 is inserted: D07649
NOTICE:  Drug1 Kegg id:  DB13699 is inserted: D07239
NOTICE:  Drug1 Kegg id:  DB13739 is inserted: D05406
NOTICE:  Drug1 Kegg id:  DB13757 is inserted: D06646
NOTICE:  Drug1 Kegg id:  DB13772 is inserted: D02474
NOTICE:  Drug1 Kegg id:  DB13781 is inserted: D06328
NOTICE:  Drug1 Kegg id:  DB13783 is inserted: D01582
NOTICE:  Drug1 Kegg id:  DB13816 is inserted: D07469
NOTICE:  Drug1 Kegg id:  DB13836 is inserted: D07234
NOTICE:  Drug1 Kegg id:  DB13837 is inserted: D07327
NOTICE:  Drug1 Kegg id:  DB13841 is inserted: D02613
NOTICE:  Drug1 Kegg id:  DB13843 is inserted: D03561
NOTICE:  Drug1 Kegg id:  DB13857 is inserted: D07223
NOTICE:  Drug1 Kegg id:  DB13866 is inserted: D07939
NOTICE:  Drug1 Kegg id:  DB13867 is inserted: D07981
NOTICE:  Drug1 Kegg id:  DB13876 is inserted: D02560
NOTICE:  Drug1 Kegg id:  DB13909 is inserted: D01398
NOTICE:  Drug1 Kegg id:  DB13919 is inserted: D00522
NOTICE:  Drug1 Kegg id:  DB13943 is inserted: D00957
NOTICE:  Drug1 Kegg id:  DB13952 is inserted: D04061
NOTICE:  Drug1 Kegg id:  DB13954 is inserted: D04063
NOTICE:  Drug1 Kegg id:  DB13977 is inserted: D02038
NOTICE:  Drug1 Kegg id:  DB13981 is inserted: D08281
NOTICE:  Drug1 Kegg id:  DB13999 is inserted: D08232
NOTICE:  Drug1 Kegg id:  DB14004 is inserted: D10400
NOTICE:  Drug1 Kegg id:  DB14006 is inserted: D00810
NOTICE:  Drug1 Kegg id:  DB14011 is inserted: D09317
NOTICE:  Drug1 Kegg id:  DB14012 is inserted: D10913
NOTICE:  Drug1 Kegg id:  DB14025 is inserted: D02539
NOTICE:  Drug1 Kegg id:  DB14026 is inserted: D08586
NOTICE:  Drug1 Kegg id:  DB14027 is inserted: D09723
NOTICE:  Drug1 Kegg id:  DB14028 is inserted: D08283
NOTICE:  Drug1 Kegg id:  DB14039 is inserted: D10928
NOTICE:  Drug1 Kegg id:  DB14043 is inserted: D08328
NOTICE:  Drug1 Kegg id:  DB14125 is inserted: D03077
NOTICE:  Drug1 Kegg id:  DB14185 is inserted: D10364
NOTICE:  Drug1 Kegg id:  DB14207 is inserted: D03772
NOTICE:  Drug1 Kegg id:  DB14512 is inserted: D00690
NOTICE:  Drug1 Kegg id:  DB14539 is inserted: D00165
NOTICE:  Drug1 Kegg id:  DB14540 is inserted: D01619
NOTICE:  Drug1 Kegg id:  DB14541 is inserted: D00976
NOTICE:  Drug1 Kegg id:  DB14545 is inserted: D01442
NOTICE:  Drug1 Kegg id:  DB14646 is inserted: D08416
NOTICE:  Drug1 Kegg id:  DB14655 is inserted: D01534
NOTICE:  Drug1 Kegg id:  DB14659 is inserted: D04900
NOTICE:  Drug1 Kegg id:  DB14681 is inserted: D07749
NOTICE:  Drug1 Kegg id:  DB14719 is inserted: D03083
NOTICE:  Drug2 RxCUI:  DB06595 is inserted: D05029
NOTICE:  Drug2 RxCUI:  DB09256 is inserted: D01244
NOTICE:  Drug2 RxCUI:  DB06681 is inserted: D03222
NOTICE:  Drug2 RxCUI:  DB00543 is inserted: D00228
NOTICE:  Drug2 RxCUI:  DB01621 is inserted: D08385
NOTICE:  Drug2 RxCUI:  DB00773 is inserted: D00125
NOTICE:  Drug2 RxCUI:  DB06616 is inserted: D03252
NOTICE:  Drug2 RxCUI:  DB13232 is inserted: D01289
NOTICE:  Drug2 RxCUI:  DB00708 is inserted: D05938
NOTICE:  Drug2 RxCUI:  DB00654 is inserted: D00356
NOTICE:  Drug2 RxCUI:  DB01009 is inserted: D00132
NOTICE:  Drug2 RxCUI:  DB01367 is inserted: D08469
NOTICE:  Drug2 RxCUI:  DB00542 is inserted: D07499
NOTICE:  Drug2 RxCUI:  DB02789 is inserted: D00143
NOTICE:  Drug2 RxCUI:  DB09106 is inserted: D03335
NOTICE:  Drug2 RxCUI:  DB06611 is inserted: D05393
NOTICE:  Drug2 RxCUI:  DB00461 is inserted: D00425
NOTICE:  Drug2 RxCUI:  DB00977 is inserted: D00554
NOTICE:  Drug2 RxCUI:  DB02187 is inserted: D04041
NOTICE:  Drug2 RxCUI:  DB09389 is inserted: D00954
NOTICE:  Drug2 RxCUI:  DB09048 is inserted: D10572
NOTICE:  Drug2 RxCUI:  DB01169 is inserted: D02106
NOTICE:  Drug2 RxCUI:  DB09045 is inserted: D09889
NOTICE:  Drug2 RxCUI:  DB01102 is inserted: D02976
NOTICE:  Drug2 RxCUI:  DB07615 is inserted: D02027
NOTICE:  Drug2 RxCUI:  DB08991 is inserted: D01394
NOTICE:  Drug2 RxCUI:  DB13145 is inserted: D01416
NOTICE:  Drug2 RxCUI:  DB00941 is inserted: D04435
NOTICE:  Drug2 RxCUI:  DB04842 is inserted: D02629
NOTICE:  Drug2 RxCUI:  DB14740 is inserted: D04456
NOTICE:  Drug2 RxCUI:  DB00006 is inserted: D03136
NOTICE:  Drug2 RxCUI:  DB01151 is inserted: D07791
NOTICE:  Drug2 RxCUI:  DB00665 is inserted: D00965
NOTICE:  Drug2 RxCUI:  DB00459 is inserted: D02754
NOTICE:  Drug2 RxCUI:  DB08899 is inserted: D10218
NOTICE:  Drug2 RxCUI:  DB05271 is inserted: D05768
NOTICE:  Drug2 RxCUI:  DB13816 is inserted: D07469
NOTICE:  Drug2 RxCUI:  DB01597 is inserted: D07698
NOTICE:  Drug2 RxCUI:  DB01320 is inserted: D07993
NOTICE:  Drug2 RxCUI:  DB08313 is inserted: D05197
NOTICE:  Drug2 RxCUI:  DB00636 is inserted: D00279
NOTICE:  Drug2 RxCUI:  DB11404 is inserted: D02473
NOTICE:  Drug2 RxCUI:  DB00983 is inserted: D07990
NOTICE:  Drug2 RxCUI:  DB01588 is inserted: D00470
NOTICE:  Drug2 RxCUI:  DB00963 is inserted: D07541
NOTICE:  Drug2 RxCUI:  DB06825 is inserted: D06247
NOTICE:  Drug2 RxCUI:  DB00244 is inserted: D00377
NOTICE:  Drug2 RxCUI:  DB01182 is inserted: D08435
NOTICE:  Drug2 RxCUI:  DB00313 is inserted: D00399
NOTICE:  Drug2 RxCUI:  DB00820 is inserted: D02008
NOTICE:  Drug2 RxCUI:  DB00026 is inserted: D02934
NOTICE:  Drug2 RxCUI:  DB00223 is inserted: D07827
NOTICE:  Drug2 RxCUI:  DB08896 is inserted: D10138
NOTICE:  Drug2 RxCUI:  DB03209 is inserted: D06399
NOTICE:  Drug2 RxCUI:  DB11410 is inserted: D04140
NOTICE:  Drug2 RxCUI:  DB01274 is inserted: D07463
NOTICE:  Drug2 RxCUI:  DB00842 is inserted: D00464
NOTICE:  Drug2 RxCUI:  DB01426 is inserted: D00199
NOTICE:  Drug2 RxCUI:  DB00463 is inserted: D01382
NOTICE:  Drug2 RxCUI:  DB00254 is inserted: D07876
NOTICE:  Drug2 RxCUI:  DB01551 is inserted: D01481
NOTICE:  Drug2 RxCUI:  DB09049 is inserted: D10479
NOTICE:  Drug2 RxCUI:  DB14719 is inserted: D03083
NOTICE:  Drug2 RxCUI:  DB00273 is inserted: D00537
NOTICE:  Drug2 RxCUI:  DB01013 is inserted: D01272
NOTICE:  Drug2 RxCUI:  DB01427 is inserted: D00231
NOTICE:  Drug2 RxCUI:  DB08836 is inserted: D08566
NOTICE:  Drug2 RxCUI:  DB01138 is inserted: D00449
NOTICE:  Drug2 RxCUI:  DB01041 is inserted: D00754
NOTICE:  Drug2 RxCUI:  DB08947 is inserted: D01797
NOTICE:  Drug2 RxCUI:  DB09357 is inserted: D00193
NOTICE:  Drug2 RxCUI:  DB11468 is inserted: D06127
NOTICE:  Drug2 RxCUI:  DB00859 is inserted: D00496
NOTICE:  Drug2 RxCUI:  DB09223 is inserted: D01176
NOTICE:  Drug2 RxCUI:  DB13452 is inserted: D01804
NOTICE:  Drug2 RxCUI:  DB09273 is inserted: D03898
NOTICE:  Drug2 RxCUI:  DB11622 is inserted: D01693
NOTICE:  Drug2 RxCUI:  DB01180 is inserted: D00198
NOTICE:  Drug2 RxCUI:  DB01185 is inserted: D00327
NOTICE:  Drug2 RxCUI:  DB08949 is inserted: D01813
NOTICE:  Drug2 RxCUI:  DB08895 is inserted: D09970
NOTICE:  Drug2 RxCUI:  DB00966 is inserted: D00627
NOTICE:  Drug2 RxCUI:  DB00306 is inserted: D06887
NOTICE:  Drug2 RxCUI:  DB06151 is inserted: D00221
NOTICE:  Drug2 RxCUI:  DB11362 is inserted: D09994
NOTICE:  Drug2 RxCUI:  DB08870 is inserted: D09587
NOTICE:  Drug2 RxCUI:  DB06813 is inserted: D05589
NOTICE:  Drug2 RxCUI:  DB00474 is inserted: D04985
NOTICE:  Drug2 RxCUI:  DB11464 is inserted: D05952
NOTICE:  Drug2 RxCUI:  DB00732 is inserted: D00758
NOTICE:  Drug2 RxCUI:  DB01276 is inserted: D04121
NOTICE:  Drug2 RxCUI:  DB11100 is inserted: D00121
NOTICE:  Drug2 RxCUI:  DB00486 is inserted: D05099
NOTICE:  Drug2 RxCUI:  DB09069 is inserted: D01606
NOTICE:  Drug2 RxCUI:  DB06702 is inserted: D07226
NOTICE:  Drug2 RxCUI:  DB06440 is inserted: D02556
NOTICE:  Drug2 RxCUI:  DB09186 is inserted: D05173
NOTICE:  Drug2 RxCUI:  DB00956 is inserted: D08045
NOTICE:  Drug2 RxCUI:  DB06228 is inserted: D07086
NOTICE:  Drug2 RxCUI:  DB09559 is inserted: D10018
NOTICE:  Drug2 RxCUI:  DB01429 is inserted: D01326
NOTICE:  Drug2 RxCUI:  DB01283 is inserted: D03714
NOTICE:  Drug2 RxCUI:  DB09053 is inserted: D10223
NOTICE:  Drug2 RxCUI:  DB00794 is inserted: D00474
NOTICE:  Drug2 RxCUI:  DB09046 is inserted: D05014
NOTICE:  Drug2 RxCUI:  DB13977 is inserted: D02038
NOTICE:  Drug2 RxCUI:  DB05773 is inserted: D09980
NOTICE:  Drug2 RxCUI:  DB13919 is inserted: D00522
NOTICE:  Drug2 RxCUI:  DB01168 is inserted: D08423
NOTICE:  Drug2 RxCUI:  DB08820 is inserted: D09916
NOTICE:  Drug2 RxCUI:  DB06781 is inserted: D01266
NOTICE:  Drug2 RxCUI:  DB01214 is inserted: D02374
NOTICE:  Drug2 RxCUI:  DB04570 is inserted: D08109
NOTICE:  Drug2 RxCUI:  DB00959 is inserted: D00407
NOTICE:  Drug2 RxCUI:  DB01195 is inserted: D07962
NOTICE:  Drug2 RxCUI:  DB09527 is inserted: D02021
NOTICE:  Drug2 RxCUI:  DB00443 is inserted: D00244
NOTICE:  Drug2 RxCUI:  DB00913 is inserted: D02941
NOTICE:  Drug2 RxCUI:  DB00699 is inserted: D01290
NOTICE:  Drug2 RxCUI:  DB01406 is inserted: D00289
NOTICE:  Drug2 RxCUI:  DB11463 is inserted: D05951
NOTICE:  Drug2 RxCUI:  DB08877 is inserted: D09959
NOTICE:  Drug2 RxCUI:  DB08819 is inserted: D06274
NOTICE:  Drug2 RxCUI:  DB08958 is inserted: D07068
NOTICE:  Drug2 RxCUI:  DB00836 is inserted: D08144
NOTICE:  Drug2 RxCUI:  DB00850 is inserted: D00503
NOTICE:  Drug2 RxCUI:  DB00549 is inserted: D00411
NOTICE:  Drug2 RxCUI:  DB00694 is inserted: D07776
NOTICE:  Drug2 RxCUI:  DB09185 is inserted: D08673
NOTICE:  Drug2 RxCUI:  DB00126 is inserted: D00018
NOTICE:  Drug2 RxCUI:  DB00722 is inserted: D00362
NOTICE:  Drug2 RxCUI:  DB09293 is inserted: D02259
NOTICE:  Drug2 RxCUI:  DB08962 is inserted: D02427
NOTICE:  Drug2 RxCUI:  DB09205 is inserted: D08239
NOTICE:  Drug2 RxCUI:  DB00876 is inserted: D04040
NOTICE:  Drug2 RxCUI:  DB00962 is inserted: D00530
NOTICE:  Drug2 RxCUI:  DB11085 is inserted: D00133
NOTICE:  Drug2 RxCUI:  DB00318 is inserted: D03580
NOTICE:  Drug2 RxCUI:  DB00624 is inserted: D00075
NOTICE:  Drug2 RxCUI:  DB00847 is inserted: D03634
NOTICE:  Drug2 RxCUI:  DB00997 is inserted: D03899
NOTICE:  Drug2 RxCUI:  DB01248 is inserted: D02165
NOTICE:  Drug2 RxCUI:  DB06707 is inserted: D02388
NOTICE:  Drug2 RxCUI:  DB01108 is inserted: D01180
NOTICE:  Drug2 RxCUI:  DB08824 is inserted: D10014
NOTICE:  Drug2 RxCUI:  DB00758 is inserted: D00769
NOTICE:  Drug2 RxCUI:  DB05812 is inserted: D09701
NOTICE:  Drug2 RxCUI:  DB00187 is inserted: D07916
NOTICE:  Drug2 RxCUI:  DB00302 is inserted: D01136
NOTICE:  Drug2 RxCUI:  DB00291 is inserted: D00266
NOTICE:  Drug2 RxCUI:  DB09133 is inserted: D01258
NOTICE:  Drug2 RxCUI:  DB01192 is inserted: D08323
NOTICE:  Drug2 RxCUI:  DB11776 is inserted: D10061
NOTICE:  Drug2 RxCUI:  DB00424 is inserted: D00147
NOTICE:  Drug2 RxCUI:  DB09245 is inserted: D02559
NOTICE:  Drug2 RxCUI:  DB06719 is inserted: D01831
NOTICE:  Drug2 RxCUI:  DB08805 is inserted: D05004
NOTICE:  Drug2 RxCUI:  DB06809 is inserted: D08971
NOTICE:  Drug2 RxCUI:  DB11730 is inserted: D10883
NOTICE:  Drug2 RxCUI:  DB01340 is inserted: D07699
NOTICE:  Drug2 RxCUI:  DB00924 is inserted: D07758
NOTICE:  Drug2 RxCUI:  DB00182 is inserted: D07445
NOTICE:  Drug2 RxCUI:  DB00175 is inserted: D08410
NOTICE:  Drug2 RxCUI:  DB01236 is inserted: D00547
NOTICE:  Drug2 RxCUI:  DB04953 is inserted: D09569
NOTICE:  Drug2 RxCUI:  DB08905 is inserted: D07260
NOTICE:  Drug2 RxCUI:  DB00982 is inserted: D00348
NOTICE:  Drug2 RxCUI:  DB06637 is inserted: D04127
NOTICE:  Drug2 RxCUI:  DB09018 is inserted: D07101
NOTICE:  Drug2 RxCUI:  DB01431 is inserted: D01374
NOTICE:  Drug2 RxCUI:  DB00363 is inserted: D00283
NOTICE:  Drug2 RxCUI:  DB09278 is inserted: D03251
NOTICE:  Drug2 RxCUI:  DB04831 is inserted: D02386
NOTICE:  Drug2 RxCUI:  DB01324 is inserted: D00657
NOTICE:  Drug2 RxCUI:  DB01275 is inserted: D08044
NOTICE:  Drug2 RxCUI:  DB01219 is inserted: D02347
NOTICE:  Drug2 RxCUI:  DB00673 is inserted: D02968
NOTICE:  Drug2 RxCUI:  DB13156 is inserted: D01995
NOTICE:  Drug2 RxCUI:  DB14207 is inserted: D03772
NOTICE:  Drug2 RxCUI:  DB00370 is inserted: D00563
NOTICE:  Drug2 RxCUI:  DB01284 is inserted: D00284
NOTICE:  Drug2 RxCUI:  DB08893 is inserted: D09535
NOTICE:  Drug2 RxCUI:  DB01036 is inserted: D00646
NOTICE:  Drug2 RxCUI:  DB01095 is inserted: D07983
NOTICE:  Drug2 RxCUI:  DB00605 is inserted: D00120
NOTICE:  Drug2 RxCUI:  DB11714 is inserted: D10808
NOTICE:  Drug2 RxCUI:  DB09020 is inserted: D00245
NOTICE:  Drug2 RxCUI:  DB00661 is inserted: D02356
NOTICE:  Drug2 RxCUI:  DB01029 is inserted: D00523
NOTICE:  Drug2 RxCUI:  DB08867 is inserted: D09567
NOTICE:  Drug2 RxCUI:  DB13520 is inserted: D07218
NOTICE:  Drug2 RxCUI:  DB11432 is inserted: D05122
NOTICE:  Drug2 RxCUI:  DB00284 is inserted: D00216
NOTICE:  Drug2 RxCUI:  DB06215 is inserted: D04177
NOTICE:  Drug2 RxCUI:  DB01194 is inserted: D00652
NOTICE:  Drug2 RxCUI:  DB01001 is inserted: D02147
NOTICE:  Drug2 RxCUI:  DB00647 is inserted: D07809
NOTICE:  Drug2 RxCUI:  DB00938 is inserted: D05792
NOTICE:  Drug2 RxCUI:  DB11471 is inserted: D02492
NOTICE:  Drug2 RxCUI:  DB08938 is inserted: D04832
NOTICE:  Drug2 RxCUI:  DB01250 is inserted: D00727
NOTICE:  Drug2 RxCUI:  DB00575 is inserted: D00281
NOTICE:  Drug2 RxCUI:  DB00255 is inserted: D00577
NOTICE:  Drug2 RxCUI:  DB11552 is inserted: D08632
NOTICE:  Drug2 RxCUI:  DB09284 is inserted: D07159
NOTICE:  Drug2 RxCUI:  DB00389 is inserted: D07616
NOTICE:  Drug2 RxCUI:  DB05885 is inserted: D05817
NOTICE:  Drug2 RxCUI:  DB00921 is inserted: D07132
NOTICE:  Drug2 RxCUI:  DB01247 is inserted: D02580
NOTICE:  Drug2 RxCUI:  DB08878 is inserted: D02527
NOTICE:  Drug2 RxCUI:  DB08439 is inserted: D02709
NOTICE:  Drug2 RxCUI:  DB01466 is inserted: D07929
NOTICE:  Drug2 RxCUI:  DB09462 is inserted: D00028
NOTICE:  Drug2 RxCUI:  DB00333 is inserted: D08195
NOTICE:  Drug2 RxCUI:  DB05288 is inserted: D01733
NOTICE:  Drug2 RxCUI:  DB06589 is inserted: D05380
NOTICE:  Drug2 RxCUI:  DB01046 is inserted: D04790
NOTICE:  Drug2 RxCUI:  DB00275 is inserted: D01204
NOTICE:  Drug2 RxCUI:  DB13843 is inserted: D03561
NOTICE:  Drug2 RxCUI:  DB00361 is inserted: D08680
NOTICE:  Drug2 RxCUI:  DB09039 is inserted: D09893
NOTICE:  Drug2 RxCUI:  DB00668 is inserted: D00095
NOTICE:  Drug2 RxCUI:  DB01121 is inserted: D00504
NOTICE:  Drug2 RxCUI:  DB00992 is inserted: D08204
NOTICE:  Drug2 RxCUI:  DB01146 is inserted: D07862
NOTICE:  Drug2 RxCUI:  DB01104 is inserted: D02360
NOTICE:  Drug2 RxCUI:  DB00376 is inserted: D08638
NOTICE:  Drug2 RxCUI:  DB08932 is inserted: D10135
NOTICE:  Drug2 RxCUI:  DB06716 is inserted: D04257
NOTICE:  Drug2 RxCUI:  DB09167 is inserted: D07872
NOTICE:  Drug2 RxCUI:  DB11595 is inserted: D10773
NOTICE:  Drug2 RxCUI:  DB01242 is inserted: D00811
NOTICE:  Drug2 RxCUI:  DB04920 is inserted: D08892
NOTICE:  Drug2 RxCUI:  DB14077 is inserted: D02189
NOTICE:  Drug2 RxCUI:  DB00458 is inserted: D08070
NOTICE:  Drug2 RxCUI:  DB01176 is inserted: D03621
NOTICE:  Drug2 RxCUI:  DB11454 is inserted: D05642
NOTICE:  Drug2 RxCUI:  DB00852 is inserted: D08449
NOTICE:  Drug2 RxCUI:  DB00780 is inserted: D08349
NOTICE:  Drug2 RxCUI:  DB13871 is inserted: D07106
NOTICE:  Drug2 RxCUI:  DB08913 is inserted: D10398
NOTICE:  Drug2 RxCUI:  DB09074 is inserted: D09730
NOTICE:  Drug2 RxCUI:  DB09021 is inserted: D03089
NOTICE:  Drug2 RxCUI:  DB12202 is inserted: D10031
NOTICE:  Drug2 RxCUI:  DB09083 is inserted: D07165
NOTICE:  Drug2 RxCUI:  DB02546 is inserted: D06320
NOTICE:  Drug2 RxCUI:  DB00839 is inserted: D00379
NOTICE:  Drug2 RxCUI:  DB01377 is inserted: D01167
NOTICE:  Drug2 RxCUI:  DB00511 is inserted: D06881
NOTICE:  Drug2 RxCUI:  DB01158 is inserted: D00645
NOTICE:  Drug2 RxCUI:  DB00861 is inserted: D00130
NOTICE:  Drug2 RxCUI:  DB09281 is inserted: D03271
NOTICE:  Drug2 RxCUI:  DB00075 is inserted: D05092
NOTICE:  Drug2 RxCUI:  DB09035 is inserted: D10316
NOTICE:  Drug2 RxCUI:  DB04938 is inserted: D08958
NOTICE:  Drug2 RxCUI:  DB00677 is inserted: D00043
NOTICE:  Drug2 RxCUI:  DB11466 is inserted: D06075
NOTICE:  Drug2 RxCUI:  DB00902 is inserted: D04979
NOTICE:  Drug2 RxCUI:  DB08906 is inserted: D06315
NOTICE:  Drug2 RxCUI:  DB00391 is inserted: D01226
NOTICE:  Drug2 RxCUI:  DB00208 is inserted: D08594
NOTICE:  Drug2 RxCUI:  DB09054 is inserted: D10560
NOTICE:  Drug2 RxCUI:  DB01205 is inserted: D00697
NOTICE:  Drug2 RxCUI:  DB06684 is inserted: D09698
NOTICE:  Drug2 RxCUI:  DB06766 is inserted: D06552
NOTICE:  Drug2 RxCUI:  DB00949 is inserted: D00536
NOTICE:  Drug2 RxCUI:  DB09148 is inserted: D10002
NOTICE:  Drug2 RxCUI:  DB00288 is inserted: D01387
NOTICE:  Drug2 RxCUI:  DB09217 is inserted: D03712
NOTICE:  Drug2 RxCUI:  DB09070 is inserted: D01639
NOTICE:  Drug2 RxCUI:  DB09212 is inserted: D08149
NOTICE:  Drug2 RxCUI:  DB11312 is inserted: D08796
NOTICE:  Drug2 RxCUI:  DB06605 is inserted: D03213
NOTICE:  Drug2 RxCUI:  DB06695 is inserted: D07144
NOTICE:  Drug2 RxCUI:  DB03783 is inserted: D00569
NOTICE:  Drug2 RxCUI:  DB01783 is inserted: D07413
NOTICE:  Drug2 RxCUI:  DB06196 is inserted: D04492
NOTICE:  Drug2 RxCUI:  DB00867 is inserted: D02359
NOTICE:  Drug2 RxCUI:  DB08935 is inserted: D09321
NOTICE:  Drug2 RxCUI:  DB00653 is inserted: D01108
NOTICE:  Drug2 RxCUI:  DB11590 is inserted: D00864
NOTICE:  Drug2 RxCUI:  DB00640 is inserted: D00045
NOTICE:  Drug2 RxCUI:  DB08911 is inserted: D10175
NOTICE:  Drug2 RxCUI:  DB01583 is inserted: D00361
NOTICE:  Drug2 RxCUI:  DB00557 is inserted: D08054
NOTICE:  Drug2 RxCUI:  DB01033 is inserted: D04931
NOTICE:  Drug2 RxCUI:  DB13682 is inserted: D07649
NOTICE:  Drug2 RxCUI:  DB01267 is inserted: D05339
NOTICE:  Drug2 RxCUI:  DB05676 is inserted: D08860
NOTICE:  Drug2 RxCUI:  DB01558 is inserted: D01245
NOTICE:  Drug2 RxCUI:  DB00287 is inserted: D01964
NOTICE:  Drug2 RxCUI:  DB01357 is inserted: D00575
NOTICE:  Drug2 RxCUI:  DB06736 is inserted: D01545
NOTICE:  Drug2 RxCUI:  DB01204 is inserted: D08224
NOTICE:  Drug2 RxCUI:  DB08918 is inserted: D10072
NOTICE:  Drug2 RxCUI:  DB11582 is inserted: D07276
NOTICE:  Drug2 RxCUI:  DB14185 is inserted: D10364
NOTICE:  Drug2 RxCUI:  DB04880 is inserted: D04004
NOTICE:  Drug2 RxCUI:  DB06810 is inserted: D00468
NOTICE:  Drug2 RxCUI:  DB00155 is inserted: D07706
NOTICE:  Drug2 RxCUI:  DB00307 is inserted: D03106
NOTICE:  Drug2 RxCUI:  DB13443 is inserted: D01471
NOTICE:  Drug2 RxCUI:  DB11156 is inserted: D08451
NOTICE:  Drug2 RxCUI:  DB00620 is inserted: D00385
NOTICE:  Drug2 RxCUI:  DB01008 is inserted: D00248
NOTICE:  Drug2 RxCUI:  DB09153 is inserted: D02056
NOTICE:  Drug2 RxCUI:  DB01043 is inserted: D08174
NOTICE:  Drug2 RxCUI:  DB00870 is inserted: D00452
NOTICE:  Drug2 RxCUI:  DB00909 is inserted: D00538
NOTICE:  Drug2 RxCUI:  DB00181 is inserted: D00241
NOTICE:  Drug2 RxCUI:  DB00952 is inserted: D08255
NOTICE:  Drug2 RxCUI:  DB00378 is inserted: D01217
NOTICE:  Drug2 RxCUI:  DB00035 is inserted: D00291
NOTICE:  Drug2 RxCUI:  DB00674 is inserted: D04292
NOTICE:  Drug2 RxCUI:  DB01623 is inserted: D00374
NOTICE:  Drug2 RxCUI:  DB01307 is inserted: D04539
NOTICE:  Drug2 RxCUI:  DB00526 is inserted: D01790
NOTICE:  Drug2 RxCUI:  DB01395 is inserted: D03917
NOTICE:  Drug2 RxCUI:  DB06013 is inserted: D10383
NOTICE:  Drug2 RxCUI:  DB00395 is inserted: D00768
NOTICE:  Drug2 RxCUI:  DB00985 is inserted: D00520
NOTICE:  Drug2 RxCUI:  DB01085 is inserted: D00525
NOTICE:  Drug2 RxCUI:  DB09289 is inserted: D02575
NOTICE:  Drug2 RxCUI:  DB13504 is inserted: D03424
NOTICE:  Drug2 RxCUI:  DB13233 is inserted: D02787
NOTICE:  Drug2 RxCUI:  DB06154 is inserted: D01721
NOTICE:  Drug2 RxCUI:  DB00767 is inserted: D00243
NOTICE:  Drug2 RxCUI:  DB01280 is inserted: D05134
NOTICE:  Drug2 RxCUI:  DB01184 is inserted: D01745
NOTICE:  Drug2 RxCUI:  DB09229 is inserted: D01562
NOTICE:  Drug2 RxCUI:  DB08811 is inserted: D01254
NOTICE:  Drug2 RxCUI:  DB01092 is inserted: D00112
NOTICE:  Drug2 RxCUI:  DB09270 is inserted: D01065
NOTICE:  Drug2 RxCUI:  DB06217 is inserted: D06665
NOTICE:  Drug2 RxCUI:  DB09008 is inserted: D01075
NOTICE:  Drug2 RxCUI:  DB00912 is inserted: D00594
NOTICE:  Drug2 RxCUI:  DB00031 is inserted: D06070
NOTICE:  Drug2 RxCUI:  DB01056 is inserted: D06172
NOTICE:  Drug2 RxCUI:  DB09031 is inserted: D02494
NOTICE:  Drug2 RxCUI:  DB06690 is inserted: D00102
NOTICE:  Drug2 RxCUI:  DB09161 is inserted: D01060
NOTICE:  Drug2 RxCUI:  DB00189 is inserted: D00704
NOTICE:  Drug2 RxCUI:  DB00813 is inserted: D00320
NOTICE:  Drug2 RxCUI:  DB13699 is inserted: D07239
NOTICE:  Drug2 RxCUI:  DB00046 is inserted: D04477
NOTICE:  Drug2 RxCUI:  DB09077 is inserted: D10559
NOTICE:  Drug2 RxCUI:  DB06168 is inserted: D09315
NOTICE:  Drug2 RxCUI:  DB09570 is inserted: D10130
NOTICE:  Drug2 RxCUI:  DB06655 is inserted: D06404
NOTICE:  Drug2 RxCUI:  DB01225 is inserted: D07510
NOTICE:  Drug2 RxCUI:  DB12783 is inserted: D03082
NOTICE:  Drug2 RxCUI:  DB08950 is inserted: D04531
NOTICE:  Drug2 RxCUI:  DB00247 is inserted: D02357
NOTICE:  Drug2 RxCUI:  DB01294 is inserted: D00728
NOTICE:  Drug2 RxCUI:  DB00262 is inserted: D00254
NOTICE:  Drug2 RxCUI:  DB01160 is inserted: D01352
NOTICE:  Drug2 RxCUI:  DB00851 is inserted: D00288
NOTICE:  Drug2 RxCUI:  DB02701 is inserted: D00036
NOTICE:  Drug2 RxCUI:  DB00204 is inserted: D00647
NOTICE:  Drug2 RxCUI:  DB08801 is inserted: D07853
NOTICE:  Drug2 RxCUI:  DB00399 is inserted: D01968
NOTICE:  Drug2 RxCUI:  DB11609 is inserted: D07384
NOTICE:  Drug2 RxCUI:  DB00928 is inserted: D03021
NOTICE:  Drug2 RxCUI:  DB01301 is inserted: D02282
NOTICE:  Drug2 RxCUI:  DB00404 is inserted: D00225
NOTICE:  Drug2 RxCUI:  DB00387 is inserted: D08425
NOTICE:  Drug2 RxCUI:  DB14600 is inserted: D03945
NOTICE:  Drug2 RxCUI:  DB01073 is inserted: D01907
NOTICE:  Drug2 RxCUI:  DB00335 is inserted: D00235
NOTICE:  Drug2 RxCUI:  DB00973 is inserted: D01966
NOTICE:  Drug2 RxCUI:  DB14027 is inserted: D09723
NOTICE:  Drug2 RxCUI:  DB11447 is inserted: D02601
NOTICE:  Drug2 RxCUI:  DB00531 is inserted: D07760
NOTICE:  Drug2 RxCUI:  DB08872 is inserted: D09539
NOTICE:  Drug2 RxCUI:  DB06712 is inserted: D01908
NOTICE:  Drug2 RxCUI:  DB00115 is inserted: D00166
NOTICE:  Drug2 RxCUI:  DB00068 is inserted: D00746
NOTICE:  Drug2 RxCUI:  DB01012 is inserted: D03504
NOTICE:  Drug2 RxCUI:  DB09055 is inserted: D07190
NOTICE:  Drug2 RxCUI:  DB13178 is inserted: D08079
NOTICE:  Drug2 RxCUI:  DB12877 is inserted: D01773
NOTICE:  Drug2 RxCUI:  DB00188 is inserted: D03150
NOTICE:  Drug2 RxCUI:  DB00648 is inserted: D00420
NOTICE:  Drug2 RxCUI:  DB06271 is inserted: D08547
NOTICE:  Drug2 RxCUI:  DB04946 is inserted: D02666
NOTICE:  Drug2 RxCUI:  DB13954 is inserted: D04063
NOTICE:  Drug2 RxCUI:  DB00589 is inserted: D08132
NOTICE:  Drug2 RxCUI:  DB01161 is inserted: D07678
NOTICE:  Drug2 RxCUI:  DB13167 is inserted: D01252
NOTICE:  Drug2 RxCUI:  DB06725 is inserted: D01866
NOTICE:  Drug2 RxCUI:  DB00583 is inserted: D02176
NOTICE:  Drug2 RxCUI:  DB05239 is inserted: D10405
NOTICE:  Drug2 RxCUI:  DB09232 is inserted: D01173
NOTICE:  Drug2 RxCUI:  DB00072 is inserted: D03257
NOTICE:  Drug2 RxCUI:  DB00253 is inserted: D02289
NOTICE:  Drug2 RxCUI:  DB01162 is inserted: D08569
NOTICE:  Drug2 RxCUI:  DB00326 is inserted: D00934
NOTICE:  Drug2 RxCUI:  DB00746 is inserted: D03670
NOTICE:  Drug2 RxCUI:  DB06811 is inserted: D01993
NOTICE:  Drug2 RxCUI:  DB05595 is inserted: D09343
NOTICE:  Drug2 RxCUI:  DB04885 is inserted: D03495
NOTICE:  Drug2 RxCUI:  DB06155 is inserted: D05731
NOTICE:  Drug2 RxCUI:  DB01235 is inserted: D00059
NOTICE:  Drug2 RxCUI:  DB09011 is inserted: D07300
NOTICE:  Drug2 RxCUI:  DB00228 is inserted: D00543
NOTICE:  Drug2 RxCUI:  DB06554 is inserted: D04282
NOTICE:  Drug2 RxCUI:  DB00818 is inserted: D00549
NOTICE:  Drug2 RxCUI:  DB00641 is inserted: D00434
NOTICE:  Drug2 RxCUI:  DB09121 is inserted: D00991
NOTICE:  Drug2 RxCUI:  DB14726 is inserted: D09707
NOTICE:  Drug2 RxCUI:  DB00725 is inserted: D02070
NOTICE:  Drug2 RxCUI:  DB00203 is inserted: D08514
NOTICE:  Drug2 RxCUI:  DB00491 is inserted: D00625
NOTICE:  Drug2 RxCUI:  DB12770 is inserted: D01131
NOTICE:  Drug2 RxCUI:  DB00435 is inserted: D00074
NOTICE:  Drug2 RxCUI:  DB00968 is inserted: D08205
NOTICE:  Drug2 RxCUI:  DB00950 is inserted: D07958
NOTICE:  Drug2 RxCUI:  DB00947 is inserted: D01161
NOTICE:  Drug2 RxCUI:  DB09023 is inserted: D07498
NOTICE:  Drug2 RxCUI:  DB00169 is inserted: D00188
NOTICE:  Drug2 RxCUI:  DB01559 is inserted: D01328
NOTICE:  Drug2 RxCUI:  DB08894 is inserted: D09947
NOTICE:  Drug2 RxCUI:  DB01067 is inserted: D00335
NOTICE:  Drug2 RxCUI:  DB06317 is inserted: D09337
NOTICE:  Drug2 RxCUI:  DB01297 is inserted: D05587
NOTICE:  Drug2 RxCUI:  DB09076 is inserted: D10180
NOTICE:  Drug2 RxCUI:  DB09292 is inserted: D10225
NOTICE:  Drug2 RxCUI:  DB00206 is inserted: D00197
NOTICE:  Drug2 RxCUI:  DB08985 is inserted: D07931
NOTICE:  Drug2 RxCUI:  DB08887 is inserted: D01892
NOTICE:  Drug2 RxCUI:  DB09093 is inserted: D07689
NOTICE:  Drug2 RxCUI:  DB09098 is inserted: D05884
NOTICE:  Drug2 RxCUI:  DB00349 is inserted: D01253
NOTICE:  Drug2 RxCUI:  DB04846 is inserted: D07660
NOTICE:  Drug2 RxCUI:  DB02659 is inserted: D10699
NOTICE:  Drug2 RxCUI:  DB09291 is inserted: D10742
NOTICE:  Drug2 RxCUI:  DB00412 is inserted: D00596
NOTICE:  Drug2 RxCUI:  DB00433 is inserted: D00493
NOTICE:  Drug2 RxCUI:  DB00312 is inserted: D00499
NOTICE:  Drug2 RxCUI:  DB00321 is inserted: D07448
NOTICE:  Drug2 RxCUI:  DB01100 is inserted: D00560
NOTICE:  Drug2 RxCUI:  DB14540 is inserted: D01619
NOTICE:  Drug2 RxCUI:  DB04901 is inserted: D04295
NOTICE:  Drug2 RxCUI:  DB06335 is inserted: D08996
NOTICE:  Drug2 RxCUI:  DB00728 is inserted: D00765
NOTICE:  Drug2 RxCUI:  DB13164 is inserted: D10859
NOTICE:  Drug2 RxCUI:  DB00515 is inserted: D00275
NOTICE:  Drug2 RxCUI:  DB00317 is inserted: D01977
NOTICE:  Drug2 RxCUI:  DB01076 is inserted: D07474
NOTICE:  Drug2 RxCUI:  DB00460 is inserted: D01162
NOTICE:  Drug2 RxCUI:  DB01080 is inserted: D00535
NOTICE:  Drug2 RxCUI:  DB02587 is inserted: D03584
NOTICE:  Drug2 RxCUI:  DB01437 is inserted: D00532
NOTICE:  Drug2 RxCUI:  DB00398 is inserted: D08524
NOTICE:  Drug2 RxCUI:  DB01616 is inserted: D07440
NOTICE:  Drug2 RxCUI:  DB12319 is inserted: D01056
NOTICE:  Drug2 RxCUI:  DB00407 is inserted: D02980
NOTICE:  Drug2 RxCUI:  DB05528 is inserted: D08946
NOTICE:  Drug2 RxCUI:  DB00564 is inserted: D00252
NOTICE:  Drug2 RxCUI:  DB00790 is inserted: D03753
NOTICE:  Drug2 RxCUI:  DB00030 is inserted: D03230
NOTICE:  Drug2 RxCUI:  DB08986 is inserted: D07320
NOTICE:  Drug2 RxCUI:  DB00893 is inserted: D02141
NOTICE:  Drug2 RxCUI:  DB13832 is inserted: D01760
NOTICE:  Drug2 RxCUI:  DB01424 is inserted: D00556
NOTICE:  Drug2 RxCUI:  DB00245 is inserted: D07511
NOTICE:  Drug2 RxCUI:  DB06186 is inserted: D04603
NOTICE:  Drug2 RxCUI:  DB06804 is inserted: D06490
NOTICE:  Drug2 RxCUI:  DB01270 is inserted: D05697
NOTICE:  Drug2 RxCUI:  DB08879 is inserted: D03068
NOTICE:  Drug2 RxCUI:  DB00213 is inserted: D05353
NOTICE:  Drug2 RxCUI:  DB00621 is inserted: D00462
NOTICE:  Drug2 RxCUI:  DB01050 is inserted: D00126
NOTICE:  Drug2 RxCUI:  DB01221 is inserted: D08098
NOTICE:  Drug2 RxCUI:  DB01619 is inserted: D08353
NOTICE:  Drug2 RxCUI:  DB00380 is inserted: D03730
NOTICE:  Drug2 RxCUI:  DB01418 is inserted: D07064
NOTICE:  Drug2 RxCUI:  DB09304 is inserted: D08511
NOTICE:  Drug2 RxCUI:  DB01081 is inserted: D00301
NOTICE:  Drug2 RxCUI:  DB13857 is inserted: D07223
NOTICE:  Drug2 RxCUI:  DB04519 is inserted: D05220
NOTICE:  Drug2 RxCUI:  DB14043 is inserted: D08328
NOTICE:  Drug2 RxCUI:  DB01608 is inserted: D01485
NOTICE:  Drug2 RxCUI:  DB04575 is inserted: D00576
NOTICE:  Drug2 RxCUI:  DB01170 is inserted: D02237
NOTICE:  Drug2 RxCUI:  DB03793 is inserted: D00038
NOTICE:  Drug2 RxCUI:  DB09472 is inserted: D01732
NOTICE:  Drug2 RxCUI:  DB06756 is inserted: D07523
NOTICE:  Drug2 RxCUI:  DB15093 is inserted: D11194
NOTICE:  Drug2 RxCUI:  DB00762 is inserted: D08086
NOTICE:  Drug2 RxCUI:  DB00436 is inserted: D00650
NOTICE:  Drug2 RxCUI:  DB00437 is inserted: D00224
NOTICE:  Drug2 RxCUI:  DB06412 is inserted: D00490
NOTICE:  Drug2 RxCUI:  DB01628 is inserted: D03710
NOTICE:  Drug2 RxCUI:  DB05332 is inserted: D08990
NOTICE:  Drug2 RxCUI:  DB00413 is inserted: D00559
NOTICE:  Drug2 RxCUI:  DB01129 is inserted: D08463
NOTICE:  Drug2 RxCUI:  DB01590 is inserted: D02714
NOTICE:  Drug2 RxCUI:  DB00524 is inserted: D00431
NOTICE:  Drug2 RxCUI:  DB06737 is inserted: D01547
NOTICE:  Drug2 RxCUI:  DB09220 is inserted: D01810
NOTICE:  Drug2 RxCUI:  DB00656 is inserted: D08626
NOTICE:  Drug2 RxCUI:  DB04572 is inserted: D00583
NOTICE:  Drug2 RxCUI:  DB00308 is inserted: D00648
NOTICE:  Drug2 RxCUI:  DB09122 is inserted: D10483
NOTICE:  Drug2 RxCUI:  DB06780 is inserted: D03698
NOTICE:  Drug2 RxCUI:  DB06764 is inserted: D08578
NOTICE:  Drug2 RxCUI:  DB01065 is inserted: D08170
NOTICE:  Drug2 RxCUI:  DB08804 is inserted: D00955
NOTICE:  Drug2 RxCUI:  DB00843 is inserted: D00670
NOTICE:  Drug2 RxCUI:  DB01209 is inserted: D00838
NOTICE:  Drug2 RxCUI:  DB00819 is inserted: D00218
NOTICE:  Drug2 RxCUI:  DB06216 is inserted: D02995
NOTICE:  Drug2 RxCUI:  DB00603 is inserted: D00951
NOTICE:  Drug2 RxCUI:  DB00875 is inserted: D01044
NOTICE:  Drug2 RxCUI:  DB01599 is inserted: D00476
NOTICE:  Drug2 RxCUI:  DB01149 is inserted: D08257
NOTICE:  Drug2 RxCUI:  DB09132 is inserted: D08007
NOTICE:  Drug2 RxCUI:  DB00727 is inserted: D00515
NOTICE:  Drug2 RxCUI:  DB06777 is inserted: D00163
NOTICE:  Drug2 RxCUI:  DB00799 is inserted: D01132
NOTICE:  Drug2 RxCUI:  DB11952 is inserted: D10555
NOTICE:  Drug2 RxCUI:  DB08900 is inserted: D06053
NOTICE:  Drug2 RxCUI:  DB11371 is inserted: D07282
NOTICE:  Drug2 RxCUI:  DB00226 is inserted: D08029
NOTICE:  Drug2 RxCUI:  DB11560 is inserted: D09921
NOTICE:  Drug2 RxCUI:  DB08889 is inserted: D08880
NOTICE:  Drug2 RxCUI:  DB01231 is inserted: D03858
NOTICE:  Drug2 RxCUI:  DB00555 is inserted: D00354
NOTICE:  Drug2 RxCUI:  DB04881 is inserted: D03968
NOTICE:  Drug2 RxCUI:  DB09199 is inserted: D05150
NOTICE:  Drug2 RxCUI:  DB11817 is inserted: D10308
NOTICE:  Drug2 RxCUI:  DB00350 is inserted: D00418
NOTICE:  Drug2 RxCUI:  DB00680 is inserted: D05077
NOTICE:  Drug2 RxCUI:  DB00703 is inserted: D00655
NOTICE:  Drug2 RxCUI:  DB00271 is inserted: D01013
NOTICE:  Drug2 RxCUI:  DB11475 is inserted: D02490
NOTICE:  Drug2 RxCUI:  DB00191 is inserted: D05458
NOTICE:  Drug2 RxCUI:  DB01278 is inserted: D05595
NOTICE:  Drug2 RxCUI:  DB08799 is inserted: D07458
NOTICE:  Drug2 RxCUI:  DB06261 is inserted: D04436
NOTICE:  Drug2 RxCUI:  DB06176 is inserted: D06637
NOTICE:  Drug2 RxCUI:  DB09225 is inserted: D01321
NOTICE:  Drug2 RxCUI:  DB06699 is inserted: D08901
NOTICE:  Drug2 RxCUI:  DB13854 is inserted: D07213
NOTICE:  Drug2 RxCUI:  DB00914 is inserted: D08351
NOTICE:  Drug2 RxCUI:  DB11372 is inserted: D02840
NOTICE:  Drug2 RxCUI:  DB00496 is inserted: D01699
NOTICE:  Drug2 RxCUI:  DB08880 is inserted: D10172
NOTICE:  Drug2 RxCUI:  DB11526 is inserted: D10229
NOTICE:  Drug2 RxCUI:  DB00611 is inserted: D00837
NOTICE:  Drug2 RxCUI:  DB04571 is inserted: D01034
NOTICE:  Drug2 RxCUI:  DB09543 is inserted: D01087
NOTICE:  Drug2 RxCUI:  DB00561 is inserted: D07873
NOTICE:  Drug2 RxCUI:  DB00366 is inserted: D02327
NOTICE:  Drug2 RxCUI:  DB00894 is inserted: D00153
NOTICE:  Drug2 RxCUI:  DB00513 is inserted: D00160
NOTICE:  Drug2 RxCUI:  DB13876 is inserted: D02560
NOTICE:  Drug2 RxCUI:  DB00734 is inserted: D00426
NOTICE:  Drug2 RxCUI:  DB11107 is inserted: D01561
NOTICE:  Drug2 RxCUI:  DB13795 is inserted: D07238
NOTICE:  Drug2 RxCUI:  DB13243 is inserted: D06130
NOTICE:  Drug2 RxCUI:  DB00051 is inserted: D02597
NOTICE:  Drug2 RxCUI:  DB00347 is inserted: D00392
NOTICE:  Drug2 RxCUI:  DB00598 is inserted: D08106
NOTICE:  Drug2 RxCUI:  DB06273 is inserted: D02596
NOTICE:  Drug2 RxCUI:  DB11461 is inserted: D05948
NOTICE:  Drug2 RxCUI:  DB09321 is inserted: D01170
NOTICE:  Drug2 RxCUI:  DB06218 is inserted: D07299
NOTICE:  Drug2 RxCUI:  DB06043 is inserted: D09939
NOTICE:  Drug2 RxCUI:  DB01638 is inserted: D00096
NOTICE:  Drug2 RxCUI:  DB06822 is inserted: D06398
NOTICE:  Drug2 RxCUI:  DB05990 is inserted: D09360
NOTICE:  Drug2 RxCUI:  DB08882 is inserted: D09566
NOTICE:  Drug2 RxCUI:  DB08868 is inserted: D10001
NOTICE:  Drug2 RxCUI:  DB00743 is inserted: D08018
NOTICE:  Drug2 RxCUI:  DB01005 is inserted: D00341
NOTICE:  Drug2 RxCUI:  DB00235 is inserted: D00417
NOTICE:  Drug2 RxCUI:  DB01471 is inserted: D03144
NOTICE:  Drug2 RxCUI:  DB01910 is inserted: D05846
NOTICE:  Drug2 RxCUI:  DB11089 is inserted: D00305
NOTICE:  Drug2 RxCUI:  DB04339 is inserted: D00175
NOTICE:  Drug2 RxCUI:  DB01553 is inserted: D01268
NOTICE:  Drug2 RxCUI:  DB11443 is inserted: D08299
NOTICE:  Drug2 RxCUI:  DB00670 is inserted: D08389
NOTICE:  Drug2 RxCUI:  DB09312 is inserted: D08808
NOTICE:  Drug2 RxCUI:  DB06410 is inserted: D01009
NOTICE:  Drug2 RxCUI:  DB06201 is inserted: D05775
NOTICE:  Drug2 RxCUI:  DB08901 is inserted: D09950
NOTICE:  Drug2 RxCUI:  DB09014 is inserted: D07316
NOTICE:  Drug2 RxCUI:  DB00408 is inserted: D02340
NOTICE:  Drug2 RxCUI:  DB00153 is inserted: D00187
NOTICE:  Drug2 RxCUI:  DB13999 is inserted: D08232
NOTICE:  Drug2 RxCUI:  DB01259 is inserted: D04024
NOTICE:  Drug2 RxCUI:  DB01018 is inserted: D08031
NOTICE:  Drug2 RxCUI:  DB00197 is inserted: D00395
NOTICE:  Drug2 RxCUI:  DB01062 is inserted: D00465
NOTICE:  Drug2 RxCUI:  DB00866 is inserted: D07156
NOTICE:  Drug2 RxCUI:  DB11617 is inserted: D02756
NOTICE:  Drug2 RxCUI:  DB00227 is inserted: D00359
NOTICE:  Drug2 RxCUI:  DB00571 is inserted: D08443
NOTICE:  Drug2 RxCUI:  DB06016 is inserted: D09997
NOTICE:  Drug2 RxCUI:  DB11616 is inserted: D01885
NOTICE:  Drug2 RxCUI:  DB01197 is inserted: D00251
NOTICE:  Drug2 RxCUI:  DB00958 is inserted: D01363
NOTICE:  Drug2 RxCUI:  DB08996 is inserted: D02565
NOTICE:  Drug2 RxCUI:  DB09303 is inserted: D10557
NOTICE:  Drug2 RxCUI:  DB01249 is inserted: D01474
NOTICE:  Drug2 RxCUI:  DB00825 is inserted: D00064
NOTICE:  Drug2 RxCUI:  DB06821 is inserted: D02517
NOTICE:  Drug2 RxCUI:  DB11630 is inserted: D06066
NOTICE:  Drug2 RxCUI:  DB00585 is inserted: D00440
NOTICE:  Drug2 RxCUI:  DB06366 is inserted: D05446
NOTICE:  Drug2 RxCUI:  DB06285 is inserted: D06078
NOTICE:  Drug2 RxCUI:  DB00544 is inserted: D00584
NOTICE:  Drug2 RxCUI:  DB14659 is inserted: D04900
NOTICE:  Drug2 RxCUI:  DB04711 is inserted: D01774
NOTICE:  Drug2 RxCUI:  DB01223 is inserted: D00227
NOTICE:  Drug2 RxCUI:  DB14011 is inserted: D09317
NOTICE:  Drug2 RxCUI:  DB01079 is inserted: D06056
NOTICE:  Drug2 RxCUI:  DB08822 is inserted: D08865
NOTICE:  Drug2 RxCUI:  DB04833 is inserted: D00557
NOTICE:  Drug2 RxCUI:  DB07402 is inserted: D02966
NOTICE:  Drug2 RxCUI:  DB00014 is inserted: D00573
NOTICE:  Drug2 RxCUI:  DB09302 is inserted: D10335
NOTICE:  Drug2 RxCUI:  DB00201 is inserted: D00528
NOTICE:  Drug2 RxCUI:  DB00372 is inserted: D02354
NOTICE:  Drug2 RxCUI:  DB00193 is inserted: D08623
NOTICE:  Drug2 RxCUI:  DB00752 is inserted: D08625
NOTICE:  Drug2 RxCUI:  DB06282 is inserted: D07402
NOTICE:  Drug2 RxCUI:  DB13952 is inserted: D04061
NOTICE:  Drug2 RxCUI:  DB00457 is inserted: D08411
NOTICE:  Drug2 RxCUI:  DB00136 is inserted: D00129
NOTICE:  Drug2 RxCUI:  DB01614 is inserted: D07065
NOTICE:  Drug2 RxCUI:  DB06779 is inserted: D03353
NOTICE:  Drug2 RxCUI:  DB09369 is inserted: D07434
NOTICE:  Drug2 RxCUI:  DB06212 is inserted: D01213
NOTICE:  Drug2 RxCUI:  DB11478 is inserted: D06362
NOTICE:  Drug2 RxCUI:  DB09280 is inserted: D10134
NOTICE:  Drug2 RxCUI:  DB00248 is inserted: D00987
NOTICE:  Drug2 RxCUI:  DB01384 is inserted: D07464
NOTICE:  Drug2 RxCUI:  DB00054 is inserted: D02778
NOTICE:  Drug2 RxCUI:  DB11518 is inserted: D04215
NOTICE:  Drug2 RxCUI:  DB01075 is inserted: D00300
NOTICE:  Drug2 RxCUI:  DB00903 is inserted: D00313
NOTICE:  Drug2 RxCUI:  DB00340 is inserted: D01871
NOTICE:  Drug2 RxCUI:  DB00517 is inserted: D00232
NOTICE:  Drug2 RxCUI:  DB00540 is inserted: D08288
NOTICE:  Drug2 RxCUI:  DB00984 is inserted: D00956
NOTICE:  Drug2 RxCUI:  DB00211 is inserted: D08220
NOTICE:  Drug2 RxCUI:  DB00107 is inserted: D00089
NOTICE:  Drug2 RxCUI:  DB00083 is inserted: D00783
NOTICE:  Drug2 RxCUI:  DB09201 is inserted: D03493
NOTICE:  Drug2 RxCUI:  DB06705 is inserted: D04286
NOTICE:  Drug2 RxCUI:  DB04825 is inserted: D02383
NOTICE:  Drug2 RxCUI:  DB01299 is inserted: D00580
NOTICE:  Drug2 RxCUI:  DB01656 is inserted: D05744
NOTICE:  Drug2 RxCUI:  DB00556 is inserted: D01738
NOTICE:  Drug2 RxCUI:  DB00800 is inserted: D00613
NOTICE:  Drug2 RxCUI:  DB00838 is inserted: D07719
NOTICE:  Drug2 RxCUI:  DB09300 is inserted: D01451
NOTICE:  Drug2 RxCUI:  DB00974 is inserted: D00052
NOTICE:  Drug2 RxCUI:  DB01545 is inserted: D01293
NOTICE:  Drug2 RxCUI:  DB00266 is inserted: D03798
NOTICE:  Drug2 RxCUI:  DB00716 is inserted: D05129
NOTICE:  Drug2 RxCUI:  DB01181 is inserted: D00343
NOTICE:  Drug2 RxCUI:  DB06739 is inserted: D01123
NOTICE:  Drug2 RxCUI:  DB09099 is inserted: D07431
NOTICE:  Drug2 RxCUI:  DB04816 is inserted: D07107
NOTICE:  Drug2 RxCUI:  DB06268 is inserted: D07171
NOTICE:  Drug2 RxCUI:  DB01213 is inserted: D00707
NOTICE:  Drug2 RxCUI:  DB06819 is inserted: D05868
NOTICE:  Drug2 RxCUI:  DB00835 is inserted: D07543
NOTICE:  Drug2 RxCUI:  DB00492 is inserted: D07992
NOTICE:  Drug2 RxCUI:  DB00907 is inserted: D00110
NOTICE:  Drug2 RxCUI:  DB06727 is inserted: D01041
NOTICE:  Drug2 RxCUI:  DB04836 is inserted: D07335
NOTICE:  Drug2 RxCUI:  DB00469 is inserted: D01767
NOTICE:  Drug2 RxCUI:  DB09311 is inserted: D03306
NOTICE:  Drug2 RxCUI:  DB13616 is inserted: D07143
NOTICE:  Drug2 RxCUI:  DB00933 is inserted: D02671
NOTICE:  Drug2 RxCUI:  DB09244 is inserted: D08392
NOTICE:  Drug2 RxCUI:  DB04908 is inserted: D02577
NOTICE:  Drug2 RxCUI:  DB00897 is inserted: D00387
NOTICE:  Drug2 RxCUI:  DB01403 is inserted: D00403
NOTICE:  Drug2 RxCUI:  DB11426 is inserted: D08156
NOTICE:  Drug2 RxCUI:  DB01595 is inserted: D00531
NOTICE:  Drug2 RxCUI:  DB00414 is inserted: D00219
NOTICE:  Drug2 RxCUI:  DB00450 is inserted: D00308
NOTICE:  Drug2 RxCUI:  DB09135 is inserted: D02161
NOTICE:  Drug2 RxCUI:  DB06650 is inserted: D09314
NOTICE:  Drug2 RxCUI:  DB09016 is inserted: D07601
NOTICE:  Drug2 RxCUI:  DB00168 is inserted: D02381
NOTICE:  Drug2 RxCUI:  DB00390 is inserted: D00298
NOTICE:  Drug2 RxCUI:  DB06692 is inserted: D02971
NOTICE:  Drug2 RxCUI:  DB01501 is inserted: D03809
NOTICE:  Drug2 RxCUI:  DB13346 is inserted: D01271
NOTICE:  Drug2 RxCUI:  DB00891 is inserted: D02434
NOTICE:  Drug2 RxCUI:  DB00650 is inserted: D07986
NOTICE:  Drug2 RxCUI:  DB08917 is inserted: D08920
NOTICE:  Drug2 RxCUI:  DB08951 is inserted: D04530
NOTICE:  Drug2 RxCUI:  DB01101 is inserted: D01223
NOTICE:  Drug2 RxCUI:  DB08904 is inserted: D03441
NOTICE:  Drug2 RxCUI:  DB04599 is inserted: D01883
NOTICE:  Drug2 RxCUI:  DB00285 is inserted: D08670
NOTICE:  Drug2 RxCUI:  DB00993 is inserted: D00238
NOTICE:  Drug2 RxCUI:  DB00926 is inserted: D00316
NOTICE:  Drug2 RxCUI:  DB00864 is inserted: D00107
NOTICE:  Drug2 RxCUI:  DB00120 is inserted: D00021
NOTICE:  Drug2 RxCUI:  DB00726 is inserted: D00394
NOTICE:  Drug2 RxCUI:  DB00960 is inserted: D00513
NOTICE:  Drug2 RxCUI:  DB09166 is inserted: D01514
NOTICE:  Drug2 RxCUI:  DB08890 is inserted: D09355
NOTICE:  Drug2 RxCUI:  DB13845 is inserted: D01440
NOTICE:  Drug2 RxCUI:  DB00823 is inserted: D01294
NOTICE:  Drug2 RxCUI:  DB06789 is inserted: D00949
NOTICE:  Drug2 RxCUI:  DB00264 is inserted: D02358
NOTICE:  Drug2 RxCUI:  DB13627 is inserted: D02301
NOTICE:  Drug2 RxCUI:  DB01348 is inserted: D08529
NOTICE:  Drug2 RxCUI:  DB09043 is inserted: D08843
NOTICE:  Drug2 RxCUI:  DB11689 is inserted: D09666
NOTICE:  Drug2 RxCUI:  DB00292 is inserted: D00548
NOTICE:  Drug2 RxCUI:  DB13981 is inserted: D08281
NOTICE:  Drug2 RxCUI:  DB14539 is inserted: D00165
NOTICE:  Drug2 RxCUI:  DB13772 is inserted: D02474
NOTICE:  Drug2 RxCUI:  DB00872 is inserted: D07748
NOTICE:  Drug2 RxCUI:  DB01227 is inserted: D04716
NOTICE:  Drug2 RxCUI:  DB00283 is inserted: D03535
NOTICE:  Drug2 RxCUI:  DB13877 is inserted: D09913
NOTICE:  Drug2 RxCUI:  DB00721 is inserted: D08422
NOTICE:  Drug2 RxCUI:  DB09142 is inserted: D05845
NOTICE:  Drug2 RxCUI:  DB06788 is inserted: D02369
NOTICE:  Drug2 RxCUI:  DB09071 is inserted: D09388
NOTICE:  Drug2 RxCUI:  DB00669 is inserted: D00451
NOTICE:  Drug2 RxCUI:  DB11644 is inserted: D09673
NOTICE:  Drug2 RxCUI:  DB00761 is inserted: D02060
NOTICE:  Drug2 RxCUI:  DB00869 is inserted: D07871
NOTICE:  Drug2 RxCUI:  DB00969 is inserted: D07129
NOTICE:  Drug2 RxCUI:  DB13943 is inserted: D00957
NOTICE:  Drug2 RxCUI:  DB00553 is inserted: D00139
NOTICE:  Drug2 RxCUI:  DB00655 is inserted: D00067
NOTICE:  Drug2 RxCUI:  DB09187 is inserted: D04781
NOTICE:  Drug2 RxCUI:  DB00606 is inserted: D01256
NOTICE:  Drug2 RxCUI:  DB11425 is inserted: D08151
NOTICE:  Drug2 RxCUI:  DB03255 is inserted: D00033
NOTICE:  Drug2 RxCUI:  DB00753 is inserted: D00545
NOTICE:  Drug2 RxCUI:  DB01002 is inserted: D08116
NOTICE:  Drug2 RxCUI:  DB06715 is inserted: D01016
NOTICE:  Drug2 RxCUI:  DB09075 is inserted: D09546
NOTICE:  Drug2 RxCUI:  DB08909 is inserted: D10127
NOTICE:  Drug2 RxCUI:  DB00961 is inserted: D08181
NOTICE:  Drug2 RxCUI:  DB01118 is inserted: D02910
NOTICE:  Drug2 RxCUI:  DB01281 is inserted: D03203
NOTICE:  Drug2 RxCUI:  DB06264 is inserted: D08617
NOTICE:  Drug2 RxCUI:  DB01609 is inserted: D03669
NOTICE:  Drug2 RxCUI:  DB01132 is inserted: D08378
NOTICE:  Drug2 RxCUI:  DB11412 is inserted: D07950
NOTICE:  Drug2 RxCUI:  DB13362 is inserted: D01190
NOTICE:  Drug2 RxCUI:  DB00454 is inserted: D08343
NOTICE:  Drug2 RxCUI:  DB11556 is inserted: D07795
NOTICE:  Drug2 RxCUI:  DB06237 is inserted: D03217
NOTICE:  Drug2 RxCUI:  DB00545 is inserted: D00487
NOTICE:  Drug2 RxCUI:  DB08974 is inserted: D04200
NOTICE:  Drug2 RxCUI:  DB00368 is inserted: D00076
NOTICE:  Drug2 RxCUI:  DB01254 is inserted: D03658
NOTICE:  Drug2 RxCUI:  DB13381 is inserted: D07145
NOTICE:  Drug2 RxCUI:  DB00036 is inserted: D00172
NOTICE:  Drug2 RxCUI:  DB00849 is inserted: D00700
NOTICE:  Drug2 RxCUI:  DB09374 is inserted: D01342
NOTICE:  Drug2 RxCUI:  DB11153 is inserted: D01168
NOTICE:  Drug2 RxCUI:  DB06691 is inserted: D08183
NOTICE:  Drug2 RxCUI:  DB04818 is inserted: D02579
NOTICE:  Drug2 RxCUI:  DB09081 is inserted: D01750
NOTICE:  Drug2 RxCUI:  DB09564 is inserted: D09727
NOTICE:  Drug2 RxCUI:  DB00527 is inserted: D00733
NOTICE:  Drug2 RxCUI:  DB00904 is inserted: D00456
NOTICE:  Drug2 RxCUI:  DB12736 is inserted: D04075
NOTICE:  Drug2 RxCUI:  DB01579 is inserted: D08347
NOTICE:  Drug2 RxCUI:  DB00471 is inserted: D08229
NOTICE:  Drug2 RxCUI:  DB00170 is inserted: D02335
NOTICE:  Drug2 RxCUI:  DB02959 is inserted: D07339
NOTICE:  Drug2 RxCUI:  DB01089 is inserted: D08194
NOTICE:  Drug2 RxCUI:  DB11549 is inserted: D08596
NOTICE:  Drug2 RxCUI:  DB11525 is inserted: D04830
NOTICE:  Drug2 RxCUI:  DB00462 is inserted: D00715
NOTICE:  Drug2 RxCUI:  DB08892 is inserted: D08861
NOTICE:  Drug2 RxCUI:  DB13841 is inserted: D02613
NOTICE:  Drug2 RxCUI:  DB01524 is inserted: D00179
NOTICE:  Drug2 RxCUI:  DB06144 is inserted: D00561
NOTICE:  Drug2 RxCUI:  DB09026 is inserted: D03208
NOTICE:  Drug2 RxCUI:  DB00383 is inserted: D08325
NOTICE:  Drug2 RxCUI:  DB13266 is inserted: D02406
NOTICE:  Drug2 RxCUI:  DB00559 is inserted: D01227
NOTICE:  Drug2 RxCUI:  DB01325 is inserted: D00461
NOTICE:  Drug2 RxCUI:  DB06786 is inserted: D01308
NOTICE:  Drug2 RxCUI:  DB00428 is inserted: D05932
NOTICE:  Drug2 RxCUI:  DB04845 is inserted: D04645
NOTICE:  Drug2 RxCUI:  DB14048 is inserted: D10727
NOTICE:  Drug2 RxCUI:  DB00675 is inserted: D08559
NOTICE:  Drug2 RxCUI:  DB04540 is inserted: D00040
NOTICE:  Drug2 RxCUI:  DB01240 is inserted: D00106
NOTICE:  Drug2 RxCUI:  DB01016 is inserted: D00336
NOTICE:  Drug2 RxCUI:  DB13270 is inserted: D07811
NOTICE:  Drug2 RxCUI:  DB01622 is inserted: D08585
NOTICE:  Drug2 RxCUI:  DB00898 is inserted: D00068
NOTICE:  Drug2 RxCUI:  DB00619 is inserted: D01441
NOTICE:  Drug2 RxCUI:  DB00763 is inserted: D00401
NOTICE:  Drug2 RxCUI:  DB09034 is inserted: D10082
NOTICE:  Drug2 RxCUI:  DB06262 is inserted: D01277
NOTICE:  Drug2 RxCUI:  DB11537 is inserted: D08391
NOTICE:  Drug2 RxCUI:  DB00258 is inserted: D00931
NOTICE:  Drug2 RxCUI:  DB09022 is inserted: D07192
NOTICE:  Drug2 RxCUI:  DB01124 is inserted: D00380
NOTICE:  Drug2 RxCUI:  DB00637 is inserted: D00234
NOTICE:  Drug2 RxCUI:  DB01288 is inserted: D04157
NOTICE:  Drug2 RxCUI:  DB00860 is inserted: D00472
NOTICE:  Drug2 RxCUI:  DB04824 is inserted: D05456
NOTICE:  Drug2 RxCUI:  DB01115 is inserted: D00437
NOTICE:  Drug2 RxCUI:  DB09036 is inserted: D09669
NOTICE:  Drug2 RxCUI:  DB11511 is inserted: D07828
NOTICE:  Drug2 RxCUI:  DB00232 is inserted: D00656
NOTICE:  Drug2 RxCUI:  DB00776 is inserted: D00533
NOTICE:  Drug2 RxCUI:  DB00896 is inserted: D05729
NOTICE:  Drug2 RxCUI:  DB00663 is inserted: D04208
NOTICE:  Drug2 RxCUI:  DB00216 is inserted: D07887
NOTICE:  Drug2 RxCUI:  DB01022 is inserted: D00148
NOTICE:  Drug2 RxCUI:  DB01154 is inserted: D06106
NOTICE:  Drug2 RxCUI:  DB06710 is inserted: D00408
NOTICE:  Drug2 RxCUI:  DB00240 is inserted: D07116
NOTICE:  Drug2 RxCUI:  DB00418 is inserted: D00430
NOTICE:  Drug2 RxCUI:  DB00742 is inserted: D00062
NOTICE:  Drug2 RxCUI:  DB00360 is inserted: D08505
NOTICE:  Drug2 RxCUI:  DB11423 is inserted: D04671
NOTICE:  Drug2 RxCUI:  DB05246 is inserted: D00404
NOTICE:  Drug2 RxCUI:  DB09037 is inserted: D10574
NOTICE:  Drug2 RxCUI:  DB12942 is inserted: D08266
NOTICE:  Drug2 RxCUI:  DB00888 is inserted: D07671
NOTICE:  Drug2 RxCUI:  DB00427 is inserted: D01782
NOTICE:  Drug2 RxCUI:  DB00765 is inserted: D00762
NOTICE:  Drug2 RxCUI:  DB01030 is inserted: D08618
NOTICE:  Drug2 RxCUI:  DB00573 is inserted: D00968
NOTICE:  Drug2 RxCUI:  DB00523 is inserted: D02815
NOTICE:  Drug2 RxCUI:  DB13544 is inserted: D01466
NOTICE:  Drug2 RxCUI:  DB00724 is inserted: D02500
NOTICE:  Drug2 RxCUI:  DB14006 is inserted: D00810
NOTICE:  Drug2 RxCUI:  DB01183 is inserted: D08249
NOTICE:  Drug2 RxCUI:  DB00937 is inserted: D07444
NOTICE:  Drug2 RxCUI:  DB08816 is inserted: D09017
NOTICE:  Drug2 RxCUI:  DB11636 is inserted: D07222
NOTICE:  Drug2 RxCUI:  DB00331 is inserted: D04966
NOTICE:  Drug2 RxCUI:  DB01285 is inserted: D00146
NOTICE:  Drug2 RxCUI:  DB08800 is inserted: D07195
NOTICE:  Drug2 RxCUI:  DB00612 is inserted: D02342
NOTICE:  Drug2 RxCUI:  DB09010 is inserted: D01784
NOTICE:  Drug2 RxCUI:  DB00422 is inserted: D04999
NOTICE:  Drug2 RxCUI:  DB01144 is inserted: D00518
NOTICE:  Drug2 RxCUI:  DB08806 is inserted: D08495
NOTICE:  Drug2 RxCUI:  DB06782 is inserted: D00167
NOTICE:  Drug2 RxCUI:  DB13166 is inserted: D08688
NOTICE:  Drug2 RxCUI:  DB04576 is inserted: D01716
NOTICE:  Drug2 RxCUI:  DB09067 is inserted: D03592
NOTICE:  Drug2 RxCUI:  DB01159 is inserted: D00542
NOTICE:  Drug2 RxCUI:  DB00554 is inserted: D00127
NOTICE:  Drug2 RxCUI:  DB01541 is inserted: D07536
NOTICE:  Drug2 RxCUI:  DB11363 is inserted: D10542
NOTICE:  Drug2 RxCUI:  DB13345 is inserted: D07834
NOTICE:  Drug2 RxCUI:  DB01070 is inserted: D00299
NOTICE:  Drug2 RxCUI:  DB06711 is inserted: D08253
NOTICE:  Drug2 RxCUI:  DB04017 is inserted: D03248
NOTICE:  Drug2 RxCUI:  DB00693 is inserted: D01261
NOTICE:  Drug2 RxCUI:  DB06698 is inserted: D07522
NOTICE:  Drug2 RxCUI:  DB01037 is inserted: D03731
NOTICE:  Drug2 RxCUI:  DB06700 is inserted: D07793
NOTICE:  Drug2 RxCUI:  DB09310 is inserted: D10532
NOTICE:  Drug2 RxCUI:  DB00975 is inserted: D00302
NOTICE:  Drug2 RxCUI:  DB01251 is inserted: D02430
NOTICE:  Drug2 RxCUI:  DB09259 is inserted: D03337
NOTICE:  Drug2 RxCUI:  DB01098 is inserted: D08492
NOTICE:  Drug2 RxCUI:  DB04841 is inserted: D01303
NOTICE:  Drug2 RxCUI:  DB04861 is inserted: D05127
NOTICE:  Drug2 RxCUI:  DB01452 is inserted: D07286
NOTICE:  Drug2 RxCUI:  DB00635 is inserted: D00473
NOTICE:  Drug2 RxCUI:  DB08952 is inserted: D08078
NOTICE:  Drug2 RxCUI:  DB09082 is inserted: D09696
NOTICE:  Drug2 RxCUI:  DB01612 is inserted: D00517
NOTICE:  Drug2 RxCUI:  DB00998 is inserted: D07997
NOTICE:  Drug2 RxCUI:  DB09285 is inserted: D05078
NOTICE:  Drug2 RxCUI:  DB00420 is inserted: D08430
NOTICE:  Drug2 RxCUI:  DB01069 is inserted: D00494
NOTICE:  Drug2 RxCUI:  DB00237 is inserted: D03180
NOTICE:  Drug2 RxCUI:  DB00770 is inserted: D00180
NOTICE:  Drug2 RxCUI:  DB13139 is inserted: D08124
NOTICE:  Drug2 RxCUI:  DB14538 is inserted: D06876
NOTICE:  Drug2 RxCUI:  DB01084 is inserted: D07890
NOTICE:  Drug2 RxCUI:  DB04817 is inserted: D08188
NOTICE:  Drug2 RxCUI:  DB00150 is inserted: D00020
NOTICE:  Drug2 RxCUI:  DB00967 is inserted: D03693
NOTICE:  Drug2 RxCUI:  DB01839 is inserted: D00078
NOTICE:  Drug2 RxCUI:  DB01591 is inserted: D08522
NOTICE:  Drug2 RxCUI:  DB00935 is inserted: D08322
NOTICE:  Drug2 RxCUI:  DB11364 is inserted: D07261
NOTICE:  Drug2 RxCUI:  DB00816 is inserted: D00685
NOTICE:  Drug2 RxCUI:  DB08884 is inserted: D04288
NOTICE:  Drug2 RxCUI:  DB13909 is inserted: D01398
NOTICE:  Drug2 RxCUI:  DB01191 is inserted: D07805
NOTICE:  Drug2 RxCUI:  DB00853 is inserted: D06067
NOTICE:  Drug2 RxCUI:  DB09203 is inserted: D07148
NOTICE:  Drug2 RxCUI:  DB00837 is inserted: D05621
NOTICE:  Drug2 RxCUI:  DB09143 is inserted: D10119
NOTICE:  Drug2 RxCUI:  DB06230 is inserted: D05111
NOTICE:  Drug2 RxCUI:  DB09050 is inserted: D10097
NOTICE:  Drug2 RxCUI:  DB06414 is inserted: D04112
NOTICE:  Drug2 RxCUI:  DB00497 is inserted: D05312
NOTICE:  Drug2 RxCUI:  DB11373 is inserted: D02380
NOTICE:  Drug2 RxCUI:  DB04743 is inserted: D01049
NOTICE:  Drug2 RxCUI:  DB00231 is inserted: D00370
NOTICE:  Drug2 RxCUI:  DB09242 is inserted: D05087
NOTICE:  Drug2 RxCUI:  DB01086 is inserted: D00552
NOTICE:  Drug2 RxCUI:  DB00328 is inserted: D00141
NOTICE:  Drug2 RxCUI:  DB01156 is inserted: D07591
NOTICE:  Drug2 RxCUI:  DB08807 is inserted: D07537
NOTICE:  Drug2 RxCUI:  DB09009 is inserted: D07468
NOTICE:  Drug2 RxCUI:  DB04894 is inserted: D06281
NOTICE:  Drug2 RxCUI:  DB00322 is inserted: D04197
NOTICE:  Drug2 RxCUI:  DB00597 is inserted: D01137
NOTICE:  Drug2 RxCUI:  DB11490 is inserted: D08247
NOTICE:  Drug2 RxCUI:  DB06713 is inserted: D05205
NOTICE:  Drug2 RxCUI:  DB00371 is inserted: D00376
NOTICE:  Drug2 RxCUI:  DB00987 is inserted: D00168
NOTICE:  Drug2 RxCUI:  DB13783 is inserted: D01582
NOTICE:  Drug2 RxCUI:  DB00945 is inserted: D00109
NOTICE:  Drug2 RxCUI:  DB01355 is inserted: D01071
NOTICE:  Drug2 RxCUI:  DB00862 is inserted: D08668
NOTICE:  Drug2 RxCUI:  DB00999 is inserted: D00340
NOTICE:  Drug2 RxCUI:  DB13595 is inserted: D07419
NOTICE:  Drug2 RxCUI:  DB00829 is inserted: D00293
NOTICE:  Drug2 RxCUI:  DB06802 is inserted: D05143
NOTICE:  Drug2 RxCUI:  DB09264 is inserted: D10741
NOTICE:  Drug2 RxCUI:  DB01261 is inserted: D08516
NOTICE:  Drug2 RxCUI:  DB00814 is inserted: D00969
NOTICE:  Drug2 RxCUI:  DB00886 is inserted: D01970
NOTICE:  Drug2 RxCUI:  DB01353 is inserted: D02618
NOTICE:  Drug2 RxCUI:  DB03843 is inserted: D00017
NOTICE:  Drug2 RxCUI:  DB00159 is inserted: D08061
NOTICE:  Drug2 RxCUI:  DB01105 is inserted: D08513
NOTICE:  Drug2 RxCUI:  DB00429 is inserted: D00682
NOTICE:  Drug2 RxCUI:  DB00533 is inserted: D00568
NOTICE:  Drug2 RxCUI:  DB00494 is inserted: D00781
NOTICE:  Drug2 RxCUI:  DB00484 is inserted: D07540
NOTICE:  Drug2 RxCUI:  DB01428 is inserted: D05309
NOTICE:  Drug2 RxCUI:  DB01215 is inserted: D00311
NOTICE:  Drug2 RxCUI:  DB00393 is inserted: D00438
NOTICE:  Drug2 RxCUI:  DB01128 is inserted: D00961
NOTICE:  Drug2 RxCUI:  DB01198 is inserted: D01372
NOTICE:  Drug2 RxCUI:  DB00315 is inserted: D00415
NOTICE:  Drug2 RxCUI:  DB09255 is inserted: D00060
NOTICE:  Drug2 RxCUI:  DB00880 is inserted: D00519
NOTICE:  Drug2 RxCUI:  DB04812 is inserted: D03080
NOTICE:  Drug2 RxCUI:  DB00905 is inserted: D02724
NOTICE:  Drug2 RxCUI:  DB01142 is inserted: D07875
NOTICE:  Drug2 RxCUI:  DB00217 is inserted: D01603
NOTICE:  Drug2 RxCUI:  DB01020 is inserted: D00630
NOTICE:  Drug2 RxCUI:  DB08999 is inserted: D07370
NOTICE:  Drug2 RxCUI:  DB01011 is inserted: D00410
NOTICE:  Drug2 RxCUI:  DB11988 is inserted: D05218
NOTICE:  Drug2 RxCUI:  DB00688 is inserted: D00752
NOTICE:  Drug2 RxCUI:  DB08797 is inserted: D01811
NOTICE:  Drug2 RxCUI:  DB04552 is inserted: D08275
NOTICE:  Drug2 RxCUI:  DB00252 is inserted: D00512
NOTICE:  Drug2 RxCUI:  DB01114 is inserted: D07398
NOTICE:  Drug2 RxCUI:  DB00222 is inserted: D00593
NOTICE:  Drug2 RxCUI:  DB00501 is inserted: D00295
NOTICE:  Drug2 RxCUI:  DB00309 is inserted: D01769
NOTICE:  Drug2 RxCUI:  DB00844 is inserted: D08246
NOTICE:  Drug2 RxCUI:  DB06643 is inserted: D03684
NOTICE:  Drug2 RxCUI:  DB00581 is inserted: D00352
NOTICE:  Drug2 RxCUI:  DB13470 is inserted: D07643
NOTICE:  Drug2 RxCUI:  DB01410 is inserted: D01703
NOTICE:  Drug2 RxCUI:  DB00261 is inserted: D07455
NOTICE:  Drug2 RxCUI:  DB00801 is inserted: D00338
NOTICE:  Drug2 RxCUI:  DB13264 is inserted: D07233
NOTICE:  Drug2 RxCUI:  DB00591 is inserted: D01825
NOTICE:  Drug2 RxCUI:  DB04871 is inserted: D06613
NOTICE:  Drug2 RxCUI:  DB00040 is inserted: D00116
NOTICE:  Drug2 RxCUI:  DB06203 is inserted: D06553
NOTICE:  Drug2 RxCUI:  DB05294 is inserted: D06407
NOTICE:  Drug2 RxCUI:  DB01306 is inserted: D04475
NOTICE:  Drug2 RxCUI:  DB06791 is inserted: D04666
NOTICE:  Drug2 RxCUI:  DB00629 is inserted: D04375
NOTICE:  Drug2 RxCUI:  DB01489 is inserted: D07315
NOTICE:  Drug2 RxCUI:  DB08955 is inserted: D07268
NOTICE:  Drug2 RxCUI:  DB00521 is inserted: D07624
NOTICE:  Drug2 RxCUI:  DB00812 is inserted: D00510
NOTICE:  Drug2 RxCUI:  DB13739 is inserted: D05406
NOTICE:  Drug2 RxCUI:  DB00305 is inserted: D00208
NOTICE:  Drug2 RxCUI:  DB09154 is inserted: D05855
NOTICE:  Drug2 RxCUI:  DB06717 is inserted: D06597
NOTICE:  Drug2 RxCUI:  DB06413 is inserted: D03215
NOTICE:  Drug2 RxCUI:  DB08881 is inserted: D09996
NOTICE:  Drug2 RxCUI:  DB01435 is inserted: D01776
NOTICE:  Drug2 RxCUI:  DB05262 is inserted: D02365
NOTICE:  Drug2 RxCUI:  DB11405 is inserted: D04037
NOTICE:  Drug2 RxCUI:  DB00091 is inserted: D00184
NOTICE:  Drug2 RxCUI:  DB11389 is inserted: D03565
NOTICE:  Drug2 RxCUI:  DB00381 is inserted: D07450
NOTICE:  Drug2 RxCUI:  DB01196 is inserted: D04066
NOTICE:  Drug2 RxCUI:  DB00690 is inserted: D00329
NOTICE:  Drug2 RxCUI:  DB00922 is inserted: D04720
NOTICE:  Drug2 RxCUI:  DB00910 is inserted: D00930
NOTICE:  Drug2 RxCUI:  DB00744 is inserted: D00414
NOTICE:  Drug2 RxCUI:  DB01268 is inserted: D06402
NOTICE:  Drug2 RxCUI:  DB11576 is inserted: D04168
NOTICE:  Drug2 RxCUI:  DB14482 is inserted: D05853
NOTICE:  Drug2 RxCUI:  DB00377 is inserted: D07175
NOTICE:  Drug2 RxCUI:  DB12712 is inserted: D08377
NOTICE:  Drug2 RxCUI:  DB06204 is inserted: D06007
NOTICE:  Drug2 RxCUI:  DB09378 is inserted: D04227
NOTICE:  Drug2 RxCUI:  DB00593 is inserted: D00539
NOTICE:  Drug2 RxCUI:  DB01390 is inserted: D01203
NOTICE:  Drug2 RxCUI:  DB00996 is inserted: D00332
NOTICE:  Drug2 RxCUI:  DB00805 is inserted: D05039
NOTICE:  Drug2 RxCUI:  DB00343 is inserted: D07845
NOTICE:  Drug2 RxCUI:  DB00338 is inserted: D00455
NOTICE:  Drug2 RxCUI:  DB01536 is inserted: D00051
NOTICE:  Drug2 RxCUI:  DB01068 is inserted: D00280
NOTICE:  Drug2 RxCUI:  DB00881 is inserted: D03752
NOTICE:  Drug2 RxCUI:  DB01345 is inserted: D08403
NOTICE:  Drug2 RxCUI:  DB00989 is inserted: D03822
NOTICE:  Drug2 RxCUI:  DB00104 is inserted: D00442
NOTICE:  Drug2 RxCUI:  DB00745 is inserted: D01832
NOTICE:  Drug2 RxCUI:  DB00662 is inserted: D08643
NOTICE:  Drug2 RxCUI:  DB06823 is inserted: D01430
NOTICE:  Drug2 RxCUI:  DB11544 is inserted: D08502
NOTICE:  Drug2 RxCUI:  DB01021 is inserted: D00658
NOTICE:  Drug2 RxCUI:  DB01241 is inserted: D00334
NOTICE:  Drug2 RxCUI:  DB01260 is inserted: D03696
NOTICE:  Drug2 RxCUI:  DB11458 is inserted: D05771
NOTICE:  Drug2 RxCUI:  DB14541 is inserted: D00976
NOTICE:  Drug2 RxCUI:  DB00806 is inserted: D00501
NOTICE:  Drug2 RxCUI:  DB01206 is inserted: D00363
NOTICE:  Drug2 RxCUI:  DB00901 is inserted: D07534
NOTICE:  Drug2 RxCUI:  DB00784 is inserted: D00151
NOTICE:  Drug2 RxCUI:  DB01544 is inserted: D01230
NOTICE:  Drug2 RxCUI:  DB00877 is inserted: D00753
NOTICE:  Drug2 RxCUI:  DB00311 is inserted: D02441
NOTICE:  Drug2 RxCUI:  DB09139 is inserted: D06041
NOTICE:  Drug2 RxCUI:  DB04865 is inserted: D08956
NOTICE:  Drug2 RxCUI:  DB00939 is inserted: D02341
NOTICE:  Drug2 RxCUI:  DB01359 is inserted: D08074
NOTICE:  Drug2 RxCUI:  DB04878 is inserted: D01665
NOTICE:  Drug2 RxCUI:  DB00184 is inserted: D03365
NOTICE:  Drug2 RxCUI:  DB00186 is inserted: D00365
NOTICE:  Drug2 RxCUI:  DB09371 is inserted: D05207
NOTICE:  Drug2 RxCUI:  DB13209 is inserted: D01642
NOTICE:  Drug2 RxCUI:  DB09288 is inserted: D07294
NOTICE:  Drug2 RxCUI:  DB06797 is inserted: D01807
NOTICE:  Drug2 RxCUI:  DB01135 is inserted: D00760
NOTICE:  Drug2 RxCUI:  DB09214 is inserted: D07269
NOTICE:  Drug2 RxCUI:  DB06612 is inserted: D04923
NOTICE:  Drug2 RxCUI:  DB00627 is inserted: D00049
NOTICE:  Drug2 RxCUI:  DB01032 is inserted: D00475
NOTICE:  Drug2 RxCUI:  DB11446 is inserted: D05291
NOTICE:  Drug2 RxCUI:  DB00946 is inserted: D05457
NOTICE:  Drug2 RxCUI:  DB06694 is inserted: D08684
NOTICE:  Drug2 RxCUI:  DB02300 is inserted: D01125
NOTICE:  Drug2 RxCUI:  DB00047 is inserted: D03250
NOTICE:  Drug2 RxCUI:  DB08826 is inserted: D07416
NOTICE:  Drug2 RxCUI:  DB09477 is inserted: D03769
NOTICE:  Drug2 RxCUI:  DB09000 is inserted: D07307
NOTICE:  Drug2 RxCUI:  DB00687 is inserted: D07967
NOTICE:  Drug2 RxCUI:  DB11380 is inserted: D03340
NOTICE:  Drug2 RxCUI:  DB00590 is inserted: D07874
NOTICE:  Drug2 RxCUI:  DB12667 is inserted: D01195
NOTICE:  Drug2 RxCUI:  DB01262 is inserted: D03665
NOTICE:  Drug2 RxCUI:  DB00704 is inserted: D05113
NOTICE:  Drug2 RxCUI:  DB13314 is inserted: D01513
NOTICE:  Drug2 RxCUI:  DB00854 is inserted: D08123
NOTICE:  Drug2 RxCUI:  DB04830 is inserted: D00595
NOTICE:  Drug2 RxCUI:  DB08980 is inserted: D07185
NOTICE:  Drug2 RxCUI:  DB13524 is inserted: D01380
NOTICE:  Drug2 RxCUI:  DB00177 is inserted: D00400
NOTICE:  Drug2 RxCUI:  DB08897 is inserted: D08837
NOTICE:  Drug2 RxCUI:  DB11485 is inserted: D07657
NOTICE:  Drug2 RxCUI:  DB00411 is inserted: D00524
NOTICE:  Drug2 RxCUI:  DB00616 is inserted: D01070
NOTICE:  Drug2 RxCUI:  DB00810 is inserted: D00779
NOTICE:  Drug2 RxCUI:  DB00679 is inserted: D00373
NOTICE:  Drug2 RxCUI:  DB03419 is inserted: D00027
NOTICE:  Drug2 RxCUI:  DB01244 is inserted: D07520
NOTICE:  Drug2 RxCUI:  DB09209 is inserted: D07385
NOTICE:  Drug2 RxCUI:  DB04855 is inserted: D02537
NOTICE:  Drug2 RxCUI:  DB01202 is inserted: D00709
NOTICE:  Drug2 RxCUI:  DB00809 is inserted: D00397
NOTICE:  Drug2 RxCUI:  DB01200 is inserted: D03165
NOTICE:  Drug2 RxCUI:  DB05381 is inserted: D08040
NOTICE:  Drug2 RxCUI:  DB01039 is inserted: D00565
NOTICE:  Drug2 RxCUI:  DB00957 is inserted: D05209
NOTICE:  Drug2 RxCUI:  DB08912 is inserted: D10064
NOTICE:  Drug2 RxCUI:  DB00282 is inserted: D07281
NOTICE:  Drug2 RxCUI:  DB00550 is inserted: D00562
NOTICE:  Drug2 RxCUI:  DB08883 is inserted: D08964
NOTICE:  Drug2 RxCUI:  DB08869 is inserted: D09015
NOTICE:  Drug2 RxCUI:  DB01589 is inserted: D00457
NOTICE:  Drug2 RxCUI:  DB14512 is inserted: D00690
NOTICE:  Drug2 RxCUI:  DB09113 is inserted: D08402
NOTICE:  Drug2 RxCUI:  DB08984 is inserted: D04102
NOTICE:  Drug2 RxCUI:  DB00111 is inserted: D03639
NOTICE:  Drug2 RxCUI:  DB08810 is inserted: D07700
NOTICE:  Drug2 RxCUI:  DB09272 is inserted: D10403
NOTICE:  Drug2 RxCUI:  DB14004 is inserted: D10400
NOTICE:  Drug2 RxCUI:  DB00441 is inserted: D02368
NOTICE:  Drug2 RxCUI:  DB09290 is inserted: D08466
NOTICE:  Drug2 RxCUI:  DB01547 is inserted: D01496
NOTICE:  Drug2 RxCUI:  DB01097 is inserted: D00749
NOTICE:  Drug2 RxCUI:  DB01217 is inserted: D00960
NOTICE:  Drug2 RxCUI:  DB05137 is inserted: D02364
NOTICE:  Drug2 RxCUI:  DB00846 is inserted: D00328
NOTICE:  Drug2 RxCUI:  DB14681 is inserted: D07749
NOTICE:  Drug2 RxCUI:  DB00970 is inserted: D00214
NOTICE:  Drug2 RxCUI:  DB04890 is inserted: D01654
NOTICE:  Drug2 RxCUI:  DB00586 is inserted: D07816
NOTICE:  Drug2 RxCUI:  DB00472 is inserted: D00823
NOTICE:  Drug2 RxCUI:  DB00651 is inserted: D00691
NOTICE:  Drug2 RxCUI:  DB00929 is inserted: D00419
NOTICE:  Drug2 RxCUI:  DB00416 is inserted: D00761
NOTICE:  Drug2 RxCUI:  DB09318 is inserted: D05987
NOTICE:  Drug2 RxCUI:  DB01534 is inserted: D07325
NOTICE:  Drug2 RxCUI:  DB11480 is inserted: D07857
NOTICE:  Drug2 RxCUI:  DB14655 is inserted: D01534
NOTICE:  Drug2 RxCUI:  DB01233 is inserted: D00726
NOTICE:  Drug2 RxCUI:  DB00346 is inserted: D07124
NOTICE:  Drug2 RxCUI:  DB00480 is inserted: D04687
NOTICE:  Drug2 RxCUI:  DB00289 is inserted: D07473
NOTICE:  Drug2 RxCUI:  DB00293 is inserted: D01064
NOTICE:  Drug2 RxCUI:  DB00594 is inserted: D07447
NOTICE:  Drug2 RxCUI:  DB09230 is inserted: D01145
NOTICE:  Drug2 RxCUI:  DB00334 is inserted: D00454
NOTICE:  Drug2 RxCUI:  DB00535 is inserted: D00917
NOTICE:  Drug2 RxCUI:  DB00356 is inserted: D00771
NOTICE:  Drug2 RxCUI:  DB00281 is inserted: D00358
NOTICE:  Drug2 RxCUI:  DB00749 is inserted: D00315
NOTICE:  Drug2 RxCUI:  DB00444 is inserted: D02698
NOTICE:  Drug2 RxCUI:  DB06688 is inserted: D06644
NOTICE:  Drug2 RxCUI:  DB06738 is inserted: D08100
NOTICE:  Drug2 RxCUI:  DB08916 is inserted: D09724
NOTICE:  Drug2 RxCUI:  DB01624 is inserted: D03556
NOTICE:  Drug2 RxCUI:  DB09063 is inserted: D10551
NOTICE:  Drug2 RxCUI:  DB01365 is inserted: D08180
NOTICE:  Drug2 RxCUI:  DB02266 is inserted: D01581
NOTICE:  Drug2 RxCUI:  DB11581 is inserted: D10679
NOTICE:  Drug2 RxCUI:  DB02925 is inserted: D01634
NOTICE:  Drug2 RxCUI:  DB06288 is inserted: D07310
NOTICE:  Drug2 RxCUI:  DB00388 is inserted: D08365
NOTICE:  Drug2 RxCUI:  DB11429 is inserted: D05025
NOTICE:  Drug2 RxCUI:  DB04844 is inserted: D08575
NOTICE:  Drug2 RxCUI:  DB06753 is inserted: D08634
NOTICE:  Drug2 RxCUI:  DB04839 is inserted: D01368
NOTICE:  Drug2 RxCUI:  DB01529 is inserted: D07287
NOTICE:  Drug2 RxCUI:  DB06774 is inserted: D00250
NOTICE:  Drug2 RxCUI:  DB08981 is inserted: D01344
NOTICE:  Drug2 RxCUI:  DB09216 is inserted: D01183
NOTICE:  Drug2 RxCUI:  DB00344 is inserted: D08447
NOTICE:  Drug2 RxCUI:  DB09065 is inserted: D09881
NOTICE:  Drug2 RxCUI:  DB06674 is inserted: D04358
NOTICE:  Drug2 RxCUI:  DB00981 is inserted: D00196
NOTICE:  Drug2 RxCUI:  DB09271 is inserted: D07099
NOTICE:  Drug2 RxCUI:  DB01171 is inserted: D02561
NOTICE:  Drug2 RxCUI:  DB04896 is inserted: D08222
NOTICE:  Drug2 RxCUI:  DB00470 is inserted: D00306
NOTICE:  Drug2 RxCUI:  DB00892 is inserted: D08319
NOTICE:  Drug2 RxCUI:  DB01420 is inserted: D00959
NOTICE:  Drug2 RxCUI:  DB14026 is inserted: D08586
NOTICE:  Drug2 RxCUI:  DB00936 is inserted: D00097
NOTICE:  Drug2 RxCUI:  DB11619 is inserted: D04317
NOTICE:  Drug2 RxCUI:  DB00530 is inserted: D07907
NOTICE:  Drug2 RxCUI:  DB01057 is inserted: D02193
NOTICE:  Drug2 RxCUI:  DB00280 is inserted: D00303
NOTICE:  Drug2 RxCUI:  DB11390 is inserted: D07750
NOTICE:  Drug2 RxCUI:  DB12332 is inserted: D10079
NOTICE:  Drug2 RxCUI:  DB14646 is inserted: D08416
NOTICE:  Drug2 RxCUI:  DB08898 is inserted: D10260
NOTICE:  Drug2 RxCUI:  DB00514 is inserted: D03742
NOTICE:  Drug2 RxCUI:  DB00200 is inserted: D01027
NOTICE:  Drug2 RxCUI:  DB06761 is inserted: D03096
NOTICE:  Drug2 RxCUI:  DB08994 is inserted: D07138
NOTICE:  Drug2 RxCUI:  DB00384 is inserted: D00386
NOTICE:  Drug2 RxCUI:  DB09488 is inserted: D02760
NOTICE:  Drug2 RxCUI:  DB00741 is inserted: D00088
NOTICE:  Drug2 RxCUI:  DB00323 is inserted: D00786
NOTICE:  Drug2 RxCUI:  DB09119 is inserted: D09612
NOTICE:  Drug2 RxCUI:  DB00475 is inserted: D00267
NOTICE:  Drug2 RxCUI:  DB00190 is inserted: D00558
NOTICE:  Drug2 RxCUI:  DB00277 is inserted: D00371
NOTICE:  Drug2 RxCUI:  DB06772 is inserted: D09755
NOTICE:  Drug2 RxCUI:  DB00519 is inserted: D00383
NOTICE:  Drug2 RxCUI:  DB00367 is inserted: D00950
NOTICE:  Drug2 RxCUI:  DB01581 is inserted: D02435
NOTICE:  Drug2 RxCUI:  DB01954 is inserted: D01783
NOTICE:  Drug2 RxCUI:  DB01521 is inserted: D07731
NOTICE:  Drug2 RxCUI:  DB13667 is inserted: D01052
NOTICE:  Drug2 RxCUI:  DB00887 is inserted: D00247
NOTICE:  Drug2 RxCUI:  DB09204 is inserted: D07465
NOTICE:  Drug2 RxCUI:  DB00882 is inserted: D07726
NOTICE:  Drug2 RxCUI:  DB00009 is inserted: D02837
NOTICE:  Drug2 RxCUI:  DB01708 is inserted: D08409
NOTICE:  Drug2 RxCUI:  DB01203 is inserted: D00432
NOTICE:  Drug2 RxCUI:  DB00158 is inserted: D00070
NOTICE:  Drug2 RxCUI:  DB04889 is inserted: D03110
NOTICE:  Drug2 RxCUI:  DB00563 is inserted: D00142
NOTICE:  Drug2 RxCUI:  DB11543 is inserted: D08487
NOTICE:  Drug2 RxCUI:  DB01436 is inserted: D01518
NOTICE:  Drug2 RxCUI:  DB09282 is inserted: D01320
NOTICE:  Drug2 RxCUI:  DB00482 is inserted: D00567
NOTICE:  Drug2 RxCUI:  DB09007 is inserted: D07198
NOTICE:  Drug2 RxCUI:  DB01014 is inserted: D07488
NOTICE:  Drug2 RxCUI:  DB00841 is inserted: D03879
NOTICE:  Drug2 RxCUI:  DB09073 is inserted: D10372
NOTICE:  Drug2 RxCUI:  DB01550 is inserted: D07947
NOTICE:  Drug2 RxCUI:  DB00884 is inserted: D08484
NOTICE:  Drug2 RxCUI:  DB00242 is inserted: D01370
NOTICE:  Drug2 RxCUI:  DB09079 is inserted: D10481
NOTICE:  Drug2 RxCUI:  DB00502 is inserted: D00136
NOTICE:  Drug2 RxCUI:  DB01193 is inserted: D02338
NOTICE:  Drug2 RxCUI:  DB12243 is inserted: D01552
NOTICE:  Drug2 RxCUI:  DB01049 is inserted: D02268
NOTICE:  Drug2 RxCUI:  DB00750 is inserted: D00553
NOTICE:  Drug2 RxCUI:  DB01047 is inserted: D00325
NOTICE:  Drug2 RxCUI:  DB01408 is inserted: D07377
NOTICE:  Drug2 RxCUI:  DB00588 is inserted: D01708
NOTICE:  Drug2 RxCUI:  DB11397 is inserted: D03791
NOTICE:  Drug2 RxCUI:  DB14012 is inserted: D10913
NOTICE:  Drug2 RxCUI:  DB06718 is inserted: D00444
NOTICE:  Drug2 RxCUI:  DB13997 is inserted: D11021
NOTICE:  Drug2 RxCUI:  DB00423 is inserted: D00402
NOTICE:  Drug2 RxCUI:  DB09221 is inserted: D01611
NOTICE:  Drug2 RxCUI:  DB00678 is inserted: D08146
NOTICE:  Drug2 RxCUI:  DB00451 is inserted: D08125
NOTICE:  Drug2 RxCUI:  DB13781 is inserted: D06328
NOTICE:  Drug2 RxCUI:  DB11411 is inserted: D04160
NOTICE:  Drug2 RxCUI:  DB00345 is inserted: D06890
NOTICE:  Drug2 RxCUI:  DB00268 is inserted: D08489
NOTICE:  Drug2 RxCUI:  DB11282 is inserted: D02379
NOTICE:  Drug2 RxCUI:  DB08908 is inserted: D03846
NOTICE:  Drug2 RxCUI:  DB01277 is inserted: D04870
NOTICE:  Drug2 RxCUI:  DB00831 is inserted: D08636
NOTICE:  Drug2 RxCUI:  DB09080 is inserted: D10145
NOTICE:  Drug2 RxCUI:  DB01586 is inserted: D00734
NOTICE:  Drug2 RxCUI:  DB01126 is inserted: D03820
NOTICE:  Drug2 RxCUI:  DB00908 is inserted: D08458
NOTICE:  Drug2 RxCUI:  DB00209 is inserted: D01103
NOTICE:  Drug2 RxCUI:  DB04854 is inserted: D01206
NOTICE:  Drug2 RxCUI:  DB09263 is inserted: D10148
NOTICE:  Drug2 RxCUI:  DB06401 is inserted: D03062
NOTICE:  Drug2 RxCUI:  DB11121 is inserted: D03473
NOTICE:  Drug2 RxCUI:  DB00764 is inserted: D08227
NOTICE:  Drug2 RxCUI:  DB09085 is inserted: D00551
NOTICE:  Drug2 RxCUI:  DB00953 is inserted: D00675
NOTICE:  Drug2 RxCUI:  DB01173 is inserted: D08305
NOTICE:  Drug2 RxCUI:  DB09137 is inserted: D06037
NOTICE:  Drug2 RxCUI:  DB00230 is inserted: D02716
NOTICE:  Drug2 RxCUI:  DB14543 is inserted: D01886
NOTICE:  Drug2 RxCUI:  DB01107 is inserted: D01150
NOTICE:  Drug2 RxCUI:  DB11376 is inserted: D02620
NOTICE:  Drug2 RxCUI:  DB06283 is inserted: D06363
NOTICE:  Drug2 RxCUI:  DB00777 is inserted: D02361
NOTICE:  Drug2 RxCUI:  DB00357 is inserted: D00574
NOTICE:  Drug2 RxCUI:  DB00808 is inserted: D00345
NOTICE:  Drug2 RxCUI:  DB06623 is inserted: D07978
NOTICE:  Drug2 RxCUI:  DB08828 is inserted: D09992
NOTICE:  Drug2 RxCUI:  DB14125 is inserted: D03077
NOTICE:  Drug2 RxCUI:  DB09128 is inserted: D10309
NOTICE:  Drug2 RxCUI:  DB00353 is inserted: D00680
NOTICE:  Drug2 RxCUI:  DB00754 is inserted: D00708
NOTICE:  Drug2 RxCUI:  DB00700 is inserted: D01115
NOTICE:  Drug2 RxCUI:  DB00270 is inserted: D00349
NOTICE:  Drug2 RxCUI:  DB06704 is inserted: D04559
NOTICE:  Drug2 RxCUI:  DB00241 is inserted: D03182
NOTICE:  Drug2 RxCUI:  DB01351 is inserted: D00555
NOTICE:  Drug2 RxCUI:  DB12278 is inserted: D08441
NOTICE:  Drug2 RxCUI:  DB00774 is inserted: D00654
NOTICE:  Drug2 RxCUI:  DB01618 is inserted: D08226
NOTICE:  Drug2 RxCUI:  DB05016 is inserted: D09323
NOTICE:  Drug2 RxCUI:  DB00017 is inserted: D00249
NOTICE:  Drug2 RxCUI:  DB01296 is inserted: D04334
NOTICE:  Drug2 RxCUI:  DB01054 is inserted: D00629
NOTICE:  Drug2 RxCUI:  DB00246 is inserted: D08687
NOTICE:  Drug2 RxCUI:  DB00934 is inserted: D02566
NOTICE:  Drug2 RxCUI:  DB05679 is inserted: D09214
NOTICE:  Drug2 RxCUI:  DB06415 is inserted: D03317
NOTICE:  Drug2 RxCUI:  DB00628 is inserted: D00694
NOTICE:  Drug2 RxCUI:  DB01606 is inserted: D00660
NOTICE:  Drug2 RxCUI:  DB14025 is inserted: D02539
NOTICE:  Drug2 RxCUI:  DB13527 is inserted: D08427
NOTICE:  Drug2 RxCUI:  DB00584 is inserted: D07892
NOTICE:  Drug2 RxCUI:  DB00863 is inserted: D00422
NOTICE:  Drug2 RxCUI:  DB06213 is inserted: D05711
NOTICE:  Drug2 RxCUI:  DB01352 is inserted: D00698
NOTICE:  Drug2 RxCUI:  DB09298 is inserted: D08515
NOTICE:  Drug2 RxCUI:  DB00304 is inserted: D02367
NOTICE:  Drug2 RxCUI:  DB01136 is inserted: D00255
NOTICE:  Drug2 RxCUI:  DB00712 is inserted: D00330
NOTICE:  Drug2 RxCUI:  DB13620 is inserted: D01298
NOTICE:  Drug2 RxCUI:  DB01282 is inserted: D07229
NOTICE:  Drug2 RxCUI:  DB09156 is inserted: D01893
NOTICE:  Drug2 RxCUI:  DB00795 is inserted: D00448
NOTICE:  Drug2 RxCUI:  DB05578 is inserted: D09371
NOTICE:  Drug2 RxCUI:  DB09287 is inserted: D03370
NOTICE:  Drug2 RxCUI:  DB00917 is inserted: D00079
NOTICE:  Drug2 RxCUI:  DB00351 is inserted: D00952
NOTICE:  Drug2 RxCUI:  DB13399 is inserted: D01348
NOTICE:  Drug2 RxCUI:  DB11428 is inserted: D08165
NOTICE:  Drug2 RxCUI:  DB11477 is inserted: D08683
NOTICE:  Drug2 RxCUI:  DB01246 is inserted: D07125
NOTICE:  Drug2 RxCUI:  DB00834 is inserted: D00585
NOTICE:  Drug2 RxCUI:  DB01078 is inserted: D01240
NOTICE:  Drug2 RxCUI:  DB01006 is inserted: D00964
NOTICE:  Drug2 RxCUI:  DB00215 is inserted: D07704
NOTICE:  Drug2 RxCUI:  DB01253 is inserted: D07905
NOTICE:  Drug2 RxCUI:  DB01058 is inserted: D00471
NOTICE:  Drug2 RxCUI:  DB13896 is inserted: D09966
NOTICE:  Drug2 RxCUI:  DB00755 is inserted: D00094
NOTICE:  Drug2 RxCUI:  DB06603 is inserted: D10019
NOTICE:  Drug2 RxCUI:  DB08815 is inserted: D04820
NOTICE:  Drug2 RxCUI:  DB00421 is inserted: D00443
NOTICE:  Drug2 RxCUI:  DB04851 is inserted: D03128
NOTICE:  Drug2 RxCUI:  DB06626 is inserted: D03218
NOTICE:  Drug2 RxCUI:  DB06274 is inserted: D02878
NOTICE:  Drug2 RxCUI:  DB14545 is inserted: D01442
NOTICE:  Drug2 RxCUI:  DB11512 is inserted: D07840
NOTICE:  Drug2 RxCUI:  DB08925 is inserted: D07348
NOTICE:  Drug2 RxCUI:  DB00352 is inserted: D08603
NOTICE:  Drug2 RxCUI:  DB01119 is inserted: D00294
NOTICE:  Drug2 RxCUI:  DB00788 is inserted: D00118
NOTICE:  Drug2 RxCUI:  DB00269 is inserted: D00269
NOTICE:  Drug2 RxCUI:  DB00532 is inserted: D00375
NOTICE:  Drug2 RxCUI:  DB09236 is inserted: D04657
NOTICE:  Drug2 RxCUI:  DB00991 is inserted: D00463
NOTICE:  Drug2 RxCUI:  DB00715 is inserted: D02362
NOTICE:  Drug2 RxCUI:  DB00652 is inserted: D00498
NOTICE:  Drug2 RxCUI:  DB05076 is inserted: D04162
NOTICE:  Drug2 RxCUI:  DB00568 is inserted: D01295
NOTICE:  Drug2 RxCUI:  DB00988 is inserted: D07870
NOTICE:  Drug2 RxCUI:  DB00717 is inserted: D00182
NOTICE:  Drug2 RxCUI:  DB01399 is inserted: D00428
NOTICE:  Drug2 RxCUI:  DB09149 is inserted: D09617
NOTICE:  Drug2 RxCUI:  DB06210 is inserted: D03978
NOTICE:  Drug2 RxCUI:  DB11823 is inserted: D07283
NOTICE:  Drug2 RxCUI:  DB00455 is inserted: D00364
NOTICE:  Drug2 RxCUI:  DB00396 is inserted: D00066
NOTICE:  Drug2 RxCUI:  DB00508 is inserted: D00390
NOTICE:  Drug2 RxCUI:  DB14039 is inserted: D10928
NOTICE:  Drug2 RxCUI:  DB09062 is inserted: D07642
NOTICE:  Drug2 RxCUI:  DB06207 is inserted: D01965
NOTICE:  Drug2 RxCUI:  DB00883 is inserted: D00516
NOTICE:  Drug2 RxCUI:  DB00214 is inserted: D00382
NOTICE:  Drug2 RxCUI:  DB00783 is inserted: D00105
NOTICE:  Drug2 RxCUI:  DB00498 is inserted: D08354
NOTICE:  Drug2 RxCUI:  DB01238 is inserted: D01164
NOTICE:  Drug2 RxCUI:  DB09247 is inserted: D07338
NOTICE:  Drug2 RxCUI:  DB00995 is inserted: D00237
NOTICE:  Drug2 RxCUI:  DB09208 is inserted: D09316
NOTICE:  Drug2 RxCUI:  DB09017 is inserted: D01744
NOTICE:  Drug2 RxCUI:  DB11413 is inserted: D04194
NOTICE:  Drug2 RxCUI:  DB00324 is inserted: D01367
NOTICE:  Drug2 RxCUI:  DB00927 is inserted: D00318
NOTICE:  Drug2 RxCUI:  DB08865 is inserted: D09731
NOTICE:  Drug2 RxCUI:  DB01026 is inserted: D00351
NOTICE:  Drug2 RxCUI:  DB00562 is inserted: D00651
NOTICE:  Drug2 RxCUI:  DB05099 is inserted: D02938
NOTICE:  Drug2 RxCUI:  DB08808 is inserted: D07590
NOTICE:  Drug2 RxCUI:  DB09257 is inserted: D01846
NOTICE:  Drug2 RxCUI:  DB14492 is inserted: D00860
NOTICE:  Drug2 RxCUI:  DB13158 is inserted: D07717
NOTICE:  Drug2 RxCUI:  DB00316 is inserted: D00217
NOTICE:  Drug2 RxCUI:  DB09064 is inserted: D03521
NOTICE:  Drug2 RxCUI:  DB01224 is inserted: D08456
NOTICE:  Drug2 RxCUI:  DB00899 is inserted: D08473
NOTICE:  Drug2 RxCUI:  DB00986 is inserted: D00540
NOTICE:  Drug2 RxCUI:  DB00736 is inserted: D07917
NOTICE:  Drug2 RxCUI:  DB04868 is inserted: D08953
NOTICE:  Drug2 RxCUI:  DB01093 is inserted: D01043
NOTICE:  Drug2 RxCUI:  DB00286 is inserted: D04070
NOTICE:  Drug2 RxCUI:  DB06372 is inserted: D06635
NOTICE:  Drug2 RxCUI:  DB01438 is inserted: D08346
NOTICE:  Drug2 RxCUI:  DB09296 is inserted: D10745
NOTICE:  Drug2 RxCUI:  DB06202 is inserted: D04672
NOTICE:  Drug2 RxCUI:  DB01189 is inserted: D00546
NOTICE:  Drug2 RxCUI:  DB01252 is inserted: D01854
NOTICE:  Drug2 RxCUI:  DB01364 is inserted: D00124
NOTICE:  Drug2 RxCUI:  DB01594 is inserted: D07328
NOTICE:  Drug2 RxCUI:  DB01023 is inserted: D00319
NOTICE:  Drug2 RxCUI:  DB06267 is inserted: D10027
NOTICE:  Drug2 RxCUI:  DB06663 is inserted: D10147
NOTICE:  Drug2 RxCUI:  DB09163 is inserted: D02284
NOTICE:  Drug2 RxCUI:  DB00747 is inserted: D00138
NOTICE:  Drug2 RxCUI:  DB08940 is inserted: D01567
NOTICE:  Drug2 RxCUI:  DB00499 is inserted: D00586
NOTICE:  Drug2 RxCUI:  DB06800 is inserted: D06618
NOTICE:  Drug2 RxCUI:  DB09213 is inserted: D03715
NOTICE:  Drug2 RxCUI:  DB12947 is inserted: D01309
NOTICE:  Drug2 RxCUI:  DB06441 is inserted: D03359
NOTICE:  Drug2 RxCUI:  DB08931 is inserted: D09572
NOTICE:  Drug2 RxCUI:  DB13074 is inserted: D10563
NOTICE:  Drug2 RxCUI:  DB00723 is inserted: D08201
NOTICE:  Drug2 RxCUI:  DB09068 is inserted: D10184
NOTICE:  Drug2 RxCUI:  DB00658 is inserted: D01983
NOTICE:  Drug2 RxCUI:  DB00490 is inserted: D07593
NOTICE:  Drug2 RxCUI:  DB11596 is inserted: D04715
NOTICE:  Drug2 RxCUI:  DB01626 is inserted: D08453
NOTICE:  Drug2 RxCUI:  DB00672 is inserted: D00271
NOTICE:  Drug2 RxCUI:  DB06206 is inserted: D05940
NOTICE:  Drug2 RxCUI:  DB09105 is inserted: D10595
NOTICE:  Drug2 RxCUI:  DB01042 is inserted: D00369
NOTICE:  Drug2 RxCUI:  DB09033 is inserted: D08083
NOTICE:  Drug2 RxCUI:  DB09134 is inserted: D01555
NOTICE:  Drug2 RxCUI:  DB00354 is inserted: D07547
NOTICE:  Drug2 RxCUI:  DB01234 is inserted: D00292
NOTICE:  Drug2 RxCUI:  DB06292 is inserted: D08897
NOTICE:  Drug2 RxCUI:  DB08802 is inserted: D08091
NOTICE:  Drug2 RxCUI:  DB01400 is inserted: D08261
NOTICE:  Drug2 RxCUI:  DB01380 is inserted: D00973
NOTICE:  Drug2 RxCUI:  DB00541 is inserted: D08679
NOTICE:  Drug2 RxCUI:  DB06527 is inserted: D06202
NOTICE:  Drug2 RxCUI:  DB00166 is inserted: D00086
NOTICE:  Drug2 RxCUI:  DB04884 is inserted: D03649
NOTICE:  Drug2 RxCUI:  DB09215 is inserted: D07267
NOTICE:  Drug2 RxCUI:  DB13757 is inserted: D06646
NOTICE:  Drug2 RxCUI:  DB13836 is inserted: D07234
NOTICE:  Drug2 RxCUI:  DB09301 is inserted: D00080
NOTICE:  Drug2 RxCUI:  DB09211 is inserted: D02722
NOTICE:  Drug2 RxCUI:  DB09218 is inserted: D03555
NOTICE:  Drug2 RxCUI:  DB00178 is inserted: D00421
NOTICE:  Drug2 RxCUI:  DB01342 is inserted: D04243
NOTICE:  Drug2 RxCUI:  DB00310 is inserted: D00272
NOTICE:  Drug2 RxCUI:  DB00221 is inserted: D04625
NOTICE:  Drug2 RxCUI:  DB00889 is inserted: D04370
NOTICE:  Drug2 RxCUI:  DB00660 is inserted: D00773
NOTICE:  Drug2 RxCUI:  DB09030 is inserted: D09765
NOTICE:  Drug2 RxCUI:  DB08907 is inserted: D09592
NOTICE:  Drug2 RxCUI:  DB13837 is inserted: D07327
NOTICE:  Drug2 RxCUI:  DB08983 is inserted: D07187
NOTICE:  Drug2 RxCUI:  DB01113 is inserted: D07425
NOTICE:  Drug2 RxCUI:  DB08860 is inserted: D01862
NOTICE:  Drug2 RxCUI:  DB06594 is inserted: D02578
NOTICE:  Drug2 RxCUI:  DB00579 is inserted: D00367
NOTICE:  Drug2 RxCUI:  DB01393 is inserted: D01366
NOTICE:  Drug2 RxCUI:  DB11228 is inserted: D04996
NOTICE:  Drug2 RxCUI:  DB09059 is inserted: D03008
NOTICE:  Drug2 RxCUI:  DB06724 is inserted: D00932
NOTICE:  Drug2 RxCUI:  DB06769 is inserted: D07085
NOTICE:  Drug2 RxCUI:  DB00617 is inserted: D00495
NOTICE:  Drug2 RxCUI:  DB00394 is inserted: D07495
NOTICE:  Drug2 RxCUI:  DB00802 is inserted: D07122
NOTICE:  Drug2 RxCUI:  DB00546 is inserted: D02770
NOTICE:  Drug2 RxCUI:  DB01174 is inserted: D00506
NOTICE:  Drug2 RxCUI:  DB04272 is inserted: D00037
NOTICE:  Drug2 RxCUI:  DB00731 is inserted: D01111
NOTICE:  Drug2 RxCUI:  DB11921 is inserted: D03671
NOTICE:  Drug2 RxCUI:  DB00695 is inserted: D00331
NOTICE:  Drug2 RxCUI:  DB11448 is inserted: D08372
NOTICE:  Drug2 RxCUI:  DB00972 is inserted: D07483
NOTICE:  Drug2 RxCUI:  DB09484 is inserted: D05864
NOTICE:  Drug2 RxCUI:  DB00822 is inserted: D00131
NOTICE:  Drug2 RxCUI:  DB01178 is inserted: D00268
NOTICE:  Drug2 RxCUI:  DB09295 is inserted: D02701
NOTICE:  Drug2 RxCUI:  DB15258 is inserted: D11470
NOTICE:  Drug2 RxCUI:  DB08942 is inserted: D04639
NOTICE:  Drug2 RxCUI:  DB01228 is inserted: D07894
NOTICE:  Drug2 RxCUI:  DB01576 is inserted: D03740
NOTICE:  Drug2 RxCUI:  DB00642 is inserted: D07472
NOTICE:  Drug2 RxCUI:  DB00185 is inserted: D00661
NOTICE:  Drug2 RxCUI:  DB00298 is inserted: D07775
NOTICE:  Drug2 RxCUI:  DB01222 is inserted: D00246
NOTICE:  Drug2 RxCUI:  DB13025 is inserted: D08590
NOTICE:  Drug2 RxCUI:  DB01239 is inserted: D00790
NOTICE:  Drug2 RxCUI:  DB01071 is inserted: D01324
NOTICE:  Drug2 RxCUI:  DB14895 is inserted: D10433
NOTICE:  Drug2 RxCUI:  DB01303 is inserted: D02017
NOTICE:  Drug2 RxCUI:  DB01229 is inserted: D00491
NOTICE:  Drug2 RxCUI:  DB14028 is inserted: D08283
NOTICE:  Drug2 RxCUI:  DB00572 is inserted: D00113
NOTICE:  Drug2 RxCUI:  DB09224 is inserted: D07309
NOTICE:  Drug2 RxCUI:  DB00392 is inserted: D01118
NOTICE:  Drug2 RxCUI:  DB12245 is inserted: D07364
NOTICE:  Drug2 RxCUI:  DB01511 is inserted: D07784
NOTICE:  Drug2 RxCUI:  DB13217 is inserted: D01975
NOTICE:  Drug2 RxCUI:  DB11712 is inserted: D11041
NOTICE:  Drug2 RxCUI:  DB00832 is inserted: D00508
NOTICE:  Drug2 RxCUI:  DB00382 is inserted: D08555
NOTICE:  Drug2 RxCUI:  DB09029 is inserted: D09967
NOTICE:  Drug2 RxCUI:  DB08875 is inserted: D10062
NOTICE:  Drug2 RxCUI:  DB01120 is inserted: D01599
NOTICE:  Drug2 RxCUI:  DB01077 is inserted: D02373
NOTICE:  Drug2 RxCUI:  DB00342 is inserted: D00521
NOTICE:  Drug2 RxCUI:  DB03395 is inserted: D03738
NOTICE:  Drug2 RxCUI:  DB08886 is inserted: D02997
NOTICE:  Drug2 RxCUI:  DB09265 is inserted: D09729
NOTICE:  Drug2 RxCUI:  DB00401 is inserted: D00618
NOTICE:  Drug2 RxCUI:  DB00920 is inserted: D01332
NOTICE:  Drug2 RxCUI:  DB08992 is inserted: D01671
NOTICE:  Drug2 RxCUI:  DB00295 is inserted: D08233
NOTICE:  Drug2 RxCUI:  DB01394 is inserted: D00570
NOTICE:  Drug2 RxCUI:  DB09078 is inserted: D09919
NOTICE:  Drug2 RxCUI:  DB00633 is inserted: D00514
NOTICE:  Drug2 RxCUI:  DB08954 is inserted: D08064
NOTICE:  Drug2 RxCUI:  DB01028 is inserted: D00544
NOTICE:  Drug2 RxCUI:  DB13867 is inserted: D07981
NOTICE:  Drug2 RxCUI:  DB13866 is inserted: D07939
NOTICE:  Drug2 RxCUI:  DB13223 is inserted: D07972
NOTICE:  Drug2 RxCUI:  DB11473 is inserted: D00805
NOTICE:  Drug2 RxCUI:  DB00604 is inserted: D00274
NOTICE:  Drug2 RxCUI:  DB01216 is inserted: D00321
NOTICE:  Drug2 RxCUI:  DB01333 is inserted: D00264
NOTICE:  Drug2 RxCUI:  DB00477 is inserted: D00270
NOTICE:  Drug2 RxCUI:  DB09052 is inserted: D09325
NOTICE:  Drug2 RxCUI:  DB00751 is inserted: D01713
NOTICE:  Drug2 RxCUI:  DB00740 is inserted: D00775
NOTICE:  Drug2 RxCUI:  DB01166 is inserted: D01896
NOTICE:  Drug2 RxCUI:  DB09421 is inserted: D00176
NOTICE:  Drug2 RxCUI:  DB00944 is inserted: D00667
NOTICE:  Drug2 RxCUI:  DB04573 is inserted: D00185
NOTICE:  Drug2 RxCUI:  DB00696 is inserted: D07906
NOTICE:  Drug2 RxCUI:  DB00623 is inserted: D07977
NOTICE:  Drug2 RxCUI:  DB00683 is inserted: D00550
NOTICE:  Drug2 RxCUI:  DB09286 is inserted: D02622
NOTICE:  Drug2 RxCUI:  DB05541 is inserted: D08879
NOTICE:  Drug2 RxCUI:  DB06266 is inserted: D07257
NOTICE:  Drug2 RxCUI:  DB06150 is inserted: D01142
NOTICE:  Drug2 RxCUI:  DB00574 is inserted: D07945
NOTICE:  Drug2 RxCUI:  DB06287 is inserted: D06068
NOTICE:  Drug2 RxCUI:  DB05039 is inserted: D09318
NOTICE:  Drug2 RxCUI:  DB09038 is inserted: D10459
NOTICE:  Drug2 RxCUI:  DB08910 is inserted: D08976
NOTICE:  Drug2 RxCUI:  DB11569 is inserted: D10071
NOTICE:  Drug2 RxCUI:  DB01309 is inserted: D04540
NOTICE:  Drug2 RxCUI:  DB00448 is inserted: D00355
NOTICE:  Drug2 RxCUI:  DB01362 is inserted: D01817
NOTICE:  Drug2 RxCUI:  DB00714 is inserted: D07460
NOTICE:  Drug2 RxCUI:  DB00276 is inserted: D02321
NOTICE:  Drug2 RxCUI:  DB09496 is inserted: D05225
NOTICE:  Drug2 RxCUI:  DB00990 is inserted: D00963
NOTICE:  Drug2 RxCUI:  DB08827 is inserted: D09637
NOTICE:  Drug2 RxCUI:  DB11481 is inserted: D03002
NOTICE:  Drug2 RxCUI:  DB09013 is inserted: D07496
NOTICE:  Drug2 RxCUI:  DB02901 is inserted: D07456
NOTICE:  Drug2 RxCUI:  DB01106 is inserted: D01717
NOTICE:  Drug2 RxCUI:  DB02513 is inserted: D01039
NOTICE:  Drug2 RxCUI:  DB09116 is inserted: D03288
NOTICE:  Drug2 RxCUI:  DB08871 is inserted: D08914
NOTICE:  Drug2 RxCUI:  DB00796 is inserted: D00626
NOTICE:  Drug2 RxCUI:  DB01567 is inserted: D01354
NOTICE:  Drug2 RxCUI:  DB03754 is inserted: D00396
NOTICE:  Drug2 RxCUI:  DB01396 is inserted: D00297
NOTICE:  Drug2 RxCUI:  DB00890 is inserted: D00898
NOTICE:  Drug2 RxCUI:  DB11963 is inserted: D09883
NOTICE:  Drug2 RxCUI:  DB06209 is inserted: D05597
NOTICE:  Drug2 RxCUI:  DB00737 is inserted: D08163
NOTICE:  Drug2 RxCUI:  DB01563 is inserted: D00265

Successfully run. Total query runtime: 1 min 54 secs.
1 rows affected.

*/