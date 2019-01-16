# RO05
Random phenomenon modeling with R

# TP1 : General and BoxMuller
During this maths practical, we will have the opportunity to generate achievements according to several laws: Gaussian law, Weibull law, Poisson law.. from pseudo-random number realizations following a uniform law $\mathcal{U}([0, 1])$.
BoxMuller Method

# TP2 : MonteCarlo simulation
We have a European option representing a fi nancial asset whose value at time t is $S(t)$
The goal is to give the average evolution of the value of the asset based on MonteCarlo Method

# TP3 : Markov Chain and MonteCarlo simulation
In a space divided into two compartments A and B we have d balls
With each experiment we draw a number with uniform probability in ${1, ..., d}$. If the ball with the number drawn is in compartment A, then it is placed in compartment B and vice versa.

# Linear regression
## STATISTIC	CRITERION
R-Squared       : 	Higher the better (> 0.70)
Adj R-Squared	  :   Higher the better
F-Statistic	    :   Higher the better
Std. Error	    :   Closer to zero the better
t-statistic	    :   Should be greater 1.96 for p-value to be less than 0.05
AIC	            :   Lower the better
BIC	            :   Lower the better
Mallows cp      : 	Should be close to the number of predictors in model
MAPE (Mean absolute percentage error)	Lower the better
MSE (Mean squared error)	Lower the better
Min_Max Accuracy => mean(min(actual, predicted)/max(actual, predicted))	Higher the better

## Predict linear model
Step 1: Create the training (development) and test (validation) data samples from original data.
```
set.seed(100)  # setting seed to reproduce results of random sampling
trainingRowIndex <- sample(1:nrow(cars), 0.8*nrow(cars))  # row indices for training data
trainingData <- cars[trainingRowIndex, ]  # model training data
testData  <- cars[-trainingRowIndex, ]   # test data
```
Step 2: Develop the model on the training data and use it to predict the distance on test data
```
lmMod <- lm(B ~ A, data=trainingData)  # build the model
distPred <- predict(lmMod, testData)  # predict distance
```
Step 3: Review measures
```
summary (lmMod)
AIC (lmMod)
```

Step 4: Calculate prediction accuracy and error rates
```
actuals_preds <- data.frame(cbind(actuals=testData$B, predicteds=distPred))
correlation_accuracy <- cor(actuals_preds)
```

Step 5 : get MinMax Accuracy
```
min_max_accuracy <- mean(apply(actuals_preds, 1, min) / apply(actuals_preds, 1, max))  
mape <- mean(abs((actuals_preds$predicteds - actuals_preds$actuals))/actuals_preds$actuals)  
```

# Queueing System

In Kendall’s notation, an M/M/C/K system has exponential arrivals (M/M/C/K), a c servers (M/M/C/K) with exponential service time (M/M/C/K) and an k−c positions in queue (M/M/C/K). For instance, a router may have several processors to handle packets, and the in/out queues are necessarily finite.
This is the simulation of an M/M/2/3 system (2 server, 1 position in queue). Note that the trajectory is identical to an M/M/1 system (one server, infinite queue).
Where M is a Markovian Process, C is the number of server and K the total place in the system.

In order to model the system, we are using R and simmer library :
```
library(simmer)
library(simmer.plot)
set.seed(1234)
```

We have to define the PPH parameter lambda and exponential parameter mu of the servicing time :
```
lambda <- 3
mu <- 4
```
The we setup the environment with simmer properties :
```
m.queue <- trajectory() %>%
  seize("server", amount=1) %>%
  timeout(function() rexp(1, mu)) %>%
  release("server", amount=1)

mm23.env <- simmer() %>%
  add_resource("server", capacity=2, queue_size=1) %>%
  add_generator("arrival", m.queue, function() rexp(1, lambda)) %>%
  run(until=2000)
```

![alt text](https://raw.githubusercontent.com/hugofloter/RO05-SY02/master/QueueingSystem/MM23Syst.png)

We get the rejection if queue if full :
```
get_mon_arrivals(mm23.env) %>%
  with(sum(!finished) / length(finished))
#> [1] 0.04714804
```

Then we consider a multi-server resource that is able to distribute the processing capacity evenly among the arrivals. This means that if, for example, capacity=2 and there is a single arrival in the server, it would be served twice as fast. -> State-dependent service rates
In terms of a simulation model, a state-dependent service rate implies that the time spent in the server must be asynchronously updated each time an arrival seizes or releases the resource.
 - start: simulation time at which the arrival started the last timeout activity.
 - multiplier: distribution of the processing capacity.
 - delay: service delay applied to the last timeout activity.

Comparison on an M/M/2 with this state-dependent system. Both systems are fed with the same interarrival times and, as expected, the average resource usage is significantly reduced.
![alt text](https://raw.githubusercontent.com/hugofloter/RO05-SY02/master/QueueingSystem/MM2Comp.png)
