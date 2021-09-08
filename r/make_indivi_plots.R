#Check staircase procedure: First create individual dataframes. 
memory <- metadata %>%filter(modality == c('memory')) 
knowledge <- metadata %>%filter(modality == c('trivia')) 
percept <- metadata %>%filter(modality == c('vision')) 

#Perception: 
Pplot_list = list() 

for(t in 1:length(percept$subject)) { 
  Pplots <- (ggplot(percept) +
               geom_step(aes(x=(trial), y=contrast)) +
               xlab("trial") +
               ylab("contrast") + theme_bw() + facet_wrap(percept$subject))
  Pplot_list[[t]] = Pplots
} #Create plots for each participant

#save to pdf with 20 participants on each page: 
pdf("staircaseplots.pdf")
for (k in 20:length(percept$subject)) {
  print(Pplot_list[[k]])
}
dev.off()

## MUST DE_COLLAPSE TRIVIA FOR THE NEXT ANALYSIS/FIGURE OUT HOW TO DO ANOTHER DATAFRAME HERE. 

glimpse(metadata)