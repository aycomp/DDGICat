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
        	drug_id, name, type, state,
        	LEFT(synonym, 50) AS synonym,
	        LEFT(indication, 60) || '...' AS indication,
        	LEFT(description, 60) || '...' AS description,
        	LEFT(toxicity, 60) || '...' AS toxicity,
        	synonym, indication,description,toxicity,
        	pharmacodynamics, absorption, half_life, 
        	metabolism, mechanism_of_action, volume_of_distribution, 
        	protein_binding, clearance, route_of_elimination, 
        	'<a href=https://pubmed.ncbi.nlm.nih.gov/' || pubmed_id || '/>' || pubmed_id || '</a>' AS pubmed_id
        FROM public.drug d
        INNER JOIN drug_groups dg 
          ON d.drug_id = dg.",
            paste("\"drugbank-id\"", " WHERE lower(d.name) LIKE ", "'", tolower(input$nameDrug), 
                  "%' AND d.type = '", input$typeDrug,  
                  "' AND dg.group = '", input$statusDrug, "'", sep=""),sep=""))
      
      outp <- dbGetQuery(pool, query)
      
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("Responsive", "ColReorder", "Buttons", "KeyTable", 
                                         "Scroller"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          keys = TRUE,
                                          deferRender = TRUE,
                                          autoWidth = TRUE,
                                          columnDefs = list(list(visible = FALSE, targets=8:11)),
                                          rowCallback = JS(
                                            "function(nRow, aData, iDisplayIndex, iDisplayIndexFull) {",
                                            'for(i=4; i<8; i++ ){',
                                            "var full_text = aData[i+4];",
                                            "$('td:eq('+i+')', nRow).attr('title', 
                                            full_text).css('background-color', aData[i+4]);",
                                            '}',
                                            "}")
                                          ),  
                                          colnames = c('Drug Id', 'Name', 'Type', 'State', 
                                                       'Synonym', 'Indication', 'Description', 'Toxicity', 
                                                       'Synonym', 'Indication', 'Description', 'Toxicity', 
                                                       'Pharmacodynamics', 'Absorption', 'Half Life', 
                                                       'Metabolism', 'Mechanism Of Action', 'Volume Of Distribution', 
                                                       'Protein Binding', 'Clearance', 'Route Of Elimination', 'Pubmed Id'),
                                          rownames = FALSE, escape = FALSE
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
        ggtitle("")
    
    })
