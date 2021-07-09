library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con, "
                WITH ddi_same_drug_protein AS (
                  SELECT 
                    COUNT(*) AS ddi_count, 
                    drug_protein_id
                  FROM public.ddi_same_drug_protein
                  GROUP BY drug_protein_id
                  ORDER BY ddi_count DESC
                )
                SELECT
                  COUNT(drug_protein_id)::int AS number_of_protein, 
                  ddi_count::int AS number_of_ddi
                FROM ddi_same_drug_protein
                GROUP BY number_of_ddi
                ORDER BY number_of_protein DESC, number_of_ddi"
)


ggplot(data, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Protein") +
  theme(
    text = element_text(family= "Times New Roman", size=14, face="bold"),
    title = element_text(family= "Times New Roman", size=14, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=14, face="bold", hjust = 0.5)) +
  ggtitle("# DDI per # Protein Linear Scale")


ggplot(data, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Protein") +
  theme(
    text = element_text(family= "Times New Roman", size=14, face="bold"),
    title = element_text(family= "Times New Roman", size=14, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=14, face="bold", hjust = 0.5)) +
  ggtitle("# DDI per # Protein Logarithmic Scale") +
scale_x_log10() + 
scale_y_log10() +
geom_smooth(method='lm')


