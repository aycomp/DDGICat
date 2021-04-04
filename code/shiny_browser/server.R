library(shiny)

shinyServer(
  function(input, output){
    output$searchCriteria <- renderText(input$searchCriteria)
    
  }
  
)