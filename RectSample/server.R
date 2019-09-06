
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

rectarea <- c(rep(1,5),5,12,rep(1,3), #areas of the 100 rectangles
1,8,16,4,9,1,9,4,1,1,
1,4,10,5,18,12,4,5,10,4,
16,5,12,12,4,4,10,9,12,8,
16,6,4,1,10,3,16,6,10,1,
16,12,6,3,16,4,18,4,8,16,
8,3,9,1,5,10,4,12,4,18,
4,12,16,10,8,18,3,4,8,2,
15,6,2,5,8,5,8,4,12,16,
3,5,16,3,6,18,4,6,9,12)

shinyServer(function(input, output) {
  
    observeEvent( input$ab, {

        x <- sample(c(1:100), input$sampsize)
  
        output$sampout <- renderText(x)
 
        output$rectsiz <- renderText(  print(rectarea[x] ))
  
        output$meansiz <- renderText( print(mean(rectarea[x])) )
  
    })
})
