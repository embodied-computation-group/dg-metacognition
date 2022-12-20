source(here("r", "Function_Bayesfactor.R")) 

# Bayes factor is estimated  and plots are saved: 
# Metacognitive sensitivity 
corr <- fit_data_wide %>%
  na.omit() %>%
  select(starts_with("mda"))

bf1<- bayes(corr$mda_memory, corr$mda_Calories)
ggsave(here("figs","bayes", "mda_Mem_cal.png"))
bf2 <- bayes(corr$mda_memory, corr$mda_vision)
ggsave(here("figs","bayes", "mda_Mem_vis.png"))
bf3 <- bayes(corr$mda_memory, corr$mda_GDP)
ggsave(here("figs","bayes", "mda_Mem_gdp.png"))
bf4 <- bayes(corr$mda_GDP, corr$mda_vision)
ggsave(here("figs","bayes", "mda_gdp_vis.png"))
bf5 <- bayes(corr$mda_GDP, corr$mda_Calories)
ggsave(here("figs","bayes", "mda_gdp_cal.png"))
bf6 <- bayes(corr$mda_Calories, corr$mda_vision)
ggsave(here("figs","bayes", "mda_cal_vis.png"))

#Metacognitive Efficiency
corr1 <- fit_data_wide %>%
  na.omit() %>%
  select(starts_with("mratio"))

bf11 <- bayes(corr1$mratio_memory, corr1$mratio_Calories)
ggsave(here("figs","bayes", "mratio_Mem_cal.png"))
bf12 <- bayes(corr1$mratio_memory, corr1$mratio_vision)
ggsave(here("figs","bayes", "mratio_Mem_vis.png"))
bf13 <- bayes(corr1$mratio_memory, corr1$mratio_GDP)
ggsave(here("figs","bayes", "mratio_Mem_gdp.png"))
bf14 <- bayes(corr1$mratio_GDP, corr1$mratio_vision)
ggsave(here("figs","bayes", "mratio_gdp_vis.png"))
bf15 <- bayes(corr1$mratio_GDP, corr1$mratio_Calories)
ggsave(here("figs","bayes", "mratio_gdp_cal.png"))
bf16 <- bayes(corr1$mratio_Calories, corr1$mratio_vision)
ggsave(here("figs","bayes", "mratio_cal_vis.png"))

#Metacognitive bias 
corr2 <- fit_data_wide %>%
  na.omit() %>%
  select(starts_with("avg"))

bf21 <- bayes(corr2$avg_conf_memory, corr2$avg_conf_Calories)
ggsave(here("figs","bayes", "avgconf_Mem_cal.png"))
bf22 <- bayes(corr2$avg_conf_memory, corr2$avg_conf_vision)
ggsave(here("figs","bayes", "avgconf_Mem_vis.png"))
bf23 <- bayes(corr2$avg_conf_memory, corr2$avg_conf_GDP)
ggsave(here("figs","bayes", "avgconf_Mem_gdp.png"))
bf24 <- bayes(corr2$avg_conf_GDP, corr2$avg_conf_vision)
ggsave(here("figs","bayes", "avgconf_gdp_vis.png"))
bf25 <- bayes(corr2$avg_conf_GDP, corr2$avg_conf_Calories)
ggsave(here("figs","bayes", "avgconf_gdp_cal.png"))
bf26 <- bayes(corr2$avg_conf_Calories, corr2$avg_conf_vision)
ggsave(here("figs","bayes", "avgconf_cal_vis.png"))

#Cognitive Sensitivity
corr3 <- fit_data_wide %>%
  na.omit() %>%
  select(starts_with("da"))

