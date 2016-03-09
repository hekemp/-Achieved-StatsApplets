# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  # Computing proportion of orange candies
  rawdataset <- reactive({
    if(input$goButton > 0 | TRUE) {
    data.frame(prob = rbinom(n = input$numsamp, size = input$sampsize, 
                    prob = input$popvalue)/input$sampsize)
    }
  })
  dataset <- rawdataset[order(mpg),] 
  
  output$plot <- renderPlot({
    input$goButton
    isolate({
    rangeC <- max(dataset()$prob) - min(dataset()$prob)
    

      # Building histogram of sampling distribution
      p <- plot(dataset(), aes(x = prob)) 
      p <- p + geom_histogram(aes(y = ..density..), fill = "steelblue", 
                              color = "black", binwidth = rangeC/20) +
        geom_density(data = dataNorm, aes(x = norm), color = "darkgreen", 
                     size = 1.25, alpha = 0) +
        theme_bw(base_size = 24)+ labs(title = paste("Mean = ", round(mean(dataset()$prob), 3), 
                  "; SE = ", 
                  round(sqrt(mean(dataset()$prob)*
                              (1-mean(dataset()$prob))/input$sampsize), 3)))
      
      print(p)
    
    })   
  })

                            
