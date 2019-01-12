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


