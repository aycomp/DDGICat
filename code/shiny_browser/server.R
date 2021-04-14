library(shiny)
library(dplyr)
library(cowplot)
library(ggpubr)

shinyServer(
  function(input, output, session){

##############DRUG BEGIN####################
    output$tableDrug <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(),
        paste0(
        "
        SELECT 
        	drug_id,name, type, state,
        	LEFT(synonym, 60) AS synonym,
	        LEFT(indication, 60) || '...' AS indication,
        	LEFT(description, 60) || '...' AS description,
        	LEFT(toxicity, 60) || '...' AS toxicity,
        	synonym, indication,description,toxicity,
        	pharmacodynamics, absorption, half_life, 
        	metabolism, mechanism_of_action, volume_of_distribution, 
        	protein_binding, clearance, route_of_elimination, pubmed_id
        FROM public.drug d
        INNER JOIN drug_groups dg 
          ON d.drug_id = dg.",
            paste("\"drugbank-id\"", " WHERE d.name LIKE ", "'%", input$nameDrug, 
                  "%' AND d.type = '", input$typeDrug,  
                  "' AND dg.group = '", input$statusDrug, "'", 
                  " AND d.state = '", input$stateDrug, "'", sep=""),sep=""))
      
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("Responsive", "ColReorder", "Buttons", "KeyTable", 
                                         "Scroller"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          #scrollX = TRUE,
                                          keys = TRUE,
                                          deferRender = TRUE,
                                          
                                         
                                          columnDefs = list(list(visible = FALSE, targets=8:11)),
                                          rowCallback = JS(
                                            "function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {",
                                            'for(i=4; i<8; i++ ){',
                                            "var full_text = aData[i+4];",
                                            "$('td:eq('+i+')', nRow).attr('title', 
                                            full_text).css('background-color', aData[i+4]);",
                                            '}',
                                            "}")
                                          ),  rownames = FALSE
                           )
      return(ret) })
    
    drug_data <- reactive({
      query <- sqlInterpolate(ANSI(), 
      "
        SELECT 
          dg.group,d.*
        FROM drug d
        INNER JOIN drug_groups dg
        	ON d.drug_id = dg.\"drugbank-id\"
      "
      )

      drug_data <- dbGetQuery(pool, query)
      
      if(input$plotDrug == "group"){
        drug_data <- drug_data %>% 
          group_by(group) %>% summarise(count = n(), res = group)
      }
      else if (input$plotDrug == "type"){
        drug_data <- drug_data %>% 
          group_by(type) %>% summarise(count = n(), res = type)
      }
      else if (input$plotDrug == "state"){
        drug_data <- drug_data %>% 
          group_by(state) %>% summarise(count = n(), res = state)
      }
    })
    
    output$plotDrug <- renderPlot({
      
      drug_data <- drug_data()
      
      ggplot(drug_data, aes(x = res, y=count)) +
        geom_col(width = 0.8) +
        labs(x= "Drug Status" , y = "Count", fill = "") +
        theme(
          text = element_text(family= "Times New Roman", size=16),
          title = element_text(family= "Times New Roman", size=16, face="bold"),
          legend.position = "bottom",
          legend.direction = "horizontal",
          plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
        ggtitle("TODO")
    
    })
##############DRUG END#####################
  
    
##############GENE BEGIN###################
    output$tableGene <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(), 
        paste0(
          "
          SELECT
            ensembl_id,
            uniprot_id,
            name,
            chromosome,
            start_position,
            end_position,
            LEFT(description, 70) || '...' AS description,
            description
          FROM gene
          ", paste(" WHERE name LIKE ", "'%", 
                   input$nameGene, "%'", sep=""), 
          sep=""))
      
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("ColReorder", "Buttons", "KeyTable"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          keys = TRUE,
                                          deferRender = TRUE,
                                        
                                          columnDefs = list(list(visible = FALSE, targets=7:7)),
                                          rowCallback = JS(
                                            "function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {",
                                            'for(i=6; i<7; i++ ){',
                                            "var full_text = aData[i+1];",
                                            "$('td:eq('+i+')', nRow).attr('title', 
                                            full_text).css('background-color', aData[i+1]);",
                                            '}',
                                            "}")
                           ), rownames = FALSE )
      return(ret) })
    
    gene_data <- reactive({
      query <- sqlInterpolate(ANSI(), "SELECT * FROM gene WHERE chromosome NOT LIKE 'H%' AND chromosome NOT LIKE 'M%'")
      
      gene_data <- dbGetQuery(pool, query)
      
      if(input$plotGene == "chr"){
        gene_data <- gene_data %>% 
          group_by(chromosome) %>% summarise(count = n(), res = chromosome)
      }

    })
    
    output$plotGene <- renderPlot({
     
      gene_data <- gene_data()
      
      ggplot(gene_data, aes(x = chromosome, y = as.integer(count))) +
        geom_col(width = 0.7) +
        labs(x= "Chromosome Name" , y = "Count") +
        theme(text = element_text(size=18))
    })
