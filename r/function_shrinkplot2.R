
# get the data

hmm_Mratio <- Mratio_indiv
mle_Mratio <- mle_wdata_exclude %>% 
  select(subject, starts_with("mratio"))


#rename the data

colnames(mle_Mratio) <- c("ID", "mle_Memory", "mle_Calories", "mle_GDP", "mle_Vision")
colnames(hmm_Mratio) <- c("ID", "hmm_Calories", "hmm_GDP", "hmm_Memory", "hmm_Vision")

# reorder to memory, vision, calories, gdp

mle_Mratio <- mle_Mratio[c("ID", "mle_Memory", "mle_Vision", "mle_Calories", "mle_GDP")]
hmm_Mratio <- hmm_Mratio[c("ID", "hmm_Memory", "hmm_Vision", "hmm_Calories", "hmm_GDP")]



# combine data

mratio_all <- full_join(mle_Mratio, hmm_Mratio, by = "ID")

# pivot

mratio_all_long <- mratio_all %>% 
  pivot_longer(names_to = c("Model", "Task"), names_sep = "_", cols = mle_Memory:hmm_GDP)

mratio_all_long$Model <- as.factor(mratio_all_long$Model) 
levels(mratio_all_long$Model) <- c("HMeta-d'", "MLE")
# figure params

big_line_size = 3/4
xcoords=c(-1,2)
ycoords=c(-1,4)
# figure, memory, vision

plot_data <- mratio_all %>%
  select(ID, mle_Memory, mle_Vision, hmm_Memory, hmm_Vision) %>% 
  pivot_longer(names_to = c("Model", ".value"), names_sep = "_", cols = 2:5) 


p1 <- plot_with_custom_line(plot_data, "Calories", "GDP", meanRho$value[1])

p1







## old code
p1 <- ggplot(plot_data, aes(x = Memory, y = Vision, colour = Model, group = Model))+
  geom_path(aes(group = ID), 
            colour = "gray", 
            alpha = 1, 
            arrow = arrow(type = "open", end = "first",
                          length=unit(1, "mm"))) +
  geom_point(size = 1, shape = 21, alpha = .75) +
  stat_ellipse(type = "norm", size = big_line_size, linetype = 2) +
  scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMeta-d'", "MLE"))+
  geom_smooth(method='lm', formula= y~x, se = FALSE, size = big_line_size, fullrange = TRUE) +
  theme_cowplot() +
#  xlim(xcoords)+
#  ylim(ycoords)+
  theme(legend.position="bottom")


#p1 <- ggMarginal(p1, type = "density", groupColour = TRUE)
 
p1
  

# figure, memory, calories

plot_data <- mratio_all %>%
  select(ID, mle_Memory, mle_Calories, hmm_Memory, hmm_Calories) %>% 
  pivot_longer(names_to = c("Model", ".value"), names_sep = "_", cols = 2:5) 


p2 <- ggplot(plot_data, aes(x = Memory, y = Calories, colour = Model, group = Model))+
  geom_path(aes(group = ID), 
            colour = "gray", 
            alpha = 1, 
            arrow = arrow(type = "open", end = "first",
                          length=unit(1, "mm"))) +
  geom_point(size = 1, shape = 21, alpha = .75) +
  stat_ellipse(type = "norm", size = big_line_size, linetype = 2) +
  scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMeta-d'", "MLE"))+
  geom_smooth(method='lm', formula= y~x, se = FALSE, size = big_line_size, fullrange = TRUE) +
#  xlim(xcoords)+
#  ylim(ycoords)+
  theme_cowplot() +
  theme(legend.position="bottom")


#p2 <- ggMarginal(p2, type = "density", groupColour = TRUE)

p2


# figure, memory, gdp

plot_data <- mratio_all %>%
  select(ID, mle_Memory, mle_GDP, hmm_Memory, hmm_GDP) %>% 
  pivot_longer(names_to = c("Model", ".value"), names_sep = "_", cols = 2:5) 


p3 <- ggplot(plot_data, aes(x = Memory, y = GDP, colour = Model, group = Model))+
  geom_path(aes(group = ID), 
            colour = "gray", 
            alpha = 1, 
            arrow = arrow(type = "open", end = "first",
                          length=unit(1, "mm"))) +
  geom_point(size = 1, shape = 21, alpha = .75) +
  stat_ellipse(type = "norm", size = big_line_size, linetype = 2) +
  scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMeta-d'", "MLE"))+
  geom_smooth(method='lm', formula= y~x, se = FALSE, size = big_line_size, fullrange = TRUE) +
