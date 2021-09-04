library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con, "
       WITH 
     ddi1 AS (WITH ddi AS (
      SELECT 
      COUNT(1) AS ddi_count
      FROM temp_ddi_same_atc1
      )
      SELECT
        'level 1'::TEXT AS atc_level,
        COUNT(1)::int AS number_of_same_atc, 
        ddi_count::int AS number_of_ddi
      FROM temp_ddi_same_atc1, ddi
      WHERE drug1_atc = drug2_atc 
      group by ddi_count
    ),
    ddi2 AS (with ddi as (
      SELECT 
      COUNT(1) AS ddi_count
      FROM temp_ddi_same_atc2
      )
      SELECT
      'level 2'::TEXT AS atc_level,
      COUNT(1)::int AS number_of_same_atc, 
      ddi_count::int AS number_of_ddi
      FROM temp_ddi_same_atc2, ddi
      WHERE drug1_atc = drug2_atc 
      group by ddi_count
    ),
    ddi3 AS (
      with ddi as (
      SELECT 
      COUNT(1) AS ddi_count
      FROM temp_ddi_same_atc3
    )
    SELECT
      'level 3'::TEXT AS atc_level,
      COUNT(1)::int AS number_of_same_atc, 
      ddi_count::int AS number_of_ddi
    FROM temp_ddi_same_atc3, ddi
    WHERE drug1_atc = drug2_atc 
    group by ddi_count
    ),
    ddi4 AS (
    with ddi as (
      SELECT 
      COUNT(1) AS ddi_count
      FROM temp_ddi_same_atc4
    )
    SELECT
      'level 4'::TEXT AS atc_level,
      COUNT(1)::int AS number_of_same_atc, 
      ddi_count::int AS number_of_ddi
    FROM temp_ddi_same_atc4, ddi
    WHERE drug1_atc = drug2_atc 
    group by ddi_count
    )
  SELECT \"atc_level\", 'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi1
  UNION ALL
  SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi1
  UNION ALL
  SELECT \"atc_level\",  'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi2
  UNION ALL
  SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi2
  UNION ALL
  SELECT \"atc_level\", 'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi3
  UNION ALL
  SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi3
  UNION ALL
  SELECT \"atc_level\", 'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi4
  UNION ALL
  SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi4
  "
)


theme_set(theme_bw())

ggplot(data, aes(fill=interaction, y=number_of_ddi, x=atc_level)) + 
  geom_col(width = 0.5) +
  labs(x= "ATC Level" , y = "Interaction Count", fill = "") +
  theme(
    text = element_text(family= "Times New Roman", size=16),
    title = element_text(family= "Times New Roman", size=16, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
  ggtitle("DDI Distribution per ATC Level")
