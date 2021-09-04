  library(DBI)
  library(ggplot2)
  library(cowplot)
  
  con = NULL
  data = NULL
  
  con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
  desc <- c('Same','Different')
  
  ###level 1
  data1 <- dbGetQuery(con, "
                  WITH ddi AS (
                      SELECT 
                    	COUNT(1) AS ddi_count
                      FROM temp_ddi_same_atc1
                    )
                    SELECT
                      COUNT(1)::int AS number_of_same_atc, 
                      ddi_count::int AS number_of_ddi
                    FROM temp_ddi_same_atc1, ddi
                    WHERE drug1_atc = drug2_atc 
                    group by ddi_count"
  )
  
  result1 <- data1$number_of_same_atc
  numbers1 <- c(round(result1/data1$number_of_ddi * 100, 2), round((data1$number_of_ddi - result1)/data1$number_of_ddi*100, 2))
  data1 <- data.frame(numbers1, desc)
  
  p1 <- ggplot(data1, aes(x = '', y = numbers1, fill = desc)) +
    geom_bar(width = 0.5, stat = "identity") +
    coord_polar("y", start = 0)+
    geom_text(aes(label = paste("%", numbers1)),
              position = position_stack(vjust = 0.5))+
    labs(x = NULL, y = NULL,  fill = NULL) +
    theme_void() +
    theme(legend.position = "none")

  ###level 2
  data2 <- dbGetQuery(con, 
      "
      WITH ddi AS (
        SELECT 
      	COUNT(1) AS ddi_count
        FROM temp_ddi_same_atc2
      )
      SELECT
        COUNT(1)::int AS number_of_same_atc, 
        ddi_count::int AS number_of_ddi
      FROM temp_ddi_same_atc2, ddi
      WHERE drug1_atc = drug2_atc 
      group by ddi_count
      "
  )
  
  result2 <- data2$number_of_same_atc
  numbers2 <- c(round(result2/data2$number_of_ddi * 100, 2), round((data2$number_of_ddi - result2)/data2$number_of_ddi*100, 2))
  data2 <- data.frame(numbers2, desc)
  
  p2 <- ggplot(data2, aes(x = '', y = numbers2, fill = desc)) +
    geom_bar(width = 0.5, stat = "identity") +
    coord_polar("y", start = 0)+
    geom_text(aes(label = paste("%", numbers2)),
              position = position_stack(vjust = 0.5))+
    labs(x = NULL, y = NULL,  fill = NULL) +
    theme_void() +
    theme(legend.position = "none")
  
  ###level 3
  data3 <- dbGetQuery(con, "
    WITH ddi AS (
      SELECT 
    	COUNT(1) AS ddi_count
      FROM temp_ddi_same_atc3
    )
    SELECT
      COUNT(1)::int AS number_of_same_atc, 
      ddi_count::int AS number_of_ddi
    FROM temp_ddi_same_atc3, ddi
    WHERE drug1_atc = drug2_atc 
    group by ddi_count " )
  
  result3 <- data3$number_of_same_atc
  numbers3 <- c(round(result3/data3$number_of_ddi * 100, 2), round((data3$number_of_ddi - result3)/data3$number_of_ddi*100, 2))
  data3 <- data.frame(numbers3, desc)
  
  p3 <- ggplot(data3, aes(x = '', y = numbers3, fill = desc)) +
    geom_bar(width = 0.5, stat = "identity") +
    coord_polar("y", start = 0)+
    geom_text(aes(label = paste("%", numbers3)),
              position = position_stack(vjust = 0.5))+
    labs(x = NULL, y = NULL,  fill = NULL) +
    theme_void() +
    theme(legend.position = "none")
  
  ###level 4
  data4 <- dbGetQuery(con, "
    WITH ddi AS (
      SELECT 
    	COUNT(1) AS ddi_count
      FROM temp_ddi_same_atc4
    )
    SELECT
      COUNT(1)::int AS number_of_same_atc, 
      ddi_count::int AS number_of_ddi
    FROM temp_ddi_same_atc4, ddi
    WHERE drug1_atc = drug2_atc 
    group by ddi_count  ")
  
  result4 <- data4$number_of_same_atc
  numbers4 <- c(round(result4/data4$number_of_ddi * 100, 2), round((data4$number_of_ddi - result4)/data4$number_of_ddi*100, 2))
  data4 <- data.frame(numbers4, desc)
  
  p4 <- ggplot(data1, aes(x = '', y = numbers4, fill = desc)) +
    geom_bar(width = 0.5, stat = "identity") +
    coord_polar("y", start = 0)+
    geom_text(aes(label = paste("%", numbers4)),
              position = position_stack(vjust = 0.5))+
    labs(x = NULL, y = NULL,  fill = NULL) +
    theme_void() +
    theme(legend.position = "none")
  
  plot_grid(p1, p2, 
            labels = c('Level 1', 'Level 2'),
            label_size = 12,   label_fontfamily = "Times New Roman")
  
  plot_grid(p3, p4, 
            labels = c('Level 3', 'Level 4'),
            label_size = 12,   label_fontfamily = "Times New Roman")
  
