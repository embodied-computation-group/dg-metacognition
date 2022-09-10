# read in the data

metacognition_trial_data <- read_csv(here("data_summary", "metacognition_TrialData_master.csv"), 
                                     col_types = cols(confidence = col_double(), 
                                                      rt_conf = col_double()))

# set modality as factor
metacognition_trial_data$modality <- as.factor(metacognition_trial_data$modality )

# remove any rows containing NaNs (i.e., missing data)
metacognition_trial_data <- na.omit(metacognition_trial_data)

metadata <- metacognition_trial_data %>%
  group_by(subject, modality) %>%
  mutate(rt = remove_outliers_robust(rt)) # remove RT outliers using MAD Rule 

metadata <- na.omit(metadata)

#Exclude those with rt <50ms 
metadata <- metadata%>%filter(rt>=0.05) 

#Exclude those with less than 50% trials (i.e. less than 100 or 50) within condition
metadata<-metadata%>%mutate(modality=as.factor(modality))
metadatac<-metadata #create new dataframe
metadatac$modality <-fct_collapse (metadatac$modality, trivia = c("Calories", "GDP")) #combine the two trivia tasks in new dataframe
metadatac <- metadatac %>%
  group_by(subject, modality)%>% count(subject) #count number of trials
excD <- subset(metadatac, metadatac$n<100) 
excID <-unique(excD$subject) #Identify participants for exclusion
metadata <- subset(metadata, !is.element(metadata$subject, excID)) ##Exclude IDs from that vector in original dataframe