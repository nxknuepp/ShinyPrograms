

library(shiny)
stdu <- 3.1 # default= 3.1 standard units for normal curves

area <- function(x, df, x2=NULL, plottype){
# return area in % (multiply by 100)
      switch(plottype,
            "below"=100*pt(x, df),
            "above"=100*(1-pt(x, df)),
            "between"=100*(pt(x2, df) - pt(x, df)))
    }

shadecurve <- function(x, df, x2=NULL, plottype){ #shade the area under the normal curve
  #determine the limits of the shaded region, and build the polygonal arrays
  lowlim <- -3.5
  highlim <- 3.5
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
    xrt <- max(lowlim, qt(x, df))
  }
  xcoords <- c(xlft, seq(xlft, xrt, 0.01), xrt)
  ycoords <- c(0, dt(seq(xlft, xrt, 0.01), df), 0)
  # call polygon to do the actuql shading
  polygon(xcoords, ycoords, col="darkblue")
  }

nplot <- function(xval, df, x2=NULL, plottype){
# draw the normal curve portion of the plot
    Area <- if (plottype != "percentile") signif(area(xval,df,x2,plottype),4) else signif(qt(xval, df),4)
  maintext <- if(plottype != "percentile") paste("Area =",Area,"%") else paste(100*xval,"th Percentile =", Area)
  curve(dt(x, df),
                from = -3.5, to = 3.5,
                ylab="", yaxt="n",
                main=maintext)
  }


shinyServer(function(input, output) {
  output$plotbelow <- renderPlot({if (!is.na(input$xbelow)){
    validate(need(input$df > 0, "DF must be positive."))
    nplot(input$xbelow, input$df, plottype="below")
    shadecurve(input$xbelow, input$df, plottype="below")
    }})
  
  output$plotabove <- renderPlot({ if(!is.na(input$xabove)){
    validate(need(input$df > 0, "DF must be positive."))
    nplot(input$xabove, input$df, plottype="above")
    shadecurve(input$xabove, input$df, plottype="above")
  }})
  
  output$plotbetween <- renderPlot({ if(!is.na(input$xlowval) && !is.na(input$xhighval)){
    validate(need(input$df>0,"DF must be positive."))
    lowval <- min(input$xlowval,input$xhighval)
    highval <- max(input$xlowval,input$xhighval)
    nplot(lowval, input$df, x2=highval,plottype="between")
    shadecurve(lowval, input$df, x2=highval,plottype="between")
  }})
  
  output$plotpercentile <- renderPlot({ if(!is.na(input$percentile )){
    validate(need(input$df>0, "DF must be positive."))
    validate(need(input$percentile>0 && input$percentile < 100, "Percentile must be strictly between 0 and 100."))
    nplot(input$percentile/100, input$df, plottype="percentile")
    shadecurve(input$percentile/100, input$df, plottype = "percentile")
  }}) 

})

