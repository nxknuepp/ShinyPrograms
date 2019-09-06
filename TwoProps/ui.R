
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Simulation: Difference of Two Proportions"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      numericInput("n1",
                  "n1", 50),
                 
      numericInput("p1",
                  "p1", 0.5),
      numericInput("n2",
                  "n2", 50),
      numericInput("p2",
                  "p2", 0.5),
      numericInput("value",
                  "Our p1-hat - p2-hat (solid, vertical line)",
                                   -2),
      submitButton("Run Simulation")
      
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("propPlot")
    )
  )
))
