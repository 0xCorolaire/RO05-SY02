d<-50;
n<-100;
N<-1000;
A<-c(0,0);
Y<-c(0,0);
for (j in 1:n) {
  A[j]<- c(0) 
}
Ehrenfest <- function(A) { 
  for (l in 1:d) { 
    Y[l]<- c(0) 
  } 
  for (j in 1:n) {
    A[j]<- c(0) 
  } 
  for(i in 1:n){
    Z<-floor(runif(1, min=1, max=50)) 
    if(Y[Z]==0){
      Y[Z]<-1 
    }else{ 
      Y[Z]<-0 
    } 
    a<-0 
    for (k in 1:d) {
      if(Y[k]==1){
        a<-a+1
      } 
    } 
    A[i]<-a 
  }
  return(A)
}

simulateEhr<-function(){
  t<- c(1:n)
  L<-Ehrenfest(A); 
  plot(t,L, xlab='n-ieme tirage' ,ylab='Nombre de boules dans A');
}

simulateMeanEhr<-function(){
  X <- replicate(N,Ehrenfest(A))
  Xmean <- rowMeans(X)
  plot(t,Xmean, xlab='n-i`eme tirage' ,ylab='Nombre moyen de boules dans A')
}

