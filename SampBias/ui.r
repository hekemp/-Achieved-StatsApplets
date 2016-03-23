# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(
  
    helpText("Currently the graph is running on pre-set data, so all of these fields aren't active at the moment. To see the effects of bias just click the point that will be removed."),
    helpText("To use toggle points, highlight the area of points in question and then hit toggle points. This will invert the selected points' statuses."),
    numericInput("popmean", "Population Mean:", 0),
    numericInput("popsd", "Population SD:", 1),
    numericInput("sampsize", "Sample Size:", 25),
    numericInput("numsamp", "Number of Samples:", 100),
    sliderInput("biasval", "Percent of Estimated Bias:", -1.0, 1.0, 0.0, step = .01, round = FALSE, format = NULL, locale = NULL, ticks = TRUE, animate = FALSE, width = NULL, sep = ",", pre = NULL, post = NULL, timeFormat = NULL, timezone = NULL, dragRange = TRUE),
    
    actionButton("goButton", "Go!")),
  
  mainPanel(
      textOutput("meansd1"),
      plotOutput("plot1", height = 350,
        click = "plot1_click",
        brush = brushOpts(
          id = "plot1_brush"
        )
      ),
      actionButton("exclude_toggle", "Toggle points"),
      actionButton("exclude_reset", "Reset"),
      textOutput("meansd2"),
#      plotOutput("plot2", height = 350, click = "plot1_click", brush = brushOpts(id = "plot1_brush")
      )
    )
  )
)
  
