library(cowplot)
library(DBI)
library(ggplot2)
library(ggpubr)


con <- dbConnect(RPostgres::Postgres(),user="postgres",password="terlik",host="localhost",port=5432, dbname="DDGICat")
##########TARGET PERCENTAGE#################
data = NULL
data <- dbGetQuery(con,
"
WITH sub AS(
	SELECT 
	  ddi_desc_cat AS cat, COUNT(1) AS count
	FROM public.ddi_same_target
	GROUP BY ddi_desc_cat
	ORDER BY cat
),
sub_sum AS
(
	SELECT SUM(sub.count) FROM sub
)
SELECT * FROM sub, sub_sum;
"

);

p1 <- ggplot(data, aes(x = '', y = as.integer(count), fill = cat)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y")+
  geom_text(aes(label = paste0((round(as.integer(count)*100/as.integer(sum))), "%")), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()

##########ENZYME PERCENTAGE#################
data = NULL
data <- dbGetQuery(con,
"
WITH sub AS(
	SELECT 
	  ddi_desc_cat AS cat, COUNT(1) AS count
	FROM public.ddi_same_enzyme
	GROUP BY ddi_desc_cat
	ORDER BY cat
),
sub_sum AS
(
	SELECT SUM(sub.count) FROM sub
)
SELECT * FROM sub, sub_sum;
"
                   
);

p2 <- ggplot(data, aes(x = '', y = as.integer(count), fill = cat)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste0((round(as.integer(count)*100/as.integer(sum))), "%")), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()

##########CARRIER PERCENTAGE#################
data = NULL
data <- dbGetQuery(con,
                   "
WITH sub AS(
	SELECT 
	  ddi_desc_cat AS cat, COUNT(1) AS count
	FROM public.ddi_same_carrier
	GROUP BY ddi_desc_cat
	ORDER BY cat
),
sub_sum AS
(
	SELECT SUM(sub.count) FROM sub
)
SELECT * FROM sub, sub_sum;
"
                   
);

p3 <- ggplot(data, aes(x = '', y = as.integer(count), fill = cat)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste0((round(as.integer(count)*100/as.integer(sum))), "%")), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()


##########TRANSPORTER PERCENTAGE#################
data = NULL
data <- dbGetQuery(con,
                   "
WITH sub AS(
	SELECT 
	  ddi_desc_cat AS cat, COUNT(1) AS count
	FROM public.ddi_same_transporter
	GROUP BY ddi_desc_cat
	ORDER BY cat
),
sub_sum AS
(
	SELECT SUM(sub.count) FROM sub
)
SELECT * FROM sub, sub_sum;
"
                   
);

p4 <- ggplot(data, aes(x = '', y = as.integer(count), fill =  cat)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = paste0((round(as.integer(count)*100/as.integer(sum))), "%")), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()

##################


prow <- plot_grid( p1 + theme(legend.position="none"),
                   p2 + theme(legend.position="none"),
                   p3 + theme(legend.position="none"),
                   p4 + theme(legend.position="none"),
                   align = 'vh',
                   labels = c("Same Target", "Same Enzyme", "Same Carrier", "Same Transporter"),
                   hjust = -1,
                   nrow = 2
)

legend_b <- get_legend(p1 + theme(legend.position="bottom"))
plot_grid(prow, legend_b, nrow=2, rel_heights = c(1, .1))

######to draw explanation table of each category
"data = NULL
data <- dbGetQuery(con,
      ""
      SELECT category_id as category, description 
      FROM description_category 
      GROUP BY category_id, description
      ORDER BY category_id"");

stable.p <- ggtexttable(data, rows = NULL, theme = ttheme(""classic"

"ggarrange(stable.p, ncol = 1, nrow = 1, heights = c(0.5, 0.25))"