#  xlim(xcoords)+
#  ylim(ycoords)+
  theme_cowplot() +
  theme(legend.position="bottom")


#p3 <- ggMarginal(p3, type = "density", groupColour = TRUE)

p3

# figure, vision, calories

plot_data <- mratio_all %>%
  select(ID, mle_Vision, mle_Calories, hmm_Vision, hmm_Calories) %>% 
  pivot_longer(names_to = c("Model", ".value"), names_sep = "_", cols = 2:5) 


p4 <- ggplot(plot_data, aes(x = Vision, y = Calories, colour = Model, group = Model))+
  geom_path(aes(group = ID), 
            colour = "gray", 
            alpha = 1, 
            arrow = arrow(type = "open", end = "first",
                          length=unit(1, "mm"))) +
  geom_point(size = 1, shape = 21, alpha = .75) +
  stat_ellipse(type = "norm", size = big_line_size, linetype = 2) +
  scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMeta-d'", "MLE"))+
  geom_smooth(method='lm', formula= y~x, se = FALSE, size = big_line_size, fullrange = TRUE) +
#  xlim(xcoords)+
#  ylim(ycoords)+
  theme_cowplot() +
  theme(legend.position="bottom")


#p4 <- ggMarginal(p4, type = "density", groupColour = TRUE)

p4


# figure, vision, gdp

plot_data <- mratio_all %>%
  select(ID, mle_Vision, mle_GDP, hmm_Vision, hmm_GDP) %>% 
  pivot_longer(names_to = c("Model", ".value"), names_sep = "_", cols = 2:5) 


p5 <- ggplot(plot_data, aes(x = Vision, y = GDP, colour = Model, group = Model))+
  geom_path(aes(group = ID), 
            colour = "gray", 
            alpha = 1, 
            arrow = arrow(type = "open", end = "first",
                          length=unit(1, "mm"))) +
  geom_point(size = 1, shape = 21, alpha = .75) +
  stat_ellipse(type = "norm", size = big_line_size, linetype = 2) +
  scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMeta-d'", "MLE"))+
  geom_smooth(method='lm', formula= y~x, se = FALSE, size = big_line_size, fullrange = TRUE) +
#  xlim(xcoords)+
#  ylim(ycoords)+
  theme_cowplot() +
  theme(legend.position="bottom")


#p5 <- ggMarginal(p5, type = "density", groupColour = TRUE)

p5

# figure, calories, gdp

plot_data <- mratio_all %>%
  select(ID, mle_Calories, mle_GDP, hmm_Calories, hmm_GDP) %>% 
  pivot_longer(names_to = c("Model", ".value"), names_sep = "_", cols = 2:5) %>% 
  na.omit()

plot_data$Model<-as.factor(plot_data$Model)


p6 <- ggplot(plot_data, aes(x = Calories, y = GDP, colour = Model, group = Model))+
  geom_path(aes(group = ID), 
            colour = "gray", 
            alpha = 1, 
            arrow = arrow(type = "open", end = "first",
                          length=unit(1, "mm"))) +
  geom_point(size = 1, shape = 21, alpha = .75) +
  stat_ellipse(type = "norm", size = big_line_size, linetype = 2) +
  scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMeta-d'", "MLE"))+
  geom_smooth(method='lm', formula= y~x, se = FALSE, size = big_line_size, fullrange = TRUE) +
#  xlim(xcoords)+
#  ylim(ycoords)+
  theme_cowplot() +
  theme(legend.position="bottom")

p6
ggsave(filename = here("figs", "shrinkage_test_plot.png"), units = "cm", dpi = 600, width = 17.5, height = 17.5)


#p6 <- ggMarginal(p6, type = "density", groupColour = TRUE)

p6


## arrange em

#plots <- ggarrange(p1, p2, p3, p4, p5, p6, common.legend = TRUE)


p1 + p2 + p3 + p4 + p5 + p6 + plot_layout(ncol = 3, guides = 'collect') &
  theme(legend.position = 'top',
        legend.direction = 'horizontal', legend.background = element_blank(),
        legend.box.background = element_rect(colour = "black"),
        legend.margin = margin(6, 6, 6, 6))

ggsave(filename = here("figs", "sFig5.png"), units = "cm", dpi = 600, width = 17.6, height = 17.6)


#ggexport(plots, filename = here("figs", "shrinkage_all_plot.pdf"), res = 600)
#ggexport(plots, filename = here("figs", "shrinkage_all_plot.png"), res = 600, width = 1600, height = 900)
