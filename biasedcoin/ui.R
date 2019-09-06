#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Biased Coin Simulation"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      radioButtons("tosses","Tosses",c("10"=10,"40"=40,"100"=100,"1000"=1000)),
      actionButton("reveal","Reveal p")
    
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("coinPlot")
    )
  )
))
