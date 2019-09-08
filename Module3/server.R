
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)

shinyServer(function(input, output, session) {
  rvals <- reactiveValues()
  observe({ rvals$dsi <- get(load(paste0(input$files,".rda")))
          rvals$xvals <- names(rvals$dsi[,sapply(rvals$dsi,class)!="factor"])
          updateSelectInput(session, "xval", choices = rvals$xvals)
          updateSelectInput(session, "yval", choices = rvals$xvals)
          updateRadioButtons(session,"scatreg", choices= c("Scatterplot","Linear Regression"))
          })
#build reactive list rl
  rl <- eventReactive(input$go,
                { #create a reactive list of values needed for plots, etc.
                  xvblname <- input$xval
                  yvblname <- input$yval
                  x <- rvals$dsi[[input$xval]]
                y <- rvals$dsi[[input$yval]]
                # create complete cases
                nonNAindices <- !is.na(x*y)
                xna <- x[nonNAindices]
                yna <- y[nonNAindices]
                n <- length(xna)
                list(x=xvblname,y=yvblname,xv=xna,yv=yna,n=n)
                })
  

  output$tdf <- renderDataTable(rvals$dsi, 
                  options=list(
                    pageLength=10, #display 10 rows initially
                    searching=FALSE)) # no search facility
  
  output$summary <- renderPrint(
        {df <- data.frame(rl()$xv, rl()$yv)
        names(df) <- c(rl()$x,rl()$y)
        summary(df)})
  
  output$scatter <- renderPlot({
    switch (input$scatreg,
    "Scatterplot" = qplot(rl()$xv, rl()$yv,
                                     xlab=rl()$x, ylab=rl()$y,
            main=paste("n=",rl()$n,"Correl =", signif(cor(rl()$xv,rl()$yv),5))
                              ),
    "Linear Regression" = {
      reg <- lm(rl()$yv ~ rl()$xv)
      ggplot(data.frame(rl()$xv,rl()$yv),aes(x=rl()$xv, y=rl()$yv)) + geom_point()  + stat_smooth(method=lm, se=FALSE)   + labs(x=rl()$x, y=rl()$y,
           title=paste("n=", rl()$n, "Slope=", signif(reg$coef[[2]],5)))
      })
   } )
    })


