generatePoisson<- function(lambda,n){
  x<- replicate(n,0)
  for (i in 1:n){
    k <- 1;
    produ <- 1;
    produ = produ * runif(1,0,1);
    while (produ >= exp(-lambda)){
      produ = produ * runif(1,0,1);
      k = k + 1;
    }
    x[i] = k;
  }
  x
}

#Plot poisson
plotPoisson<- function(n){
  n = 500;
  lambda = 3;
  poisson = generatePoisson(lambda, n);
  xPoisson <- seq(min(poisson), max(poisson), 1)
  fPoisson <- replicate(n,0)
  for(i in 1:n){
    fPoisson[i] <- dim(which(poisson<xPoisson[i]))/n
  } 
  plot(xPoisson,fPoisson,'r')
}


