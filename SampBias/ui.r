# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

biasChoices <<- list("Default" = "default", "Excludes baboons with an upper arm length of less than 15 inches (Lower 18.72%)" = "armLength", "Excludes baboons over 12 years old (Upper 19.21%)" = "age", "Excludes baboons with over a 7 on the skinfold intentsity scale (Upper 15.27%)" = "skinfold", "Excludes baboons ranked from 0.9 to 1.0 in the tribe (Upper 13.79%)" = "ranking", "Excludes baboons from sampling sites H and J (18.72% of population)" = "location")

shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(
  
    helpText("To see the effects of bias just click the point that will be removed."),
    helpText("To use toggle points, highlight the area of points in question and then hit toggle points. This will invert the selected points' statuses."),
    numericInput("sampsize", "Sample Size:", 25),
    helpText("To see examples of pre-established biases using a third hidden variable, select one of the following."),
    helpText("Note: Changing this variable will reset the graph's settings."),
    selectInput("selection", "Select what variable there will be bias for:", choices = biasChoices),
#    helpText("Upper Arm Length: Baboons with an upper arm length of less than 15 inches will be excluded [Lower 18.72%]."),
#    helpText("Age: Baboons over 12 years old will be excluded [Upper 19.21%]."),
#    helpText("Skinfold Depth: Baboons with over a 7 on the skinfold intentsity scale will be excluded [Upper 15.27%]."),
#    helpText("Rank in Tribe: Baboons that are at the top of the tribe (ranked from 0.9 to 1.0) will be excluded [Upper 13.79%]."),
#    helpText("Location: Baboons from the sampling sites H and J will be excluded [18.72% of population]."),
    helpText(" "),
    helpText("To take a sample from the biased population using your selected sample size, click one of the buttons below."),
    helpText("A histogram will be constructed using the mean of the mass per sample with the number of bins you specify."),
    helpText("The population's mean is displayed on the histogram as a red line."),
    helpText("Note: Samples drawn from a single point are not supported in this part of the applet."),
    helpText("If you can't see your sample, try either decreasing the amount of bins or drawing more samples."),
    actionButton("draw_1_Sample", "Draw 1 Sample \n"),
    actionButton("draw_10_Sample", "Draw 10 Samples \n"),
    textOutput("numSamples"),
    actionButton("clear_Samples", "Clear Samples")),
  
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
