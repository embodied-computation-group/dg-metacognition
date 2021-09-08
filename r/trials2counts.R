trials2counts <- function(stimID, response, rating,nRatings, padAmount = 0,padCells=0){
  
  nR_S1 <- list()
  nR_S2 <- list()
  
  if (padAmount == 0){
    padAmount = 1/(2*nRatings)}
  
  # S1 responses
  for (r in nRatings:1){
    cs1 <- 0
    cs2 <- 0
    for (i in 1:length(stimID)){
      s = stimID[i]
      x = response[i]
      y = rating[i]
      
      if ((s==0) & (x==0) & (y==r)){
        (cs1 <- cs1+1)}
      if ((s==1) & (x==0) & (y==r)){
        (cs2 <- cs2+1)}
    }
    nR_S1 <- append(nR_S1,cs1)
    nR_S2 <- append(nR_S2,cs2)
  }
  
  # S2 responses
  for (r in 1:nRatings){
    cs1 <- 0
    cs2 <- 0
    for (i in 1:length(stimID)){
      s = stimID[i]
      x = response[i]
      y = rating[i]
      
      if ((s==0) & (x==1) & (y==r)){
        (cs1 <- cs1+1)}
      if ((s==1) & (x==1) & (y==r)){
        (cs2 <- cs2+1)}
    }
    nR_S1 <- append(nR_S1,cs1)
    nR_S2 <- append(nR_S2,cs2)
  }
  
  
  # pad response counts to avoid zeros
  nR_S1 <- as.numeric(nR_S1)
  nR_S2 <- as.numeric(nR_S2)
  if (padCells == 1){
    nR_S1 <- lapply(nR_S1,FUN= function(x) x+padAmount)
    nR_S2 <- lapply(nR_S2,FUN= function(x) x+padAmount)}
  
  # Combine into lists
  newlist <- list(nR_S1,nR_S2)
}