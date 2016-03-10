# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(
  
    numericInput("popmean", "Population Mean:", 0),
    numericInput("popsd", "Population SD:", 1),
    numericInput("sampsize", "Sample Size:", 25),
    numericInput("numsamp", "Number of Samples:", 100),
    sliderInput("biasval", "Percent of Estimated Bias:", -1.0, 1.0, 0.0, step = .01, round = FALSE, format = NULL, locale = NULL, ticks = TRUE, animate = FALSE, width = NULL, sep = ",", pre = NULL, post = NULL, timeFormat = NULL, timezone = NULL, dragRange = TRUE),
    helpText("The following value is used only for debug purposes"),
    numericInput("popvalue", "DefaultParameter:", .45),
    br(),
    
    actionButton("goButton", "Go!")),
  
  mainPanel(
    plotOutput("plot", height="600px")
    dataTableOutput("dataset")
  )  
))
