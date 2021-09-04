library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")

###########TARGET
data1 <- dbGetQuery(con, "
                WITH ddi_same_drug_protein AS (
                  SELECT 
                    COUNT(*) AS ddi_count, 
                    drug_protein_id
                  FROM public.ddi_same_drug_protein 
                  WHERE drug_protein_type = 1
                    AND severity = 'high'
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


ggplot(data1, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Target") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Target Linear Scale")


ggplot(data1, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Target") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Target Logarithmic Scale") +
scale_x_log10() + 
scale_y_log10() +
geom_smooth(method='lm')

######################ENZYME
data2 <- dbGetQuery(con, "
                WITH ddi_same_drug_protein AS (
                  SELECT 
                    COUNT(*) AS ddi_count, 
                    drug_protein_id
                  FROM public.ddi_same_drug_protein 
                  WHERE drug_protein_type = 2
                    AND severity = 'high'
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


ggplot(data2, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Enzyme") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Enzyme Linear Scale")


ggplot(data2, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Enzyme") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Enzyme Logarithmic Scale") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method='lm')



######################CARRIER
data3 <- dbGetQuery(con, "
                WITH ddi_same_drug_protein AS (
                  SELECT 
                    COUNT(*) AS ddi_count, 
                    drug_protein_id
                  FROM public.ddi_same_drug_protein 
                  WHERE drug_protein_type = 3
                    AND severity = 'high'
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


ggplot(data3, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Carrier") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Carrier Linear Scale")


ggplot(data3, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Carrier") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Carrier Logarithmic Scale") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method='lm')




######################TRANSPORTER
data4 <- dbGetQuery(con, "
                WITH ddi_same_drug_protein AS (
                  SELECT 
                    COUNT(*) AS ddi_count, 
                    drug_protein_id
                  FROM public.ddi_same_drug_protein 
                  WHERE drug_protein_type = 4
                    AND severity = 'high'
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


ggplot(data4, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Transporter") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Transporter Linear Scale")


ggplot(data4, aes(x = number_of_protein, y = number_of_ddi)) +
  geom_point(alpha=0.6) +
  labs(x= "# DDI" , y = "# Transporter") +
  theme(
    text = element_text(family= "Times New Roman", size=11, face="bold"),
    title = element_text(family= "Times New Roman", size=11, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=12, face="bold", hjust = 0.5)) +
  ggtitle("# DDI high per # Transporter Logarithmic Scale") +
  scale_x_log10() + 
  scale_y_log10() +
  geom_smooth(method='lm')


