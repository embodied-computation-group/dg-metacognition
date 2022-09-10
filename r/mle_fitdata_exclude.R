

#Exclude outliers based on MAD rule (confidence, d' and criterion)
# Get confidence from raw data:
Avgmeta <- metadata %>% 
  group_by(subject, modality) %>% 
  summarise(avg_conf=mean(confidence, na_rm=TRUE)) #calculate Mean confidence for each modality

MedianContrast <- metadata %>% 
  group_by(subject, modality) %>% 
  summarise(medContrast=median(contrast, na_rm=TRUE))

#join Avgmeta with fit_data 
mle_fit_data_full <- mle_fit_data %>% full_join(Avgmeta, 
                                     by= c('subject'='subject', 
                                           'modality' = 'modality'))

mle_fit_data_full <- mle_fit_data_full %>% full_join(MedianContrast, 
                                                by= c('subject'='subject', 
                                                      'modality' = 'modality'))

# remove any NAs - outlier function returns all NAs otherwise...

mle_fit_data_full <- na.omit(mle_fit_data_full)

# remove outliers
mle_metadata_exc <- mle_fit_data_full %>%
  group_by(modality) %>%
  mutate(avg_conf = remove_outliers_robust(avg_conf)) # remove confidence outliers using MAD Rule 


# da 
mle_metadata_exc <- mle_metadata_exc%>%
  group_by(modality) %>%
  mutate(da = remove_outliers_robust(da)) 

# criterion 
mle_metadata_exc <- mle_metadata_exc%>%
  group_by(modality) %>%
  mutate(c = remove_outliers_robust(c)) # remove criterion outliers using MAD Rule 

# mratio 
mle_metadata_exc <- mle_metadata_exc%>%
  group_by(modality) %>%
  mutate(mratio = remove_outliers_robust(mratio)) # remove mratio outliers using MAD Rule 

# signal contrast 
mle_metadata_exc <- mle_metadata_exc%>%
  group_by(modality) %>%
  mutate(medContrast = remove_outliers_robust(medContrast)) # remove mratio outliers using MAD Rule 

total_outliers <- sum(is.na(mle_metadata_exc))

sprintf("removing %d outlier observations", sum(is.na(mle_metadata_exc)))

mle_metadata_exc <- na.omit(mle_metadata_exc)


## plots before and after exclusion

p1<-ggplot(mle_fit_data_full, aes(y = da, x = modality))+
  geom_boxjitter(outlier.shape = NA)+
  ggtitle("before exclusion")

p2<-ggplot(mle_metadata_exc, aes(y = da, x = modality))+
  geom_boxjitter(outlier.shape = NA) +
  ggtitle("after exclusion")

p3<-ggplot(mle_fit_data_full, aes(y = c, x = modality))+
  geom_boxjitter(outlier.shape = NA)+
  ggtitle("before exclusion")

p4<-ggplot(mle_metadata_exc, aes(y = c, x = modality))+
  geom_boxjitter(outlier.shape = NA) +
  ggtitle("after exclusion")


p5<-ggplot(mle_fit_data_full, aes(y = mratio, x = modality))+
  geom_boxjitter(outlier.shape = NA)+
  ggtitle("before exclusion")

p6<-ggplot(mle_metadata_exc, aes(y = mratio, x = modality))+
  geom_boxjitter(outlier.shape = NA) +
  ggtitle("after exclusion")

p7<-ggplot(mle_fit_data_full, aes(y = medContrast))+
  geom_boxjitter(outlier.shape = NA)+
  facet_wrap(~modality, scales = "free_y", ncol =4)
  ggtitle("before exclusion")

p8<-ggplot(mle_metadata_exc, aes(y = medContrast))+
  geom_boxjitter(outlier.shape = NA) +
  facet_wrap(~modality, scales = "free_y", ncol =4)
  ggtitle("after exclusion")


