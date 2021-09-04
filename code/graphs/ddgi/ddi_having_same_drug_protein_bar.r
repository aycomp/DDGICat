  library(cowplot)
library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")

#################TARGET#################
data <- dbGetQuery(con, 
"
SELECT 'Target' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage
	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(1)
UNION ALL
SELECT 'Target' AS protein_type, 'Different Drug-Protein' AS protein_sharing, (100- final_percentage) AS percentage 
	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(1)
UNION ALL
SELECT 'Enzyme' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage
	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(2)
UNION ALL
SELECT 'Enzyme' AS protein_type, 'Different Drug-Protein' AS protein_sharing,  (100- final_percentage) AS percentage
	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(2)
UNION ALL
SELECT 'Carrier' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage 
	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(3)	
UNION ALL
SELECT 'Carrier' AS protein_type, 'Different Drug-Protein' AS protein_sharing, (100- final_percentage) AS percentage 
	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(3)	
UNION ALL
SELECT 'Transporter' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage
FROM public.calculate_shared_protein_percentage_of_interacted_drugs(4)
UNION ALL
SELECT 'Transporter' AS protein_type, 'Different Drug-Protein' AS protein_sharing, (100- final_percentage) AS percentage  
	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(4)
"
)

theme_set(theme_bw())

ggplot(data, aes(fill=protein_sharing, y=percentage, x=protein_type)) + 
  geom_col(width = 0.5) +
  labs(x= "Protein Type" , y = "Percentage", fill = "") +
  theme(
    text = element_text(family= "Times New Roman", size=16),
    title = element_text(family= "Times New Roman", size=16, face="bold"),
    legend.position = "bottom",
    legend.direction = "horizontal",
    plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
  ggtitle("DDI Percentages per Sharing Same Drug-Protein")