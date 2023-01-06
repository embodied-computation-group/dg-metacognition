source(here("r", "Function_scatterplot.R"))

corr1F <- fit_data_wideEvenF %>%
  select(starts_with("Even_mratio"))
corr2F <- fit_data_wideOddF %>%
  select(starts_with("Odd_mratio"))

corrCom <- data.frame(MemEven=fit_data_wideEvenF$Even_mratio_memory,
                      CalEven=fit_data_wideEvenF$Even_mratio_Calories,
                      GDPEven=fit_data_wideEvenF$Even_mratio_GDP,
                      VisEven=fit_data_wideEvenF$Even_mratio_vision,
                      MemOdd=fit_data_wideOddF$Odd_mratio_memory,
                      CalOdd=fit_data_wideOddF$Odd_mratio_Calories,
                      GDPOdd=fit_data_wideOddF$Odd_mratio_GDP,
                      VisOdd=fit_data_wideOddF$Odd_mratio_vision)
#Metacognitive Sensitivity
scat1 <- as_tibble(corrCom)
s1 <-scatter(scat1, scat1$MemEven, scat1$MemOdd) + 
  scale_y_continuous("Memory Even")+ scale_x_continuous("Memory Odd")
s2 <- scatter(scat1, scat1$CalEven, scat1$CalOdd) + 
  scale_y_continuous("Calories Even")+ scale_x_continuous("Calories Odd")
s3 <- scatter(scat1, scat1$GDPEven, scat1$GDPOdd) + 
  scale_y_continuous("GDP Even")+ scale_x_continuous("GDP Odd")
s4 <- scatter(scat1, scat1$VisEven, scat1$VisOdd) +
  scale_y_continuous("Vision Even") + scale_x_continuous("Vision Odd")

comPlot1 <- ggarrange(s1, s2, s3, s4)
annotate_figure(comPlot1, top = text_grob("Split-half Analysis of Metacognitive Efficiency", color = "black", face = "bold", size = 14))  


ggsave(here("figs", "SplitHald_Filtered.png")) 
