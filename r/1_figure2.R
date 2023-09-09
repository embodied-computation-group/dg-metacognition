
#make the four bins: 
metadataPlot <- metadata %>%group_by(subject) %>% 
  mutate(trial_number = row_number()) %>%
  group_by(subject) #create a trial number column

#split in the four bins according to task 
metadataPlot <- metadataPlot %>%
  group_by(modality) %>%
  mutate(trial_bin = ntile(trial_number, n = 4)) 

#Summarise means for each bin and modality
metadataPlotMean <- metadataPlot %>%
  group_by(trial_bin, modality) %>%
  summarise(mean.acc = mean(accuracy),
            sd.acc = sd(accuracy), n.acc = n_distinct(subject)) %>%
  mutate(se.acc = sd.acc / sqrt(n.acc),
         lower.ci.acc = mean.acc - qt(1 - (0.05 / 2), n.acc - 1) * se.acc,
         upper.ci.acc = mean.acc + qt(1 - (0.05 / 2), n.acc - 1) * se.acc) %>%
  ungroup()


#Average confidence across domains, split by correct and incorrect trials
#split by correct and incorrect:
tmp_data <- metadata  %>%
  mutate(accuracy = factor(accuracy)) %>%
  mutate(accuracy = recode_factor(accuracy, '1' = "Hits", '0' = "Misses"))

#Average confidence for Correct trials:
ConfByError <- tmp_data  %>%
  group_by(subject, modality, accuracy) %>% 
  summarise(avgCF_Corr=mean(confidence, na_rm=TRUE)) 

head(ConfByError)


# Figure2 

#Plot of d' without outliers: 

f2a<-ggplot(mle_metadata_exc, aes(x = modality, y = da, fill= modality)) +
  geom_half_point(range_scale = 8/10, shape = 21, alpha = 1/10, side = "l")+
  geom_half_boxplot(outlier.shape = NA, notch = TRUE, width = 1/4,
                    alpha = 1, color = "black", side = "r")+
  guides(fill="none") +
  ggtitle("Cognitive Sensitivity") +  labs(y = "D-prime", x = "Modality") + 
  theme_cowplot() + 
  scale_fill_manual(values = colors)+
  scale_x_discrete(labels = c("Calories", "GDP","Memory", "Vision")) +
  theme(legend.position = "none", 
        # aspect.ratio = 1,
        plot.title = element_text(size = 12), 
        axis.text=element_text(size=10),
        axis.title=element_text(size=10,face="bold"))

#Plot of group-level Staircases: 


pd <- position_dodge(0.1)
f2b <- ggplot(metadataPlotMean, aes(x = trial_bin, y = mean.acc, group = modality, color= modality)) +
  geom_line(position = pd) +
  geom_point(position = pd) + 
  geom_errorbar(aes(ymin=lower.ci.acc,  ymax = upper.ci.acc),
                size = 1, width=0, position = pd, alpha = 1/4) +
  ylab("Average Accuracy")+
  xlab("Task Quarter") + 
  theme_cowplot() +
  ggtitle("Group-level Staircases") + 
  scale_linetype_discrete(name = "Modality", breaks = c("Calories", "GDP","Memory", "Vision")) +
  scale_x_continuous(labels = label_ordinal())+
  scale_y_continuous(breaks = seq(.6, .9, .1),
                     labels = scales::percent,
                     limits = c(.6, .9)) +
  theme(legend.title = element_blank(), 
        #aspect.ratio = 1,
        legend.position = c(1, 1), 
        legend.justification = c(1,1),
        legend.text = element_text(size = 10), 
        legend.direction = "horizontal", 
        plot.title = element_text(size = 12), 
        axis.text=element_text(size=10),
        axis.title=element_text(size=10,face="bold")) +
  guides(colour = guide_legend(nrow = 2))+
  scale_colour_manual(values = colors)

f <- f2a + f2b 

f <- f +  plot_annotation(tag_levels = 'A',   tag_suffix = ')') & 
  theme(plot.tag = element_text(size = 12))

f




f2c <- ggplot(data=Pilot, 
              aes(x = modality, y = avgCF_Corr, fill=modality, shape = accuracy)) + 
  
  geom_half_point(aes(color = modality), range_scale = 1/2, alpha = 1/10,
                  side = "l", position = position_dodge(c(3/4,3/4)))+
  geom_half_boxplot(outlier.shape = NA, 
                    side = "r", notch = TRUE, width = 1/2,
                    alpha = 1, color = "black", show.legend = FALSE, 
                    position = position_dodge(c(3/4,3/4)))+
  theme_cowplot() +
  labs(y = "Average Confidence",
       x = "Modality", 
       fill = "Legend") + 
  scale_x_discrete(labels = c("Calories", "GDP","Memory", "Vision"))+ 
  scale_shape_manual(values=c(1, 4), guide = "legend")+
  guides(shape = guide_legend(override.aes = list(color = "black", alpha = 1))) +
  scale_fill_manual(values = colors, guide = "none")+
  scale_color_manual(values = colors, guide = "none")+
  scale_y_continuous(breaks = seq(1, 7, 1),
                     limits = c(.5, 7)) +
  ggtitle("Confidence by Accuracy") +
  theme(legend.position = c(.01,.05),
        legend.spacing.y = unit(1, "mm"),
        legend.spacing.x = unit(2, "mm"),
        legend.text.align = 0,
        legend.box.just = "center",
        # aspect.ratio = 1,
        legend.direction="horizontal",
        legend.background = element_blank(),
        legend.text = element_text(size = 10 ), 
        legend.title = element_blank(), 
        plot.title = element_text(size = 12), 
        axis.text=element_text(size=10),
        axis.title=element_text(size=10,face="bold")) 

# M-ratio across modalities:


f2d<-ggplot(mle_metadata_exc, aes(x = modality, y = mratio, fill= modality)) +
  geom_hline(yintercept = 1, linetype="dashed", color = "black", size=.5)+
  aes(ymin = 0) +
  geom_blank() +
  geom_half_point(range_scale = 8/10, shape = 21, alpha = 1/10, side = "l")+
  geom_half_boxplot(outlier.shape = NA, notch = TRUE, width = 1/4, alpha = 1,
                    color = "black", side = "r")+
  guides(color="none") +
  ggtitle("Metacognitive Efficiency")+
  labs(y = "Meta-d'/d'", x = "Modality", color = "Legend") + 
  scale_fill_manual(values = colors)+
  scale_x_discrete(labels = c("Calories", "GDP","Memory", "Vision")) +
  scale_y_continuous(breaks = seq(-2, 4, 1),
                     limits = c(-2, 4)) +
  theme_cowplot() +
  theme(legend.position = "none", 
        #  aspect.ratio = 1, 
        plot.title = element_text(size = 12), 
        axis.text=element_text(size=10),
        axis.title=element_text(size=10,face="bold")) 


f <- f2c + f2d  +  plot_annotation(tag_levels = 'A',   tag_suffix = ')') & 
  theme(plot.tag = element_text(size = 10))

f

figure2 <- (f2a + f2b) / (f2c + f2d) +  plot_annotation(tag_levels = 'A',   tag_suffix = ')') & 
  theme(plot.tag = element_text(size = 10))

