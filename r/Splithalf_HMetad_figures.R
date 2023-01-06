#pull the relevant data from the output

# Convergence diagnostic
ValueM <- gelman.diag(outputM, confidence = 0.95)
RhatM <- data.frame(conv = ValueM$psrf)
ValueC <- gelman.diag(outputC, confidence = 0.95)
RhatC <- data.frame(conv = ValueC$psrf)
ValueG <- gelman.diag(outputG, confidence = 0.95)
RhatG <- data.frame(conv = ValueG$psrf)
ValueV <- gelman.diag(outputV, confidence = 0.95)
RhatV <- data.frame(conv = ValueV$psrf)

# Values (mean and CI)
ValueM <- summary(outputM)
statM <- data.frame(mean = ValueM$statistics[,"Mean"])
statM %<>%
  rownames_to_column(var = "name") %>% 
  cbind(CILow = ValueM$quantiles[,"2.5%"]) %>% 
  cbind(CIUp = ValueM$quantiles[,"97.5%"])

ValueC <- summary(outputC)
statC <- data.frame(mean = ValueC$statistics[,"Mean"])
statC %<>%
  rownames_to_column(var = "name") %>% 
  cbind(CILow = ValueC$quantiles[,"2.5%"]) %>% 
  cbind(CIUp = ValueC$quantiles[,"97.5%"])

ValueG <- summary(outputG)
statG <- data.frame(mean = ValueG$statistics[,"Mean"])
statG %<>%
  rownames_to_column(var = "name") %>% 
  cbind(CILow = ValueG$quantiles[,"2.5%"]) %>% 
  cbind(CIUp = ValueG$quantiles[,"97.5%"])

ValueV <- summary(outputV)
statV <- data.frame(mean = ValueV$statistics[,"Mean"])
statV %<>%
  rownames_to_column(var = "name") %>% 
  cbind(CILow = ValueV$quantiles[,"2.5%"]) %>% 
  cbind(CIUp = ValueV$quantiles[,"97.5%"])


# HDI function 
HDIM <- data.frame(HPDinterval(outputM, prob = 0.95))
HDIM %<>%
  rownames_to_column(var = "name")
HDIC <- data.frame(HPDinterval(outputC, prob = 0.95))
HDIC %<>%
  rownames_to_column(var = "name")
HDIG <- data.frame(HPDinterval(outputG, prob = 0.95))
HDIG %<>%
  rownames_to_column(var = "name")
HDIV <- data.frame(HPDinterval(outputV, prob = 0.95))
HDIV %<>%
  rownames_to_column(var = "name")



## Plot posterior distributions -------------------------------------------------------------------
mcmc.sampleM <- ggs(outputM)
mcmc.sampleC <- ggs(outputC)
mcmc.sampleG <- ggs(outputG)
mcmc.sampleV <- ggs(outputV)

#Make the figures: 


meanRhoM <- mcmc.sampleM %>% summarise(value= mean(value, na.rm=TRUE)) 
meanRhoC <- mcmc.sampleC %>% summarise(value= mean(value, na.rm=TRUE)) 
meanRhoG <- mcmc.sampleG %>% summarise(value= mean(value, na.rm=TRUE)) 
meanRhoV <- mcmc.sampleV %>% summarise(value= mean(value, na.rm=TRUE)) 

H1title <- paste("Rho =",round(meanRhoM$value, digits=3)) #Mem
H2title <- paste("Rho =",round(meanRhoC$value, digits=3)) # CAl
H3title <- paste("Rho =",round(meanRhoG$value, digits=3)) #GDP
H4title <- paste("Rho =",round(meanRhoV$value, digits=3)) #Vis

Rho1 <- mcmc.sampleM %>% filter(Parameter == "rho") 
Rho2 <- mcmc.sampleC %>% filter(Parameter == "rho") 
Rho3 <- mcmc.sampleG %>% filter(Parameter == "rho") 
Rho4 <- mcmc.sampleV %>% filter(Parameter == "rho") 

