# This example converts the Reeses Pieces Applet seen here:
# http://www.rossmanchance.com/applets/Reeses/ReesesPieces.html
# to a shiny app.

library(shiny)

biasChoices <<- list("Default" = "default", "Baboons with the shortest upper arm length (inches) [~Lower 20%]" = "armLength", "Oldest baboons (years) [~Upper 20%]" = "age", "Baboons with the most skinfolds (mm) [~Upper 20%]" = "skinfold", "Ranked highest in the tribe [~Upper 20%]" = "ranking", "From sampling sites H and J [~20%]" = "location")
populationChoices <<- list("All Baboons" = "all", "Male Baboons" = "males", "Female Baboons" = "females")


shinyUI(pageWithSidebar(
  
  headerPanel("Sampling Bias"),
  
  sidebarPanel(
  
    radioButtons("popSelect", "Select a population to use for your samples:", choices = populationChoices),
    helpText("To see the effects of bias just click the point that will be removed."),
    helpText("To use toggle points, highlight the area of points in question and then hit toggle points. This will invert the selected points' statuses."),
    numericInput("sampsize", "Sample Size:", 25),
    helpText("To see examples of pre-established biases using a third hidden variable, select one of the following."),
    helpText("Note: Changing this variable will reset the graph's settings."),
    selectInput("selection", "Select a group of baboons to exclude:", choices = biasChoices),
    helpText(" "),
    helpText("To take a sample from the biased population using your selected sample size, click one of the buttons below."),
    helpText("A histogram will be constructed using the mean of the mass per sample with the number of bins you specify."),
    helpText("The selected population's mean is displayed on the histogram as a red line."),
    helpText("The entire population's mean is displayed on the histogram as a purple line."),
    helpText("Note: Samples drawn from a single point are not supported in this part of the applet."),
    helpText("If you draw a sample and it doesn't show up, this means that the server had a bad time obtaining your sample. Just change either the population or bias scenario to something else momentarily and then the server will be ready to process your request again."),
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
