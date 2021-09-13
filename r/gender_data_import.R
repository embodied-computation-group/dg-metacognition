
# get pre ratings

survey_data_pre <- read_delim(here("data_summary", "/self_belief_pre_labels.csv"), 
                              ";", escape_double = FALSE, trim_ws = TRUE)

survey_data_post <- read_delim(here("data_summary", "/self_belief_post_labels.csv"), 
                               ";", escape_double = FALSE, trim_ws = TRUE)


# read in the trialwise metacognition data

metacognition_trial_data <- read_csv(here("data_summary", "metacognition_TrialData_master.csv"), 
                                     col_types = cols(confidence = col_double(), 
                                                      rt_conf = col_double()))

# some data wrangling

survey_data_pre$gender <- as.factor(survey_data_pre$gender)
survey_data_pre <- survey_data_pre %>%
  filter(Sid!=996) # remove bogus subject


names(survey_data_pre)[names(survey_data_pre) == "Timestamp"] <- "Timestamp_1"
names(survey_data_post)[names(survey_data_post) == "Timestamp"] <- "Timestamp_2"



# set modality as factor
metacognition_trial_data$modality <- as.factor(metacognition_trial_data$modality )

# remove any rows containing NaNs (i.e., missing data)

metacognition_trial_data <- na.omit(metacognition_trial_data)