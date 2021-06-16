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
            radioButtons("typeDrug", "Please select the drug type", c("small molecule", "biotech"), "small molecule")),
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
                      textInput("nameDrug2", "Please enter Drug2 name", value=""),
                      selectInput("severity", "Plese select severity level", 
                                  c("all" = "", "high" = "high", "CI" = "CI", "P" = "P", "CI,P" = "CI,P"), "")),
                  conditionalPanel(condition= "input.tabsDdi == 'Plot'",
                       selectInput("plotDdi", "Plese select plot type", 
                                   c("Drug Count" = "drug", "ATC Level" = "atc", "Severity" = "severity")))),
               mainPanel(
                 tabsetPanel(id="tabsDdi",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableDdi")),
                             tabPanel("Plot", 
                                      plotOutput("plotDdi")))))),
    tabPanel("DGI",
             sidebarLayout(
               sidebarPanel(width=2,
                  conditionalPanel(condition= "input.tabsDgi == 'Table'",
                      textInput("nameDgiDrug", "Please Enter Drug Name", value=""),
                      selectInput("proteinType", "Plese Select Drug Protein Type", 
                                  c("all" = "1,2,3,4", "Target" = "1", "Enzyme" = "2", "Transporter" = "3", "Carrier" = "4"), ""),
                      textInput("nameDgiGen", "Please Enter Gene Name", value="")),
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
                            selectInput("disease", "Plese select a disease", "Asthma"),
                            selectInput("drug1", "Plese select drug 1", ""),
                            selectInput("drug2", "Plese select drug 2", ""),
                            radioButtons("intersectionSet", "Shared", 
                                         c("Chromosome" = "0",
                                           "Gene" = "1",
                                           "Protein" = "2",
                                           "SNP" = "3"
                                         ), "1")
                            ),
               mainPanel(
                 tabsetPanel(type="tab",
                             tabPanel("Table",
                                      DT::dataTableOutput("tableDdgi")),
                             tabPanel("Plot", 
                                      plotOutput("plotDdgi")))))        
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
    ),
    tabPanel("Downloads",
             sidebarLayout(
               sidebarPanel(width=2,
                   # Input: Choose dataset ----
                   selectInput("dataset", "Choose a dataset:",
                               choices = c("Drug", "Gene", "SNP","DDI", "DGI", "DDGI")),
                   
                   # Button
                   downloadButton("downloadData", "Download")
               ),
               
               mainPanel(
                 tableOutput("table"))) 
    )
  )
))