
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
mu <- 0
sigma <- 1
x <- 0
shinyUI(fluidPage(
  titlePanel("Normal Curve Calculations"),
    fluidRow(sidebarPanel(numericInput("mean", "Mean", mu),
                 numericInput("sd", "Standard Deviation", sigma))),
    fluidRow(tabsetPanel(
      tabPanel("Area Below",
        sidebarLayout(
          sidebarPanel(
            numericInput("xbelow","x",NULL),
            submitButton("Submit")),
          mainPanel(plotOutput("plotbelow"))
        )),
      tabPanel("Area Between",
        sidebarLayout(
          sidebarPanel(
            numericInput("xlowval","Between", NULL),
            numericInput("xhighval","and", NULL),
            submitButton("Submit")),
          mainPanel(plotOutput("plotbetween"))
          )),     
      tabPanel("Area Above",
        sidebarLayout(
          sidebarPanel(
            numericInput("xabove","x",NULL),
            submitButton("Submit")),
          mainPanel(plotOutput("plotabove"))
          )),       
      tabPanel("Percentile",
        sidebarLayout(
          sidebarPanel(
            numericInput("percentile","Percentile",NULL),
            submitButton("Submit")),
          mainPanel(plotOutput("plotpercentile"))
          )) )      
      ))) 