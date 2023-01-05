#Split the data
metadataEven <-metadata %>% filter(trial %% 2==0) %>% mutate(TrialType = "Even")
metadataOdd <- metadata %>% filter(trial %% 2!=0) %>% mutate (TrialType = "Odd")

#Bind the two dataframes: 
metadata <- rbind(metadataEven, metadataOdd)

#Prepare the data for the fit: 

subjects = unique(metadata$subject) # subjects vector, for looping
trials = as.character(unique(metadata$TrialType))
modalities = as.character(unique(metadata$modality))
subjects <- subjects[-320]

nR_S1 = list() 
nR_S2 = list()
nR_S1t = list() 
nR_S2t = list()

for (m in 1:length(modalities)){
  for (t in 1:length(trials)){
    
    nR_S1_tmp_modality = data.frame((matrix(NA, nrow=14, ncol=319)))
    nR_S2_tmp_modality = data.frame((matrix(NA, nrow=14, ncol=319)))
    
    for (s in 1:length(subjects)){
      
      
      subdata <- filter(metadata, subject == subjects[s])  
      
      #transform trial data to counts
      newlist <- trials2counts(subdata$signal, subdata$response, subdata$confidence, 7, padAmount = 1,padCells=1)
      nR_S1_tmp <- unlist(newlist[1], recursive = TRUE, use.names = TRUE)
      nR_S2_tmp <- unlist(newlist[2], recursive = TRUE, use.names = TRUE)
      
      nR_S1_tmp_modality[,s] <- nR_S1_tmp
      nR_S2_tmp_modality[,s] <- nR_S2_tmp
      
      
    } 
    nR_S1t [[t]]<- nR_S1_tmp_modality
    nR_S2t [[t]]<- nR_S2_tmp_modality
    
  }
  nR_S1 [[m]]<- nR_S1t
  nR_S2 [[m]]<- nR_S2t  
}

#Fit the data: (This takes a long time)

#Memory
outputM <- metad_groupcorr(nR_S1[[1]], nR_S2[[1]])
saveRDS(outputM, file = here("data_summary","Split_Mem.rds"))
#Calories
outputC <- metad_groupcorr(nR_S1[[2]], nR_S2[[2]])
saveRDS(outputC, file = here("data_summary","Split_Cal.rds"))
#GDP
outputG <- metad_groupcorr(nR_S1[[3]], nR_S2[[3]])
saveRDS(outputG, file = here("data_summary","Split_GDP.rds"))
#Vision
outputV <- metad_groupcorr(nR_S1[[4]], nR_S2[[4]])
saveRDS(outputV, file = here("data_summary","Split_Vis.rds"))
