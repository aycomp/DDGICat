library(shiny)

shinyServer(
  function(input, output, session){
    #output$searchCriteria <- renderText(input$searchCriteria)
    #output$searchKey <- renderText(input$searchKey)
    #output$drugStatus <- renderText(input$drugStatus)
    
    
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
    
    output$histDrug <- renderPlot({
      query <- sqlInterpolate(ANSI(), "SELECT count(*) FROM drug")
      print(query)
      drug_data <- dbGetQuery(pool, query)
      
      plot(drug_data)
    })
    
  })