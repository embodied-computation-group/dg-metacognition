parMLEfit <- function(subjects, modalities)

n.cores <- parallel::detectCores() - 1

#create the cluster
my.cluster <- parallel::makeCluster(
  n.cores, 
  type = "PSOCK"
)

#check cluster definition (optional)
print(my.cluster)

#register it to be used by %dopar%
doParallel::registerDoParallel(cl = my.cluster)

#check if it is registered (optional)
foreach::getDoParRegistered()

fit_data = data.frame()

#for(s in 1:length(subjects)) {

fit_data <-  foreach (s = 1:length(subjects), .combine=rbind) %:%   # for parallel computing.. wip.. 
  
  foreach (m = 1:4, .combine = rbind)  %dopar% {
    
    fit_mle(subjects, modalities, s, m)
    
  }
  


stopCluster(cl = my.cluster)

return(fit_data)
