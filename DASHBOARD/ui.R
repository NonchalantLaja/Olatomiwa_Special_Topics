library(shiny)
library(shinydashboard)



############################################################################# RUN THIS CHUNK FIRST

# Changing the working directory to the source file location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Dataset 1
data <- read.csv('data/sp500_All_alt.csv')
data$Date = as.Date(data$Date)

# Dataset 2
data2 <- read.csv('data/sp500_new2.csv')

comp_names <- unique(data2$Company)

############################################################################## RUN THIS CHUNK FIRST

# Defining the UI for the application
shinyUI(
  dashboardPage( title = "Stock Dashboard",  skin = "black",
    
    dashboardHeader(title = "S&P 500 Dashboard",
                    
                     dropdownMenu(type = "message", 
                                 messageItem(from = "Update", message = "Progress Saved", time = "21:21"),
                                 messageItem(from = "Charts", message = "Multiple Chart Options", icon = icon("bar-chart"), time = "29-08-2019")
                                 ),
                    dropdownMenu(type = "notifications", 
                                 notificationItem(text = "New menu items added", icon = icon("dashboard"), status = "success"),
                                 notificationItem(text = "S & P 500 Loading...", icon = icon("warning"), status = "warning")
                                 ),
                    dropdownMenu(type = "tasks", 
                                 taskItem(value = 60, color = "red", "Overall Dashboard Completion"),
                                 taskItem(value = 75, color = "green", "Overall UI Completion"),
                                 taskItem(value = 60, color = "aqua", "Automation")
                                )
                    
                    
                    
                    ),
    
    
    dashboardSidebar(
      
      sidebarMenu(
        
        sidebarSearchForm("searchTest", "buttonSearch", "Search..."),
        
      menuItem("Visualizations", tabName = "Visualizations", icon = icon("image"), badgeLabel = "new", badgeColor = "green"),
      
      menuItem("Detailed Analysis", tabname = "Detailed", icon = icon("bar-chart"),
               
        # menuSubItem("Extreme value Theory", tabName = "EVT", icon = icon("line-chart")),
        # menuSubItem("Artificial Neural network", tabName = "ANN", icon = icon("clone")),
        # menuSubItem("Model", tabName = "model", icon = icon("cogs"))
        
        menuSubItem("Individual Summaries", tabName = "S", icon = icon("line-chart")),
        menuSubItem("Correlations", tabName = "C", icon = icon("clone")),
        menuSubItem("Descriptions", tabName = "D", icon = icon("cogs"))
        
        ),
      
      menuItem("Raw Data", tabName = "Raw", icon = icon("id-card"), badgeLabel = "new", badgeColor = "green")
      
      #menuItem("Project Proposal", tabName = "pdf", icon = icon("clone"), badgeLabel = "new", badgeColor = "red"),
      
      #radioButtons("comp", "Choose Company", choices = c("AMZN", "TWTR", "PYPL" ), inline = T),
      
      #textInput("text_input", "Search Company Name", value = "TWTR")
    
      )
    
    ),
    
    dashboardBody(
      tabItems(
        tabItem(tabName = "Visualizations",
                
                fluidRow(
                  column(width = 12,
                  valueBox(505, "Companies Involved", icon = icon("info-circle"), color = "green"),
                  valueBoxOutput("chosen"),
                  valueBox("Standard & Poor", "The two founding financial companies", icon = icon("question-circle"), color = "yellow")
                  )
                ),
                
                fluidRow(
                  box(title = "Volume Plot of TWTR", status = "primary" , solidHeader = T, plotOutput("volume")),
                  box(title = "Adj Close Plot of TWTR", status = "primary", solidHeader = T, plotOutput("close"))
                        ),
                
                fluidRow(
                  tabBox(
                    tabPanel(title = "Adj Close Plot of AMZN", status = "warning", solidHeader = T, plotOutput("close2")),
                    tabPanel(title = "Another Adj Close Plot", status = "warning", solidHeader = T, plotOutput("close3"))
                  ),
                  tabBox(
                    tabPanel(title = "Choose",
                    selectInput("choose_plot",h2("Select Company to Plot"), choices = comp_names, selected = comp_names[1])),
                    tabPanel(title = "Plot type 1", status = "primary", solidHeader = T, plotOutput("type1"), downloadButton("download_type1", "Download Plot")),
                    tabPanel(title = "Plot type 2", status = "secondary", solidHeader = T, plotOutput("type2"), downloadButton("download_type2", "Download Plot")),
                    tabPanel(title = "Plot type 3", status = "warning", solidHeader = T, plotOutput("type3"), downloadButton("download_type3", "Download Plot"))
                  )
                )
                ),
        tabItem(tabname = "Detailed", h1("Detailed Analysis")
                
        
        ),
        # tabItem(tabName = "EVT", h1("Extreme Value Theory"),
        #         fluidRow(
        #           box(title = "EVT Distributions", status = "primary" , solidHeader = T, 
        #               img(src = 'distribution.png', width = 500, height = 500)
        #               ),
        #           box(
        #             h1("EVT can be classified into 3 major distributions, as the image illustrates"), br(),
        #             h1("By choosing the best distribution that fits the data"), br(),
        #             h1("Frechet, Gumbell and Weibull distributions ensures that the non normally distributed data is properly analysed")
        #           )
        #         )
        # ),
        # tabItem(tabName = "ANN", h1("Artificial Neural Network")
        #         
        # ),
        # tabItem(tabName = "model", h1("Model")
        #         
        # ),
        tabItem(tabName = "S", h1("Individual Summary"),
                selectInput("choose_S",h2("Select Company"), choices = comp_names, selected = comp_names[1]),
                verbatimTextOutput("S"),  
                downloadButton("download_S", "Download Individual Summary")
        ),
        tabItem(tabName = "C", h1("Correlation"),
                selectInput("choose_C",h2("Select Company"), choices = comp_names, selected = comp_names[1]),
                verbatimTextOutput("C"),  
                downloadButton("download_C", "Download Correlation")
        ),
        tabItem(tabName = "D", h1("Description"),
                selectInput("choose_D",h2("Select Company"), choices = comp_names, selected = comp_names[1]),
                verbatimTextOutput("D"),  
                downloadButton("download_D", "Download Description")
        ),
        tabItem(tabName = "Raw", h1("Raw Data"),
                
                fluidRow(
                  infoBox("Companies Involved", 505, icon = icon("bar-chart-o")),
                  infoBox("Dashboard Level", "Standard", icon = icon("thumbs-up"))
                ),
                
                fluidRow(br(), h2("Overview of Datasets Used: "), br()
                ),
                
                tabsetPanel(type = "tab",
                            tabPanel("Dataset 1", DT::dataTableOutput("company_all"), downloadButton("download_data1", "Download Dataset 1")),
                            tabPanel("Summary 1", verbatimTextOutput("summary1"),  downloadButton("download_summary1", "Download Summary 1"))
                            
                            ),
                 # fluidRow(
                 #   selectInput("company_state", h2("Select Company Ticker"), choices = data_concat$Company),
                 #   tableOutput("company_sub")
                 # )
                
                tabsetPanel(type = "tab",
                            tabPanel("Dataset 2", DT::dataTableOutput("company_data_table"), downloadButton("download_data2", "Download Dataset 2")),
                            tabPanel("Summary 2", verbatimTextOutput("summary2"),  downloadButton("download_summary2", "Download Summary 2"))
                            )
                
                
        )
        # tabItem(tabName = "pdf", h1("Research Document Proposal"),
        #         tags$iframe(style = "height:500px; width:100%; scrolling = yes", src = "proposal.pdf")
        #       )
      

      )
    )
  )
)


