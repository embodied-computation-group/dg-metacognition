#Check staircase procedure: First create individual dataframes. 
memory <- metadata %>%filter(modality == c('memory')) 
knowledge <- metadata %>%filter(modality == c('trivia')) 
percept <- metadata %>%filter(modality == c('vision')) 

subjects <- unique(percept$subject)

this_data <- percept %>% filter(subject == subjects[t])

#Perception:
for(t in seq(1,length(subjects), 12) ) { 
  plots = list()
  counter = 0
  for(p in seq(t, t+11)) {
    
    counter = counter + 1;
    tmp_data <- percept %>% filter(subject == subjects[p])
    this_median = median(median(tmp_data$contrast))
    thisPlot <- ggplot(tmp_data) +
    geom_step(aes(x=(trial), y=contrast)) +
    xlab("trial") +
    ylim(-5, 30) +
    xlim(0, 200)+ 
    geom_hline(yintercept = this_median) +
    ylab("contrast") + theme_bw() +
    ggtitle(paste("subject", subjects[p], "visStair", sep = "_"))
    plots[[counter]] <- thisPlot
    
    
  } 
  
  filename=paste("staircase",subjects[t], "_", subjects[t+11],".png",sep="")
  wrap_plots(plots)
  ggsave(here("figs", filename))

}

#Create plots for each participant

#save to pdf with 20 participants on each page: 
pdf("staircaseplots.pdf")
for (k in 20:length(percept$subject)) {
  print(Pplot_list[[k]])
}
dev.off()

## MUST DE_COLLAPSE TRIVIA FOR THE NEXT ANALYSIS/FIGURE OUT HOW TO DO ANOTHER DATAFRAME HERE. 

glimpse(metadata)