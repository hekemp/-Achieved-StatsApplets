library(shiny)
               
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("The Correlation Guessing Game"),

  # Sidebar with input for correlation and number of observations
  sidebarPanel(
#    "INPUTS",

    selectInput("nr_obs", "Number of observations:", c(50,100,500,1000,10000), selected =100, multiple = FALSE),
    br(),
    sliderInput("rho", "Estimated Corrlelation:", min = -1, max = 1, value = 0.5, step=0.01),
    textOutput("guessResult"),
    actionButton("checkAnswer", "Check Answer \n"),
    br(),
    actionButton("newPlot", "Get New Plot"),
    br(),
    actionButton("resetScore", "Reset Score \n"),
    br(),
    br(),
    "Note: The observations are distributed accorting to a standard bivariate distribution with correlation r."
    ),

  mainPanel(plotOutput("scatterplot",height="400px"), plotOutput("results"))


))
