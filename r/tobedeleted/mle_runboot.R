
# function to return bootstrapped correlation matrices
boot_Results <- function(dat, bootN = 2000) {

varnames = colnames(dat)

coeff <- matrix(,nrow=length(dat),ncol=length(dat))
pval <- matrix(,nrow=length(dat),ncol=length(dat))
LowerCI <- matrix(,nrow=length(dat),ncol=length(dat))
UpperCI <- matrix(,nrow=length(dat),ncol=length(dat))

datmat <- as.matrix(dat)

nvars <- dim(dat)[2]

for (i in 1:nvars) 
  {
  
  for (j in 1:nvars) {
  res = corci(datmat[,i], datmat[,j], method="spearman", nboot = bootN)
  
  coeff[i,j] = res$estimate
  pval[i,j] = res$p.value
  LowerCI[i,j] = res$conf.int[1]
  UpperCI[i,j] = res$conf.int[2]
  }
}

bootResults <- list(coeff,pval,LowerCI, UpperCI)
names(bootResults) <- c("coeff", "pval", "LowerCI", "UpperCI")

bootResults <- lapply(bootResults, "rownames<-", colnames(dat))
bootResults <- lapply(bootResults, "colnames<-", colnames(dat))

return(bootResults)

}

