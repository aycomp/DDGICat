    library(DBI)
    library(ggplot2)
    
    con = NULL
    data = NULL
    
    con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
    data1 <- dbGetQuery(con,
    "
    WITH most_interacted_drugs AS 
    (
    	SELECT 
    		drug1_id AS drug_id, 
    		COUNT(1) AS cnt
    	FROM public.ddi
    	GROUP BY drug1_id
    	ORDER BY cnt DESC
    )
    SELECT 
    	COUNT(1) AS cnt, 
    	code_4, 
    	level_4
    FROM most_interacted_drugs mid
    INNER JOIN drug_atc_codes atc
    	ON mid.drug_id = atc.\"drugbank-id\"
    GROUP BY code_4, level_4
    ORDER BY cnt DESC;
    
    " 
    )
    data1$cnt <- as.numeric(data1$cnt)
    mean(data1$cnt)
    median(data1$cnt)
    sd(data1$cnt)
    hist(data1$cnt, main = "ATC Level 1", xlab= "DDI Count")
    boxplot(data1$cnt)
    "
    ddi_distribution_same_atc_1_1.jpeg
    ddi_distribution_same_atc_1_2.jpeg
    "
    
    
    data2 <- dbGetQuery(con,
    "
    WITH most_interacted_drugs AS 
    (
    	SELECT 
    		drug1_id AS drug_id, 
    		COUNT(1) AS cnt
    	FROM public.ddi
    	GROUP BY drug1_id
    	ORDER BY cnt DESC
    )
    SELECT 
    	COUNT(1) AS cnt, 
    	code_3, 
    	level_3
    FROM most_interacted_drugs mid
    INNER JOIN drug_atc_codes atc
    	ON mid.drug_id = atc.\"drugbank-id\"
    GROUP BY code_3, level_3
    ORDER BY cnt DESC
    " 
    )
    data2$cnt <- as.numeric(data2$cnt)
    mean(data2$cnt)
    median(data2$cnt)
    sd(data2$cnt)
    hist(data2$cnt, main = "ATC Level 2", xlab= "DDI Count")
    boxplot(data2$cnt)
    "
    ddi_distribution_same_atc_2_1.jpeg
    ddi_distribution_same_atc_2_2.jpeg
    "
    
    
    data3 <- dbGetQuery(con,
    "
    WITH most_interacted_drugs AS 
    (
    	SELECT 
    		drug1_id AS drug_id, 
    		COUNT(1) AS cnt
    	FROM public.ddi
    	GROUP BY drug1_id
    	ORDER BY cnt DESC
    )
    SELECT 
    	COUNT(1) AS cnt, 
    	code_2, 
    	level_2
    FROM most_interacted_drugs mid
    INNER JOIN drug_atc_codes atc
    	ON mid.drug_id = atc.\"drugbank-id\"
    GROUP BY code_2, level_2
    ORDER BY cnt DESC
    " 
    )
    data3$cnt <- as.numeric(data3$cnt)
    mean(data3$cnt)
    median(data3$cnt)
    sd(data3$cnt)
    hist(data3$cnt, main = "ATC Level 3", xlab= "DDI Count")
    boxplot(data3$cnt)
    "
    ddi_distribution_same_atc_3_1.jpeg
    ddi_distribution_same_atc_3_2.jpeg
    "
    
    
    data4 <- dbGetQuery(con,
    "
    WITH most_interacted_drugs AS 
    (
    	SELECT 
    		drug1_id AS drug_id, 
    		COUNT(1) AS cnt
    	FROM public.ddi
    	GROUP BY drug1_id
    	ORDER BY cnt DESC
    )
    SELECT 
    	COUNT(1) AS cnt, 
    	code_1, 
    	level_1
    FROM most_interacted_drugs mid
    INNER JOIN drug_atc_codes atc
    	ON mid.drug_id = atc.\"drugbank-id\"
    GROUP BY code_1, level_1
    ORDER BY cnt DESC
    " 
    )
    data4$cnt <- as.numeric(data4$cnt)
    mean(data4$cnt)
    median(data4$cnt)
    sd(data4$cnt)
    hist(data4$cnt, main = "ATC Level 4", xlab= "DDI Count")
    boxplot(data4$cnt)
    "
    ddi_distribution_same_atc_4_1.jpeg
    ddi_distribution_same_atc_4_2.jpeg
    "
    
    
    data5 <- dbGetQuery(con,
    "
    WITH most_interacted_drugs AS 
    (
    	SELECT 
    		drug1_id AS drug_id, 
    		COUNT(1) AS cnt
    	FROM public.ddi
    	GROUP BY drug1_id
    )
    SELECT 
    	COUNT(1) AS cnt, 
    	atc_code
    FROM most_interacted_drugs mid
    INNER JOIN drug_atc_codes atc
    	ON mid.drug_id = atc.\"drugbank-id\"
    GROUP BY atc_code
    ORDER BY cnt DESC
    " 
    )
    data5$cnt <- as.numeric(data5$cnt)
    mean(data5$cnt)
    median(data5$cnt)
    sd(data5$cnt)
    hist(data5$cnt, main = "ATC Level 5", xlab= "DDI Count")
    boxplot(data5$cnt)
    "
    ddi_distribution_same_atc_5_1.jpeg
    ddi_distribution_same_atc_5_2.jpeg
    "