##############GENE END#####################
  

##############SNP BEGIN####################
    output$tableSnp <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(), paste0("SELECT * FROM snp", 
                                             paste(" WHERE refsnp_id LIKE ", "'%", input$nameSnp, "%'", sep=""), 
                                             sep=""))

    outp <- dbGetQuery(pool, query)
    ret <- DT::datatable(outp, width = "100%",
                         extensions= c("ColReorder", "Buttons", "KeyTable", "Scroller"),
                         options = list(colReorder = TRUE, dom = 'Bfrtip',
                                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                        keys = TRUE,
                                        deferRender = TRUE
                         ),  rownames = FALSE
    )
    return(ret) })
      
    snp_data <- reactive({
      query <- sqlInterpolate(ANSI(), "SELECT * FROM snp ORDER BY chr_name")
      
      snp_data <- dbGetQuery(pool, query)
      
      if(input$plotSnp == "chr"){
        snp_data <- snp_data %>% 
          group_by(chr_name) %>% summarise(count = n(), res = chr_name)
      }
    })
    
    output$plotSnp <- renderPlot({
      
      snp_data <- snp_data()

      ggplot(snp_data, aes(x = chr_name, y = count)) +
          geom_col() +
        labs(x= "Chromosome Name" , y = "SNP Count")
        
    })
