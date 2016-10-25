library(shiny)

if (!"MASS" %in% installed.packages()) install.packages("MASS")
library(MASS) 

shinyServer(function(input,output){
  
nr_obs2 = 50
nr_obs = 100

mu1  <- 100
mu2  <- 100
sig1 <- 100
sig2 <- 100
  
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
    rho  <- vals$rValue

    # Generate random shots
    shots <- mvrnorm(n=as.numeric(nr_obs),mu=c(mu1,mu2),Sigma=matrix(c(sig1,rho*100,rho*100,sig2),2))
      
    valu$answerChecked = 0
    val$messageToReturn = ""
      
    })
  
  
  observeEvent(input$checkAnswer, {
  
    print(valuePlot$numGuessed)
    print(length(guessPlot$guess))
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
    
rho  <- vals$rValue

# Generate random shots
shots <- mvrnorm(n=as.numeric(nr_obs),mu=c(mu1,mu2),Sigma=matrix(c(sig1,rho*100,rho*100,sig2),2))

# Plot the shots
plot(shots, xlim=c(60,140),ylim=c(60,140), xlab="X",ylab="Y",col="dark blue",pch=20)


  })
  
    output$results <- renderPlot({
    if(length(guessPlot$guess) == 0)
      {negThrees = {}
      for(i in 1:21){
        negThrees[i] = -3
      }
      plot(x = seq(0,20), y = negThrees, ylim = c(-2,2), xlab = "Trial", ylab = "Difference (Guess - Actual)")
       abline(h=0)
      }
      
    else if(length(guessPlot$guess) == 1){
      negThrees = {}
      negThrees[1] = -3
      negThrees[2] = guessPlot$guess[1]
      for(i in 3:21){
        negThrees[i] = -3
      }
      
   plot(x = seq(0,20), y = negThrees, ylim=c(-2,2), xlab = "Trial", ylab = "Difference (Guess - Actual)")
   abline(h=0)}
      
    else if(length(guessPlot$guess) <= 20){
      negThrees = {}
      negThrees[1] = -3
      print(1:length(guessPlot$guess))
      print(length(guessPlot$guess)+1:21)
      for(i in 0:length(guessPlot$guess)+1){
        negThrees[i+1] = guessPlot$guess[i]
      }
      for(i in length(guessPlot$guess)+2:21){
        negThrees[i] = -3
      }
      
   plot(x = seq(0,20), y = negThrees[1:21], ylim=c(-2,2), xlab = "Trial", ylab = "Difference (Guess - Actual)")
   abline(h=0)}
    else{
      negThrees = {}
      negThrees[1] = -3
      for(i in 2:length(guessPlot$guess)+1){
        negThrees[i] = guessPlot$guess[i]
      }
      plot(x = seq(0,length(guessPlot$guess)), y = guessPlot$guess, ylim=c(-2,2), xlab = "Trial", ylab = "Difference (Guess - Actual)")
   abline(h=0)}
      

})
  
  output$secondResults <- renderPlot({
    if(length(guessPlot2$guess2) == 0)
      {plot(-3, xlim=c(-1,1),ylim = c(-1,1), xlab = "Actual", ylab = "Guess")
       lines(x= seq(-2,2), y=seq(-2,2) ,type="l", col="blue")
      }
    else{
  #plot(x = seq(1,length(valuPlot$numRight)), y = valuPlot$numRight)
   plot(y = guessPlot2$guess2 , x = guessPlot3$guess3, xlim = c(-1,1),ylim=c(-1,1), xlab = "Actual", ylab = "Guess")
   lines(x= seq(-2,2), y=seq(-2,2) ,type="l", col="blue")
    }
  })
})
