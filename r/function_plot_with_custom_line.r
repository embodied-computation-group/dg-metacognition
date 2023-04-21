library(ggplot2)
library(gridExtra)
library(cowplot)

plot_with_custom_line <- function(plot_data, x, y, rho) {
  
  # calculate slope and intercept
  slope <- rho * (sd(plot_data[[y]]) / sd(plot_data[[x]]))
  intercept <- mean(plot_data[[y]]) - slope * mean(plot_data[[x]])
  
  # create plot with HMM and MLE models
  p <- ggplot(plot_data, aes_string(x = x, y = y, colour = "Model", group = "Model")) +
    geom_path(aes(group = ID), 
              colour = "gray", 
              alpha = 1, 
              arrow = arrow(type = "open", end = "first",
                            length=unit(1, "mm"))) +
    geom_point(size = 1, shape = 21, alpha = .75) +
    stat_ellipse(type = "norm", size = 1, linetype = 2) +
    #scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMM", "MLE")) +
    geom_smooth(method = 'lm', formula = y ~ x, se = FALSE, aes(linetype = "MLE"), size = 1, fullrange = TRUE) +
    #geom_abline(slope = slope, intercept = intercept, color = "#425B8D", size = 1, alpha = 0.7)+
    scale_linetype_manual(values = c(2, 1), labels = c("HMM", "MLE")) +
    scale_color_manual(values = c("#425B8D", "#D38D57"), labels = c("HMM", "MLE")) +
    theme_cowplot()+
    theme(legend.position = "bottom") +
    theme(plot.title = element_text(hjust = 0.5))
  
  
  return(p)
}
