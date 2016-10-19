library(shiny)

if (!"MASS" %in% installed.packages()) install.packages("MASS")
library(MASS) 

shinyServer(function(input,output){
  
nr_obs2 = 50
nr_obs = 100
  
  rValueChoices = c(-1.0, -.9, -.8, -.7, -.6, -.5, -.2, 0, .2, .5, .6, .7, .8, .9, 1.0)

vals <- reactiveValues(
  rValue = sample(rValueChoices,1))
  
val <- reactiveValues(
  messageToReturn = "")
  
valu <- reactiveValues(
  answerChecked = 0)

valuPlot <- reactiveValues(
  numRight = {})
  
valuePlot <- reactiveValues(
  numGuessed = 1)
  
guessPlot <- reactiveValues(
  guess = {}
  )

guessPlot2 <- reactiveValues (
  guess2 = {}
  )
  
guessPlot3 <- reactiveValues (
  guess3 = {}
  )
  
valuePlot2 <- reactiveValues(
  numGuessedRight = 0)
  
  observeEvent(input$newPlot, {
       vals$rValue = sample(rValueChoices,1)
    })
  
  observeEvent(input$resetScore, {
    valuPlot$numRight = {}
    valuePlot$numGuessed = 1
    valuePlot2$numGuessedRight = 0
    guessPlot$guess = {}
    guessPlot2$guess2= {}
    guessPlot3$guess3 = {}
    })
  
    observeEvent(input$newPlot, {
    
    vals$rValue = sample(rValueChoices,1)
    mu1  <- 0
    mu2  <- 0
    sig1 <- 1
    sig2 <- 1
    rho  <- vals$rValue

    # Generate random shots
    shots <- rellipticalCopula(n=as.numeric(nr_obs2),rho=rho)
      
    secondData <- mvrnorm(n=as.numeric(nr_obs2),mu=c(mu1,mu2),Sigma=matrix(c(sig1,rho,rho,sig2),2))
      
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
    guessPlot$guess[valuePlot$numGuessed] = input$rho - vals$rValue
    guessPlot2$guess2[valuePlot$numGuessed] = input$rho
    guessPlot3$guess3[valuePlot$numGuessed] = vals$rValue
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
shots <- rellipticalCopula(n=as.numeric(nr_obs2),rho=rho)

secondData <- mvrnorm(n=as.numeric(nr_obs2),mu=c(mu1,mu2),Sigma=matrix(c(sig1,rho,rho,sig2),2))

# Plot the shots
plot(abs(shots)*100,xlim=c(0,100),ylim=c(0,100),xlab="x",ylab="y",col="dark blue",pch=20)
points(abs(secondData)*100,col="dark blue",pch=20)


  })
  
    output$results <- renderPlot({
    if(length(guessPlot$guess) == 0)
      {plot(-3, ylim = c(-2,2))
       abline(h=0)
      }
    else{
  #plot(x = seq(1,length(valuPlot$numRight)), y = valuPlot$numRight)
   plot(x = seq(1,length(guessPlot$guess)), y = guessPlot$guess, ylim=c(-2,2))
   abline(h=0)}
})
  
  output$secondResults <- renderPlot({
    if(length(guessPlot2$guess2) == 0)
      {plot(-3, xlim=c(-1,1),ylim = c(-1,1))
       lines(x= seq(-2,2), y=seq(-2,2) ,type="l", col="blue")
      }
    else{
  #plot(x = seq(1,length(valuPlot$numRight)), y = valuPlot$numRight)
   plot(y = guessPlot2$guess2 , x = guessPlot3$guess3, xlim = c(-1,1),ylim=c(-1,1))
   lines(x= seq(-2,2), y=seq(-2,2) ,type="l", col="blue")
    }
  })
})
