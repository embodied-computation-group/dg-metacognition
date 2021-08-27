fit_HmetaCorr <- function (subjects, modalities, s, m) {

  library(here)
  library(metaSDT)
  
  source(here("r", "trials2counts.R"))
  source(here("r", "Bayes_metad_hierarchical.R"))
  

tryCatch(
  expr = {
    # subset data for subject and modality 
    subdata <- filter(metadata, subject == subjects[s] & modality == modalities[m])  
    
    #transform trial data to counts
    newlist <- trials2counts(subdata$signal, subdata$response, subdata$confidence, 7, padAmount = 1,padCells=1)
    nR_S1 <- unlist(newlist[1], recursive = TRUE, use.names = TRUE)
    nR_S2 <- unlist(newlist[2], recursive = TRUE, use.names = TRUE)
    
    fit <- metad_groupcorr(nR_s1, nR_S2)
    
    Results <- data.frame("subject" = subjects[s],"modality"=modalities[m],
                          "corr"=fit$rho, "Mratio"=fit$Mratio)
    return(Results)  
  }
)
  
}