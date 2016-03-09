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
    numericInput("biasval", "Estimated Bias:", 0),
    print("Note: Bias value should be between -1.0 and 1.0. A negative percentage will remove the lower values while a higher percentage will remove higher values. A value of zero will remove nothing."
    br(),
    
    actionButton("goButton", "Go!")),
  
  mainPanel(
    plotOutput("plot", height="600px")
  )  
))
