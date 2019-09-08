
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
# Build vector of possible file choices
# To add additional files, place its data frame (as .rda) in current directory
filelist <- sort(sub(".rda","",list.files(".",paste0("*",".rda")))) 

shinyUI(fluidPage(
  # Application title
  titlePanel("Module 3 (Quantitative -vs- Quantitative)"),
  fluidRow(
    column(2,
           selectInput("files","Data for Analysis",choices=filelist),
           selectInput("xval","Explanatory vbl (x)", c("")),
           selectInput("yval","Response vbl (y)",c("")),
          radioButtons("scatreg","Plot Type", c("Scatterplot","Linear Regression")),
          actionButton("go","Calculate, Plot")
         
    ),
    column(7,h3("Summary Statistics"),fluidRow(verbatimTextOutput("summary")),fluidRow(h3("Plots"),plotOutput("scatter"))),
  fluidRow(
    column(8, offset=1, h3("Dataset Viewer"),
            dataTableOutput("tdf")))

  ))
 # sidebarLayout(
  #  sidebarPanel(
   #   selectInput("files","Data for Analysis",choices=filelist)
      
    #),
    
    # Show a plot of the generated distribution
    #mainPanel(
     # h3("Dataset Viewer"),
      #dataTableOutput("tdf")
    #)
  #)
)


