
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  output$ui <- renderUI({
    if (is.null(input$file1))
      return()
    inFile <- input$file1
    df <- read.table(inFile$datapath, col.names=c("Name"),
                     stringsAsFactors=FALSE)
    list(
      actionButton(inputId = "go", label = "Generate Groups"),
      checkboxGroupInput("dynamic", "Check Attendees",
        choices = df$Name, selected = df$Name))
  })
  
  data <- eventReactive(input$go,{
    nstudents <- length(input$dynamic)
    # no more than 10 groups allowed; try for groups of 3 students
    numGroups <- min( 10, floor(nstudents/3))
    groupAssign <- seq(nstudents)
    groupAssign <- ( groupAssign + numGroups - 1 )%%numGroups + 1
    students <- sample(input$dynamic) #randomize the present students
    sdf <- data.frame(Group = groupAssign, Members = students)
    sdf <- sdf[ order(sdf$Group, sdf$Members), ]
    print(sdf, row.names=FALSE)
  })
  
  output$groups <- renderPrint({ data() })
})

