source(here("r", "fitMLEEven.R"))
source(here("r", "fitMLEOdd.R"))

#Split the trials by odd and even:
metadataEven <-metadata %>% filter(trial %% 2==0)
metadataOdd <- metadata %>% filter(trial %% 2!=0)

#Fit the even trials:

subjects = unique(metadataEven$subject) # subjects vector, for looping
modalities = as.character(unique(metadataEven$modality)) # modalities vector, for looping


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
source(here("r", "parMLEEven.R"))

# stop the cluster
stopCluster(cl = my.cluster)

# write out the data file
write.csv(fit_dataEven, file = here("data_summary","mle_mratio_fit_dataEven.csv"))


#Fit the odd trials:

subjects = unique(metadataOdd$subject) # subjects vector, for looping
modalities = as.character(unique(metadataOdd$modality)) # modalities vector, for looping


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
source(here("r", "parMLEOdd.R"))

# stop the cluster
stopCluster(cl = my.cluster)

# write out the data file
write.csv(fit_dataOdd, file = here("data_summary","mle_mratio_fit_dataOdd.csv"))



#Exclude outliers based on mratio, using the MAD rule 

#Exclude those where mratio could not be estimated  
metadata_exc_even <- fit_dataEven%>%filter(mratio!="NaN")
metadata_exc_odd <- fit_dataOdd%>%filter(mratio!="NaN")

#mratio - MAD rule 
metadata_exc_even <- metadata_exc_even%>%
  group_by(modality) %>%
  mutate(mratio = remove_outliers_robust(mratio)) # remove RT outliers using MAD Rule 
metadata_exc_odd <- metadata_exc_odd%>%
  group_by(modality) %>%
  mutate(mratio = remove_outliers_robust(mratio)) # remove RT outliers using MAD Rule 

#Pivot the data frame to wide.
#Even:
fit_data_wideEvenF <- metadata_exc_even %>% pivot_wider(
  names_from = modality,
  values_from = c(da, mda, mratio, c)
)
colnames(fit_data_wideEvenF) <- paste0("Even_", colnames(fit_data_wideEvenF)) 

#Odd:
fit_data_wideOddF <- metadata_exc_odd %>% pivot_wider(
  names_from = modality,
  values_from = c(da, mda, mratio, c)
)
colnames(fit_data_wideOddF) <- paste0("Odd_", colnames(fit_data_wideOddF))

#join the two dataframes: 
wide_data_fil <- full_join(fit_data_wideEvenF, fit_data_wideOddF, by =c("Even_subject" = "Odd_subject" )) 

write.csv(wide_data_fil, file = here("data_summary","mle_mratio_fit_data_wide_fil.csv"))

