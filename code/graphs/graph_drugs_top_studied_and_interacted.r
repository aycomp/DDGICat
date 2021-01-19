con=NULL
data=NULL
library(ggplot2)

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"SELECT 
  name, 
  articles_count AS count 
FROM drug 
ORDER BY articles_count DESC 
LIMIT 10")

p1 <- ggplot(data, aes(name, count), width = 0.1)+
  geom_bar(stat="identity", width=.5, fill="steelblue") + 
  coord_flip()+
  labs(title="Most Studied Drugs",y="Article Count", x="Drug Name") + 
  theme(axis.text.x = element_text(vjust=0.5))
  
con=NULL
data=NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
data <- dbGetQuery(con,
"SELECT 
  drug_interactions_count AS count, 
  name  
FROM drug 
ORDER BY drug_interactions_count 
DESC LIMIT 10")

p2 <- ggplot(data, aes(name, count))+
  geom_bar(stat="identity", width=.5, fill="steelblue") +  coord_flip()+
  labs(title="Most Interacted Drugs",y="Interaction Count", x="") + 
  theme(axis.text.x = element_text(vjust=0.5))

plot_grid(p1, p2,
          align = "h",
          ncol = 2)

gridExtra::grid.arrange(p1, p2, ncol=2)

#ggsave("drugs_top_10.jpeg")




