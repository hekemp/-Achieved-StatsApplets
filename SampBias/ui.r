# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(

    numericInput("sampsize", "Sample Size:", 25),
    numericInput("numsamp", "Number of Samples:", 100),
    numericInput("popvalue", "Parameter:", .45),
    br(),
    
    checkboxInput("normcurve", "Draw Normal Curve", FALSE),
    
    actionButton("goButton", "Go!")),
  
  mainPanel(
    plotOutput("plot", height="600px")
  )  
))