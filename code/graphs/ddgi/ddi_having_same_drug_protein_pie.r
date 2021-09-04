  library(cowplot)
library(DBI)
library(ggplot2)

con = NULL
data = NULL

con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")

#################TARGET#################
data1 <- dbGetQuery(con, " SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(1) ")

desc <- c('Same','Different')
result1 <- data1$calculate_shared_protein_percentage_of_interacted_drugs
numbers1 <- c(result1, 100 - result1)
data1 <- data.frame(numbers1, desc)

p1 <- ggplot(data1, aes(x = '', y = numbers1, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") + 
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste("%", numbers1)),
            position = position_stack(vjust = 0.5)) +
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void() +
  theme(legend.position = "none")


#################ENZYME#################
data2 <- dbGetQuery(con, " SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(2) ")

desc <- c('Same','Different')
result2 <- data2$calculate_shared_protein_percentage_of_interacted_drugs
numbers2 <- c(result2, 100 - result2)
data2 <- data.frame(numbers2, desc)

p2 <- ggplot(data2, aes(x = '', y = numbers2, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste("%", numbers2)),
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void() +
  theme(legend.position = "none")


################CARRIER################
data3 <- dbGetQuery(con, " SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(3) ")

desc <- c('Same','Different')
result3 <- data3$calculate_shared_protein_percentage_of_interacted_drugs
numbers3 <- c(result3, 100 - result3)
data3 <- data.frame(numbers3, desc)

p3 <- ggplot(data3, aes(x = '', y = numbers3, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste("%", numbers3)),
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void() +
  theme(legend.position = "none")


#################TRANSPORTER#################
data4 <- dbGetQuery(con, " SELECT public.calculate_shared_protein_percentage_of_interacted_drugs(4) ")

desc <- c('Same','Different')
result4 <- data4$calculate_shared_protein_percentage_of_interacted_drugs
numbers4 <- c(result4, 100 - result4)
data4 <- data.frame(numbers4, desc)

p4 <- ggplot(data4, aes(x = '', y = numbers4, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") + 
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste("%", numbers4)), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void() +
  theme(legend.position = "bottom", legend.direction = "vertical")

plot_grid(p1, p2, 
          labels = c('Target', 'Enzyme'),
          label_size = 12,   label_fontfamily = "Times New Roman")

plot_grid(p3, p4, 
        labels = c('Carrier', 'Transporter'),
        label_size = 12,   label_fontfamily = "Times New Roman")


#theme(legend.position = "bottom", legend.direction = "horizontal")