library(shiny)
# Recursive implementation of fast exponentiation. If the power is even, recursively divide by 2 and square.

modpower <- function(base, expon, modulus){
    base <- base%%modulus
    if (expon == 0) return(1)
    else if (expon == 1) return(base)
    else if (expon%%2 == 0) return(modpower((base*base)%%modulus,
        expon/2, modulus))
    else return( (base*modpower(base, expon - 1, modulus)) %% modulus) 
}
shinyServer(function(input, output) {
    output$answerline <- renderText({modpower(input$base, input$expon, input$modulus)})
})


