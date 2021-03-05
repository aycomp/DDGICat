library(plotrix)

desc <- c('49% (1)','19% (2)', '16% (3)', '12% (4)', '4% (5)')

descl <-c('The risk or severity of adverse effects can be increased when Drug A is combined with Drug B.',
         'Drug A may increase/decrease the … activities of Drug B.',
         'The metabolism of Drug A can be increased/decreased when combined with Drug B.',
         'The therapeutic efficacy of Drug A can be decreased when used in combination with Drug B.',
         'The serum concentration of Drug A can be increased/decreased when it is combined with Drug B.')

numbers <- c(486002, 183222,154317, 116470, 43932)
             
pie3D(numbers,radius=0.9,labels=desc,explode=0.1)






"
#percentage calculations
486002+183222+154317+116470+43932 = 983943
486002 / 983943 = 49%
183222 / 983943 = 19%
154317 / 983943 = 16%
116470 / 983943 = 12%
43932 / 983943 = 4%


#old plot
ggplot(data, aes(x = '', y = numbers, fill = desc)) +
  geom_bar(width = 0.7, stat = 'identity') +
  coord_polar('y', start = 0)+
  geom_text(
            aes(label = paste0((ceiling(numbers*100/1151858)), '%')), 
            position = position_stack(vjust = 0.5)
            )+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void() +
  theme(
      text = element_text(size=18),
      legend.position = 'bottom',
      legend.direction = 'vertical'
      )
"