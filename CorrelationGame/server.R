library(shiny)

if (!"MASS" %in% installed.packages()) install.packages("MASS")
library(MASS) 

shinyServer(function(input,output){

  output$scatterplot <- renderPlot({

# Bivariate normal distribution parameters
mu1  <- 0
mu2  <- 0
sig1 <- 1
sig2 <- 1
rho  <- input$rho

# Generate random shots
shots <- mvrnorm(n=as.numeric(input$nr_obs),mu=c(mu1,mu2),Sigma=matrix(c(sig1,rho,rho,sig2),2))

# Plot the shots
plot(shots,xlim=c(-4,4),ylim=c(-4,4),xlab="y1",ylab="y2",col="dark blue",pch=20)


  })  
})


