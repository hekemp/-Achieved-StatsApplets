# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

biasChoices <<- list("Upper Arm Length" = "armLength", "Age" = "age", "Skinfold Depth" = "skinfold")

shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(
  
    helpText("To see the effects of bias just click the point that will be removed."),
    helpText("To use toggle points, highlight the area of points in question and then hit toggle points. This will invert the selected points' statuses."),
    numericInput("sampsize", "Sample Size:", 25),
    selectInput("selection", "Select what variable there will be bias for:", choices = biasChoices)),
  
  mainPanel(
      textOutput("meansd1"),
      plotOutput("plot1", height = 350, click = "plot1_click", brush = brushOpts(id = "plot1_brush")),
      actionButton("exclude_toggle", "Toggle points"),
      actionButton("exclude_reset", "Reset"),
      plotOutput("plot2")
    )
  )
)
