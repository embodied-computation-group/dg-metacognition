
library(tidyverse)
library(magrittr)
library(reshape2)
library(rjags)
library(coda)
library(lattice)
library(broom)
#library(ggpubr)
library(ggmcmc)

metad_indiv <- function (nR_S1, nR_S2) {
  
  Tol <- 1e-05
  nratings <- length(nR_S1)/2
  
  # Adjust to ensure non-zero counts for type 1 d' point estimate
  adj_f <- 1/((nratings)*2)
  nR_S1_adj = nR_S1 + adj_f
  nR_S2_adj = nR_S2 + adj_f
  
  ratingHR <- matrix()
  ratingFAR <- matrix()
  
  for (c in 2:(nratings*2)) {
    ratingHR[c-1] <- sum(nR_S2_adj[c:length(nR_S2_adj)]) / sum(nR_S2_adj)
    ratingFAR[c-1] <- sum(nR_S1_adj[c:length(nR_S1_adj)]) / sum(nR_S1_adj)
    
  }
  
  t1_index <- nratings
  d1 <<- qnorm(ratingHR[(t1_index)]) - qnorm(ratingFAR[(t1_index)])
  c1 <<- -0.5 * (qnorm(ratingHR[(t1_index)]) + qnorm(ratingFAR[(t1_index)]))
  
  counts <- t(nR_S1) %>% 
    cbind(t(nR_S2))
  counts <- as.vector(counts)
  
  # Data preparation for model
  data <- list(
    d1 = d1,
    c1 = c1,
    counts = counts,
    nratings = nratings,
    Tol = Tol
  )
  
  ## Model using JAGS
  # Create and update model
  model <- jags.model(file = 'Bayes_metad_indiv_R.txt', data = data,
                      n.chains = 3, quiet=FALSE)
  update(model, n.iter=1000)
  # Sampling
  output <- coda.samples( 
    model          = model,
    variable.names = c("meta_d", "cS1", "cS2"),
    n.iter         = 10000,
    thin           = 1 )
  #Sum
  Value <- summary(output)
  stat <- data.frame(mean = Value[["statistics"]][, "Mean"])
  stat %<>%
    rownames_to_column(var = "name")
  # Rhat
  Value <- gelman.diag(output, confidence = 0.95)
  Rhat <- data.frame(conv = Value$psrf)
  # HDI
  HDI <- data.frame(HPDinterval(output, prob = 0.95))
  HDI %<>%
    rownames_to_column(var = "name")
  # All values in the same dataframe
  Fit <- stat %>%
    cbind(lower = HDI$lower,upper = HDI$upper)
  #Filter
  Fit <- Fit[-c(1:12), ]
  Fit$d <- data$d1
  Fit$criterion <- data$c1
  Fit$ratingHR <- mean(ratingHR)
  Fit$ratingFAR <- mean(ratingFAR)
  Fit$mratio <-Fit$mean/Fit$d
  return(Fit)
}
