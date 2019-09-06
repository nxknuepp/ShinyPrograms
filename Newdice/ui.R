
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

MIN <- -12
MAX <- 12
WID <- "20%"
shinyUI(fluidPage(

  # Application title
  titlePanel("Build Your Own Die"),

  fluidRow(
    column(3,
      numericInput("face1","Face1",1,min=MIN,max=MAX,step=1,width=WID),
      numericInput("face2","Face2",2,min=MIN,max=MAX,step=1,width=WID),
      numericInput("face3","Face3",3,min=MIN,max=MAX,step=1,width=WID),
      numericInput("face4","Face4",4,min=MIN,max=MAX,step=1,width=WID),
      numericInput("face5","Face5",5,min=MIN,max=MAX,step=1,width=WID),
      numericInput("face6","Face6",6,min=MIN,max=MAX,step=1,width=WID)),
    #  submitButton("Recompute")),

    # Show a plot of the generated distribution
    column(8,
      verbatimTextOutput("mean"),
      verbatimTextOutput("sd"),
      plotOutput("distPlot")
    )
  ),
# Output the approximate distribution of sum of many rolls
  fluidRow(
    column(3,
      radioButtons("rolls","Number of Rolls", c("1"=1,"4"=4,"64"=64,
        "100"=100,"400"=400, "900"=900))
           ),
    column(8,
      h4("Empirical Summary Statistics (1000 repititions)"),
      verbatimTextOutput("meansum"),
      verbatimTextOutput("sdsum"),
     h4("Empirical Histogram (1000 repititions)"),
      plotOutput("distPlotsum")
           )
  )
  ))
  
