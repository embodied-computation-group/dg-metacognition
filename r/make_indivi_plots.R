#Check staircase procedure: First create individual dataframes. 
metadata <- metadata %>%mutate(modality=as.factor(modality))

memory <- metadata %>% group_by(subject ) %>% 
  filter(modality == c('memory'))  %>%  mutate(trial_number = row_number()) 
calories <- metadata %>%group_by(subject) %>% 
  filter(modality == c('Calories'))  %>%  mutate(trial_number = row_number())
percept <- metadata %>%group_by(subject )%>%
  filter(modality == c('vision'))  %>%  mutate(trial_number = row_number())
GDP <- metadata %>%group_by(subject ) %>% 
  filter(modality == c('GDP'))  %>%  mutate(trial_number = row_number())


subjects <- unique(percept$subject) #define subjects



#Perception:
for(t in seq(1,length(subjects), 12) ) { 
  plots = list()
  counter = 0
  for(p in seq(t, t+11)) {
    
    counter = counter + 1;
    tmp_data <- percept %>% filter(subject == subjects[p])
    this_median = median(median(tmp_data$contrast))
    thisPlot <- ggplot(tmp_data) +
    geom_step(aes(x=(trial_number), y=contrast)) +
    xlab("trial") +
    ylim(-5, 30) +
    xlim(0, 200)+ 
    geom_hline(yintercept = this_median) +
    ylab("contrast") + theme_bw() +
    ggtitle(paste("subject", subjects[p], "visStair", sep = "_"))
    plots[[counter]] <- thisPlot
    
    
  } 
  
  filename=paste("staircase_vis_",subjects[t], "_", subjects[t+11],".png",sep="")
  wrap_plots(plots)
  ggsave(here("figs","stairs", filename))

}




#Calories:
for(t in seq(1,length(subjects), 12) ) { 
  plots = list()
  counter = 0
  for(p in seq(t, t+11)) {
    
    counter = counter + 1;
    tmp_data <- calories %>% filter(subject == subjects[p])
    this_median = median(median(tmp_data$contrast))
    thisPlot <- ggplot(tmp_data) +
      geom_step(aes(x=(trial_number), y=contrast)) +
      xlab("trial") +
      ylim(-100, 800) +
      xlim(0, 105)+ 
      geom_hline(yintercept = this_median) +
      ylab("contrast") + theme_bw() +
      ggtitle(paste("subject", subjects[p], "calStair", sep = "_"))
    plots[[counter]] <- thisPlot
    
    
  } 
  
  filename=paste("staircase_Cal_",subjects[t], "_", subjects[t+11],".png",sep="")
  wrap_plots(plots)
  ggsave(here("figs", "stairs", filename))
  
}


#GDP:
for(t in seq(1,length(subjects), 12) ) { 
  plots = list()
  counter = 0
  for(p in seq(t, t+11)) {
    
    counter = counter + 1;
    tmp_data <- GDP %>% filter(subject == subjects[p])
    this_median = median(median(tmp_data$contrast))
    thisPlot <- ggplot(tmp_data) +
      geom_step(aes(x=(trial_number), y=contrast)) +
      xlab("trial") +
      ylim(-5, 10) +
      xlim(0, 105)+ 
      geom_hline(yintercept = this_median) +
      ylab("contrast") + theme_bw() +
      ggtitle(paste("subject", subjects[p], "GDPStair", sep = "_"))
    plots[[counter]] <- thisPlot
    
    
  } 
  
  filename=paste("staircase_GDP_",subjects[t], "_", subjects[t+11],".png",sep="")
  wrap_plots(plots)
  ggsave(here("figs", "stairs", filename))
  
}







## make a plot of accuracy for each memory condition 
meanMem <- memory %>% mutate(contrast= as.factor(contrast)) %>%
  group_by(contrast, subject) %>%
  summarise(meanMemAcc = mean(accuracy))


ggplot(meanMem, aes(x = contrast, y = meanMemAcc)) +
  geom_boxjitter() +
  theme_bw()

ggsave(here("figs", "stairs", "metememory_contrast.png"))

