
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
# Ready to try new dynamic server on August 17
shinyUI(fluidPage(
  titlePanel("Random Group Assignment"),
  fluidRow(
    column(3, wellPanel(
      fileInput('file1', 'Choose .txt File',
                accept=c('text/csv', 
                         'text/comma-separated-values,text/plain', 
                         '.csv')))),
      
    column(3, wellPanel(
      # This column gives the roster and the attendance check boxes
      uiOutput("ui")
   #   submitButton("Generate Groups")
    )),
    column(3, 
      tags$p("Random Groups"),
      verbatimTextOutput("groups"))
  )))
  
