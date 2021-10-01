
RhoPlot <- function(data, rho) {

  
  
  ggplot(data, aes(value)) +
  geom_histogram(binwidth = 0.03, fill = "blue", colour = "grey", alpha = 0.5) +
  geom_vline(xintercept = stat$mean[stat$name == rho],linetype="dashed", size = 1.5) +
  geom_segment(aes(x = HDI$lower[HDI$name == rho], y = 50, xend = HDI$upper[HDI$name == rho], yend = 50), colour = "white", size = 2.5) +
  apatheme +
  xlim(c(-0.25, 1)) +
  theme(plot.title = element_text( size = 12),
        plot.subtitle = element_text(size = 8)) +
  # ylim(c(0, 2500)) +
  ylab("Sample count") +
  xlab(expression(paste(rho, " value")))
  
  }