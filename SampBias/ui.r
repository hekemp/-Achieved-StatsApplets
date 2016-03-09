# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(

    numericInput("sampsize", "Sample Size:", 25),
    numericInput("numsamp", "Number of Samples:", 100),
    numericInput("popvalue", "Estimated Mean:", .45),
    sliderInput("biasval", "Estimated Bias:", -1.0, 1.0, 0.0, step = NULL, round = FALSE, format = NULL, locale = NULL, ticks = TRUE, animate = FALSE, width = NULL, sep = ",", pre = NULL, post = NULL, timeFormat = NULL, timezone = NULL, dragRange = TRUE),
    #br(),
    
    actionButton("goButton", "Go!")),
  
  mainPanel(
    plotOutput("plot", height="600px")
  )  
))
