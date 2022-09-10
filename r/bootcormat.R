
# function to return bootstrapped correlation matrices
bootcormat <- function(dat, bootN = 2000) {

varnames = colnames(dat)

r <- matrix(,nrow=length(dat),ncol=length(dat))
p <- matrix(,nrow=length(dat),ncol=length(dat))
LCI <- matrix(,nrow=length(dat),ncol=length(dat))
UCI <- matrix(,nrow=length(dat),ncol=length(dat))

datmat <- as.matrix(dat)

nvars <- dim(dat)[2]

for (i in 1:nvars) 
  {
  
  for (j in 1:nvars) {
  res = corci(datmat[,i], datmat[,j], method="spearman", nboot = bootN)
  
  r[i,j] = res$estimate
  p[i,j] = res$p.value
  LCI[i,j] = res$conf.int[1]
  UCI[i,j] = res$conf.int[2]
  }
}

bootResults <- list(r,p,LCI, UCI)
names(bootResults) <- c("r", "p", "LCI", "UCI")

bootResults <- lapply(bootResults, "rownames<-", colnames(dat))
bootResults <- lapply(bootResults, "colnames<-", colnames(dat))

return(bootResults)

}

