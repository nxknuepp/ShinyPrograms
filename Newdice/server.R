
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
sumbins <- rep(0,1000)

shinyServer(function(input, output) {
  die <- reactive( c(input$face1,
           input$face2,
           input$face3,
           input$face4,
           input$face5,
           input$face6))
  reps <- reactive({for (i in 1:1000) sumbins[i]<-sum(sample(die(),input$rolls,replace=TRUE))
  #browser()
  sumbins})
  output$mean <- renderText({paste("Mean=", signif(mean(die()),3))})
  output$sd <- renderText({paste("Standard Deviation=",signif(sd(die())*sqrt(5/6),3))})
  output$meansum <- renderText({paste("Mean Sum of Rolls =", signif(mean(reps()),5))})
  output$sdsum <- renderText({paste("Standard Error of Sum =",signif(sd(reps()),3))})
  output$distPlotsum <- renderPlot({
    binss <- if(input$rolls > 1) seq(min(reps()), max(reps()),length.out=15) else seq(min(reps())-.5, max(reps())+.5)
    hist(reps(), breaks=binss,col = 'blue', border = 'white',freq=FALSE,
         main=paste("Histogram (Sum of",input$rolls, "Roll(s))"), xlab="Sum of Rolls")
  })
  output$distPlot <- renderPlot({
    bins <- seq(min(die())-.5, max(die())+.5)
    hist(die(), breaks=bins,col = 'darkgray', border = 'white',main="Histogram of Die Faces",xlab="Faces")
  })

})
