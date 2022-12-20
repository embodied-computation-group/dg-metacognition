#Create table:
ANOT <- data.frame(
  Measure = character(),
  `Sum of Squares` = character(),
  dfn = character(), 
  dfd = character(),
  `F`= character(), 
  p = character()
)  

#Insert values:  
ANOT[1,] <- list(paste0("d'"), paste0(dpC_aov1$SSn[2]),paste0(dpC_aov1$DFn[2]), paste0(dpC_aov1$DFd[2]), paste0(round(dpC_aov1$F[2], 3)), paste0(dpC_aov1$p[2]))
ANOT[2,] <- list(paste0("Criterion"), paste0(CC_aov1$SSn[2]),paste0(CC_aov1$DFn[2]), paste0(CC_aov1$DFd[2]), paste0(round(CC_aov1$F[2], 3)), paste0(CC_aov1$p[2]))
ANOT[3,] <- list(paste0("Avg. Conf"), paste0(MB_aov1$SSn[2]),paste0(MB_aov1$DFn[2]), paste0(MB_aov1$DFd[2]), paste0(round(MB_aov1$F[2], 3)), paste0(MB_aov1$p[2]))
ANOT[4,] <- list(paste0("Meta-d'"), paste0(MS_aov1$SSn[2]),paste0(MS_aov1$DFn[2]), paste0(MS_aov1$DFd[2]), paste0(round(MS_aov1$F[2], 3)), paste0(MS_aov1$p[2]))
ANOT[5,] <- list(paste0("Meta-d'/d'"), paste0(ME_aov1$SSn[2]),paste0(ME_aov1$DFn[2]), paste0(ME_aov1$DFd[2]), paste0(round(ME_aov1$F[2], 3)), paste0(ME_aov1$p[2]))


#NOTE I MANUALLY CHANGE THE P-values to <.001 here! Thus with different data this may not be appropriate. 
ANOT <- ANOT %>% mutate(p = as.character("<.001"))  

#write csv
write.csv(ANOT ,file= here("tables", 'ANOVA.csv'))


##Tables of all Post-hoc t-tests: 
DTT <-data.frame(Pair=character(),
                 df=double(),
                 t=double(),
                 p=double(),
                 d=double(),
                 stringsAsFactors=FALSE)
CTT <-data.frame(Pair=character(),
                 df=double(),
                 t=double(),
                 p=double(),
                 d=double(),
                 stringsAsFactors=FALSE)
MBTT <-data.frame(Pair=character(),
                  df=double(),
                  t=double(),
                  p=double(),
                  d=double(),
                  stringsAsFactors=FALSE)
MSTT <-data.frame(Pair=character(),
                  df=double(),
                  t=double(),
                  p=double(),
                  d=double(),
                  stringsAsFactors=FALSE)
METT <-data.frame(Pair=character(),
                  df=double(),
                  t=double(),
                  p=double(),
                  d=double(),
                  stringsAsFactors=FALSE)


#change layout and labels: 
## the reported p is holm corrected   
DTT[1:6,] <- list(paste0(dpT$group1, " & ", dpT$group2), paste0(dpT$df) , paste0(round(dpT$statistic, 3)),  paste0(round(dpT$p.adj,3)),
                  paste0(round(Dcohen$effsize,3)))
CTT[1:6,] <- list(paste0(CT$group1, " & ", CT$group2), paste0(CT$df), paste0(round(CT$statistic, 3)), paste0(round(CT$p.adj,3)),
                  paste0(round(Ccohen$effsize,3)))
MBTT[1:6,] <- list(paste0(MBT$group1, " & ", MBT$group2), paste0(MBT$df), paste0(round(MBT$statistic, 3)),paste0(round(MBT$p.adj,3)), 
                   paste0(round(Bcohen$effsize,3)))
MSTT[1:6,] <- list(paste0(MST$group1, " & ", MST$group2), paste0(MST$df), paste0(round(MST$statistic, 3)),paste0(round(MST$p.adj,3)),
                   paste0(round(Scohen$effsize,3)))
METT[1:6,] <- list(paste0(MET$group1, " & ", MET$group2), paste0(MET$df), paste0(round(MET$statistic, 3)),paste0(round(MET$p.adj,3)),
                   paste0(round(Ecohen$effsize,3)))

#Change the p-value to <.001 when appropriate: 
DTT <- DTT %>% mutate(p = ifelse(p == '0', "p <.001", paste0(p)))
CTT <- CTT %>% mutate(p = ifelse(p == '0', "p <.001", paste0(p)))
MBTT <- MBTT %>% mutate(p = ifelse(p == '0', "p <.001", paste0(p)))
MSTT <- MSTT %>% mutate(p = ifelse(p == '0', "p <.001", paste0(p)))
METT <- METT %>% mutate(p = ifelse(p == '0', "p <.001", paste0(p)))


#write csv
write.csv(DTT ,file= here("tables", 'ttest_dprime.csv'))
write.csv(CTT ,file= here("tables", 'ttest_criterion.csv'))
write.csv(MBTT ,file= here("tables", 'ttest_metabias.csv'))
write.csv(MSTT ,file= here("tables", 'ttest_metasens.csv'))
write.csv(METT ,file= here("tables", 'ttest_metaeffi.csv'))


