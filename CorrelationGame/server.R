library(shiny)

if (!"MASS" %in% installed.packages()) install.packages("MASS")
library(MASS) 

shinyServer(function(input,output){

vals <- reactiveValues(
  rValue = runif(1, min=-1, max=1))
  
val <- reactiveValues(
  messageToReturn = "")
  
  observeEvent(input$newPlot, {
       vals$rValue <- runif(1, min=-1, max=1)
    })
  
  
  observeEvent(input$checkAnswer, {
  
   # if(abs(input$rho) - abs(vals$rValue) < .3 || abs(input$rho) - abs(vals$rValue) > -.3 )
   if(input$rho - vals$rValue < .1 & input$rho - vals$rValue > -.1)
   {val$messageToReturn <- "That's correct! R = " + paste(vals$rValue)
   }
    if(input$rho - vals$rValue > .1 || input$rho - vals$rValue < -.1)
      {if(input$rho - vals$rValue <= 1 || input$rho - vals$rValue >= -1)
        {if(vals$rValue < input$rho)
            {val$messageToReturn <- "That guess was too high. R = "}

         if(vals$rValue > input$rho)
          {val$messageToReturn <- "That guess was too low. R = "}
      
      if((input$rho - vals$rValue <= .3 & input$rho - vals$rValue >= .1) || (input$rho - vals$rValue >= -.3 & input$rho - vals$rValue <= -.1))
        {if(vals$rValue < input$rho)
            {val$messageToReturn <- "That guess was a little too high. R = "}

         if(vals$rValue > input$rho)
          {val$messageToReturn <- "That guess was a little too low. R = "}

        }
      }
  }
  }
  )
  
  getResult <- function() {
     paste(val$messageToReturn)
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
