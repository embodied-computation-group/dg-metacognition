

mle_fit_data  <-  foreach (s = 1:length(subjects), .combine=rbind, .errorhandling = 'pass') %:%   
  
  foreach (m = 1:length(modalities), .combine = rbind)  %dopar% {
    
    fit_mle(subjects, modalities, s, m)
    
  }
  


