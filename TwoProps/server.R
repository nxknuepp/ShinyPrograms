
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyServer(function(input, output) {
  
  output$propPlot <- renderPlot({
    validate(need(input$n1>0, "Sample size must be positive."),
             need(input$n2>0, "Sample size must be positive."),
             need(input$p1 > 0 & input$p1 < 1, "p1 must be between 0 and 1."),
             need(input$p2 > 0 & input$p2 < 1, "p2 must be between 0 and 1."),
             need(input$value >= -2 & input$value <= 2, "Value must be between -2 and 2.")
             )
    if (input$value==-2) return(NULL);
    # generate bins based on input$bins from ui.R
    diffs <- rbinom(10000, input$n1, input$p1)/input$n1 -
      rbinom(10000, input$n2, input$p2)/input$n2
    m <- mean(diffs)
    s <- sd(diffs)

    hist(diffs, breaks=30, #seq(min(diffs-.01), max(diffs+.01), 0.025),
         main = paste("Estimates: mean", 
        signif(m,3), ", SE", signif(s,3)), 
         ylab="", col = 'lightgray', border = 'white',
        xlab=expression(paste("Simulated ", hat(p)[1]-hat(p)[2], " (10,000 runs)")))
    abline(v=c(m-2*s, m-s, m, m+s, m+2*s), lty=2, lwd=2)
    abline(v=input$value, lwd=2)
  })
  
})
