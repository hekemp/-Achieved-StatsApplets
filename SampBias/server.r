# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  # Computing proportion of orange candies
  dataset <- reactive({
    if(input$goButton > 0 | TRUE) {
    data.frame(prob = rbinom(n = input$numsamp, size = input$sampsize, 
                    prob = input$popvalue)/input$sampsize)
    }
  })
  
  
  output$plot <- renderPlot({
    input$goButton
    isolate({
    rangeC <- max(dataset()$prob) - min(dataset()$prob)
    
      # Building histogram of sampling distribution
      p <- ggplot(dataset(), aes(x = dataset(), y = dataset$length)) 
      p <- p + geom_point() + labs(title = paste("Mean = ", round(mean(dataset()$prob), 3), 
                  "; SE = ", 
                  round(sqrt(mean(dataset()$prob)*
                              (1-mean(dataset()$prob))/input$sampsize), 3)))
      
      print(p)
    
    })   
  })
  
})
