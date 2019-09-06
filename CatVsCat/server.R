
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggplot2)
library(dplyr)

shinyServer(function(input, output, session) {

# dsi <- reactive({ get(load(paste0(input$files,".rda")))  })
  rvals <- reactiveValues()
  observe({ rvals$dsi <- get(load(paste0(input$files,".rda")))
  rvals$val <- names(rvals$dsi[,sapply(rvals$dsi,class)=="factor"])
  choicelst <- c("",rvals$val)
  updateSelectInput(session, "vals", choices = choicelst)
  updateSelectInput(session, "explvbl", choices = choicelst)
  updateSelectInput(session, "respvbl", choices = choicelst)
  updateSelectInput(session, "vbl1", choices = choicelst)
  updateSelectInput(session, "vbl2", choices = choicelst)
  })

  
 # rvals$val <- names(rvals$dsi[,sapply(rvals$dsi,class)=="factor"])
  freqpctmx <- function(v1, v2, margjoint=c("marginal","joint"),type=c("freq","pct")){
    tbl <- table(v1, v2)
    mx <- as.matrix(addmargins(table(v1,v2)))
    if (margjoint=="joint") if (type=="freq") mx else mx/sum(mx)*400 else {
      #marginal calculations
      mx1 <- mx
      if (type=="freq") mx else {
        mx1 <- mx
        for (i in 1:ncol(mx)) mx1[,i] <- mx[,i]/sum(mx[,i])*200
        mx1 }
    }
  }
 
  main <- function(type) { if (type =="Frequency") "COUNTS:  " else "PERCENTS:  "}
  
  output$jnttitle <- renderText(if(input$vbl1!="" && input$vbl2!="")
    paste(main(input$jfreqpct), "Rows =", input$vbl1, ",", "Cols =", input$vbl2))
  
  output$jointtbl <- renderTable({if(input$vbl1!="" && input$vbl2!=""){
    switch(input$jfreqpct,
           "Frequency" = freqpctmx(rvals$dsi[[input$vbl1]],
                                   rvals$dsi[[input$vbl2]],
                                   margjoint = "joint",type="freq"),
           "Percent" = freqpctmx(rvals$dsi[[input$vbl1]],
                                 rvals$dsi[[input$vbl2]],
                                 margjoint = "joint",type="pct"))
  }})
  
  output$jointplot <- renderPlot({if(input$vbl1!="" && input$vbl2!=""){
    df <- data.frame(xv = rvals$dsi[[input$vbl1]], 
                     yv = rvals$dsi[[input$vbl2]])
    comblabel <- paste(input$vbl1,input$vbl2)
    df1 <- df %>% filter(!is.na(xv),!is.na(yv)) %>% mutate(both=interaction(xv,yv)) %>% group_by(both) %>% summarize(count=n()) %>% mutate(percent=count/sum(count))
    switch(input$jfreqpct,
           "Frequency" = ggplot(df1,aes(both,count,fill=both))+geom_bar(stat="identity",position="dodge") +  geom_text(stat="identity",aes(label=count),vjust=-.5) + 
             xlab(comblabel) + labs(fill=comblabel),
           "Percent" = ggplot(df1,aes(both,percent*100,fill=both))+geom_bar(stat="identity",position="dodge") +  geom_text(stat="identity",aes(label=signif(percent*100,3)),vjust=-.5) + ylab("Percent") +
             xlab(comblabel) + labs(fill=comblabel))
  }})
  
  output$condittitle <- renderText(
    paste(main(input$mfreqpct), "Rows =", input$respvbl, ",", 
                "Cols =", input$explvbl))
  
  output$condittbl <- renderTable({if(input$explvbl!="" && input$respvbl!=""){
    switch(input$mfreqpct,
           "Frequency" = freqpctmx(
                                   rvals$dsi[[input$respvbl]],
                                   rvals$dsi[[input$explvbl]],
                                   margjoint = "marginal",type="freq"),
           "Percent" = freqpctmx(
                                 rvals$dsi[[input$respvbl]],
                                 rvals$dsi[[input$explvbl]],
                                 margjoint = "marginal",type="pct"))
  }})
  
  output$counts <- renderTable({if (!is.null(rvals$dsi[[input$vals]])) {tabl <-table(rvals$dsi[input$vals])
                        mx <- as.matrix(addmargins(tabl))
                        mx <- cbind(mx,mx[,1]/sum(mx[1:nrow(mx)-1,1])*100)
                        colnames(mx)<-c("Frequency","Percent")
                        mx}})
  output$univarplot <- renderPlot({if (!is.null(rvals$dsi[[input$vals]])){
    df <- data.frame(xv = rvals$dsi[[input$vals]])
    df <- df %>% filter(!is.na(xv))
    switch(input$plottype,
      "Bar" = ggplot(df, aes(x=xv,fill=xv))+geom_bar(position="dodge") + 
        geom_text(stat="count",aes(label=..count..),vjust=-.5) +
        ggtitle("Counts")+xlab(input$vals) + theme(legend.position="none"),
    "Stacked Bar" = ggplot(df,aes(factor(1),fill=xv))+geom_bar(width=.5)+
        ggtitle("Counts")+xlab(input$vals)+labs(fill=input$vals),
    "Pie" = ggplot(df,aes(factor(1),fill=xv))+geom_bar(width=1)+
      ggtitle("Counts")+xlab(input$vals)+labs(fill=input$vals) + 
      coord_polar("y")+ylab(NULL))
  }})
  output$conditplot <- renderPlot({if(input$explvbl!="" && input$respvbl!=""){
    df <- data.frame(xv = rvals$dsi[[input$explvbl]], 
                     yv = rvals$dsi[[input$respvbl]])
    df <- df %>% filter(!is.na(xv)) %>% filter(!is.na(yv))
    switch(input$mfreqpct,
           "Frequency"= ggplot(df, aes(xv,y=..count..,fill=yv)) + geom_bar(position="dodge") +
      geom_text(stat="count",aes(label=..count..),position=position_dodge(.9),
                vjust=-.5)+ggtitle("Counts")+xlab(input$explvbl)+ylab(input$respvbl)+labs(fill=input$respvbl),
      "Percent" = {df1 <- df %>% filter(!is.na(xv)) %>% filter(!is.na(yv)) %>% group_by(xv,yv) %>% summarize(count=n()) %>% mutate(pct=count/sum(count))
    ggplot(df1,aes(x=factor(xv),y=pct*100,fill=factor(yv))) +
      geom_bar(stat="identity",position="dodge") +
      geom_text(stat="identity",aes(label=signif(pct*100,3)),position=position_dodge(.9), vjust = -.5) +xlab(input$explvbl) + ylab("Percent") + labs(fill=input$respvbl)+ggtitle("Percents")
      }  )
  }})
  output$tdf <- renderDataTable(rvals$dsi,
                                options=list(
                                  pageLength=10, #display 10 rows initially
                                  searching=FALSE)) # no search facility
})
