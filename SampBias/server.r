# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)
library(ggplot2)
library(data.table)

baboon <- read.csv("baboons.csv")

shinyServer(function(input, output) {# For storing which rows have been excluded
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow(mtcars))
  )
  output$table1 <- renderTable(baboon)
  
  output$plot1 <- renderPlot({
    # Plot the kept and excluded points as two separate data sets
    keep    <- mtcars[ vals$keeprows, , drop = FALSE]
    exclude <- mtcars[!vals$keeprows, , drop = FALSE]
    
    ggplot(keep, aes(wt, mpg)) + geom_point() +
       geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25) +
      coord_cartesian(xlim = c(1.5, 5.5), ylim = c(5,35))
  })

  # Toggle points that are clicked
  observeEvent(input$plot1_click, {
    res <- nearPoints(mtcars, input$plot1_click, allRows = TRUE)

    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })

  # Toggle points that are brushed, when button is clicked
  observeEvent(input$exclude_toggle, {
    res <- brushedPoints(mtcars, input$plot1_brush, allRows = TRUE)

    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })

  # Reset all points
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, nrow(mtcars))
  })
  
  getTitle1 <- function() {
     paste("Population Mean = ", round(mean(mtcars$mpg),3), " | Population SD = ", round(sd(mtcars$mpg),3))
  }
  
  output$meansd1 <- renderText({
    getTitle1()
  })
  
  getSample <- function(){
   keep2 <- mtcars[vals$keeprows, , drop = FALSE]
    dataTableCars <- data.table(keep2)
    samSet <- dataTableCars[sample(.N, input$sampsize, replace = TRUE)]
    return(samSet)}
  
  getTitleVar <- function(dat) {
    paste("Sample Mean = ", round(mean(dat),3), " | Sample SD = ", round(sd(dat),3))}

  output$plot2 <- renderPlot({
  randSam <- getSample()
  pl <- ggplot(randSam, aes(wt, mpg)) + geom_point() +  coord_cartesian(xlim = c(1.5, 5.5), ylim = c(5,35))
  pl <- pl+ ggtitle(getTitleVar(randSam$mpg))
  print(pl)
  
  })
  

})

                            
