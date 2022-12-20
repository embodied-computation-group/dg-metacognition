## AUROC2
## Area under ROC type 2 curve
## translated from matlab script type2roc.m by Fleming & Lau (2014)
## taken from https://github.com/smfleming/meta_dots/blob/master/type2roc.m
## authored: Steve Fleming 2012
# Taken from https://github.com/jsavinc/visual-crowding-experiments/blob/ab916402d77ebe73e3181a52c4c9f62202d72ab2/misc/type2roc.r 
#Jan Savinc

# correct - vector of 1 x ntrials, 0 for error, 1 for correct
# subjectiveRatings - vector of 1 x ntrials of confidence ratings taking values 1:Nratings
# numRatings - how many confidence levels available

auroc2 <- function(corrects, subjectiveRatings, numRatings) {
  ratings <- rev(c(1:numRatings))
  
  hits <- function(x) {subjectiveRatings==x & corrects}
  falsealarms <- function(x) {subjectiveRatings==x & abs(corrects-1)}
  
  type2hits_list <- lapply(ratings,hits)
  type2falsealarms_list <- lapply(ratings,falsealarms)
  
  type2hits_listsums <- 0.5 + sapply(type2hits_list,sum)
  type2falsealarms_listsums <- 0.5 + sapply(type2falsealarms_list,sum)
  
  H2s <- type2hits_listsums / sum(type2hits_listsums)
  FA2s <- type2falsealarms_listsums / sum(type2falsealarms_listsums)
  
  cumulative_H2s <- c(0,cumsum(H2s))
  cumulative_FA2s <- c(0, cumsum(FA2s))
  
  k <- function(i) {(cumulative_H2s[i+1] - cumulative_FA2s[i])^2 - (cumulative_H2s[i] - cumulative_FA2s[i+1])^2}
  ## k(i) = (cum_H2(c+1) - cum_FA2(c))^2 - (cum_H2(c) - cum_FA2(c+1))^2;
  
  ks <- sapply(rev(ratings), k)
  
  aoc <- 0.5 + 0.25*sum(ks)
  return(aoc)
}

