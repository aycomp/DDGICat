library(gridExtra)
library(ggplot2)
library(ggpubr)
library(cowplot)

desc <-c('The risk or severity of adverse effects can be increased when Drug A is combined with Drug B.',
         'Drug A may increase/decrease the … activities of Drug B.',
         'The metabolism of Drug A can be increased/decreased when combined with Drug B.',
         'The therapeutic efficacy of Drug A can be decreased when used in combination with Drug B.',
         'The serum concentration of Drug A can be increased/decreased when it is combined with Drug B.')

numbers <- c(486002,
             183222,
             154317,
             116470,
             43932)
             
data <- data.frame(numbers, desc)
  
bxp <- ggplot(data, aes(x = '', y = numbers, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste0((ceiling(numbers*100/1151858)), "%")), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()


plot_grid(bxp, align = "v", ncol = 1)
