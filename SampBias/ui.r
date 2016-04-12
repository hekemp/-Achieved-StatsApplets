# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

biasChoices <<- list("Default" = "default", "Upper Arm Length" = "armLength", "Age" = "age", "Skinfold Depth" = "skinfold")

shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(
  
    helpText("To see the effects of bias just click the point that will be removed."),
    helpText("To use toggle points, highlight the area of points in question and then hit toggle points. This will invert the selected points' statuses."),
    numericInput("sampsize", "Sample Size:", 25),
    helpText("To see examples of pre-established biases using a third hidden variable, select one of the following."),
    helpText("Note: Changing this variable will reset the graph's settings."),
    selectInput("selection", "Select what variable there will be bias for:", choices = biasChoices),
    helpText("Upper Arm Length: Baboons with an upper arm length of less than 15 inches will be excluded [Lower 18.72%]."),
    helpText("Age: Baboons over 12 years old will be excluded [Upper 19.21%]."),
    helpText("Skinfold Depth: Baboons with over a 7 on the skinfold intentsity scale will be excluded [Upper 15.27%].")
    numericInput("sampleTimes", "Number of Samples Taken:", 20)
    numericInput("numBins", "Number of Bins:", 5)),
  
  mainPanel(
      textOutput("meansd1"),
      plotOutput("plot1", height = 350, click = "plot1_click", brush = brushOpts(id = "plot1_brush")),
      actionButton("exclude_toggle", "Toggle points"),
      actionButton("exclude_reset", "Reset"),
      plotOutput("plot2"),
      plotOutput("plot3")
    )
  )
)
