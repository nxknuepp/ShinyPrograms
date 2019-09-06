

library(shiny)
stdu <- 3.1 # default= 3.1 standard units for normal curves

area <- function(x, mean, sd, x2=NULL,plottype){
# return area in % (multiply by 100)
      switch(plottype,
            "below"=100*pnorm(x,mean,sd),
            "above"=100*(1-pnorm(x,mean,sd)),
            "between"=100*(pnorm(x2,mean,sd)-pnorm(x,mean,sd)))
    }

shadecurve <- function(x, mean, sd, x2=NULL, plottype){ #shade the area under the normal curve
  #determine the limits of the shaded region, and build the polygonal arrays
  lowlim <- mean - stdu * sd
  highlim <- mean + stdu * sd
  if (plottype=="below"){
    xlft <- lowlim
    xrt <- max(lowlim, x)
  }
  else if (plottype=="above") {
    xlft <- min(x, highlim)
    xrt <- highlim
  }
  else if (plottype=="between") {
    xlft <- min(max(lowlim, x),highlim)
    xrt <- max(lowlim,min(x2, highlim))
  }
  else  { #percentile
    xlft <- lowlim
    xrt <- max(lowlim, qnorm(x,mean,sd))
  }
  xcoords <- c(xlft, seq(xlft, xrt, 0.01), xrt)
  ycoords <- c(0,dnorm(seq(xlft,xrt,0.01),mean,sd),0)
  # call polygon to do the actuql shading
  polygon(xcoords, ycoords, col="darkblue")
  }

nplot <- function(xval, mean, sd, x2=NULL, plottype){
# draw the normal curve portion of the plot
    Area <- if (plottype != "percentile") signif(area(xval,mean,sd,x2,plottype),4) else signif(qnorm(xval,mean,sd),4)
  maintext <- if(plottype != "percentile") paste("Area =",Area,"%") else paste(100*xval,"th Percentile =", Area)
  curve(dnorm(x,mean,sd),
                from = mean-stdu*sd, to = mean+stdu*sd,
                ylab="", yaxt="n",
                main=maintext)
  }


shinyServer(function(input, output) {
  output$plotbelow <- renderPlot({if (!is.na(input$xbelow)){
    validate(need(input$sd > 0, "SD must be positive."))
    nplot(input$xbelow,input$mean,input$sd,plottype="below")
    shadecurve(input$xbelow,input$mean,input$sd,plottype="below")
    }})
  
  output$plotabove <- renderPlot({ if(!is.na(input$xabove)){
    validate(need(input$sd > 0, "SD must be positive."))
    nplot(input$xabove, input$mean, input$sd, plottype="above")
    shadecurve(input$xabove, input$mean, input$sd, plottype="above")
  }})
  
  output$plotbetween <- renderPlot({ if(!is.na(input$xlowval) && !is.na(input$xhighval)){
    validate(need(input$sd>0,"SD must be positive."))
    lowval <- min(input$xlowval,input$xhighval)
    highval <- max(input$xlowval,input$xhighval)
    nplot(lowval, input$mean, input$sd, x2=highval,plottype="between")
    shadecurve(lowval, input$mean, input$sd, x2=highval,plottype="between")
  }})
  
  output$plotpercentile <- renderPlot({ if(!is.na(input$percentile )){
    validate(need(input$sd>0, "SD must be positive."))
    validate(need(input$percentile>0 && input$percentile < 100, "Percentile must be strictly between 0 and 100."))
    nplot(input$percentile/100, input$mean, input$sd, plottype="percentile")
    shadecurve(input$percentile/100, input$mean, input$sd, plottype = "percentile")
  }}) 

})

