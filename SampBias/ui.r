# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

biasChoices <<- list("Default" = "default", "Upper Arm Length" = "armLength", "Age" = "age", "Skinfold Depth" = "skinfold", "Rank in Tribe" = "ranking", "Location" = "location")

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
    helpText("Skinfold Depth: Baboons with over a 7 on the skinfold intentsity scale will be excluded [Upper 15.27%]."),
    helpText("Rank in Tribe: Baboons that are at the top of the tribe (ranked from 0.9 to 1.0) will be excluded [Upper 13.79%]."),
    helpText("Location: Baboons from the sampling sites H and J will be excluded [18.72% of population]."
    helpText(" "),
    helpText("This section of the applet will draw the number of samples you specify from your biased population and plot the mean mass of these samples in a histogram using the number of bins of your choosing."),
    helpText("The population's mean is displayed on the histogram as a red block."),
    helpText("Note: Changing either of these variables will reset the histograms settings and thus your samples."),
    numericInput("sampleTimes", "Number of Samples Taken:", 20),
    sliderInput("numBins", "Number of Bins:", 1, 100, 10, 1)),
  
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