##############DRUG END#####################
  
    
##############GENE BEGIN###################
    output$tableGene <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(), 
        paste0("
          SELECT
            ensembl_id,
            uniprot_id,
            name,
            chromosome,
            start_position,
            end_position,
            description
          FROM gene
          ", paste(" WHERE lower(name) LIKE ", "'", tolower(input$nameGene), "%'", sep=""), 
          sep=""))
      
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("ColReorder", "Buttons", "KeyTable"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          keys = TRUE,
                                          deferRender = TRUE,
                                          autoWidth = TRUE
                           ),
                           colnames = c('Ensembl Id', 'Uniprot Id', 'Name', 'Chromosome', 
                                        'Start Position', 'End Position', 'Description'),
                           rownames = FALSE , escape = FALSE)
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
                                             paste(" WHERE lower(refsnp_id) LIKE ", "'%", tolower(input$nameSnp), "%'", sep=""), 
                                             sep=""))

    outp <- dbGetQuery(pool, query)
    ret <- DT::datatable(outp, width = "100%",
                         extensions= c("ColReorder", "Buttons", "KeyTable", "Scroller"),
                         options = list(colReorder = TRUE, dom = 'Bfrtip',
                                        buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                        keys = TRUE,
                                        deferRender = TRUE,
                                        autoWidth = TRUE
                         ),  colnames = c('RefSNP Id', 'RefSNP Source', 'Chromosome Name', 
                                          'Chromosome Start', 'Chromosome End', 'Chromosome Strand', 'Allele'), 
                                          rownames = FALSE, escape = FALSE
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
                          description
                      FROM ddi", 
                paste(" WHERE 
                        (lower(drug1_name) LIKE ", "'", tolower(input$nameDrug1), "%' AND lower(drug2_name) LIKE ", "'", tolower(input$nameDrug2), "%') OR", 
                      " (lower(drug2_name) LIKE ", "'", tolower(input$nameDrug1), "%' AND lower(drug1_name) LIKE ", "'", tolower(input$nameDrug2), "%')",
                      " AND severity = ", "'", input$severity, "'", sep=""), 
                sep="")
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("ColReorder", "Buttons", "KeyTable"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          keys = TRUE,
                                          deferRender = TRUE,
                                          autoWidth = TRUE
                           ),   colnames = c('Drug1 Id', 'Drug2 Id', 'Drug1 Name', 'Drug2 Name', 
                                             'Severity', 'Description'), rownames = FALSE, escape = FALSE
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
                      d.drug_id,
                      d.name,
                      CASE 
                        WHEN dp.drug_protein_type = 1 THEN 'Target'
                        WHEN dp.drug_protein_type = 2 THEN 'Enzyme'
                        WHEN dp.drug_protein_type = 3 THEN 'Transporter'
                        WHEN dp.drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type,
                      dp.gene_name,
                      dp.drug_protein_name,
                      dp.polypeptide_uniprot_id,
                      dp.general_function,
                      dp.specific_function
                   FROM drug_protein dp 
                   INNER JOIN drug d 
                      ON d.drug_id = dp.drug_id ", 
                paste(" WHERE lower(d.name) LIKE ", "'", tolower(input$nameDgiDrug), "%' 
                          AND dp.drug_protein_type IN (", input$proteinType, ") ",
                          "AND lower(dp.gene_name) LIKE '", tolower(input$nameDgiGen), "%'",
                sep=""), 
           sep=""))
      
      outp <- dbGetQuery(pool, query)
      ret <- DT::datatable(outp, width = "100%",
                           extensions= c("Responsive", "ColReorder", "Buttons", "KeyTable"),
                           options = list(colReorder = TRUE, dom = 'Bfrtip',
                                          buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                          keys = TRUE,
                                          deferRender = TRUE,
                                          autoWidth = TRUE ),
                              colnames = c('Drug Id', 'Name', 'Protein Type', 'Gene Name', 'Drug Protein Name', 
                                           'Polypeptide Uniprot Id', 'General Function', 'Specific Function'), 
                              rownames = FALSE )
      
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
        ggtitle("")
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
          ggtitle("")
      }
      
    })
  
