require(pacman)
p_load(shiny, readxl, visNetwork,
       igraph, data.table, scales,
       shinyjs, shinythemes, RColorBrewer,
       DT, V8, tidyverse,
       shinydashboard, dplyr)

jsResetCode <- "shinyjs.reset = function() {history.go(0)}"

shinyUI(fluidPage(
  theme = shinytheme("paper"),
  navbarPage("Network Explorer Version",
             tabPanel("Data Import",
                      br(),br(),
                      tags$head(
                        tags$style(HTML("
                                        @import url('//fonts.googleapis.com/css?family=Fjalla One|Cabin:400,700');
                                        h1 {
                                        font-family: 'Arial';
                                        text-align:center;
                                        font-weight: 250;
                                        line-height: 1.1;
                                        color: #33686f;
                                        }
                                        
                                        "))
                        ),
                      fluidRow(
                        br(),br(),br(),
                        shiny::column(width=8,
                                      offset = 2,
                                      h5("Instructions"),
                                      br(),
                                      p(HTML(paste0("First import a list of ships with MMSI and associated companies. Then import loitering table, which must include loitering ships (identified by MMSI) and loitering polygon. If you do not have a sample of these formats, you may download a sample list of ships", a(href='https://github.com/NPSCORELAB/COREmaritime/blob/master/data/Edgelist_Master.xlsx', " here "), "and a loitering spread sheet", a(href='https://github.com/NPSCORELAB/COREmaritime/blob/master/data/Jan_Isos99.csv'," here "), ".", sep=" "))),
                                      br(),
                                      column(width=12,
                                             align = "center",
                                             fileInput("links1",
                                                       "Upload a list of MMSIs and companies",
                                                       #accept = c(".csv"),
                                                       buttonLabel = "Browse",
                                                       placeholder = "No file selected"
                                                       ),
                                             br(),
                                             fileInput("links2",
                                                       
                                                       "Upload a list of MMSIs and companies",
                                                       accept = c(".csv"),
                                                       buttonLabel = "Browse",
                                                       placeholder = "No file selected"
                                                       ),
                                             br(),
                                             useShinyjs(),
                                             extendShinyjs(text = jsResetCode),
                                             actionButton("reset_button", "Reset Application")
                                             )
                                    )
                      ),
                      mainPanel() #nothing goes here
                        ),
             tabPanel("Boats and Areas",
                      mainPanel(
                        tabsetPanel(
                          tabPanel("Network", bootstrapPage(
                            tags$head(tags$style("#network{height:85vh !important;}")), #renders the Network output as 85% of the screen
                            visNetworkOutput("network")
                          )
                          ),
                          tabPanel("Data", DT::dataTableOutput("table"))
                        ),
                        width = 12
                      ) #mainPanel ends
                      # ) #sidebarLayout ends
             ),# tabPanel "Network" ends
             tabPanel("Coloitering Ships", 
                      mainPanel(
                        tabsetPanel(
                          #tabPanel("Network", visNetworkOutput("network2", height = "700px", width = "100%")
                          tabPanel("Network", bootstrapPage(
                            tags$head(tags$style("#network2{height:85vh !important;}")), #renders the Network output as 85% of the screen
                            absolutePanel(top = "30%", right = "20%", width = "20%", draggable = TRUE,
                                          selectInput("measure2", "Choose a measure for sizing:", choices = c("None",
                                                                                                              "Degree",
                                                                                                              "Betweenness")),
                                          style = "opacity: 0.85; z-index: 1000;"
                                          
                            ),
                            visNetworkOutput("network2")
                          )
                          ),
                          tabPanel("Data", DT::dataTableOutput("table2"))
                        ),
                        width = 12
                      ) #mainPanel ends
                      # ) #sidebarLayout ends
             ),# tabPanel "Coloitering Ships" ends
             tabPanel("Coorporates",
                      mainPanel(
                        tabsetPanel(
                          tabPanel("Network", bootstrapPage(
                            tags$head(tags$style("#network3{height:85vh !important;}")), #renders the Network output as 85% of the screen
                            absolutePanel(top = "30%", right = "20%", width = "20%", draggable = TRUE,
                                          selectInput("measure3", "Choose a measure for sizing:", choices = c("None",
                                                                                                              "Degree",
                                                                                                              "Betweenness")),
                                          style = "opacity: 0.85; z-index: 1000;"
                                          
                            ),
                            visNetworkOutput("network3")
                          )
                          ),
                          tabPanel("Data", DT::dataTableOutput("table3"))
                        ),
                        width = 12
                      ) #mainPanel ends
                      # ) #sidebarLayout ends
             ) # tabPanel "Coloitering Ships" ends
             ,
             tabPanel("Downloads",
                      fluidPage(
                        shiny::column(width=8,
                                      offset = 2,
                                      h3("Instructions"),
                                      p("In this section you will be able to download HTML widgets for all the networks generated in this applications. Please take note that all dynamic capabilities (e.g., dynamic sizing) will not be available in these downloads."),
                                      hr(),
                                      br(),
                                      column(12,
                                             column(4,
                                                    h5("Download Boats and Areas Network:"),
                                                    shiny::downloadButton("download_mmsixpol",
                                                                          label = "Download")),
                                             column(4,
                                                    h5("Download Ship Coloitering Network:"),
                                                    shiny::downloadButton("download_sxs",
                                                                          label = "Download")),
                                             column(4,
                                                    h5("Download Coorporates Network:"),
                                                    shiny::downloadButton("download_cxc",
                                                                          label = "Download"))
                                             ))
                      ))
                        ) # navbarPage ends
             )
  )
