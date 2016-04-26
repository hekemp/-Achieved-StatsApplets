# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)
library(ggplot2)
library(data.table)

baboon <- read.csv("baboons.csv")

shinyServer(function(input, output) {# For storing which rows have been excluded
  
  observeEvent(input$popSelect, {
  if(input$popSelect = "all")
    baboon <- read.csv("baboons.csv")
  if(input$popSelect = "males")
    baboon <- read.csv("baboonsM.csv")
  if(input$popSelect = "females")
    baboon <- read.csv("baboonsF.csv")
  }
    
  vals <- reactiveValues(
    keeprows = rep(TRUE, nrow(baboon))
  )
  val <- reactiveValues(
    meanDataSet = c()
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
    {vals$keeprows <- rep(TRUE, nrow(baboon))
    res <- rep(TRUE, nrow(baboon))
    res[which(baboon$upperarm > 15)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)}
    
    if(input$selection == "age")
    {vals$keeprows <- rep(TRUE, nrow(baboon))
    res <- rep(TRUE, nrow(baboon))
    res[which(baboon$age < 12)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)}
    
    if(input$selection == "skinfold")
    {vals$keeprows <- rep(TRUE, nrow(baboon))
    res <- rep(TRUE, nrow(baboon))
    res[which(baboon$skinfold < 7)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)}
    
    if(input$selection == "ranking")
    {vals$keeprows <- rep(TRUE, nrow(baboon))
    res <- rep(TRUE, nrow(baboon))
    res[which(baboon$rank < .9)] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)}
    
    if(input$selection == "location")
    {vals$keeprows <- rep(TRUE, nrow(baboon))
    res <- rep(TRUE, nrow(baboon))
    res[which(baboon$group == "a")] <- FALSE
    res[which(baboon$group == "b")] <- FALSE
    res[which(baboon$group == "c")] <- FALSE
    res[which(baboon$group == "d")] <- FALSE
    res[which(baboon$group == "e")] <- FALSE
    res[which(baboon$group == "f")] <- FALSE
    res[which(baboon$group == "g")] <- FALSE
    res[which(baboon$group == "i")] <- FALSE
    res[which(baboon$group == "k")] <- FALSE
    vals$keeprows <- xor(vals$keeprows, res)}
    })
    
    observeEvent(input$draw_1_Sample, {
    val$meanDataSet[length(val$meanDataSet) + 1] = round(mean(getSample()$mass), 3)
    })
    
    observeEvent(input$draw_10_Sample, {
    for (timesExecuted in 1:10)
    {val$meanDataSet[length(val$meanDataSet) + 1] = round(mean(getSample()$mass), 3)}
    })
      
    observeEvent(input$clear_Samples, {
    val$meanDataSet <- c()})
  
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
  
  getHistTitle <- function()
  {paste("Histogram of Sample Means from the Baboon Population \n Each Sample Mean is Based on a Random Sample of Size", input$sampsize)}
  
  output$numSamples <- renderText({
    paste("The number of samples is: ", length(val$meanDataSet))
    })
  
  output$plot3 <- renderPlot({
  
  if(length(val$meanDataSet) == 0)
    {plot(1, type="n", main = getHistTitle(), xlab="Mass", ylab="Frequency", xlim=c(8, 29), ylim= c(0, 21))
     abline(v=mean(baboon$mass),col="red")
    }
  else if(length(val$meanDataSet) == 1)
  {bins <- seq(min(baboon$mass), max(baboon$mass), length.out = 41)
     hist(val$meanDataSet, breaks =bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass", ylab = "Frequency", xlim = c(8,29), ylim= c(0, 21))
     abline(v=mean(baboon$mass),col="red")
     }
    
  else {
         bins <- seq(min(baboon$mass), max(baboon$mass), length.out = 41)
         counta <- hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass", ylab = "Frequency")$counts
         if(max(counta) <= 20)
           {counta <- hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass", ylab = "Frequency")$counts
            hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass", ylab = "Frequency", xlim = c(8,29), ylim = c(0, 21))
            abline(v=mean(baboon$mass),col="red")}
          else
            {counta <- hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass", ylab = "Frequency")$counts
            hist(val$meanDataSet, breaks = bins, col = 'darkgray', border = 'white', main = getHistTitle(), xlab = "Mass", ylab = "Frequency", xlim = c(8,29), ylim = c(0, max(counta)+1))
            abline(v=mean(baboon$mass),col="red")
          }
     }

  })
  
  
  })
