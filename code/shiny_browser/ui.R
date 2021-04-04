library(shiny)

shinyUI(fluidPage(
  titlePanel(title=h3("DDGICat Browser")),
  sidebarLayout(
    sidebarPanel(
      selectInput("searchCriteria", 
                  "Plese select the search option", 
                  c("Search by Drug", "Search by Gene", "Search by SNP"))
    ),
    mainPanel(
      textOutput("searchCriteria")
    )
  )
))