
metadata_exc <- mle_metadata_exc

# identify whether participants have data points in all domains, by measuring length:
rownum <- metadata_exc %>% group_by (subject) %>% summarise(length(modality))

#Identify those with less than four 
rowExc <- subset(rownum, rownum$`length(modality)`<4)
rowexcID <-unique(rowExc$subject)
#Exclude IDs from that vector in original dataframe:
metadata_exc <- subset(metadata_exc, !is.element(metadata_exc$subject, rowexcID))


#Pivot into wide format. 
fit_data_wide <- metadata_exc %>% pivot_wider(
  names_from = modality,
  values_from = c(da, mda, mratio, c, avg_conf))

#Get the descriptive data: 
#Average everything and calculate standard deviations for the MLE model: 
metadata_avg <- metadata_exc %>% 
  group_by(modality) %>% 
  summarise(dprime=mean(da, na_rm=TRUE), 
            criterion=mean(c, na_rm=TRUE),
            metad=mean(mda, na_rm=TRUE),
            mratio1=mean(mratio, na_rm=TRUE),
            avg_conf1=mean(avg_conf, na_rm=TRUE),
            dprime_sd=sd(da),
            criterion_sd=sd(c),
            metad_sd=sd(mda),
            mratio_sd=sd(mratio),
            avg_conf_sd=sd(avg_conf), 
            n1 = n()
  )  %>% mutate(Modality=c("Calories", "GDP", "Memory", "Vision")) %>%
  select(-modality)

#Anova: difference in d', criterion metacognitive bias, sensitivity and efficiency between modalities. 
#+ Post hoc t-tests. (MLE)


#ANOVA data frames: 
dpC_aov1 <- data.frame()
CC_aov1 <- data.frame()
MB_aov1 <- data.frame()
MS_aov1<- data.frame()
ME_aov1<- data.frame()

###Repated ANOVA for d': 
#Select relevant coulmns: 
dpC <- metadata_exc %>% select(modality, subject, starts_with("da")) %>%
  mutate(`d-prime`=da, 
         modality=as.factor(modality)) %>% select(-da) %>% ungroup()

#Summary table: 
sum <- dpC %>% group_by(modality) %>% 
  get_summary_stats(`d-prime`, type="mean_sd")

#Get Anova: 
dpC_aov <- anova_test(data=dpC, dv=`d-prime`, wid=subject, within=modality, detailed=TRUE)
dpC_aov1 <- get_anova_table(dpC_aov)

#Post-hoc: pairwise repeated t-tests
dpT <- dpC %>% pairwise_t_test(`d-prime` ~ modality, paired =TRUE, p.adjust.method = "holm")

###Repated ANOVA for c: 
#Select relevant coulmns: 
CC <- metadata_exc %>% select(modality, subject, starts_with("c")) %>%
  mutate(Criterion=c, 
         modality=as.factor(modality)) %>% select(-c) %>% ungroup()

#Summary table: 
sum1 <- CC %>% group_by(modality) %>% 
  get_summary_stats(Criterion, type="mean_sd")

#Get Anova: 
CC_aov <- anova_test(data=CC, dv=Criterion, wid=subject, within=modality, detailed=TRUE)
CC_aov1 <-get_anova_table(CC_aov)

#Post-hoc: repeated t-tests
CT <- CC %>% pairwise_t_test(Criterion ~ modality, paired =TRUE, p.adjust.method = "holm")

## Repeated measures ANOVA of metacognitive bias: 
#Select relevant coulmns: 
MB <- metadata_exc %>% select(modality, subject, starts_with("avg")) %>%
  mutate(Bias=avg_conf, 
         modality=as.factor(modality)) %>% select(-avg_conf) %>% ungroup()

#Summary table: 
sum2 <- MB %>% group_by(modality) %>% 
  get_summary_stats(Bias, type="mean_sd")

#Get Anova: 
MB_aov <- anova_test(data=MB, dv=Bias, wid=subject, within=modality, detailed=TRUE)
MB_aov1 <- get_anova_table(MB_aov)

#Post-hoc: repeated t-tests
MBT <- MB %>% pairwise_t_test(Bias ~ modality, paired =TRUE, p.adjust.method = "holm")


## Repeated measures ANOVA of meta-d':
#Select relevant coulmns: 
MS <- metadata_exc %>% select(modality, subject, starts_with("mda")) %>%
  mutate(Sensitivity=mda, 
         modality=as.factor(modality)) %>% select(-mda) %>% ungroup()

#Summary table: 
sum3 <- MS %>% group_by(modality) %>% 
  get_summary_stats(Sensitivity, type="mean_sd")

#Get Anova: 
MS_aov <- anova_test(data=MS, dv=Sensitivity, wid=subject, within=modality, detailed=TRUE)
MS_aov1 <-get_anova_table(MS_aov)

#Post-hoc: repeated t-tests
MST <- MS %>% pairwise_t_test(Sensitivity ~ modality, paired =TRUE, p.adjust.method = "holm")


## Repeated measures ANOVA of mratio: 
#Select relevant coulmns: 
ME <- metadata_exc %>% select(modality, subject, starts_with("mratio")) %>%
  mutate(Efficiency=mratio, 
         modality=as.factor(modality)) %>% select(-mratio) %>% ungroup()

#Summary table: 
sum4 <- ME %>% group_by(modality) %>% 
  get_summary_stats(Efficiency, type="mean_sd")

#Get Anova: 
ME_aov <- anova_test(data=ME, dv=Efficiency, wid=subject, within=modality, detailed=TRUE)
ME_aov1 <- get_anova_table(ME_aov)

#Post-hoc: repeated t-tests
MET <- ME %>% pairwise_t_test(Efficiency ~ modality, paired =TRUE,p.adjust.method = "holm")

#Calculate degrees of freedoms for t-test and cohen's d:

#df:
dpT <- dpT %>% mutate(df= n1 +n2 -2)
CT <- CT %>% mutate(df= n1 +n2 -2)
MBT <- MBT %>% mutate(df= n1 +n2 -2)
MST <- MST%>% mutate(df= n1 +n2 -2)
MET <- MET %>% mutate(df= n1 +n2 -2)

#Cohen's d: 
Dcohen <- dpC %>% cohens_d(`d-prime` ~ modality, paired=TRUE)
Ccohen <- CC %>% cohens_d(Criterion ~ modality, paired=TRUE)
Bcohen <- MB %>% cohens_d(Bias ~ modality, paired=TRUE)
Scohen <- MS %>% cohens_d(Sensitivity ~ modality, paired=TRUE)
Ecohen <- ME %>% cohens_d(Efficiency ~ modality, paired=TRUE)



