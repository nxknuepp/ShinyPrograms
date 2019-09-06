
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Random Rectangle Picker"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      radioButtons("sampsize",
                  "Sample Size",
                  c("5"=5,"10"=10)),
      actionButton("ab","Generate New Rectangles")
    ),

    # Show a plot of the generated distribution
    mainPanel( h4("Random Rectangles"),
      verbatimTextOutput("sampout"),
      h4("Rectangle Sizes"),
      verbatimTextOutput("rectsiz"),
      h4("Mean Rectangle Size"),
      verbatimTextOutput("meansiz")
    )
  )
))
