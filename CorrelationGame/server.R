library(shiny)

if (!"MASS" %in% installed.packages()) install.packages("MASS")
library(MASS) 

shinyServer(function(input,output){

vals <- reactiveValues(
  rValue <- runif(1, min=-1, max=1))
  
  observeEvent(input$newPlot, {
       rValue <- runif(1, min=-1, max=1)
    })
  
  
  correctMessage <- "That's correct!"
  overDotThreePlus <- "That guess was a little too high. Try again!"
  overDotThreeMinus <- "That guess was a little too low. Try again!"
  overDotSixPlus <- "Your guess was too high. Try again!"
  overDotSixMinus <- "Your guess was too low. Try again!"
  
  getResult <- function() {
     paste(correctMessage)
  }

  output$guessResult <- renderText({
    getResult()
  })
  
  
  output$scatterplot <- renderPlot({

# Bivariate normal distribution parameters
mu1  <- 0
mu2  <- 0
sig1 <- 1
sig2 <- 1
rho  <- vals$rValue

# Generate random shots
shots <- mvrnorm(n=as.numeric(input$nr_obs),mu=c(mu1,mu2),Sigma=matrix(c(sig1,rho,rho,sig2),2))

# Plot the shots
plot(shots,xlim=c(-4,4),ylim=c(-4,4),xlab="x",ylab="y",col="dark blue",pch=20)


  })
  
    output$results <- renderPlot({

# Bivariate normal distribution parameters
mu1  <- 0
mu2  <- 0
sig1 <- 1
sig2 <- 1
rho  <- vals$rValue

# Generate random shots
shots <- mvrnorm(n=as.numeric(input$nr_obs),mu=c(mu1,mu2),Sigma=matrix(c(sig1,rho,rho,sig2),2))

# Plot the shots
plot(shots,xlim=c(-4,4),ylim=c(-4,4),xlab="x",ylab="y",col="dark blue",pch=20)


  })  
  
  
})
