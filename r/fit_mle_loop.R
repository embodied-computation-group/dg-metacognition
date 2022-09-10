# setup cluster
n.cores <- parallel::detectCores() - 1 # 1 less than max cores to prevent crashing

# since R can only work with around 120 cores maximum, set an upper limit if needed
if (n.cores > 120) {
  n.cores <- 120
}


#create the cluster
my.cluster <- parallel::makeCluster(
  n.cores, 
  type = "PSOCK"
)

#register it to be used by %dopar%
doParallel::registerDoParallel(cl = my.cluster)


# fit all subjects in parallel
source(here("r", "parMLEfit.R"))

# stop the cluster
stopCluster(cl = my.cluster)

# write out the data file
write.csv(mle_fit_data, file = here("data_summary","mle_mratio_fit_data.csv"))

save(mle_fit_data,file=here("data_summary", "mle_fitdata.Rda"))


