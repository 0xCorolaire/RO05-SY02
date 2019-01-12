# function to generate standard Normal using the Box-Muller transformations 
BoxMullerMethod <- function(n.gen){ 
  urandom1 <- runif(n.gen) 
  urandom2 <- runif(n.gen) 
  Rsq <- -2*log(urandom1) 
  theta <- 2*pi*urandom2 
  x <- sqrt(Rsq)*cos(theta) 
  y <- sqrt(Rsq)*sin(theta) 
  # combine independent x and y 
  z <- (x+y)/sqrt(2) 
  # output 
  z 
}