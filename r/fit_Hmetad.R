subjects = unique(metadata$subject) # subjects vector, for looping
modalities = as.character(unique(metadata$modality)) # modalities vector, for

subjects <- subjects[-320]

#Loop over modalities and subjects to get into correct format for model. 

nR_S1 = list() 
nR_S2 = list()

for (m in 1:length(modalities)){
  
  nR_S1_tmp_modality = data.frame((matrix(NA, nrow=14, ncol=319)))
  nR_S2_tmp_modality = data.frame((matrix(NA, nrow=14, ncol=319)))
  
  for (s in 1:length(subjects)){
    
    
    subdata <- filter(metadata, subject == subjects[s] & modality == modalities[m])  
    
    #transform trial data to counts
    newlist <- trials2counts(subdata$signal, subdata$response, subdata$confidence, 7, padAmount = 1,padCells=1)
    nR_S1_tmp <- unlist(newlist[1], recursive = TRUE, use.names = TRUE)
    nR_S2_tmp <- unlist(newlist[2], recursive = TRUE, use.names = TRUE)
    
    nR_S1_tmp_modality[,s] <- nR_S1_tmp
    nR_S2_tmp_modality[,s] <- nR_S2_tmp
    
    
  } 
  nR_S1 [[m]]<- nR_S1_tmp_modality
  nR_S2 [[m]]<- nR_S2_tmp_modality
  
}