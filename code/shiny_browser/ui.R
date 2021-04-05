library(shiny)

shinyUI(fluidPage(
  navbarPage("DDGICat Browser",
    tabPanel("Drug",
      sidebarLayout(
        sidebarPanel(width=2,
          textInput("nameDrug", "Please enter drug name", value=""),
          selectInput("statusDrug", 
                      "Plese select drug approval status", 
                      c("approved", "experimental", "illicit", "investigational", "nutraceutical", "vet_approved", "withdrawn"), ""),
          radioButtons("typeDrug", "Please select the drug type", c("small molecule", "biotech"), "small molecule")
        ),
    
        mainPanel(
         tabsetPanel(type="tab",
                     tabPanel("Table",
                              DT::dataTableOutput("tableDrug")),
                     tabPanel("Summary"),
                     tabPanel("Plot", 
                              plotOutput("histDrug")),
                     tabPanel("Statistics")))
     
                    ),
            ),
    tabPanel("Gene",
           sidebarLayout(
             sidebarPanel(width=2,
                          textInput("nameGene", "Please enter gene name", value="")
             ),
             
             mainPanel(
               tabsetPanel(type="tab",
                           tabPanel("Table",
                                    DT::dataTableOutput("tableGene")),
                           tabPanel("Summary"),
                           tabPanel("Plot", 
                                    plotOutput("histGene")),
                           tabPanel("Statistics")))
             
           ),           
            ),
    tabPanel("SNP",
             sidebarLayout(
               sidebarPanel(width=2,
                            textInput("nameSNP", "Please enter SNP name", value="")
               ),
               
               mainPanel(
                 tabsetPanel(type="tab",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableSNP")),
                             tabPanel("Summary"),
                             tabPanel("Plot", 
                                      plotOutput("histSNP")),
                             tabPanel("Statistics"))))          
          ),
    tabPanel("DDI",
             sidebarLayout(
               sidebarPanel(width=2,
                            textInput("nameDrug1", "Please enter Drug1 name", value=""),
                            textInput("nameDrug2", "Please enter Drug2 name", value="")
               ),
               
               mainPanel(
                 tabsetPanel(type="tab",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableDDI")),
                             tabPanel("Summary"),
                             tabPanel("Plot", 
                                      plotOutput("histDDI")),
                             tabPanel("Statistics"))))        
          ),
    tabPanel("DGI",
             sidebarLayout(
               sidebarPanel(width=2,
                            textInput("nameDgiDrug", "Please enter Drug name", value=""),
                            textInput("nameDgiGen", "Please enter protein name", value="")
               ),
               
               mainPanel(
                 tabsetPanel(type="tab",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableDGI")),
                             tabPanel("Summary"),
                             tabPanel("Plot", 
                                      plotOutput("histDGI")),
                             tabPanel("Statistics"))))        
    ),
    tabPanel("DDGI",
             sidebarLayout(
               sidebarPanel(width=2,
                            textInput("nameDdgiDrug1", "Please enter Drug1 name", value=""),
                            textInput("nameDdgiDrug2", "Please enter Drug2 name", value=""),
                            textInput("nameDdgiGen", "Please enter protein name", value="")
               ),
               
               mainPanel(
                 tabsetPanel(type="tab",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableDDGI")),
                             tabPanel("Summary"),
                             tabPanel("Plot", 
                                      plotOutput("histDDGI")),
                             tabPanel("Statistics"))))        
    )      
  )
))