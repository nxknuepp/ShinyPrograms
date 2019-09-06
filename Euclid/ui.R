
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Extended Euclidean Algorithm"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      helpText("Enter positive integers a and b, and press Submit.",
               "Their greatest common divisor and the linear combination ",
               "generating the gcd will be displayed."),
      numericInput("ain","a",1,0),
      numericInput( "bin","b",1,1),
      submitButton("Submit")
      ),

    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("gcdline")
    )
  )
))
