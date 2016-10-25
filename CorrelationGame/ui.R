library(shiny)
               
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("The Correlation Guessing Game"),

  # Sidebar with input for correlation and number of observations
  sidebarPanel(
#    "INPUTS",

    "Guesses will be considered correct if they are within +/- .1 of the true R value.",
    br(),
    sliderInput("rho", "Estimated Corrlelation:", min = -1, max = 1, value = 0.5, step=0.01),
    textOutput("guessResult"),
    HTML(paste("Hello", tags$span(style="color:red", "red"), sep = "")),
    actionButton("checkAnswer", "Check Answer \n"),
    br(),
    actionButton("newPlot", "Get New Plot"),
    br(),
    actionButton("resetScore", "Reset Score \n"),
    br(),
    br(),
    "Note: The observations are distributed accorting to a standard bivariate distribution with correlation r."
    ),

  mainPanel(plotOutput("scatterplot",height="800px"), plotOutput("results"), plotOutput("secondResults"))


))
