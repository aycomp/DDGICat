library(shiny)
library(dplyr)
library(cowplot)

shinyServer(
  function(input, output, session){

##############DRUG BEGIN####################
    output$tableDrug <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(),
        paste0(
        "SELECT d.* FROM drug d 
        INNER JOIN drug_groups dg 
          ON d.drug_id = dg.",
            paste("\"drugbank-id\"", " WHERE d.name LIKE ", "'%", input$nameDrug, 
                  "%' AND d.type = '", input$typeDrug,  
                  "' AND dg.group = '", input$statusDrug, "'", sep=""), 
        sep=""))
      print(query)
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp)
      return(ret) })
    
    output$summaryDrug <- renderPrint({
      query <- sqlInterpolate(ANSI(), "SELECT * FROM drug")
      drug_data <- dbGetQuery(pool, query)
      summary(drug_data) })
    
    output$plotDrug <- renderPlot({
      query <- sqlInterpolate(ANSI(), 
        "
        WITH biot AS(
          	WITH bio AS 
          	(
          		SELECT drug_id FROM drug WHERE \"type\" = 'biotech'
          	)
          	SELECT 
          		'biotech'::TEXT AS drug_type,
          		\"group\",
          		COUNT(1) AS count
          	FROM \"drug_groups\"
          	WHERE \"drugbank-id\" IN (SELECT drug_id FROM bio)
          	GROUP BY \"group\"
          ),
          smt AS (
          	WITH sm AS 
          	(
          		SELECT drug_id	FROM drug WHERE \"type\" = 'small molecule'
          	)
          	SELECT 
          		'small molecule'::TEXT AS drug_type,
          		\"group\",
          		COUNT(1) AS count
          	FROM \"drug_groups\"
          	WHERE \"drugbank-id\" IN (SELECT drug_id FROM sm)
          	GROUP BY \"group\"
          )
          SELECT \"group\", drug_type, count FROM smt
          UNION ALL   
          SELECT \"group\", drug_type, count FROM biot;
        "
        )
      drug_data <- dbGetQuery(pool, query)

      ggplot(drug_data, aes(x = group, y = as.integer(count), fill = drug_type)) +
        geom_col(width = 0.8) +
        labs(x= "Drug Status" , y = "Count", fill = "") +
        theme(
          text = element_text(family= "Times New Roman", size=16),
          title = element_text(family= "Times New Roman", size=16, face="bold"),
          legend.position = "bottom",
          legend.direction = "horizontal",
          plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
        ggtitle("Drug Type and Status")
    })
##############DRUG END#####################
  
    
##############GENE BEGIN###################
    output$tableGene <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(), paste0("SELECT * FROM gene", 
                                             paste(" WHERE name LIKE ", "'%", input$nameGene, "%'", sep=""), 
                                             sep=""))
      print(query)
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp)
      return(ret) })
    
    output$summaryGene <- renderPrint({
      query <- sqlInterpolate(ANSI(), "SELECT * FROM gene")
      gene_data <- dbGetQuery(pool, query)
      summary(gene_data) })
    
    output$plotGene <- renderPlot({
      query <- sqlInterpolate(ANSI(), 
      "
        WITH a AS (
        	SELECT 
        		SUBSTRING(chromosome FROM '[1-23]+') AS chromosome
        	FROM gene
        	GROUP BY chromosome
        )
        SELECT chromosome, COUNT(1) AS count
        FROM a
        WHERE chromosome IS NOT NULL
        GROUP BY chromosome
        ORDER BY chromosome
      "
      )
      gene_data <- dbGetQuery(pool, query)
      
      theme_set(theme_bw())
      
      ggplot(gene_data, aes(x = chromosome, y = as.integer(count))) +
        geom_col(width = 0.7) +
        labs(x= "Chromosome Name" , y = "Count") +
        theme(text = element_text(size=18))
    })
##############GENE END#####################
  

##############SNP BEGIN####################
    output$tableSnp <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(), paste0("SELECT * FROM snp", 
                                             paste(" WHERE snp_id LIKE ", "'%", input$nameSnp, "%'", sep=""), 
                                             sep=""))
      print(query)
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp)
      return(ret) })
    
    output$summarySnp <- renderPrint({
      query <- sqlInterpolate(ANSI(), "SELECT * FROM snp")
      snp_data <- dbGetQuery(pool, query)
      summary(snp_data) })
    
    output$plotSnp <- renderPlot({
      query <- sqlInterpolate(ANSI(), 
      "
        SELECT * FROM snp;
      "
      )
      snp_data <- dbGetQuery(pool, query)
      
      theme_set(theme_bw())
      
      ggplot(snp_data, aes(x = chromosome, y = as.integer(count))) +
        geom_col(width = 0.7) +
        labs(x= "Gene Name" , y = "SNP Count") +
        theme(text = element_text(size=18))
    })
##############SNP END######################

    
##############DDI BEGIN####################
    output$tableDdi <- DT::renderDataTable({
      q <- paste0("SELECT * FROM ddi", 
                  paste(" WHERE drug1_name LIKE ", "'%", input$nameDrug1, 
                        "%' AND drug2_name LIKE ", "'%", input$nameDrug2, "%'", sep=""), 
                  sep="")
      query <- sqlInterpolate(ANSI(), q)
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp)
      return(ret) })
    
    output$summaryDdi <- renderPrint({
      query <- sqlInterpolate(ANSI(), "SELECT * FROM ddi")
      ddi_data <- dbGetQuery(pool, query)
      summary(ddi_data) })
    
    output$plotDdi <- renderPlot({
      query <- sqlInterpolate(ANSI(), 
      "
          SELECT 
          	COUNT(*) AS cnt
          FROM public.ddi
          GROUP BY drug1_id
      "
      )
      ddi_data <- dbGetQuery(pool, query)
      
      ddi_data$cnt <- as.numeric(ddi_data$cnt)
      
      theme_set(theme_bw())
      
      p1 <- ggplot(ddi_data, aes(x = cnt)) +
        geom_histogram() +
        labs(x= "Drug Count" , y = "DDI Count") +
        theme(text = element_text(size=18))
      
      p2 <- ggplot(ddi_data, aes(x = cnt)) +
        geom_boxplot() +
        labs(x= "Drug Count" , y = "DDI Count") +
        theme(text = element_text(size=18))
      
      plot_grid(p1, p2, align = "v")
    })
##############DDI END######################
    
    
##############DGI BEGIN####################

##############DGI END######################

        
##############DDGI BEGIN###################

##############DDGI END#####################
    
})