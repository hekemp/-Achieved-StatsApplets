library(shiny)

if (!"MASS" %in% installed.packages()) install.packages("MASS")
library(MASS) 

shinyServer(function(input,output){

vals <- reactiveValues(
  rValue = runif(1, min=-1, max=1))
  
val <- reactiveValues(
  messageToReturn = "")
  
valu <- reactiveValues(
  answerChecked = 0)

valuPlot <- reactiveValues(
  numRight = {})
  
valuePlot <- reactiveValues(
  numGuessed = 1)
  
valuePlot2 <- reactiveValues(
  numGuessedRight = 0)
  
  observeEvent(input$newPlot, {
       vals$rValue <- runif(1, min=-1, max=1)
    })
  
  observeEvent(input$resetScore, {
    valuPlot$numRight = {}
    valuePlot$numGuessed = 1
    valuePlot2$numGuessedRight = 0
    })
  
    observeEvent(input$newPlot, {
    
    vals$rValue = runif(1, min=-1, max=1)
    mu1  <- 0
    mu2  <- 0
    sig1 <- 1
    sig2 <- 1
    rho  <- vals$rValue

    # Generate random shots
    shots <- rellipticalCopula(n=as.numeric(input$nr_obs),rho=rho)
      
    valu$answerChecked = 0
    val$messageToReturn = ""
      
    })
  
#  valuPlot <- reactiveValues(
#  numRight = {})
  
#valuePlot <- reactiveValues(
 # numGuessed = 1)
  
#  valuePlot2 <- reactiveValues(
#  numGuessedRight = 0)
  
  observeEvent(input$checkAnswer, {
  if(valu$answerChecked <= 0){
   # if(abs(input$rho) - abs(vals$rValue) < .3 || abs(input$rho) - abs(vals$rValue) > -.3 )
   if(input$rho - vals$rValue <= .1 & input$rho - vals$rValue >= -.1)
   {#val$messageToReturn <- "That's correct! R = " + paste(vals$rValue)
     val$messageToReturn <- paste("That's correct! R = ", round(vals$rValue,3))
     valuePlot2$numGuessedRight = valuePlot2$numGuessedRight + 1
     valu$answerChecked <- 1
     valuPlot$numRight[valuePlot$numGuessed]= valuePlot2$numGuessedRight
     valuePlot$numGuessed = valuePlot$numGuessed + 1
   }
    if(input$rho - vals$rValue > .1 || input$rho - vals$rValue < -.1)
      {if(input$rho - vals$rValue <= 1 || input$rho - vals$rValue >= -1)
        {if(vals$rValue < input$rho)
            {val$messageToReturn <- paste("That guess was too high. R = ", round(vals$rValue,2))
             valu$answerChecked <- 1
            valuPlot$numRight[valuePlot$numGuessed]= valuePlot2$numGuessedRight
            valuePlot$numGuessed = valuePlot$numGuessed + 1
            }

         if(vals$rValue > input$rho)
          {val$messageToReturn <- paste("That guess was too low. R = ", round(vals$rValue,2))
          valu$answerChecked <- 1
          valuPlot$numRight[valuePlot$numGuessed]= valuePlot2$numGuessedRight
          valuePlot$numGuessed = valuePlot$numGuessed + 1
          }
      
      if((input$rho - vals$rValue <= .3 & input$rho - vals$rValue > .1) || (input$rho - vals$rValue >= -.3 & input$rho - vals$rValue < -.1))
        {if(vals$rValue < input$rho)
            {val$messageToReturn <- paste("That guess was a little too high. R = ", round(vals$rValue,2))
            valu$answerChecked <- 1
            valuPlot$numRight[valuePlot$numGuessed]= valuePlot2$numGuessedRight
            valuePlot$numGuessed = valuePlot$numGuessed + 1
            }

         if(vals$rValue > input$rho)
          {val$messageToReturn <- paste("That guess was a little too low. R = ", round(vals$rValue,2))
          valu$answerChecked <- 1
          valuPlot$numRight[valuePlot$numGuessed]= valuePlot2$numGuessedRight
          valuePlot$numGuessed = valuePlot$numGuessed + 1
          }
        }
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
shots <- rellipticalCopula(n=as.numeric(input$nr_obs),rho=rho)

# Plot the shots
plot(shots*100,xlim=c(0,100),ylim=c(0,100),xlab="x",ylab="y",col="dark blue",pch=20)


  })
  
    output$results <- renderPlot({
  plot(x = seq(1,valuePlot$numGuessed), y = valuPlot$numRight)
})

})
