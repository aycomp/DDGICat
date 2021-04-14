library(shiny)

shinyUI(fluidPage(
  navbarPage("DDGICat Browser",
    tabPanel("Drug",
      sidebarLayout(
        sidebarPanel(width=2,
          conditionalPanel(condition= "input.tabsDrug == 'Table'",
            textInput("nameDrug", "Please enter drug name", value=""),
            selectInput("statusDrug", 
                        "Plese select drug approval status", 
                        c("approved", "experimental", "illicit", "investigational", "nutraceutical", "vet_approved", "withdrawn"), ""),
            radioButtons("typeDrug", "Please select the drug type", c("small molecule", "biotech"), "small molecule"),
            radioButtons("stateDrug", "Please select the drug state", c("liquid", "solid", "gas", "-"), "solid")),
          conditionalPanel(condition= "input.tabsDrug == 'Plot'",
            selectInput("plotDrug", "Plese select plot type", 
                      c("Drug Status" = "group", "Drug Type" = "type", "Drug State" = "state"), ""))),
    
        mainPanel(
         tabsetPanel(id="tabsDrug",
                     tabPanel("Table",
                              DT::dataTableOutput("tableDrug")),
                     tabPanel("Plot", 
                              plotOutput("plotDrug"))))),
            ),
    tabPanel("Gene",
           sidebarLayout(
             sidebarPanel(width=2,
               conditionalPanel(condition= "input.tabsGene == 'Table'",
                  textInput("nameGene", "Please enter gene name", value="")),
               conditionalPanel(condition= "input.tabsGene == 'Plot'",
                  selectInput("plotGene", "Plese select plot type", 
                      c("Chromosome" = "chr"), ""))),
             
             mainPanel(
               tabsetPanel(id="tabsGene",
                           tabPanel("Table",
                                    DT::dataTableOutput("tableGene")),
                           tabPanel("Plot", 
                                    plotOutput("plotGene"))))),           
            ),
    tabPanel("SNP",
             sidebarLayout(
               sidebarPanel(width=2,
                conditionalPanel(condition= "input.tabsSnp == 'Table'",
                  textInput("nameSnp", "Please enter SNP name", value="")),
                conditionalPanel(condition= "input.tabsSnp == 'Plot'",
                   selectInput("plotSnp", "Plese select plot type", 
                               c("Chromosome" = "chr")))),
               
               mainPanel(
                 tabsetPanel(id="tabsSnp",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableSnp")),
                             tabPanel("Plot", 
                                      plotOutput("plotSnp")))))          
          ),
    tabPanel("DDI",
             sidebarLayout(
               sidebarPanel(width=2,
                  conditionalPanel(condition= "input.tabsDdi == 'Table'",
                      textInput("nameDrug1", "Please enter Drug1 name", value=""),
                      textInput("nameDrug2", "Please enter Drug2 name", value="")),
                  conditionalPanel(condition= "input.tabsDdi == 'Plot'",
                       selectInput("plotDdi", "Plese select plot type", 
                                   c("Drug Count" = "drug", "ATC Level" = "atc", "Severity" = "severity")))),
   
               mainPanel(
                 tabsetPanel(id="tabsDdi",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableDdi")),
                             tabPanel("Plot", 
                                      plotOutput("plotDdi")))))        
          ),
    tabPanel("DGI",
             sidebarLayout(
               sidebarPanel(width=2,
                  conditionalPanel(condition= "input.tabsDgi == 'Table'",
                      textInput("nameDgiDrug", "Please enter Drug name", value=""),
                      textInput("nameDgiGen", "Please enter protein name", value="")),
                  conditionalPanel(condition= "input.tabsDgi == 'Plot'",
                       selectInput("plotDgi", "Plese select plot type", 
                                   c("Gene" = "gene", "Protein Type" = "protein_type")))),
             
               
               mainPanel(
                 tabsetPanel(id="tabsDgi",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableDgi")),
                             tabPanel("Plot", 
                                      plotOutput("plotDgi")))))        
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
                             tabPanel("Plot", 
                                      plotOutput("histDDGI")))))        
    ),
    tabPanel("Statistics",
             sidebarLayout(
               sidebarPanel(width=2,
                            radioButtons("statisticId", "Please select the statistic type", 
                                         c("Drug Type and Group" = "0",
                                           "#Gene per Chromosome" = "1",
                                           "#SNP per Gene" = "2",
                                           "#SNP per Chromosome" = "3",
                                           "Druggable Gene per Drug" = "4",
                                           "Drugable Gene per Chromosome" = "5",
                                           "DDI Classification" = "6",
                                           "#DDI per Drug" = "7",
                                           "# Protein per Drug" = "8",
                                           "# Protein per Drug" = "9",
                                           "# DDI having same protein" = "10"
                                          ), "")
               ),
               
               mainPanel(
                 tabsetPanel(type="tab",
                             tabPanel("Plot", 
                                      plotOutput("plotStat")))))        
    )   
  )
))