bf31 <- bayes(corr3$da_memory, corr3$da_Calories) 
ggsave(here("figs","bayes", "cogsen_Mem_calE.png"))
bf32 <- bayes(corr3$da_memory, corr3$da_vision)
ggsave(here("figs","bayes", "cogsen_Mem_visE.png"))
bf33 <- bayes(corr3$da_memory, corr3$da_GDP) 
ggsave(here("figs","bayes", "cogsen_Mem_gdpE.png"))
bf34 <- bayes(corr3$da_GDP, corr3$da_vision)
ggsave(here("figs","bayes", "cogsen_gdp_visE.png"))
bf35 <- bayes(corr3$da_GDP, corr3$da_Calories) 
ggsave(here("figs","bayes", "cogsen_gdp_calE.png"))
bf36 <- bayes(corr3$da_Calories, corr3$da_vision) 
ggsave(here("figs","bayes", "cogsen_cal_visE.png"))


#Make the  tables: 
BayesSen <- data.frame(Pair=character(),
                       `Bayes Factor`=double())
BayesEff <- data.frame( Pair=character(),
                        `Bayes Factor`=double())
BayesBia <- data.frame( Pair=character(),
                        `Bayes Factor`=double())
BayesCog <- data.frame( Pair=character(),
                        `Bayes Factor`=double())

BayesSen <- BayesSen %>% rename( "Bayes Factor"= Bayes.Factor)
BayesEff <- BayesEff %>% rename( "Bayes Factor"= Bayes.Factor)
BayesBia <- BayesBia %>% rename( "Bayes Factor"= Bayes.Factor)
BayesCog <- BayesCog %>% rename( "Bayes Factor"= Bayes.Factor)

BayesSen[1,] <-list(paste0('Memory & Calories'), paste0(round(bf1@bayesFactor$bf,3))) 
BayesSen[2,] <-list(paste0('Memory & Vision'), paste0(round(bf2@bayesFactor$bf,3))) 
BayesSen[3,] <-list(paste0('Memory & GDP'), paste0(round(bf3@bayesFactor$bf,3))) 
BayesSen[4,] <-list(paste0('GDP & Calories'), paste0(round(bf4@bayesFactor$bf,3))) 
BayesSen[5,] <-list(paste0('Vision & Calories'), paste0(round(bf5@bayesFactor$bf,3))) 

BayesEff[1,] <-list(paste0('Memory & Calories'), paste0(round(bf11@bayesFactor$bf,3))) 
BayesEff[2,] <-list(paste0('Memory & Vision'), paste0(round(bf12@bayesFactor$bf,3))) 
BayesEff[3,] <-list(paste0('Memory & GDP'), paste0(round(bf13@bayesFactor$bf,3))) 
BayesEff[4,] <-list(paste0('GDP & Calories'), paste0(round(bf14@bayesFactor$bf,3))) 
BayesEff[5,] <-list(paste0('Vision & Calories'), paste0(round(bf15@bayesFactor$bf,3))) 

BayesBia[1,] <-list(paste0('Memory & Calories'), paste0(round(bf21@bayesFactor$bf,3))) 
BayesBia[2,] <-list(paste0('Memory & Vision'), paste0(round(bf22@bayesFactor$bf,3))) 
BayesBia[3,] <-list(paste0('Memory & GDP'), paste0(round(bf23@bayesFactor$bf,3))) 
BayesBia[4,] <-list(paste0('GDP & Calories'), paste0(round(bf24@bayesFactor$bf,3))) 
BayesBia[5,] <-list(paste0('Vision & Calories'), paste0(round(bf25@bayesFactor$bf,3))) 

BayesCog[1,] <-list(paste0('Memory & Calories'), paste0(round(bf31@bayesFactor$bf,3))) 
BayesCog[2,] <-list(paste0('Memory & Vision'), paste0(round(bf32@bayesFactor$bf,3))) 
BayesCog[3,] <-list(paste0('Memory & GDP'), paste0(round(bf33@bayesFactor$bf,3))) 
BayesCog[4,] <-list(paste0('GDP & Calories'), paste0(round(bf34@bayesFactor$bf,3))) 
BayesCog[5,] <-list(paste0('Vision & Calories'), paste0(round(bf35@bayesFactor$bf,3))) 

