library(shiny)
egcd <- function(a,b){ #extended Euclidean algorithm based on Concrete Mathematics 2ed (Graham, Knuth, etc.) pp 103, 104
            # Updated to avoid redundant recursive calls. April 17, 2019 NK
    if ( b == 0 )
        return(list(1,0))
    else {
        retlist <- egcd(b, a %% b)
        return( list(retlist[[2]], retlist[[1]] - (a %/% b) * retlist[[2]]))
    }
}

shinyServer(function(input, output) {
    a <- reactive({ floor(input$ain) }) # Ensure inputs are integers
    b <- reactive({ floor(input$bin)})
    Egcd  <- reactive({ egcd( a(), b()) })
    aout <- reactive({ Egcd()[[1]] })
    bout <- reactive({ Egcd()[[2]] })
    output$gcdline <- renderText({paste0("gcd(",a(),",",b(),")= (",
                          aout(),")x",a()," + (", bout() ,")x", b(),
                          " =", a()*aout() + b()*bout()) })
})


