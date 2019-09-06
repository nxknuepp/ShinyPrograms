
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
filelist <- sort(sub(".rda","",list.files(".",paste0("*",".rda")))) #build vector of possible file choices

shinyUI(fluidPage(
  titlePanel("Categorical -vs- Categorical"),
  fluidRow(
    selectInput("files","Data",choices=filelist), 
    tabsetPanel(
      tabPanel("One Variable (Marginal)",
               sidebarPanel(
                 selectInput("vals","Variable", c("")),
        #         radioButtons("pickfp","Frequency or %", c("Frequency","Percent")),
                 radioButtons("plottype","Plot Type",c("Bar","Stacked Bar","Pie"))
                 ),
               mainPanel(tableOutput("counts"),
                         plotOutput("univarplot"))
               ),
      tabPanel("Two Variables (Conditional)",
               sidebarPanel(
                 selectInput("explvbl","Explanatory",c("")),
                 selectInput("respvbl","Response",c("")),
                 radioButtons("mfreqpct","Summary Type", c("Frequency","Percent"))),
               mainPanel(
                 verbatimTextOutput("condittitle"),
                 tableOutput("condittbl"),
                 plotOutput("conditplot"))
               ),
      tabPanel("Two Variables (Joint)",
               sidebarPanel(
                 selectInput("vbl1","Variable 1",c("")),
                 selectInput("vbl2","Variable 2",c("")),
                 radioButtons("jfreqpct","Summary Type", c("Frequency","Percent"))),
              mainPanel(
                  verbatimTextOutput("jnttitle"),
                  tableOutput("jointtbl"),
                  plotOutput("jointplot"))
               )
    )),

    fluidRow(
      column(8, offset=1, h3("Dataset Viewer"),
             dataTableOutput("tdf")))
    
  ))
  
