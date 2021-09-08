fit_HmetaCorr  <- function (subjects, modalities, s, m) {
  
  library(here)
  
  source(here("r", "trials2counts.R"))
  source(here("r", "metad_indiv.R"))
  source(here("r", "Bayes_metad_hierarchical.R"))
  
  tryCatch(
    expr = {
      # subset data for subject and modality 
      subdata <- filter(metadata, subject == subjects[s] & modality == modalities[m])  
      
      #transform trial data to counts
      newlist <- trials2counts(subdata$signal, subdata$response, subdata$confidence, 7, padAmount = 1,padCells=1)
      nR_S1 <- unlist(newlist[1], recursive = TRUE, use.names = TRUE)
      nR_S2 <- unlist(newlist[2], recursive = TRUE, use.names = TRUE)
      
      #fit model
      fit <- metad_groupcorr(nR_S1, nR_S2)
      #glimpse(subdata)
      #Sys.sleep(1)
      
      Results <- coda.samples(model = fit$model, variable.names = fit$variable.names,
                              n.iter=fit$n.iter, thin=fit$thin)
        
        "subject" = subjects[s],"modality"=modalities[m],
                            "Corr" = fit$model, "mda" = fit$meta_da[1],
                            "mratio" = fit$M_ratio[1], "c" = fit$criterion[1])  
      
      output <- coda.samples( 
        model          = cor_model,
        variable.names = c("mu_logMratio", "sigma_logMratio", "rho", "Mratio", "mu_c2"),
        n.iter         = 10000,
        thin           = 1 )
      
      
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