R1 <- RhoPlotS(Rho1, "rho", HDIM, statM) + labs(title = "Memory", subtitle=paste(H1title))
R2 <- RhoPlotS(Rho2, "rho", HDIC, statC) +labs(title = "Calories", subtitle= paste(H2title))
R3 <- RhoPlotS(Rho3, "rho", HDIG, statG) +labs(title = "GDP", subtitle= paste(H3title))
R4 <- RhoPlotS(Rho4, "rho", HDIV, statV) +labs(title = "Vision", subtitle= paste(H4title))

#Bayesian Hierarhical fit: 
RhoPlot <- ggarrange(R1, R3, R2, R4)
annotate_figure(RhoPlot, top = text_grob("Split Half trials analysis: Hierarhical Bayesian estimation", color = "black", face = "bold", size = 14)) 

ggsave(here("figs", "mrho_Split.png"), height = 7, width = 12)


#Mean rho: Same as above
H1title <- paste("Rho =",round(meanRhoM$value, digits=3)) #Mem
H2title <- paste("Rho =",round(meanRhoC$value, digits=3)) # CAl
H3title <- paste("Rho =",round(meanRhoG$value, digits=3)) #GDP
H4title <- paste("Rho =",round(meanRhoV$value, digits=3)) #Vis


# Create individual Mratio data frame
Mratio_indivC <- statC %>% 
  filter(grepl("^M", name)) %>% 
  mutate(task = ifelse(grepl("1]", name), "Even","Odd"),
         pp = name %>%
           str_extract(regex("\\d+(?=,)")) %>% 
           as.integer()) %>% 
  dcast(pp ~ task, value.var = "mean")

Mratio_indivG <- statG %>% 
  filter(grepl("^M", name)) %>% 
  mutate(task = ifelse(grepl("1]", name), "Even","Odd"),
         pp = name %>%
           str_extract(regex("\\d+(?=,)")) %>% 
           as.integer()) %>% 
  dcast(pp ~ task, value.var = "mean")

Mratio_indivM <- statV %>% 
  filter(grepl("^M", name)) %>% 
  mutate(task = ifelse(grepl("1]", name), "Even","Odd"),
         pp = name %>%
           str_extract(regex("\\d+(?=,)")) %>% 
           as.integer()) %>% 
  dcast(pp ~ task, value.var = "mean")

Mratio_indivV <- statV %>% 
  filter(grepl("^M", name)) %>% 
  mutate(task = ifelse(grepl("1]", name), "Even","Odd"),
         pp = name %>%
           str_extract(regex("\\d+(?=,)")) %>% 
           as.integer()) %>% 
  dcast(pp ~ task, value.var = "mean")

# Create plot

Cor1 <- ind_hier(Mratio_indivC, Mratio_indivC$Even,Mratio_indivC$Odd) +
  scale_y_continuous("Odd") + scale_x_continuous("Even") +
  ggtitle(H1title)+ theme(plot.title = element_text( size = 13))


Cor2 <- ind_hier(Mratio_indivG, Mratio_indivG$Even,Mratio_indivG$Odd) +
  ggtitle(H2title)+ theme(plot.title = element_text( size = 13)) +
  scale_y_continuous("Odd") + scale_x_continuous("Even")

Cor3 <- ind_hier(Mratio_indivM, Mratio_indivM$Even,Mratio_indivM$Odd)+
  ggtitle(H3title)+ theme(plot.title = element_text( size = 13)) +
  scale_y_continuous("Odd") + scale_x_continuous("Even") 

Cor4 <- ind_hier(Mratio_indivV, Mratio_indivV$Even,Mratio_indivV$Odd)+
  ggtitle(H4title)+ theme(plot.title = element_text( size = 13)) +
  scale_y_continuous("Odd") + scale_x_continuous("Even") 


SplitPlotHier <- ggarrange(Cor1, Cor2, Cor3, Cor4) 
annotate_figure(SplitPlotHier , top = text_grob("Split Half Trials (Hmeta-d')", color = "black", 
                                                face = "bold", size = 18))   

ggsave(here("figs", "Hier_Split_scatter.png"), height = 7, width = 12)
