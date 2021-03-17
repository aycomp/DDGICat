library(cowplot)




##########TARGET PERCENTAGE#################
"
--CALCULATION: 39684 * 100 / 580673 = 7 %

--etkileşimi olan kayıtlardan 565583 tanesinin target protein kaydı var.
--580673
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_target)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_target)

--39684
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_target

"

desc <- c('same target','different target')
numbers <- c(7, 93)

data <- data.frame(numbers, desc)

p1 <- ggplot(data, aes(x = '', y = numbers, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = numbers), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()


##########ENZYME PERCENTAGE#################
"
--CALCULATION: 237440 * 100 / 369434 = 64 %

--369434
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_enzyme)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_enzyme)

--237440
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_enzyme

"

desc <-c('same enzyme','different enzyme')
numbers <- c(64, 36)

data <- data.frame(numbers, desc)

p2 <- ggplot(data, aes(x = '', y = numbers, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = numbers), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()

##########CARRIER PERCENTAGE#################
"
--CALCULATION: 24468 * 100 / 35219 = 69 %

--35219
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_carrier)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_carrier)

--24468
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_carrier

"

desc <-c('same carrier','different carrier')
numbers <- c(69, 31)

data <- data.frame(numbers, desc)

p3 <- ggplot(data, aes(x = '', y = numbers, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = numbers), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()


##########TRANSPORTER PERCENTAGE#################
"
--CALCULATION: 62207 * 100 / 369434 = 16 %

--369434
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM ddi
where drug1_id in (select DISTINCT(drug_id) FROM public.drug_transporter)
	AND drug2_id in (select DISTINCT(drug_id) FROM public.drug_transporter)

--62207
SELECT COUNT(DISTINCT(drug1_id || drug2_id)) FROM public.ddi_same_transporter

"

desc <-c('same transporter','different transporter')
numbers <- c(16, 84)

data <- data.frame(numbers, desc)

p4 <- ggplot(data, aes(x = '', y = numbers, fill = desc)) +
  geom_bar(width = 0.5, stat = "identity") +
  coord_polar("y", start = 0)+
  geom_text(aes(label = numbers), 
            position = position_stack(vjust = 0.5))+
  labs(x = NULL, y = NULL,  fill = NULL) +
  theme_void()

plot_grid(p1, p2, p3, p4, align = "v", ncol = 2, nrow=2)


