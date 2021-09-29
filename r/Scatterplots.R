#These are the scatter plots for the MLE estimation. 

#Metacognitive Sensitivity
scat1 <- as_tibble(corr)
s1 <-scatter(scat1, scat1$mda_memory, scat1$mda_Calories) + 
  scale_y_continuous("Calories")+ scale_x_continuous("Memory")
s2 <- scatter(scat1, scat1$mda_memory, scat1$mda_vision) + 
  scale_y_continuous("Vision")+ scale_x_continuous("Memory")
s3 <- scatter(scat1, scat1$mda_memory, scat1$mda_GDP) + 
  scale_y_continuous("GDP")+ scale_x_continuous("Memory")
s4 <- scatter(scat1, scat1$mda_GDP, scat1$mda_vision) + 
  scale_y_continuous("Vision")+ scale_x_continuous("GDP")
s5 <- scatter(scat1, scat1$mda_GDP, scat1$mda_Calories) + 
  scale_y_continuous("Calories")+ scale_x_continuous("GDP")
s6 <- scatter(scat1, scat1$mda_Calories, scat1$mda_vision) +
  scale_y_continuous("Vision") + scale_x_continuous("Calories")

comPlot1 <- ggarrange(s1, s2, s3, s4, s5, s6)
annotate_figure(comPlot1, top = text_grob("Metacognitive Sensitivity", color = "black", 
                                          face = "bold", size = 14))  

#Metacognitive Efficiency
#Indicate the estimated correlations: 
S1title <- paste("r =",round(res1.1$estimate, digits=3))
S2title <- paste("r =",round(res1.2$estimate, digits=3))
S3title <- paste("r =",round(res1.3$estimate, digits=3))
S4title <- paste("r =",round(res1.4$estimate, digits=3))
S5title <- paste("r =",round(res1.5$estimate, digits=3))
S6title <- paste("r =",round(res1.6$estimate, digits=3))


scat2 <- as_tibble(corr1)
s11 <- scatter(scat2, scat2$mratio_memory, scat2$mratio_Calories) + theme(plot.title = element_text( size = 10)) + scale_y_continuous("Calories")+scale_x_continuous("Memory") + ggtitle(paste(S1title))
s12 <- scatter(scat2, scat2$mratio_memory, scat2$mratio_vision) + theme(plot.title = element_text( size = 10)) + scale_y_continuous("Vision")+scale_x_continuous("Memory") + ggtitle(paste(S2title))
s13 <- scatter(scat2, scat2$mratio_memory, scat2$mratio_GDP) + theme(plot.title = element_text( size = 10)) + scale_y_continuous("GDP")+scale_x_continuous("Memory") + ggtitle(paste(S3title))
s14 <- scatter(scat2, scat2$mratio_GDP, scat2$mratio_vision) +  theme(plot.title = element_text( size = 10)) +scale_y_continuous("Vision")+scale_x_continuous("GDP") + ggtitle(paste(S4title))
s15 <- scatter(scat2, scat2$mratio_GDP, scat2$mratio_Calories) + theme(plot.title = element_text( size = 10)) + scale_y_continuous("Calories")+ scale_x_continuous("GDP") + ggtitle(paste(S5title))
s16 <- scatter(scat2, scat2$mratio_Calories, scat2$mratio_vision) + theme(plot.title = element_text( size = 10)) + scale_y_continuous("Vision")+scale_x_continuous("Calories") + ggtitle(paste(S6title))

comPlot2 <- ggarrange(s11, s12, s13, s14, s15, s16) 
annotate_figure(comPlot2, top = text_grob("Metacognitive Efficiency", color = "black", 
                                          face = "bold", size = 14))    


#Metacognitive Bias
scat3 <- as_tibble(corr2)
s21 <-scatter(scat3, scat3$avg_conf_memory, scat3$avg_conf_Calories) +
  scale_y_continuous("Calories") + scale_x_continuous("Memory")
s22 <- scatter(scat3, scat3$avg_conf_memory, scat3$avg_conf_vision) + 
  scale_y_continuous("Vision") + scale_x_continuous("Memory")
s23 <- scatter(scat3, scat3$avg_conf_memory, scat3$avg_conf_GDP) + 
  scale_y_continuous("GDP") + scale_x_continuous("Memory")
s24 <- scatter(scat3, scat3$avg_conf_GDP, scat3$avg_conf_vision) + 
  scale_y_continuous("Vision") + scale_x_continuous("GDP")
s25 <- scatter(scat3, scat3$avg_conf_GDP, scat3$avg_conf_Calories) + 
  scale_y_continuous("Calories") + scale_x_continuous("GDP")
s26 <- scatter(scat3, scat3$avg_conf_Calories, scat3$avg_conf_vision) + 
  scale_y_continuous("Vision") + scale_x_continuous("Calories")

comPlot3 <- ggarrange(s21, s22, s23, s24, s25, s26)
annotate_figure(comPlot3, top = text_grob("Metacognitive Bias", color = "black", 
                                          face = "bold", size = 14)) 