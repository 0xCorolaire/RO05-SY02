generateOneThird <- function(n){
  x = zeros(n, 1)
  for (i in 1:n){
    u = runif(1,1,1)
  }
  if (u < 1 / 3){
    x(i) = -1
  } else if (u < 2 / 3){
    x(i) = 0
  } else{
    x(i) = 1
  }
}