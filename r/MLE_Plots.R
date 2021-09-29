
#unfiltered
p1<-ggplot(fitAvg_data, aes(x = modality, y =c, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Criterion Unfiltered")
p2<-ggplot(fitAvg_data, aes(x = modality, y = avg_conf, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Metacognitive Bias Unfiltered")
p3<-ggplot(fitAvg_data, aes(x = modality, y = mda, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Metacognitive Sensitivity Unfiltered")
p4<-ggplot(fitAvg_data, aes(x = modality, y = da, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Cognitive Sensitivity Unfiltered")
p5<-ggplot(fitAvg_data, aes(x = modality, y = mratio, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Metacognitive efficiency Unfiltered")

#combine the plots:
Dataunfil1 <- ggarrange(p1, p4)
Dataunfil2 <- ggarrange(p2, p3, p5, ncol = 3)

#filtered Plots: 
p6<-ggplot(metadata_exc, aes(x = modality, y =c, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Cognitive Criterion") +
  ylab("c") + xlab("Modality")
p7<-ggplot(metadata_exc, aes(x = modality, y = avg_conf, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Metacognitive Bias")+
  ylab("Average Confidence") + xlab("Modality")

p8<-ggplot(metadata_exc, aes(x = modality, y = mratio, fill= modality)) +
  geom_boxjitter(outlier.shape = NA,
                 jitter.shape = 21, notch = TRUE, width = .25,
                 errorbar.draw = TRUE, errorbar.length = .2, alpha = .7) +
  #geom_half_violin(alpha = 0.7)+
  #  geom_half_point(shape = 21, alpha = 0.7, transformation = position_jitter(.01), range_scale = .5, side = "r")+
  # geom_half_boxplot(outlier.shape = NA, 
  #                  side = "l", notch = TRUE, width = 0.25,
  #                  position = position_dodge(c(.75,.75)), alpha = 0.7, color = "black")+
  guides(color="none") +
  ggtitle("Metacognitive Efficiency")+
  labs(y = "Meta-d'/d'", x = "Modality", color = "Legend") + 
  scale_fill_manual(values = colors)+
  scale_x_discrete(labels = c("Calories", "GDP","Memory", "Vision")) +
  theme_cowplot() +
  theme(legend.position = "none") 


p9<-ggplot(metadata_exc, aes(x = modality, y = da, fill= modality)) +
  geom_boxjitter(outlier.shape = NA,
                 jitter.shape = 21, notch = TRUE, errorbar.draw = TRUE,
                 errorbar.length = .2, alpha = .7) +
  #   geom_half_violin(alpha = 0.7)+
  #  geom_half_point(shape = 21, alpha = 0.7)+
  #  geom_half_boxplot(outlier.shape = NA, 
  #                   side = "l", notch = TRUE, width = 0.25,
  #                    position = position_dodge(c(.75,.75)), alpha = 0.7, color = "black")+
  
  guides(fill="none") +
  ggtitle("Cognitive Sensitivity") +  labs(y = "d'", x = "Modality") + 
  theme_cowplot() + 
  scale_fill_manual(values = colors)+
  scale_x_discrete(labels = c("Calories", "GDP","Memory", "Vision")) +
  theme(legend.position = "none")

p10<-ggplot(metadata_exc, aes(x = modality, y = mda, color= modality)) +
  geom_boxjitter() + theme_bw() + guides(color="none") +
  ggtitle("Metacognitive Sensitivity")+ 
  ylab("meta-d'") + xlab("Modality")

# Filtered versus unfiltered 
filunfil1 <- ggarrange(p1, p6)
annotate_figure(filunfil1, top = text_grob("Cognitive Criterion filtered/unfiltered", color = "black", face = "bold", size = 14))
filunfil5 <- ggarrange(p4, p9)
annotate_figure(filunfil5, top = text_grob("Cognitive Sensitivity filtered/unfiltered", color = "black",face = "bold", size = 14))
filunfil2 <- ggarrange(p2, p7)
annotate_figure(filunfil2, top = text_grob("Metaognitive Bias filtered/unfiltered", color = "black", face = "bold", size = 14))
filunfil3 <- ggarrange(p3, p10)
annotate_figure(filunfil3, top = text_grob("Metacognitive Sensitivity filtered/unfiltered",   color = "black", face = "bold", size = 14))
filunfil4 <- ggarrange(p5, p8)
annotate_figure(filunfil4, top = text_grob("Metacognitive Efficiency filtered/unfiltered", color = "black",  face = "bold", size = 14))


#Filtered data´: 
Datafil1 <- ggarrange(p9, p6)
annotate_figure(Datafil1, top = text_grob("MLE Estimation of Cognitive performance", color = "black",face = "bold", size = 14))  
Datafi2 <- ggarrange(p7, p10, p8, ncol = 3)
annotate_figure(Datafi2, top = text_grob("MLE Estimation of Metacognitive performance", 
                                         color = "black", face = "bold", size = 14))  
