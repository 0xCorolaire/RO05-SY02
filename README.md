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
