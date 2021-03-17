/*
	NOTE:	What percentages of interacting drugs have the same protein.


*/
-------------TARGET
SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(1);

/*
	NOTICE:  cnt_ddi: 590436 , cnt_same_drug_protein: 40341, final_percentage: 6

	Successfully run. Total query runtime: 5 secs 544 msec.
	1 rows affected.
*/

-------------ENZYME
SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(2);

/*
	NOTICE:  cnt_ddi: 373947 , cnt_same_drug_protein: 241754, final_percentage: 64

	Successfully run. Total query runtime: 5 secs 695 msec.
	1 rows affected.
*/


-------------CARRIER
SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(3);

/*
	NOTICE:  cnt_ddi: 36586 , cnt_same_drug_protein: 25626, final_percentage: 70

	Successfully run. Total query runtime: 617 msec.
	1 rows affected.
*/


-------------TRANSPORTER
SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(4);

/*
	NOTICE:  cnt_ddi: 115086 , cnt_same_drug_protein: 65208, final_percentage: 56

	Successfully run. Total query runtime: 1 secs 508 msec.
	1 rows affected.
*/