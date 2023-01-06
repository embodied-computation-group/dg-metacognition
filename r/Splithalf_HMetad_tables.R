#Pull the relevant data: 

#Fit stats summary. 
FitM <- statM %>%
  cbind(lower = HDIM$lower,
        upper = HDIM$upper,
        RhatM = RhatM[,1]) 
FitC <- statC %>%
  cbind(lower = HDIC$lower,
        upper = HDIC$upper,
        RhatC = RhatC[,1]) 
FitG <- statG %>%
  cbind(lower = HDIG$lower,
        upper = HDIG$upper,
        RhatG = RhatG[,1]) 
FitV <- statV %>%
  cbind(lower = HDIV$lower,
        upper = HDIV$upper,
        RhatV = RhatV[,1]) 

#Select Mratio and take the exponential of the value:
meanMratioM <- FitM %>% filter(str_detect(name,"mu_logMratio")) %>%
  mutate(Hmratio=exp(mean), 
         lowerHDI=exp(lower),
         upperHDI=exp(upper)) %>% 
  mutate(Modality=c("Memory Even", "Memory Odd")) %>%  
        # n2="319") %>%
  select(Modality, Hmratio, lowerHDI, upperHDI)

meanMratioC <- FitC %>% filter(str_detect(name,"mu_logMratio")) %>%
  mutate(Hmratio=exp(mean), 
         lowerHDI=exp(lower),
         upperHDI=exp(upper)) %>% 
  mutate(Modality=c("Calories Even", "Calories Odd")) %>%  
  # n2="319") %>%
  select(Modality, Hmratio, lowerHDI, upperHDI)

meanMratioG <- FitG %>% filter(str_detect(name,"mu_logMratio")) %>%
  mutate(Hmratio=exp(mean), 
         lowerHDI=exp(lower),
         upperHDI=exp(upper)) %>% 
  mutate(Modality=c("GDP Even", "GDP Odd")) %>%  
  # n2="319") %>%
  select(Modality, Hmratio, lowerHDI, upperHDI)

meanMratioV <- FitV %>% filter(str_detect(name,"mu_logMratio")) %>%
  mutate(Hmratio=exp(mean), 
         lowerHDI=exp(lower),
         upperHDI=exp(upper)) %>% 
  mutate(Modality=c("Visual Even", "Visual Odd")) %>%  
  # n2="319") %>%
  select(Modality, Hmratio, lowerHDI, upperHDI)

#Bind all of them:
meanMratio=rbind(meanMratioM,meanMratioG, meanMratioC,meanMratioV )

# select the HDIs for each rho  
rHDIM <- HDIM %>% filter(str_detect(name,"rho")) %>% select(name, lower, upper)
rHDIC <- HDIC %>% filter(str_detect(name,"rho")) %>% select(name, lower, upper)
rHDIG <- HDIG %>% filter(str_detect(name,"rho")) %>% select(name, lower, upper)
rHDIV <- HDIV %>% filter(str_detect(name,"rho")) %>% select(name, lower, upper)
rHDI=rbind(rHDIM, rHDIC, rHDIG, rHDIV)

#get and bind meanRho:
meanRho <- data.frame((matrix(NA, nrow=4, ncol=2)))
colnames(meanRho) <- c("Pair","Rho")
meanRho[,1] <-c("Memory", "Calories", "GDP", "Visual")
meanRho[,2] <- rbind(meanRhoM,meanRhoC,meanRhoG, meanRhoV)

#join these HDIs with mean rho
RhoHDI <- cbind(meanRho, rHDI) %>% select(Pair, Rho, lower, upper) 

#Change names and layout: NOTE: I manually chose the upper limit display
table4s <- RhoHDI %>% mutate(Pair= c("Memory (Even and Odd)", "Calories (Even and Odd)", 
                                    "GDP (Even and Odd)", "Vision (EVEN and Odd)"),
                            Rho=round(Rho,3),
                            HDIr = paste(round(lower,3), " ; ", upper="0.999"))

table4s <- table4s %>% mutate(HDI = paste0("[", table4s$HDIr, "]")) %>%
  select(Pair, Rho, HDI)


write.csv(table4s,file= here("tables", 'HMetad_SplitHalf.csv'))