##############DGI END######################
 
        
##############DDGI BEGIN###################
    #Disease
    sqlOutputDisease <- reactive({
        query <- sqlInterpolate(ANSI(), "SELECT DISTINCT(name) AS disease FROM disease ORDER BY name")
      outp <- dbGetQuery(pool, query)
    })
    observe ({
      updateSelectInput(session, "disease", choices = sqlOutputDisease()) })
      
    #Drug 1
    sqlOutputDrug1 <- reactive({
      query <- sqlInterpolate(ANSI(), paste0("
          SELECT 
          	  DISTINCT(chemicals) AS drug_name
          FROM public.clinical_variants
          WHERE lower(phenotypes) LIKE '", tolower(input$disease), "%' ORDER BY chemicals " , sep=""))
      outp <- dbGetQuery(pool, query)
    })
    observe ({
      updateSelectInput(session, "drug1", choices = sqlOutputDrug1()) })
    
    #Drug 2
    sqlOutputDrug2 <- reactive({
      query <- sqlInterpolate(ANSI(), paste0("
          WITH q AS (
	            SELECT 
            		\"Entity1_name\" AS drug_name
            	FROM public.relationships
            	WHERE \"Entity2_type\" = 'Chemical'
            		AND \"Entity1_type\" = 'Chemical'
            		AND (\"Entity1_name\" = '", input$drug1, "' OR \"Entity2_name\" = '", input$drug1, "' )
            	UNION ALL   
            	SELECT 
            		\"Entity2_name\" AS drug_name
            	FROM public.relationships
            	WHERE \"Entity2_type\" = 'Chemical'
            		AND \"Entity1_type\" = 'Chemical'
            		AND (\"Entity1_name\" = '", input$drug1, "' OR \"Entity2_name\" = '", input$drug1, "' )
          )
          SELECT DISTINCT(drug_name) FROM q ", sep=""))
      outp <- dbGetQuery(pool, query)
    })
    observe ({
      updateSelectInput(session, "drug2", choices = sqlOutputDrug2()) })
    
    #Fill Data Table
    output$tableDdgi <- DT::renderDataTable({
        if(input$intersectionSet == "0"){ #Chromosome
            qsub <- paste0("
              WITH q1 AS (
                  SELECT 
                    	ge.chromosome AS name,
                    	dp.gene_name,
                    	d.name AS drug_name
                  FROM public.drug_protein dp
                  INNER JOIN public.drug d
                  	ON dp.drug_id = d.drug_id
                  INNER JOIN public.gene ge
                  	ON dp.gene_name = ge.name ", paste(" 
                  WHERE lower(d.name) LIKE '", tolower(input$drug1), "%'
                    AND ge.chromosome NOT LIKE 'H%'
                  ORDER BY ge.chromosome ) ", sep=""), ", 
               q2 AS (
                  SELECT 
                      ge.chromosome AS name,
                      dp.gene_name,
                      d.name AS drug_name
                  FROM public.drug_protein dp
                  INNER JOIN public.drug d
                    ON dp.drug_id = d.drug_id
                  INNER JOIN public.gene ge
                    ON dp.gene_name = ge.name ", paste(" 
                  WHERE lower(d.name) LIKE '", tolower(input$drug2), "%'
                    AND ge.chromosome NOT LIKE 'H%'
                  ORDER BY ge.chromosome ) ", sep=""), "
              SELECT 
                  q1.name AS \"Chromosome Name\",
                  q1.drug_name AS \"Drug1 Name\", 
                  q2.drug_name AS \"Drug2 Name\",
                  q1.gene_name AS \"Drug1 Gene\",
                  q2.gene_name AS \"Drug2 Gene\"
              FROM q1
              INNER JOIN q2
                ON lower(q1.name) = lower(q2.name) ", sep="")
        }
        else if(input$intersectionSet == "1"){ #Gene
            qsub <- paste0("
                WITH q1 AS (
                    SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE '", tolower(input$drug1), "%' ", sep=""), "), 
                q2 AS (
                   SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE '", tolower(input$drug2), "%' ", sep=""), ")
              SELECT 
                  q1.gene_name AS \"Gene Name\",
                  q1.drug_name AS \"Drug1 Name\", 
                  q2.drug_name AS \"Drug2 Name\",
                  q1.drug_protein_type AS \"Drug Protein Type\",
                  q1.drug_protein_name AS \"Drug Protein Name\",
                  CASE 
                    WHEN q1.polypeptide_uniprot_id = q2.polypeptide_uniprot_id 
                    THEN q1.polypeptide_uniprot_id
                    ELSE 'not same'
                  END AS \"Uniprot Id\",
                  CASE 
                    WHEN q1.polypeptide_name = q2.polypeptide_name 
                    THEN q1.polypeptide_name
                    ELSE 'not same'
                  END AS \"Polypeptide Name\",
                  CASE 
                    WHEN q1.general_function = q2.general_function 
                    THEN q1.general_function
                    ELSE 'not same'
                  END AS \"General Function\",
                  CASE 
                    WHEN q1.specific_function = q2.specific_function 
                    THEN q1.specific_function
                    ELSE 'not same'
                  END AS \"Specific Function\"
              FROM q1
              INNER JOIN q2
                ON lower(q1.gene_name) = lower(q2.gene_name) ", sep="")
                
        }
        else if(input$intersectionSet == "2"){ #Protein
          qsub <- paste0("
                WITH q1 AS (
                    SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE '", tolower(input$drug1), "%' ", sep=""), "), 
                q2 AS (
                   SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE '", tolower(input$drug2), "%' ", sep=""), ")
              SELECT 
                  q1.polypeptide_uniprot_id AS \"Protein Name\",
                  q1.gene_name AS \"Gene Name\",
                  q1.drug_protein_type AS \"Protein Type\",
                  q1.drug_name AS \"Drug1 Name\", 
                  q2.drug_name AS \"Drug2 Name\"
              FROM q1
              INNER JOIN q2
                ON lower(q1.polypeptide_uniprot_id) = lower(q2.polypeptide_uniprot_id) ", sep="")
        }
        else if(input$intersectionSet == "3"){ #SNP
          qsub <- paste0("
             WITH q1 AS (
                  SELECT 
                    ds.uniprot_id,
                    ds.drug_id,
                    d.name,
                    ds.snp_id,
                    ds.chromosome,
                    ds.gene_name,
                    LEFT(ds.description, 70) || '...' AS description,
                    ds.description
                  FROM public.drug_snp ds 
                  INNER JOIN public.drug d 
                    ON d.drug_id = ds.drug_id ", paste(" 
                  WHERE lower(d.name) LIKE '", tolower(input$drug1), "%' ", sep=""), "),
              q2 AS (
                  SELECT 
                    ds.uniprot_id,
                    ds.drug_id,
                    d.name,
                    ds.snp_id,
                    ds.chromosome,
                    ds.gene_name,
                    LEFT(ds.description, 70) || '...' AS description,
                    ds.description
                  FROM public.drug_snp ds 
                  INNER JOIN public.drug d 
                    ON d.drug_id = ds.drug_id ", paste(" 
                  WHERE lower(d.name) LIKE '", tolower(input$drug2), "%' ", sep=""), ")
              SELECT 
                  q1.snp_id AS \"SNP Name\",
                  q1.chromosome AS \"Chromosome\",
                  q1.gene_name AS \"Gene Name\",
                  q1.name AS \"Drug1 Name\", 
                  q2.name AS \"Drug2 Name\"
              FROM q1
              INNER JOIN q2
                ON lower(q1.snp_id) = lower(q2.snp_id) ", sep="")
          
        }
      
        query <- sqlInterpolate(ANSI(), qsub)
        outp <- dbGetQuery(pool, query)
        ret <- DT::datatable(outp, width = "100%",
                             extensions= c("Responsive", "ColReorder", "Buttons", "KeyTable"),
                             options = list(colReorder = TRUE, dom = 'Bfrtip',
                                            buttons = c('copy', 'csv', 'excel', 'pdf', 'print'), 
                                            keys = TRUE,
                                            autoWidth = TRUE
                             ),  
                             rownames = FALSE,
                             print(gsub("[\r\n\t]", "", qsub))
      )
      return(ret) })
    
    ddgi_data <- reactive({
      qsub <- ""
      
      if(input$intersectionSet == "0"){ #Chromosome
        qsub <- paste0("
              WITH q1 AS (
                  SELECT 
                    	ge.chromosome AS name,
                    	dp.gene_name,
                    	d.name AS drug_name
                  FROM public.drug_protein dp
                  INNER JOIN public.drug d
                  	ON dp.drug_id = d.drug_id
                  INNER JOIN public.gene ge
                  	ON dp.gene_name = ge.name ", paste(" 
                  WHERE lower(d.name) LIKE ", "'%", tolower(input$drug1), "%'
                    AND ge.chromosome NOT LIKE 'H%'
                  ORDER BY ge.chromosome ) ", sep=""), ", 
               q2 AS (
                  SELECT 
                      ge.chromosome AS name,
                      dp.gene_name,
                      d.name AS drug_name
                  FROM public.drug_protein dp
                  INNER JOIN public.drug d
                    ON dp.drug_id = d.drug_id
                  INNER JOIN public.gene ge
                    ON dp.gene_name = ge.name ", paste(" 
                  WHERE lower(d.name) LIKE ", "'%", tolower(input$drug2), "%'
                    AND ge.chromosome NOT LIKE 'H%'
                  ORDER BY ge.chromosome ) ", sep=""), "
              SELECT 
                  q1.name AS name,
                  q1.drug_name AS drug1_name, 
                  q2.drug_name AS drug2_name,
                  q1.gene_name AS drug1_gene,
                  q2.gene_name AS drug2_gene
              FROM q1
              INNER JOIN q2
                ON lower(q1.name) = lower(q2.name) ", sep="")
        
      }
      else if(input$intersectionSet == "1"){ #Gene
        qsub <- paste0("
                WITH q1 AS (
                    SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE ", "'%", tolower(input$drug1), "%' ", sep=""), "), 
                q2 AS (
                   SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE ", "'%", tolower(input$drug2), "%' ", sep=""), ")
              SELECT 
                  q1.gene_name AS name,
                  q1.drug_protein_type,
                  q1.drug_protein_name,
                  q1.drug_name AS drug1_name, 
                  q2.drug_name AS drug2_name
              FROM q1
              INNER JOIN q2
                ON lower(q1.gene_name) = lower(q2.gene_name) ", sep="")
      }
      else if(input$intersectionSet == "2"){ #Protein
        qsub <- paste0("
                WITH q1 AS (
                    SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE ", "'%", tolower(input$drug1), "%' ", sep=""), "), 
                q2 AS (
                   SELECT 
                      dp.gene_name,
                    	d.name AS drug_name,
            	        CASE 
                        WHEN drug_protein_type = 1 THEN 'Target'
                        WHEN drug_protein_type = 2 THEN 'Enzyme'
                        WHEN drug_protein_type = 3 THEN 'Transporter'
                        WHEN drug_protein_type = 4 THEN 'Carrier' 
                      END AS drug_protein_type, 
                    	dp.drug_protein_name, 
                    	dp.polypeptide_uniprot_id, 
                    	dp.polypeptide_name, 
                    	dp.general_function, 
                    	dp.specific_function
                    FROM public.drug_protein dp
                    INNER JOIN public.drug d
                    	ON dp.drug_id = d.drug_id ", paste(" 
                    WHERE lower(d.name) LIKE ", "'%", tolower(input$drug2), "%' ", sep=""), ")
              SELECT 
                  q1.polypeptide_uniprot_id AS name,
                  q1.gene_name,
                  q1.drug_protein_type,
                  q1.drug_name AS drug1_name, 
                  q2.drug_name AS drug2_name
              FROM q1
              INNER JOIN q2
                ON lower(q1.polypeptide_uniprot_id) = lower(q2.polypeptide_uniprot_id) ", sep="")
        
      }
      else if(input$intersectionSet == "3"){ #SNP
        qsub <- paste0("
             WITH q1 AS (
                  SELECT 
                    ds.uniprot_id,
                    ds.drug_id,
                    d.name,
                    ds.snp_id,
                    ds.chromosome,
                    ds.gene_name,
                    LEFT(ds.description, 70) || '...' AS description,
                    ds.description
                  FROM public.drug_snp ds 
                  INNER JOIN public.drug d 
                    ON d.drug_id = ds.drug_id ", paste(" 
                  WHERE lower(d.name) LIKE ", "'%", tolower(input$drug1), "%' ", sep=""), "),
              q2 AS (
                  SELECT 
                    ds.uniprot_id,
                    ds.drug_id,
                    d.name,
                    ds.snp_id,
                    ds.chromosome,
                    ds.gene_name,
                    LEFT(ds.description, 70) || '...' AS description,
                    ds.description
                  FROM public.drug_snp ds 
                  INNER JOIN public.drug d 
                    ON d.drug_id = ds.drug_id ", paste(" 
                  WHERE lower(d.name) LIKE ", "'%", tolower(input$drug2), "%' ", sep=""), ")
              SELECT 
                  q1.snp_id AS name,
                  q1.chromosome,
                  q1.gene_name,
                  q1.name AS drug1_name, 
                  q2.name AS drug2_name
              FROM q1
              INNER JOIN q2
                ON lower(q1.snp_id) = lower(q2.snp_id) ", sep="")
      }
      
      query <- sqlInterpolate(ANSI(), qsub)
      
      ddgi_data <- dbGetQuery(pool, query)
      
      ddgi_data <- ddgi_data %>% group_by(name) %>% 
        summarise(count = n(), res = name)
    })
    
    output$plotDdgi <- renderPlot({
      
      ddgi_data <- ddgi_data()
      
      ggplot(ddgi_data, aes(x = name, y=count)) +
        geom_col(width = 0.8) +
        labs(x= "Name" , y = "Count", fill = "") +
        theme(
          text = element_text(family= "Times New Roman", size=16),
          title = element_text(family= "Times New Roman", size=16, face="bold"),
          legend.position = "bottom",
          legend.direction = "horizontal",
          plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
        ggtitle("")
      
    })
##############DDGI END#####################
    

##############STATISTICS BEGIN###################
#statisticId
    
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
    
##############STATISTICS END###################
    

##############DOWNLOAD BEGIN###################

    query <- sqlInterpolate(ANSI(), "SELECT * FROM public.drug;")
    
    Drug <- dbGetQuery(pool, query)
      
    # Reactive value for selected dataset ----
    datasetInput <- reactive({
      switch(input$dataset,
             "Drug" = Drug,
             "Gene" = Gene,
             "SNP" = SNP)
    })
    
    # Downloadable csv of selected dataset ----
    output$downloadData <- downloadHandler(
      filename = function() {
        paste(input$dataset, ".csv", sep = "")
      },
      content = function(file) {
        write.csv(datasetInput(), file, row.names = FALSE)
      }
    )
    
##############DOWNLOAD END#####################
    
})