##############SNP END######################

    
##############DDI BEGIN####################
    output$tableDdi <- DT::renderDataTable({
      query <- paste0("SELECT 
                          drug1_id, drug2_id, 
                          drug1_name, drug2_name, 
                          severity,
                          LEFT(description, 50) || '...' AS description,
                          description
                      FROM ddi", 
                  paste(" WHERE drug1_name LIKE ", "'%", input$nameDrug1, 
                        "%' AND drug2_name LIKE ", "'%", input$nameDrug2, "%'", sep=""), 
                  sep="")
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("ColReorder", "Buttons", "KeyTable"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          keys = TRUE,
                                          deferRender = TRUE,
                                          columnDefs = list(list(visible = FALSE, targets=5:6)),
                                          rowCallback = JS(
                                            "function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {",
                                            'for(i=5; i<6; i++ ){',
                                            "var full_text = aData[i+1];",
                                            "$('td:eq('+i+')', nRow).attr('title', 
                                            full_text).css('background-color', aData[i+1]);",
                                            '}',
                                            "}")
                           ),  rownames = FALSE
      )
      return(ret) })
    
    
    ddi_data <- reactive({
      query <- sqlInterpolate(ANSI(), "SELECT 
                              drug1_id, drug2_id,
                              drug1_name, drug2_name,
                              severity,
                              description 
                            FROM ddi")
      
      ddi_data <- dbGetQuery(pool, query)
      
      if(input$plotDdi == "drug"){
        ddi_data <- ddi_data %>% 
          group_by(drug1_id) %>% summarise(count = n(), res = drug1_id)
      }
      else  if(input$plotDdi == "atc"){
        ddi_data <- ddi_data %>% 
          group_by(severity) %>% summarise(count = n(), res = severity)
      }
      else if(input$plotDdi == "severity"){
        ddi_data <- ddi_data %>%  
          group_by(description) %>% 
          #select(description, contains('The risk or severity')) %>% 
          summarise(count = n(), res = severity)
      }
    })
    
    output$plotDdi <- renderPlot({
      
      ddi_data <- ddi_data()
     
      if(input$plotDdi == "drug"){
          p1 <- ggplot(ddi_data, aes(x = count)) +
            geom_histogram() +
            labs(x= "Drug Count" , y = "DDI Count") +
            theme(text = element_text(size=18))
          
          p2 <- ggplot(ddi_data, aes(x = count)) +
            geom_boxplot() +
            labs(x= "Drug Count" , y = "DDI Count") +
            theme(text = element_text(size=18))
          
          plot_grid(p1, p2, align = "v")
      }
      else  if(input$plotDdi == "atc"){
      
      }
      else if(input$plotDdi == "severity"){
        ddi_data$count <- as.numeric(ddi_data$count)
        
        #hist(ddi_data$count,
         #    main = "",
          #   xlab= "Drug Count", 
           #  ylab="ADDI Count",
            # cex.lab=1.5, cex.axis=1)  
      }
      
    })
##############DDI END######################
    

##############DGI BEGIN####################
    output$tableDgi <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(), 
                  paste0("SELECT 
                            drug_id,
                            CASE 
                              WHEN drug_protein_type = 1 THEN 'Target'
                              WHEN drug_protein_type = 2 THEN 'Enzyme'
                              WHEN drug_protein_type = 3 THEN 'Transporter'
                              WHEN drug_protein_type = 4 THEN 'Carrier' 
                            END AS drug_protein_type,
                            gene_name,
                            drug_protein_name,
                            polypeptide_uniprot_id,
                            general_function,
                            specific_function
                         FROM drug_protein", 
                             paste(" WHERE drug_id LIKE ", "'%", 
                                   input$nameDgiDrug, "%'", sep=""), 
                             sep=""))
      
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("Responsive", "ColReorder", "Buttons", "KeyTable"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          keys = TRUE,
                                          deferRender = TRUE
                           ),  rownames = FALSE
      )
      return(ret) })
    
    dgi_data <- reactive({
      query <- sqlInterpolate(ANSI(), " SELECT * FROM public.drug_protein")
      
      dgi_data <- dbGetQuery(pool, query)
      
      if(input$plotDgi == "gene"){
        dgi_data <- dgi_data %>% 
          group_by(gene_name) %>% summarise(count = n(), res = gene_name)  
        
        }
      else if(input$plotDgi == "protein_type"){
        dgi_data <- dgi_data %>% 
          group_by(drug_protein_type) %>% 
          summarise(count = n(), res = drug_protein_type)
          
      }
    })
    
    output$plotDgi <- renderPlot({
      
      dgi_data <- dgi_data()
      
      if(input$plotDgi == "gene"){
        
      ggplot(dgi_data, aes(x = gene_name, y=count)) +
        geom_col(width = 0.8) +
        labs(x= "Gene" , y = "Count", fill = "") +
        theme(
          text = element_text(family= "Times New Roman", size=16),
          title = element_text(family= "Times New Roman", size=16, face="bold"),
          legend.position = "bottom",
          legend.direction = "horizontal",
          plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
        ggtitle("TODO")
      }
      else if(input$plotDgi == "protein_type"){
      
        ggplot(dgi_data, aes(x = drug_protein_type, y=count)) +
          geom_col(width = 0.8) +
          labs(x= "protein type" , y = "Count", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("TODO")
      }
      
    })
  
##############DGI END######################
 
        
##############DDGI BEGIN###################

##############DDGI END#####################
    

##############STATISTICS BEGIN###################
#statisticId
    
##############STATISTICS END###################

    output$plotStat <- renderPlot({
      if(input$statisticId == "0")
      {
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
        stat_drug_data <- dbGetQuery(pool, query)
        
        ggplot(stat_drug_data, aes(x = group, y = as.integer(count), fill = drug_type)) +
          geom_col(width = 0.8) +
          labs(x= "Drug Status" , y = "Count", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Drug Type and Status")
      }
      else if (input$statisticId == "1")
      {
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
        stat_gene_data <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_gene_data, aes(x = chromosome, y = as.integer(count))) +
          geom_col(width = 0.7) +
          labs(x= "Chromosome Name" , y = "Count") +
          theme(text = element_text(size=18))
      }
      else if (input$statisticId == "2")
      {
        query <- sqlInterpolate(ANSI(), 
        "
          SELECT * FROM snp;
        "
        )
        stat_snp_data <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_snp_data, aes(x = snp_id, y = as.integer(count))) +
          geom_col(width = 0.7) +
          labs(x= "Gene Name" , y = "SNP Count") +
          theme(text = element_text(size=18))
      }
      else if (input$statisticId == "3")
      {
        
      }
      else if (input$statisticId == "4")
      {
        
      }
      else if (input$statisticId == "5")
      {
        
      }      
      else if (input$statisticId == "6")
      {
        
      }
      else if (input$statisticId == "7")
      {
        
      }
      else if (input$statisticId == "8")
      {
        
      }
      else if (input$statisticId == "9")
      {
        
      }
      else if (input$statisticId == "10")
      {
        
      }
      
    })

})