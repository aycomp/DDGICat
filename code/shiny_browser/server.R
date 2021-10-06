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
                  "%' AND ('", input$typeDrug, "' = 'all' OR d.type = '", input$typeDrug,  
                  "' ) AND ('", input$statusDrug, "' = 'all' OR dg.group = '", input$statusDrug, "')", sep=""),sep=""))
      
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
    
##############DRUG END#####################
  
    
##############GENE BEGIN###################
    output$tableGene <- DT::renderDataTable({
      query <- sqlInterpolate(ANSI(), 
        paste0("
          SELECT
            ensembl_id,
            hgnc_symbol,
            uniprot_id,
            uniprot_symbol,
            chromosome,
            start_position,
            end_position,
            description
          FROM gene
          ", paste(" WHERE lower(hgnc_symbol) LIKE ", "'", tolower(input$nameGene), "%'", sep=""), 
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
                           colnames = c('Ensembl Id', 'Hgnc Symbol', 'Uniprot Id', 'Uniprot Symbol', 'Chromosome', 
                                        'Start Position', 'End Position', 'Description'),
                           rownames = FALSE , escape = FALSE)
      return(ret) })
    
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
                        ((lower(drug1_name) LIKE ", "'", tolower(input$nameDrug1), "%' AND lower(drug2_name) LIKE ", "'", tolower(input$nameDrug2), "%') OR", 
                      " (lower(drug2_name) LIKE ", "'", tolower(input$nameDrug1), "%' AND lower(drug1_name) LIKE ", "'", tolower(input$nameDrug2), "%'))",
                      
                      " AND ( CASE WHEN '", input$severity , "' = '' THEN 1 = 1 
                          ELSE severity = '", input$severity, "' END )", sep=""))
      
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
            		AND (lower(\"Entity1_name\") LIKE '%", tolower(input$drug1), "%' OR lower(\"Entity2_name\") LIKE '%", tolower(input$drug1), "%' )
            	UNION ALL   
            	SELECT 
            		\"Entity2_name\" AS drug_name
            	FROM public.relationships
            	WHERE \"Entity2_type\" = 'Chemical'
            		AND \"Entity1_type\" = 'Chemical'
            		AND (lower(\"Entity1_name\") LIKE '%", tolower(input$drug1), "%' OR lower(\"Entity2_name\") LIKE '%", tolower(input$drug1), "%' )
          ), d AS (
              SELECT 
                drug1_name AS drug_name
              FROM ddi
              WHERE severity IN ('high', 'CI')
                AND lower(drug1_name) LIKE '%", tolower(input$drug1), "%'
            ),
          c AS (SELECT lower(drug_name) as name FROM q 
            UNION ALL 
           SELECT lower(drug_name) as name FROM d
          )
          SELECT DISTINCT(name) AS drug_name FROM c  
        ", sep=""))
      
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
                  	ON dp.gene_name = ge.hgnc_symbol ", paste(" 
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
                    ON dp.gene_name = ge.hgnc_symbol ", paste(" 
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
                  	ON dp.gene_name = ge.hgnc_symbol ", paste(" 
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
                    ON dp.gene_name = ge.hgnc_symbol ", paste(" 
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
    
    choiced <- reactive({
      
      if(input$entityId == "Drug"){
        choice <- c("Drug State" = "drugState", 
                    "Drug Status" = "drugStatus", 
                    "Drug Type" = "drugType", 
                    "Drug Status per Drug Type" = "drugStatusPerDrug")
      }
      else if(input$entityId == "Gene"){
        choice <- c("Drugable Gene Count per Chromosome" = "drugableGenePerChromosome", 
                    "Drugable/NonDrugable Gene Count per Chromosome" = "drugableNonDrugableGenePerChromosome",
                    "Top Drug Associated Genes" = "topDrugAssociatedGenes",
                    "Top Drug Associated Proteins" = "topDrugAssociatedProteins",
                    "Protein Type per Drug Association" = "proteinTypePerDrugAssociation",
                    "Target Distribution per Drug" = "targetDistributionPerDrug",
                    "Enzyme Distribution per Drug" = "enzymeDistributionPerDrug",
                    "Carrier Distribution per Drug" = "carrierDistributionPerDrug",
                    "Transporter Distribution per Drug" = "transporterDistributionPerDrug")
      }
      else if(input$entityId == "SNP"){
        choice <- c("Drugable SNP Count per Chromosome" = "drugableSNPPerChromosome", 
                    "Drugable/NonDrugable SNP Count per Chromosome" = "drugableNonDrugableSNPPerChromosome")
      }
      else if(input$entityId == "DDI"){
        choice <- c("Drug Count" = "ddiDistributionperDrugCount",
                    "Same ATC Level" = "ddiSharingSameATCLevel",
                    "Distribution per ATC Level1" = "ddiDistributionperATCLevel1",
                    "Distribution per ATC Level2" = "ddiDistributionperATCLevel2",
                    "Distribution per ATC Level3" = "ddiDistributionperATCLevel3",
                    "Distribution per ATC Level4" = "ddiDistributionperATCLevel4"
                    )}
      else if(input$entityId == "DDGI"){
        choice <- c("DDI Distribution per Drug-Protein" = "ddiDistributionperDrugProtein",
                    "DDI Percentagesper Sharing Same Drug-Protein" = "ddiDistributionperSharingSameDrugProtein")}
    })
    
    observe ({
      updateSelectInput(session, "plot", choices = choiced())
    })
    
    output$plotStat <- renderPlot({

      if (input$plot == "drugState")
      {
        query <- sqlInterpolate(ANSI(), "
            SELECT 
            	state, COUNT(*) AS count
            FROM public.drug
            WHERE state != '-'
            GROUP BY state"
        )
        
        stat_drug_data <- dbGetQuery(pool, query)
        
        ggplot(stat_drug_data, aes(x = reorder(state, -count), y = as.integer(count))) +
          geom_col(width = 0.8) +
          geom_text(aes(label = count), vjust = -0.2) +
          labs(x= "Drug State" , y = "Count", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Drug State")
      }
      else if (input$plot == "drugStatus")
      {
        query <- sqlInterpolate(ANSI(), "
          SELECT 
            dg.group as status, COUNT(*) AS count
          FROM drug d
          INNER JOIN drug_groups dg
          	ON d.drug_id = dg.\"drugbank-id\"
          GROUP BY dg.group
          ORDER BY dg.group
        "
        )
        
        stat_drug_data <- dbGetQuery(pool, query)
        
        ggplot(stat_drug_data, aes(x = reorder(status, -count), y = as.integer(count))) +
          geom_col(width = 0.8) +
          geom_text(aes(label = count), vjust = -0.2) +
          labs(x= "Drug Status" , y = "Count", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Drug Status")        
      }
      else if (input$plot == "drugType")
      {
        query <- sqlInterpolate(ANSI(), "
            SELECT 
            	type, COUNT(*) AS count
            FROM public.drug
            GROUP BY type
            ORDER BY type; "
        )
        
        stat_drug_data <- dbGetQuery(pool, query)
        
        ggplot(stat_drug_data, aes(x = reorder(type, -count), y = as.integer(count))) +
          geom_col(width = 0.8) +
          geom_text(aes(label = count), vjust = -0.2) +
          labs(x= "Drug Type" , y = "Count") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Drug Type")        
      }
      else if(input$plot == "drugStatusPerDrug")
      {
        query <- sqlInterpolate(ANSI(), "
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
            SELECT \"group\", drug_type, count FROM biot; "
        )
        
        stat_drug_data <- dbGetQuery(pool, query)
          
        ggplot(stat_drug_data, aes(x = reorder(group, -count), y = count, fill = drug_type)) +
          geom_col(width = 0.8) +
          geom_text(aes(label = count), vjust = -0.2,  position=position_stack(vjust=.5)) +
          labs(x= "Drug Status" , y = "Count") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Drug Status per Drug Type")
      }
      else if (input$plot == "drugableGenePerChromosome")
      {
        query <- sqlInterpolate(ANSI(), "
            WITH a AS (	
              SELECT
              	COUNT(*),
              	chromosome
              FROM public.gene	
              WHERE chromosome >= '1' 
              	AND chromosome <= '23'
              GROUP BY chromosome
              ORDER BY chromosome::INT  
              ),
            b AS (
            SELECT 
            	COUNT(*),
            	chromosome
            FROM public.gene	
            WHERE chromosome IN ('X', 'Y')
            GROUP BY chromosome
            ORDER BY chromosome
            )
            SELECT * FROM a 
            UNION ALL 
            SELECT * FROM b "
        )
        
        stat_gene_data <- dbGetQuery(pool, query)
        theme_set(theme_bw())
        
        ggplot(stat_gene_data, aes(x = reorder(chromosome, -count), y = count)) +
          geom_col(width = 0.8) +
          labs(x= "Chromosome" , y = "Gene Count", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16, face="bold"),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          geom_text(aes(label = count), vjust = -0.2) +
          ggtitle("Drugable Gene Count per Chromosome")
      }
      else if (input$plot == "drugableNonDrugableGenePerChromosome")
      {
        query <- sqlInterpolate(ANSI(), "
         WITH drugable_gene AS (
            WITH 
             a AS (	
            	  SELECT
            		COUNT(*) AS count,
            		chromosome
            	  FROM public.gene	
            	  WHERE chromosome >= '1' 
            		AND chromosome <= '23'
            	  GROUP BY chromosome
            	  ORDER BY chromosome::INT  
            	  ),
            b AS (
            	SELECT 
            		COUNT(*) AS count,
            		chromosome
            	FROM public.gene	
            	WHERE chromosome IN ('X', 'Y')
            	GROUP BY chromosome
            	ORDER BY chromosome
            	)
            	SELECT chromosome, count FROM a 
            	UNION ALL 
            	SELECT chromosome, count FROM b
            ),
            gene_count AS (
            	SELECT chromosome, count
            	FROM gene_count_per_chromosome
            )
            SELECT 
            	g.chromosome AS chromosome,
            	d.count AS count,
            	'Yes' AS drugability,
            	round(((d.count::decimal / g.count::decimal) * 100),0) AS percentage
            FROM gene_count g
            INNER JOIN drugable_gene d
            	ON g.chromosome = d.chromosome
            UNION ALL
            SELECT 
            	g.chromosome AS chromosome,
            	g.count AS count,
            	'No' AS drugability,
            	(100 - round(((d.count::decimal / g.count::decimal) * 100),0)) AS percentage
            FROM gene_count g
            INNER JOIN drugable_gene d
            	ON g.chromosome = d.chromosome "
        )

        stat_gene_data <- dbGetQuery(pool, query)
        
        ggplot(stat_gene_data, aes(x = reorder(chromosome, -count), y = count, fill = drugability)) +
          geom_col(width = 0.9) +
          geom_text(aes(label = percentage, vjust = -0.2)) +
          labs(x= "Chromosome", y = "Gene Count") +
          theme(
            text = element_text(family= "Times New Roman", size=16, face="bold"),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Drugable/NonDrugable Gene Percentage per Chromosome")
      }
      else if (input$plot == "topDrugAssociatedGenes") {
        query <- sqlInterpolate(ANSI(), "
            SELECT 
            	COUNT(*)::int AS cnt, gene_name
            FROM public.drug_protein
            WHERE gene_name IS NOT NULL
            GROUP BY gene_name
            ORDER BY cnt DESC
            LIMIT 10; " );
        
        theme_set(theme_bw())
        
        stat_gene_data <- dbGetQuery(pool, query)
        
        ggplot(stat_gene_data, aes(x = reorder(gene_name, -cnt), y = cnt)) +
          geom_col(width = 0.8) +
          geom_text(aes(label = cnt, vjust = -0.2)) +
          labs(x= "Gene Name" , y = "Count") +
          theme(
            text = element_text(family= "Times New Roman", size=12, face="bold"),
            title = element_text(family= "Times New Roman", size=14, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Top 10 Most Drug-Associated Genes")
        
      }
      else if (input$plot == "topDrugAssociatedProteins") {
        query <- sqlInterpolate(ANSI(), "
         SELECT 
              	COUNT(*)::int AS cnt, 
              	CASE WHEN drug_protein_type = 1 THEN 'Target'
              	     WHEN drug_protein_type = 2 THEN 'Enzyme'
              	     WHEN drug_protein_type = 3 THEN 'Carrier'
              	     WHEN drug_protein_type = 4 THEN 'Transporter'
              	END AS drug_protein_type,
              	drug_protein_name AS protein_name
                FROM public.drug_protein
              --WHERE drug_protein_name IS NOT NULL
              GROUP BY drug_protein_type, drug_protein_name
              ORDER BY cnt DESC
            LIMIT 10; ");
                                
        stat_drug_protein_data <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_drug_protein_data, aes(x = reorder(protein_name, -cnt), y = cnt, 
                         fill=reorder(drug_protein_type, -cnt))) +
          geom_col(width = 0.7) +
          geom_text(aes(label = cnt, vjust = -0.2)) +
          labs(x= "Protein Name" , y = "Count", fill="") +
          theme(
            text = element_text(family= "Times New Roman", size=10, face="bold"),
            axis.text.x = element_text(angle = 20),
            title = element_text(family= "Times New Roman", size=12, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=14, face="bold", hjust = 0.5)) +
          ggtitle("Top Drug-Interacting Proteins") +
          guides(fill=guide_legend())
                                
      }
      else if (input$plot == "proteinTypePerDrugAssociation") {
        query <- sqlInterpolate(ANSI(), "
            SELECT 
            	COUNT(*)::int AS cnt,
        			CASE 
        			  WHEN drug_protein_type = 1 THEN 'Target'
        			  WHEN drug_protein_type = 2 THEN 'Enzyme'
        			  WHEN drug_protein_type = 3 THEN 'Carrier'
        			  WHEN drug_protein_type = 4 THEN 'Transporter'
        			END AS drug_protein_type
            FROM public.drug_protein
            GROUP BY drug_protein_type
            ORDER BY cnt DESC "
        )
        
        stat_protein_type_data <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_protein_type_data, aes(x = reorder(drug_protein_type, -cnt), y = cnt)) +
          geom_col(width = 0.8) +
          geom_text(aes(label = cnt, vjust = -0.2)) +
          labs(x= "Protein Type" , y = "Count") +
          theme(
            text = element_text(family= "Times New Roman", size=12, face="bold"),
            title = element_text(family= "Times New Roman", size=13, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=14, face="bold", hjust = 0.5)) +
          ggtitle("Protein Types per Drug Association")
      }
      else if (input$plot == "drugableSNPPerChromosome")
      {
        query <- sqlInterpolate(ANSI(), "
            SELECT 
            	chr_name, COUNT(*) AS count
            FROM public.snp
            GROUP BY chr_name
            ORDER BY (chr_name::INT)"
        )
        
        stat_snp_data <- dbGetQuery(pool, query)
        
        ggplot(stat_snp_data, aes(x = reorder(chr_name, -count), y = count)) +
          geom_col(width = 0.8) +
          labs(x= "Chromosome", y = "SNP Count") +
          theme(
            text = element_text(family= "Times New Roman", size=16, face="bold"),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          geom_text(aes(label = count), vjust = -0.2) +
          ggtitle("DDGICat - #SNP per Chromosome")
      }
      else if (input$plot == "drugableNonDrugableSNPPerChromosome")
      {
        query <- sqlInterpolate(ANSI(), "
         WITH drugable_snp AS (
            	WITH 
            	 a AS (	
            		  SELECT
            			COUNT(*) AS count,
            			chr_name::text AS chromosome
            		  FROM public.snp	
            		  WHERE chr_name >= '1' 
            			AND chr_name <= '23'
            		  GROUP BY chr_name
            		  ORDER BY chr_name::INT 
            		  )
            		SELECT chromosome, count FROM a 
            	),
            	snp_count AS (
            		SELECT chromosome, count
            		FROM snp_count_per_chromosome
            	)
            	SELECT 
            		g.chromosome AS chromosome,
            		d.count AS count,
            		'Yes' AS drugability,
            	  round(((d.count::decimal / g.count::decimal) * 100),2) AS percentage
            	FROM snp_count g
            	INNER JOIN drugable_snp d
            		ON g.chromosome = d.chromosome
            	UNION ALL
            	SELECT 
            		g.chromosome AS chromosome,
            		g.count AS count,
            		'No' AS drugability,
            		(100 - round(((d.count::decimal / g.count::decimal) * 100), 2)) AS percentage
            	FROM snp_count g
            	INNER JOIN drugable_snp d
            		ON g.chromosome = d.chromosome;  "
        )
        
        stat_snp_data <- dbGetQuery(pool, query)
        
        ggplot(stat_snp_data, aes(x = reorder(chromosome, -count), y = log(count), fill = drugability)) +
          geom_col(width = 0.8) +
          geom_text(aes(label = percentage, vjust = -0.2),  position=position_stack(vjust=.5)) +
          labs(x= "Chromosome", y = "SNP Count (Log 10)") +
          theme(
            text = element_text(family= "Times New Roman", size=16, face="bold"),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("Drugable/NonDrugable SNP Percentage per Chromosome")
      }
      else if (input$plot == "targetDistributionPerDrug") {
        query <- sqlInterpolate(ANSI(), "
          WITH target AS (
              SELECT 
                COUNT(drug_protein_id) AS target_count, 
                drug_id
              FROM public.drug_protein
              WHERE drug_protein_type = 1
              GROUP BY drug_id
              ORDER BY target_count DESC
            )
            SELECT
              COUNT(drug_id) AS number_of_drugs, 
              target_count AS number_of_target
            FROM target
            WHERE target_count < 40
            GROUP BY number_of_target
            ORDER BY number_of_drugs DESC, number_of_target
        ")
        
        stat_target_data <- dbGetQuery(pool, query)
        
        ggplot(stat_target_data, aes(x = number_of_drugs, y = number_of_target)) +
          geom_point(alpha=0.8) +
          labs(x= "Drug Count" , y = "Target Count") +
          theme(
            text = element_text(family= "Times New Roman", size=14, face="bold"),
            title = element_text(family= "Times New Roman", size=14, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("Target Distribution per Drug") +
          scale_x_log10() + 
          scale_y_log10() +
          geom_smooth(method='lm') +
          stat_regline_equation(label.x = log10(10), label.y = log10(20)) +
          stat_regline_equation(label.x = log10(10), label.y = log10(18), aes(label = ..rr.label..))
        
      }
      else if (input$plot == "enzymeDistributionPerDrug") {
        query <- sqlInterpolate(ANSI(), "
            WITH enzyme AS (
                SELECT 
                COUNT(drug_protein_id) AS enzyme_count, 
                drug_id
                FROM public.drug_protein
                WHERE drug_protein_type = 2
                GROUP BY drug_id
                ORDER BY enzyme_count DESC
              )
              SELECT
              COUNT(drug_id) AS number_of_drugs, 
              enzyme_count AS number_of_enzyme
              FROM enzyme
              WHERE enzyme_count < 11
              GROUP BY number_of_enzyme
              ORDER BY number_of_drugs DESC, number_of_enzyme ")
        
        stat_enzyme_data <- dbGetQuery(pool, query)
        
        ggplot(stat_enzyme_data, aes(x = number_of_drugs, y = number_of_enzyme)) +
          geom_point(alpha=0.8) +
          labs(x= "Drug Count" , y = "Enzyme Count") +
          theme(
            text = element_text(family= "Times New Roman", size=14, face="bold"),
            title = element_text(family= "Times New Roman", size=14, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("Enzyme Distribution per Drug") +
          scale_x_log10() + 
          scale_y_log10() +
          geom_smooth(method='lm') +
          stat_regline_equation(label.x = log10(100), label.y = log10(8)) +
          stat_regline_equation(label.x = log10(100), label.y = log10(7), aes(label = ..rr.label..))
      }
      else if (input$plot == "carrierDistributionPerDrug") {
        query <- sqlInterpolate(ANSI(), "
              WITH carrier AS (
                SELECT 
                  COUNT(drug_protein_id) AS carrier_count, 
                  drug_id
                FROM public.drug_protein
                WHERE drug_protein_type = 3
                GROUP BY drug_id
                ORDER BY carrier_count DESC
              )
              SELECT
                COUNT(drug_id) AS number_of_drugs, 
                carrier_count AS number_of_carrier
              FROM carrier
              GROUP BY number_of_carrier
              ORDER BY number_of_drugs DESC, number_of_carrier       
        ")
        
        stat_carrier_data <- dbGetQuery(pool, query)
        
        ggplot(stat_carrier_data, aes(x = number_of_drugs, y = number_of_carrier)) +
          geom_point(alpha=0.8) +
          labs(x= "Drug Count" , y = "Carrier Count") +
          theme(
            text = element_text(family= "Times New Roman", size=14, face="bold"),
            title = element_text(family= "Times New Roman", size=14, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("Carrier Distribution per Drug") +
          scale_x_log10() + 
          scale_y_log10() +
          geom_smooth(method='lm') +
          stat_regline_equation(label.x = log10(10), label.y = log10(6)) +
          stat_regline_equation(label.x = log10(10), label.y = log10(5), aes(label = ..rr.label..))
      }
      else if (input$plot == "transporterDistributionPerDrug") {
        query <- sqlInterpolate(ANSI(), "
            WITH transporter AS (
                SELECT 
                  COUNT(drug_protein_id) AS transporter_count, 
                  drug_id
                FROM public.drug_protein
                WHERE drug_protein_type = 4
                GROUP BY drug_id
                ORDER BY transporter_count DESC
              )
              SELECT
                COUNT(drug_id) AS number_of_drugs, 
                transporter_count AS number_of_transporter
              FROM transporter
              GROUP BY number_of_transporter
              ORDER BY number_of_drugs DESC, number_of_transporter
        ")
        
        stat_transporter_data <- dbGetQuery(pool, query)
        
        ggplot(stat_transporter_data, aes(x = number_of_drugs, y = number_of_transporter)) +
          geom_point(alpha=0.8) +
          labs(x= "Drug Count" , y = "Transporter Count") +
          theme(
            text = element_text(family= "Times New Roman", size=14, face="bold"),
            title = element_text(family= "Times New Roman", size=14, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("Transporter Distribution per Drug") +
          scale_x_log10() + 
          scale_y_log10() +
          geom_smooth(method='lm') +
          stat_regline_equation(label.x = log10(10), label.y = log10(26)) +
          stat_regline_equation(label.x = log10(10), label.y = log10(23), aes(label = ..rr.label..))
      }
      else if (input$plot == "ddiDistributionperDrugCount"){
        query <- sqlInterpolate(ANSI(), "
        WITH ddi AS (
          SELECT 
          COUNT(*) AS ddi_count, 
          drug1_id
          FROM public.ddi
          WHERE severity = 'high'
          GROUP BY drug1_id
          ORDER BY ddi_count DESC
        )
        SELECT
        COUNT(drug1_id)::int AS number_of_drugs, 
        ddi_count::int AS number_of_ddi
        FROM ddi
        GROUP BY number_of_ddi
        ORDER BY number_of_drugs DESC, number_of_ddi" );
        
        stat_ddi_per_drug_data <- dbGetQuery(pool, query)
        
        ggplot(stat_ddi_per_drug_data, aes(x = number_of_drugs, y = number_of_ddi)) +
          geom_point(alpha=0.8) +
          labs(x= "Drug Count" , y = "Interaction Count") +
          theme(
            text = element_text(family= "Times New Roman", size=14, face="bold"),
            title = element_text(family= "Times New Roman", size=14, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("DDI Distribution per Drug") +
          scale_x_log10() + 
          scale_y_log10() +
          geom_smooth(method='lm') +
          stat_regline_equation(label.x = log10(7), label.y = log10(15)) +
          stat_regline_equation(label.x = log10(7), label.y = log10(13), aes(label = ..rr.label..))
      }
      else if (input$plot == "ddiSharingSameATCLevel"){
        query <- sqlInterpolate(ANSI(), " 
            WITH 
               ddi1 AS (WITH ddi AS (
                SELECT 
                COUNT(1) AS ddi_count
                FROM temp_ddi_same_atc1
                )
                SELECT
                  'level 1'::TEXT AS atc_level,
                  COUNT(1)::int AS number_of_same_atc, 
                  ddi_count::int AS number_of_ddi
                FROM temp_ddi_same_atc1, ddi
                WHERE drug1_atc = drug2_atc 
                group by ddi_count
              ),
              ddi2 AS (with ddi as (
                SELECT 
                COUNT(1) AS ddi_count
                FROM temp_ddi_same_atc2
                )
                SELECT
                'level 2'::TEXT AS atc_level,
                COUNT(1)::int AS number_of_same_atc, 
                ddi_count::int AS number_of_ddi
                FROM temp_ddi_same_atc2, ddi
                WHERE drug1_atc = drug2_atc 
                group by ddi_count
              ),
              ddi3 AS (
                with ddi as (
                SELECT 
                COUNT(1) AS ddi_count
                FROM temp_ddi_same_atc3
              )
              SELECT
                'level 3'::TEXT AS atc_level,
                COUNT(1)::int AS number_of_same_atc, 
                ddi_count::int AS number_of_ddi
              FROM temp_ddi_same_atc3, ddi
              WHERE drug1_atc = drug2_atc 
              group by ddi_count
              ),
              ddi4 AS (
              with ddi as (
                SELECT 
                COUNT(1) AS ddi_count
                FROM temp_ddi_same_atc4
              )
              SELECT
                'level 4'::TEXT AS atc_level,
                COUNT(1)::int AS number_of_same_atc, 
                ddi_count::int AS number_of_ddi
              FROM temp_ddi_same_atc4, ddi
              WHERE drug1_atc = drug2_atc 
              group by ddi_count
              )
            SELECT \"atc_level\", 'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi1
            UNION ALL
            SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi1
            UNION ALL
            SELECT \"atc_level\",  'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi2
            UNION ALL
            SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi2
            UNION ALL
            SELECT \"atc_level\", 'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi3
            UNION ALL
            SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi3
            UNION ALL
            SELECT \"atc_level\", 'Interaction(YES)' AS interaction, number_of_same_atc AS number_of_ddi FROM ddi4
            UNION ALL
            SELECT \"atc_level\", 'Interaction(NO)' AS interaction, (number_of_ddi- number_of_same_atc) AS number_of_ddi FROM ddi4
            " )
      
        stat_ddi_dist_per_atc <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_ddi_dist_per_atc, aes(fill=interaction, y=number_of_ddi, x=atc_level)) + 
          geom_col(width = 0.5) +
          labs(x= "ATC Level" , y = "Interaction Count", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("DDI Distribution per ATC Level")
        
      }
      else if (input$plot == "ddiDistributionperATCLevel1"){
        query <- sqlInterpolate(ANSI(), "
          WITH most_interacted_drugs AS 
              (
              	SELECT 
              		drug1_id AS drug_id, 
              		COUNT(1) AS cnt
              	FROM public.ddi
              	GROUP BY drug1_id
              	ORDER BY cnt DESC
              )
              SELECT 
              	COUNT(1)::int AS cnt, 
              	code_4, 
              	level_4
              FROM most_interacted_drugs mid
              INNER JOIN drug_atc_codes atc
              	ON mid.drug_id = atc.\"drugbank-id\"
              GROUP BY code_4, level_4
              ORDER BY cnt DESC
              LIMIT 10
        ")
        
        stat_ddi_dist_same_atc1 <- dbGetQuery(pool, query)
        theme_set(theme_bw())
        
        ggplot(stat_ddi_dist_same_atc1, aes(x = reorder(code_4, -cnt), y = cnt, fill = reorder(level_4, -cnt))) +
          geom_col(width = 0.6) +
          labs(x= "ATC 1" , y = "DDI Count", fill = "") +
          theme(
            text = element_text(size=12),
            title = element_text(family= "Times New Roman", size=12, face="bold"),
            legend.position = "bottom",
            legend.direction = "vertical",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("ATC Level 1") 
  
      }
      else if (input$plot == "ddiDistributionperATCLevel2"){
        query <- sqlInterpolate(ANSI(), "
             WITH most_interacted_drugs AS 
            (
            	SELECT 
            		drug1_id AS drug_id, 
            		COUNT(1) AS cnt
            	FROM public.ddi
            	GROUP BY drug1_id
            	ORDER BY cnt DESC
            )
            SELECT 
            	COUNT(1)::int AS cnt, 
            	code_3, 
            	level_3
            FROM most_interacted_drugs mid
            INNER JOIN drug_atc_codes atc
            	ON mid.drug_id = atc.\"drugbank-id\"
            GROUP BY code_3, level_3
            ORDER BY cnt DESC
            LIMIT 10
        ")
        
        stat_ddi_dist_same_atc2 <- dbGetQuery(pool, query)
        theme_set(theme_bw())
      
        ggplot(stat_ddi_dist_same_atc2, aes(x = reorder(code_3, -cnt), y = cnt, fill = reorder(level_3, -cnt))) +
          geom_col(width = 0.6) +
          labs(x= "ATC 2" , y = "DDI Count", fill = "") +
          theme(
            text = element_text(size=12),
            title = element_text(family= "Times New Roman", size=12, face="bold"),
            legend.position = "bottom",
            legend.direction = "vertical",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("ATC Level 2")
      }
      else if (input$plot == "ddiDistributionperATCLevel3"){
        query <- sqlInterpolate(ANSI(), "
          WITH most_interacted_drugs AS 
            (
            	SELECT 
            		drug1_id AS drug_id, 
            		COUNT(1) AS cnt
            	FROM public.ddi
            	GROUP BY drug1_id
            	ORDER BY cnt DESC
            )
            SELECT 
            	COUNT(1)::int AS cnt, 
            	code_2, 
            	level_2
            FROM most_interacted_drugs mid
            INNER JOIN drug_atc_codes atc
            	ON mid.drug_id = atc.\"drugbank-id\"
            GROUP BY code_2, level_2
            ORDER BY cnt DESC
            LIMIT 10
        ")
        
        stat_ddi_dist_same_atc3 <- dbGetQuery(pool, query)
        theme_set(theme_bw())
        
        ggplot(stat_ddi_dist_same_atc3, aes(x = reorder(code_2, -cnt), y = cnt, fill = reorder(level_2, -cnt))) +
          geom_col(width = 0.6) +
          labs(x= "ATC 3" , y = "DDI Count", fill = "") +
          theme(
            text = element_text(size=12),
            title = element_text(family= "Times New Roman", size=12, face="bold"),
            legend.position = "bottom",
            legend.direction = "vertical",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("ATC Level 3")
      }
      else if (input$plot == "ddiDistributionperATCLevel4"){
        query <- sqlInterpolate(ANSI(), "
             WITH most_interacted_drugs AS 
            (
            	SELECT 
            		drug1_id AS drug_id, 
            		COUNT(1) AS cnt
            	FROM public.ddi
            	GROUP BY drug1_id
            	ORDER BY cnt DESC
            )
            SELECT 
            	COUNT(1)::int AS cnt, 
            	code_1, 
            	level_1
            FROM most_interacted_drugs mid
            INNER JOIN drug_atc_codes atc
            	ON mid.drug_id = atc.\"drugbank-id\"
            GROUP BY code_1, level_1
            ORDER BY cnt DESC
            LIMIT 10
        ")
        
        stat_ddi_dist_same_atc4 <- dbGetQuery(pool, query)
        theme_set(theme_bw())
        
        ggplot(stat_ddi_dist_same_atc4, aes(x = reorder(code_1, -cnt), y = cnt, fill = reorder(level_1, -cnt))) +
          geom_col(width = 0.6) +
          labs(x= "ATC 4" , y = "DDI Count", fill = "") +
          theme(
            text = element_text(size=12),
            title = element_text(family= "Times New Roman", size=12, face="bold"),
            legend.position = "bottom",
            legend.direction = "vertical",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("ATC Level 4")
   
      }
      else if (input$plot == "ddiDistributionperDrugProtein"){ 
      
        query <- sqlInterpolate(ANSI(), " 
                WITH ddi_same_drug_protein AS (
                  SELECT 
                    COUNT(*) AS ddi_count, 
                    drug_protein_id
                  FROM public.ddi_same_drug_protein 
                  WHERE severity = 'high'
                  GROUP BY drug_protein_id
                  ORDER BY ddi_count DESC
                )
                SELECT
                  COUNT(drug_protein_id)::int AS number_of_protein, 
                  ddi_count::int AS number_of_ddi
                FROM ddi_same_drug_protein
                GROUP BY number_of_ddi  
                ORDER BY number_of_protein DESC, number_of_ddi"
        )
        
        stat_ddi_per_protein_data <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_ddi_per_protein_data, aes(x = number_of_protein, y = number_of_ddi)) +
          geom_point(alpha=0.8) +
          labs(x = "Protein Count", y= "Interaction Count") +
          theme(
            text = element_text(family= "Times New Roman", size=14, face="bold"),
            title = element_text(family= "Times New Roman", size=14, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=16, face="bold", hjust = 0.5)) +
          ggtitle("DDI Distribution per Drug-Protein") +
          scale_x_log10() + 
          scale_y_log10() +
          geom_smooth(method='lm') +
          stat_regline_equation(label.x = log10(5), label.y = log10(30)) +
          stat_regline_equation(label.x = log10(5), label.y = log10(20), aes(label = ..rr.label..))
        
        
      }
      else if (input$plot == "ddiDistributionperSharingSameDrugProtein"){
        query <- sqlInterpolate(ANSI(), " 
              SELECT 'Target' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage
              	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(1)
              UNION ALL
              SELECT 'Target' AS protein_type, 'Different Drug-Protein' AS protein_sharing, (100- final_percentage) AS percentage 
              	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(1)
              UNION ALL
              SELECT 'Enzyme' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage
              	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(2)
              UNION ALL
              SELECT 'Enzyme' AS protein_type, 'Different Drug-Protein' AS protein_sharing,  (100- final_percentage) AS percentage
              	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(2)
              UNION ALL
              SELECT 'Carrier' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage 
              	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(3)	
              UNION ALL
              SELECT 'Carrier' AS protein_type, 'Different Drug-Protein' AS protein_sharing, (100- final_percentage) AS percentage 
              	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(3)	
              UNION ALL
              SELECT 'Transporter' AS protein_type, 'Same Drug-Protein' AS protein_sharing, final_percentage AS percentage
              FROM public.calculate_shared_protein_percentage_of_interacted_drugs(4)
              UNION ALL
              SELECT 'Transporter' AS protein_type, 'Different Drug-Protein' AS protein_sharing, (100- final_percentage) AS percentage  
              	FROM public.calculate_shared_protein_percentage_of_interacted_drugs(4)
        ")
        
        stat_ddi_per_same_protein_data <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_ddi_per_same_protein_data, aes(fill=protein_sharing, y=percentage, x=protein_type)) + 
          geom_col(width = 0.5) +
          labs(x= "Protein Type" , y = "Percentage", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("DDI Percentages per Sharing Same Drug-Protein")
      }
      else if (input$plot == "Numbers"){
        
        query <- sqlInterpolate(ANSI(), " 
                  SELECT 
                  	'DDI' AS entity_name, 
                  	COUNT(1) AS count 
                  FROM public.ddi
                  UNION ALL
                  SELECT 
                  	'Drug' AS entity_name, 
                  	COUNT(1) AS count 
                  FROM public.drug
                  UNION ALL
                  SELECT 
                  	'DDI' AS entity_name, 
                  	COUNT(1) AS count 
                  FROM public.ddi
                  UNION ALL
                  SELECT 
                  	'Disease' AS entity_name, 
                  	COUNT(1) AS count 
                  FROM public.disease ");
        
        stat_total_numbers_data <- dbGetQuery(pool, query)
        
        theme_set(theme_bw())
        
        ggplot(stat_total_numbers_data, aes(y=count, x=entity_name)) + 
          geom_col(width = 0.5) +
          labs(x= "Entity" , y = "Count", fill = "") +
          theme(
            text = element_text(family= "Times New Roman", size=16),
            title = element_text(family= "Times New Roman", size=16, face="bold"),
            legend.position = "bottom",
            legend.direction = "horizontal",
            plot.title = element_text(family= "Times New Roman", size=18, face="bold", hjust = 0.5)) +
          ggtitle("DDI Percentages per Sharing Same Drug-Protein")
        
      }
    })
    
##############STATISTICS END###################
    

##############DOWNLOAD BEGIN###################

    query <- sqlInterpolate(ANSI(), "SELECT * FROM public.drug;")
    Drug <- dbGetQuery(pool, query)
      
    query <- sqlInterpolate(ANSI(), "SELECT * FROM public.gene;")
    Gene <- dbGetQuery(pool, query)
    
    query <- sqlInterpolate(ANSI(), "SELECT * FROM public.snp;")
    SNP <- dbGetQuery(pool, query)
  
    query <- sqlInterpolate(ANSI(), "SELECT * FROM public.ddi;")
    DDI <- dbGetQuery(pool, query)
    
    query <- sqlInterpolate(ANSI(), "SELECT * FROM public.drug_protein;")
    DGI <- dbGetQuery(pool, query)
    
    query <- sqlInterpolate(ANSI(), "SELECT * FROM public.ddi_same_drug_protein;")
    DDGI <- dbGetQuery(pool, query)
    
    # Reactive value for selected dataset ----
    datasetInput <- reactive({
      switch(input$dataset,
             "Drug" = Drug,
             "Gene" = Gene,
             "SNP" = SNP,
             "DDI" = DDI,
             "DGI" = DGI,
             "DDI-Having Same Drug Protein" = DDGI)
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