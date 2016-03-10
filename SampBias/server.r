# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)
library(ggplot2)

shinyServer(function(input, output) {
  
  # # Computing proportion of orange candies
  # dataset <- reactive({
  #   if(input$goButton > 0 | TRUE) {
  #   data.frame(prob = rbinom(n = input$numsamp, size = input$sampsize, 
  #                   prob = input$popvalue)/input$sampsize)
  #   }
  # })
    # Computing proportion of orange candies
  # dataset <- reactive({
  #   if(input$goButton > 0 | TRUE) {
  #   replicate(input$numsamp, 
  #             rnorm(n = input$sampsize, mean = input$popmean, sd = input$popsd))
  #   }
  # })
  # output$dataset <- renderDataTable({dataset)}


  
    # output$plot <- renderPlot({
    # input$goButton
    # # compute means and sd for data
    # isolate({
    # confnums <- data.frame(means = apply(dataset(), 2, mean),
    #                       se = apply(dataset(), 2, sd)/sqrt(input$sampsize))
  
  output$plot <- renderPlot({
    input$goButton
    isolate({
#    rangeC <- max(dataset()$prob) - min(dataset()$prob)
    
      # Building histogram of sampling distributionoutput$plot1 <- renderPlot({
      p <- plot(x = ToothGrowth$supp, y = ToothGrowth$len)
    #  p <- ggplot(msleep, aes(x = msleep[5], y = msleep[10])) 
      # p <- p + geom_histogram(fill = "steelblue", color = "black", 
      #                         binwidth = rangeC/20) +
      #   theme_bw(base_size = 24) + labs(title = paste("Mean = ", round(mean(dataset()$prob), 3), 
      #             "; SE = ", 
      #             round(sqrt(mean(dataset()$prob)*
      #                         (1-mean(dataset()$prob))/input$sampsize), 3)))
      
      print(p)
    
    })   
  })
  
})
                            
