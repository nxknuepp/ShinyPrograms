# Fast modular exponentiation in Shiny
library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Fast Modular Exponentiation"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      helpText("Enter positive integers for the base, exponent and modulus. Then press Submit.",
            "The result is Base ^ Exponent (mod Modulus)."),
      numericInput("base","Base",5,1),
      numericInput( "expon","Exponent",2,0),
      numericInput( "modulus", "Modulus",7,1),
      submitButton("Submit")
      ),

    # Show a plot of the generated distribution
    mainPanel(
      verbatimTextOutput("answerline")
    )
  )
))
