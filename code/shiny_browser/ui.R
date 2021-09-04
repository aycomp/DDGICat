library(shiny)

shinyUI(fluidPage(
  navbarPage("DDGICat Browser",
    tabPanel("Drug",
      sidebarLayout(
        sidebarPanel(width=2,
            textInput("nameDrug", "Please enter drug name", value=""),
            selectInput("statusDrug", 
                        "Plese select drug approval status", 
                        c("all", "approved", "experimental", "illicit", "investigational", "nutraceutical", "vet_approved", "withdrawn"), "all"),
            radioButtons("typeDrug", "Please select the drug type", c("all", "small molecule", "biotech"), "all")),
    fluidRow(
        mainPanel(  DT::dataTableOutput("tableDrug")))),
            ),
    tabPanel("Gene",
           sidebarLayout(
             sidebarPanel(width=2,
                  textInput("nameGene", "Please enter gene name", value="")),
             
             mainPanel(DT::dataTableOutput("tableGene"))),      
            ),
    tabPanel("SNP",
             sidebarLayout(
               sidebarPanel(width=2,
                  textInput("nameSnp", "Please enter SNP name", value="")),
               
               mainPanel(DT::dataTableOutput("tableSnp")))          
          ),
    tabPanel("DDI",
             sidebarLayout(
               sidebarPanel(width=2,
                      textInput("nameDrug1", "Please enter Drug1 name", value=""),
                      textInput("nameDrug2", "Please enter Drug2 name", value=""),
                      selectInput("severity", "Plese select severity level", 
                                  c("all" = "", "high" = "high", "CI" = "CI", "P" = "P", "CI,P" = "CI,P"), "")),
               
               mainPanel(DT::dataTableOutput("tableDdi")))
             ),
    tabPanel("DGI",
             sidebarLayout(
               sidebarPanel(width=2,
                      textInput("nameDgiDrug", "Please Enter Drug Name", value=""),
                      selectInput("proteinType", "Plese Select Drug Protein Type", 
                                  c("all" = "1,2,3,4", "Target" = "1", "Enzyme" = "2", "Transporter" = "3", "Carrier" = "4"), ""),
                      textInput("nameDgiGen", "Please Enter Gene Name", value="")),
               
               mainPanel(DT::dataTableOutput("tableDgi")))
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
               mainPanel(DT::dataTableOutput("tableDdgi")))      
    ),
    tabPanel("Statistics",
             sidebarLayout(
               sidebarPanel(width=2,
                            selectInput("entityId", "Plese Select Entity", 
                                        c("Drug", "Gene", "SNP", "DDI", "DDGI"), ""),
                            
                            selectInput("plot", "Plese Select Plot", ""),
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
                               choices = c("Drug", "Gene", "SNP","DDI", "DGI", "DDI-Having Same Drug Protein")),
                   
                   # Button
                   downloadButton("downloadData", "Download")
               ),
               
               mainPanel(
                 tableOutput("table"))) 
    )
  )
))