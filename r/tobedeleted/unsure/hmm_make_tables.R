#Do the same with the hierarhical model:

#Select Mratio and take the exponential of the value:
meanMratio <- Fit %>% filter(str_detect(name,"mu_logMratio")) %>%
  mutate(Hmratio=exp(mean), 
         lowerHDI=exp(lower),
         upperHDI=exp(upper)) %>% 
  mutate(Modality=c("Memory", "Calories", "GDP", "Vision"), 
         n2="319") %>%
  select(Modality, Hmratio, lowerHDI, upperHDI, n2)


#Load criterion and dprime - Astrid:
c1 <-readRDS("C:/Users/Astrid/Documents/DomainGen/fit_c1")
d1 <-readRDS("C:/Users/Astrid/Documents/DomainGen/fit_d1")

#Label tasks and pivot the vectors: 
c1 <- data.frame(c1)
d1 <- data.frame(d1)
c1 <- c1 %>% mutate (Memory=T1, Calories= T2, GDP = T3, Vision = T4, subject = row_number())%>% select(-T1, -T2, -T3, -T4)
d1 <- d1 %>% mutate (Memory=T1, Calories= T2, GDP = T3, Vision = T4, subject = row_number())%>% select(-T1, -T2, -T3, -T4)

c1l <- c1 %>% pivot_longer(
  cols = c("Memory", "Calories", "GDP", "Vision"), 
  names_to="Modality",
  values_to ="Criterion")

d1l <- d1 %>% pivot_longer(
  cols = c("Memory", "Calories", "GDP", "Vision"), 
  names_to="Modality",
  values_to ="d'")

#Summarise - mean and SD: 
c1l_avg <- c1l %>% 
  group_by(Modality) %>% 
  summarise(Hcriterion=mean(Criterion, na_rm=TRUE), 
            Hcriterion_sd=sd(Criterion), n3=n())

d1l_avg <- d1l %>% 
  group_by(Modality) %>% 
  summarise(Hdprime=mean(`d'`, na_rm=TRUE), 
            Hdprime_SD= sd(`d'`), n4=n())

#Join the two: 
HdcSum <- left_join(c1l_avg , d1l_avg , 
                    by=c("Modality"="Modality"))

#Join MLE and Hier: 
MetaSum <- left_join(meanMratio , HdcSum , 
                     by=c("Modality"="Modality"))


# select the HDIs for each rho  
rHDI <- HDI %>% filter(str_detect(name,"rho")) %>% select(name, lower, upper)
#join these HDIs with mean rho
RhoHDI <- full_join(meanRho, rHDI, 
                    by= c("Parameter"="name"))

#Change names and layout: 
table4 <- RhoHDI %>% mutate(Pair= c("Memory & Calories", "Memory and GDP", "Memory and Vision", 
                                    "GDP and Calories", "Calories and Vision", "GDP and Vision"),
                            Rho=round(value,3),
                            HDIr = paste(round(lower,3), round(upper,3), sep=" ; "))
table4 <- table4 %>% mutate(HDI = paste0("[", table4$HDIr, "]"))


#HDI for mean mratio: 
meanMratio1 <- MSum %>% mutate(HDIr = paste(round(lowerHDI,3), round(upperHDI,3), sep=" ; "))
meanMratio1  <- meanMratio1  %>% mutate(HDI = paste0("[", meanMratio1$HDIr, "]"))

#Create table
HMT <- data.frame((matrix(NA, nrow=4, ncol=7)))

#Insert values in the table 
HMT [,1] <-meanMratio1$Modality
HMT [,2] <-meanMratio1$n2
HMT [,3] <-paste0(round(meanMratio1$Hmratio,2))
HMT [,4] <-meanMratio1$HDI
HMT [2,5] <- paste0(round(table4[4,6],3), " ",table4[4,8]) #CAl-vis
HMT [3,5] <- paste0(round(table4[1,6],3), " ",table4[1,8]) #Mem-Cal
HMT [4,5] <- paste0(round(table4[5,6],3), " ",table4[5,8]) #GDP-Vis
HMT [3,6] <- paste0(round(table4[2,6],3), " ",table4[2,8]) #Mem-Vis
HMT [4,6] <- paste0(round(table4[6,6],3), " ",table4[6,8]) #GDP-CAL
HMT [4,7] <- paste0(round(table4[3,6],3), " ",table4[3,8]) #Mem-GDP


#  * : under 0.05 - can be seen in dataframe table3. 

#Rename and select Columns: 
HMT  <- HMT %>% mutate(Modality =X1, n=X2, M=X3, HDI=X4, Calories = X5, GDP = X6, Memory =X7) %>%
  select(Modality, n, M, HDI, Calories, GDP, Memory)

#Save as csv
write.csv(HMT ,file= here("tables", 'EffCor_Hier.csv'))


#Put into APA format. 
Table4 <-apa(HMT, "Table 4: Correlation of Metacognitive Efficiency (meta-d'/d'): Hierarchical Bayesian")
Table4