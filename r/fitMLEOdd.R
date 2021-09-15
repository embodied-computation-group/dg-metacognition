fit_mleOdd <- function (subjects, modalities, s, m) {
  
  library(here)
  library(metaSDT)
  
  source(here("r", "remove_outliers.R"))
  source(here("r", "trials2counts.R"))
  source(here("r", "metad_indiv.R"))
  
  
  tryCatch(
    expr = {
      # subset data for subject and modality 
      subdata <- filter(metadataOdd, subject == subjects[s] & modality == modalities[m])  
      
      #transform trial data to counts
      newlist <- trials2counts(subdata$signal, subdata$response, subdata$confidence, 7, padAmount = 1,padCells=1)
      nR_S1 <- unlist(newlist[1], recursive = TRUE, use.names = TRUE)
      nR_S2 <- unlist(newlist[2], recursive = TRUE, use.names = TRUE)
      
      #fit model
      fit <- fit_meta_d_MLE(nR_S1, nR_S2)
      #glimpse(subdata)
      #Sys.sleep(1)
      
      Results <- data.frame("subject" = subjects[s],"modality"=modalities[m],
                            "da" = fit$da[1], "mda" = fit$meta_da[1],
                            "mratio" = fit$M_ratio[1], "c" = fit$criterion[1])  
      return(Results)  
      
    },
    error = function(e) {
      # message("* caught an error on subject ", subjects[s])
      # print(e)
      Results <- data.frame("subject" = subjects[s],
                            "modality"=modalities[m],"da" = NaN,
                            "mda" = NaN, "mratio" = NaN, "c" = NaN) 
      
      return(Results)  
    }
    
    
  )
  
  
  
}