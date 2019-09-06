#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  p <- sample(c(.2,.3,.4,.6,.7,.8),1)
 
  heads <- rbinom(1000, 1, p)
  cumheads <- cumsum(heads)
  output$coinPlot <- renderPlot({
n <- reactive({as.numeric(input$tosses)})
    plot(1:n(), cumheads[1:n()]/(1:n()),pch=if (n()<1000) 1 else ".", xlab="Tosses",ylab="",ylim=c(0,1))
   
if (input$reveal) abline(h=p)
 
}
  )
  
})
