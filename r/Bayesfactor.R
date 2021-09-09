bayes <- function(y, x) {
  
  source(here("r", "BootCorci.R"))
  
  bf = correlationBF(y = y, x = x)
 
  ## Sample from the corresponding posterior distribution
  samples = correlationBF(y = y, x = x,
                          posterior = TRUE, iterations = 10000)
  
  plot(samples[,"rho"])
  print(bf)
}