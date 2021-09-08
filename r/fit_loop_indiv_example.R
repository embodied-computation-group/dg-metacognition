fit_data = data.frame()

for(s in 1:length(subjects)) {
  #foreach (s = 1:length(subjects), .combine=rbind) %dopar%  { # for parallel computing.. wip.. 
  
  
  for(m in 1:length(modalities)) {
    
    
    tryCatch(
      expr = {
        # subset data for subject and modality 
        subdata <- filter(metadata, subject == subjects[s] & modality == modalities[m])  
        
        #transform trial data to counts
        newlist <- trials2counts(subdata$signal, subdata$response, subdata$confidence,7, padAmount = 1,padCells=1)
        nR_S1 <- unlist(newlist[1], recursive = TRUE, use.names = TRUE)
        nR_S2 <- unlist(newlist[2], recursive = TRUE, use.names = TRUE)
        
        #fit model
        fit <- fit_meta_d_MLE(nR_S1, nR_S2)
        #glimpse(subdata)
        #Sys.sleep(1)
        
        output <- data.frame("subject" = subjects[s],"modality"=modalities[m],
                             "da" = fit$da[1], "mda" = fit$meta_da[1],
                             "mratio" = fit$M_ratio[1])  
        
        fit_data <- rbind(fit_data, output)
      },
      error = function(e) {
        message("* caught an error on subject ", subjects[s])
        print(e)
        output <- data.frame("subject" = subjects[s],
                             "modality"=modalities[m],"da" = NaN,
                             "mda" = NaN, "mratio" = NaN) 
        fit_data <- rbind(fit_data, output)
        
      }
      
      
    )
    
  }
  
}