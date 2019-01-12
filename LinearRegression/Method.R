TwoSamplesGenerator <- local({
  generate_dataset <- function(outcome_, alpha_, gen_func_, test_func_, ...) {
    repeat {
      ds <- gen_func_()
      if ((test_func_(ds, ...)$p.value < alpha_) == outcome_) 
        break
    }
    ds
  }
  generate_dataset(runif(1) > 0.5, 0.1, function() {
    data.frame(A = rnorm(128, sd = 1), B = rnorm(128, sd = 1))
  }, function(ds, ...) {
    var.test(ds$A, ds$B, alternative = "less", conf.level = 0.9)
  })
})
par(mfrow=c(2,2))
# plot datas
plot(TwoSamplesGenerator$A,TwoSamplesGenerator$B)
#Do the linear study
rm<-lm(B~A,data=TwoSamplesGenerator)
# get coefficients of graph
intercept<-rm$coefficients[1]
b<-rm$coefficients[2]
abline(intercept,b)
#summarize
summary(rm)
#Q - Q plot
qqnorm(rm$residuals)
qqline(rm$residuals)
plot(rm$fitted.values,rm$residuals) # check independancy
#give a Condifence Interval
confint(rm,level=0.99)
# get a prediction either on predict or on confiance
newData=data.frame(A=c(1.1))
pred <- predict(rm,newData,interval="predict")


# prediction 
set.seed(100)

trainingRowIndex <- sample(1:nrow(TwoSamplesGenerator), 0.8*nrow(TwoSamplesGenerator))
trainingData <- TwoSamplesGenerator[trainingRowIndex, ]
testData  <- TwoSamplesGenerator[-trainingRowIndex, ]
lmMod <- lm(B ~ A, data=trainingData)


library(DAAG)
cvResults <- suppressWarnings(CVlm(df=TwoSamplesGenerator, form.lm=B ~ A, m=5, dots=FALSE, seed=29, legend.pos="topleft",  printit=FALSE, main="Small symbols are predicted values while bigger ones are actuals."));
attr(cvResults, 'ms')