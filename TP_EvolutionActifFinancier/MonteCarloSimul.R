N = 1000; 
T = 1; 
h = 0.05;
S0 = 1;
mu = 0.05;
sigma = 0.3;
M = T / h;
somme  = 0; 
Nb = N / M;

calculSn <- function() {
  Y <- replicate(n,0)
  for (n in 1:20) {
    Z<- runif(1)
    Y[n]<- S0*exp((mu-0.5*sigma^2)*n*h+sigma*sqrt(n*h)*Z) 
  }
  return(Y)
}

t<- c(1:20)
t<- 0.05*t

X <- replicate(N,calculSn())
Xmean <- rowMeans(X)
plot(t,Xmean, xlab='Temps t' ,ylab='Valeur de l\'actif financier S(t)')

