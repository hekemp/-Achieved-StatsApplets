library(shiny)
               
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Illustrating Correlation in Data"),

  # Sidebar with input for correlation and number of observations
  sidebarPanel(
#    "INPUTS",

    sliderInput("rho", "Corrlelation:", min = 0, max = 1, value = 0.5, step=0.01),
    selectInput("nr_obs", "Number of observations:", c(50,100,500,1000,10000,100000), selected =1000, multiple = FALSE),
    br(),
    "Note: The observations are distributed accorting to a standard bivariate distribution with correlation r."
    ),

  mainPanel(plotOutput("scatterplot",height="800px"))

))
