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

OneSampleGenerator <- local({
  generate_dataset <- function(outcome_, alpha_, gen_func_, test_func_, ...) {
    repeat {
      ds <- gen_func_()
      if ((test_func_(ds, ...)$p.value < alpha_) == outcome_) 
        break
    }
    ds
  }
  generate_dataset(runif(1) > 0.5, 0.01, function() {
    eval(rnorm(128, mean = 2L, sd = 0.4))
  }, function(ds, ...) {
    eval(ks.test(ds, "pnorm", mean = 2L, sd = 0.4))
  })
})