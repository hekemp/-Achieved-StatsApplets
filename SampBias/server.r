# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)
library(ggplot2)
library(data.table)

baboon <- read.csv("baboons.csv")

shinyServer(function(input, output) {# For storing which rows have been excluded
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow(baboon))
  )
  
  
  output$plot1 <- renderPlot({
    # Plot the kept and excluded points as two separate data sets
    keep    <- baboon[ vals$keeprows, , drop = FALSE]
    exclude <- baboon[!vals$keeprows, , drop = FALSE]
    
    ggplot(keep, aes(length, mass)) + geom_point() +
       geom_point(data = exclude, fill = NA, color = "black", alpha = 0.25) +
      coord_cartesian(xlim = c(66, 157), ylim = c(7,30))
  })

  # Toggle points that are clicked
  observeEvent(input$plot1_click, {
    res <- nearPoints(baboon, input$plot1_click, allRows = TRUE)

    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })

  # Toggle points that are brushed, when button is clicked
  observeEvent(input$exclude_toggle, {
    res <- brushedPoints(baboon, input$plot1_brush, allRows = TRUE)

    vals$keeprows <- xor(vals$keeprows, res$selected_)
  })

  # Reset all points
  observeEvent(input$exclude_reset, {
    vals$keeprows <- rep(TRUE, nrow(baboon))
  })
  
  observeEvent(input$selection, {
    if(input$selection == "default")
    {vals$keeprows <- rep(TRUE, nrow(baboon))}
    if(input$selection == "armLength")
    {vals$keeprows <- rep(TRUE, nrow(baboon)
     vals$keeprows <- subset(vals$keeprows, (upperarm < 15))
#    vals$keeprows <- xor(vals$keeprows, res)
    
    }
    if(input$selection == "age")
    {vals$keeprows <- rep(TRUE, nrow(baboon))
    }
    if(input$selection == "skinfold")
    {vals$keeprows <- rep(TRUE, nrow(baboon))
    }
    })
  
  getTitle1 <- function() {
     paste("Population Mean = ", round(mean(baboon$mass),3), " | Population SD = ", round(sd(baboon$mass),3))
  }
  
  output$meansd1 <- renderText({
    getTitle1()
  })
  
  getSample <- function(){
   keep2 <- baboon[vals$keeprows, , drop = FALSE]
    dataTableCars <- data.table(keep2)
    samSet <- dataTableCars[sample(.N, input$sampsize, replace = TRUE)]
    return(samSet)}
  
  getTitleVar <- function(dat) {
    paste("Sample Mean = ", round(mean(dat),3), " | Sample SD = ", round(sd(dat),3))}

  output$plot2 <- renderPlot({
  randSam <- getSample()
  pl <- ggplot(randSam, aes(length, mass)) + geom_point() +  coord_cartesian(xlim = c(66, 157), ylim = c(7,30))
  pl <- pl+ ggtitle(getTitleVar(randSam$mass))
  print(pl)
  
  })
  
  })
  

                            
