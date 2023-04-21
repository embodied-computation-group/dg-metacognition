library(ggplot2)
library(cowplot)

ind_hier <- function (data, x, y, rho = NULL) {
  x_var <- sym(x)
  y_var <- sym(y)
  
  plot <- ggplot(data=data, aes(x = !!x_var, y = !!y_var)) + 
    geom_point(alpha = 5/10, size = 1, shape = 21) +
    theme_cowplot() + theme(legend.position = "none") +
    xlab(expression(paste(mu, " Mratio"))) +  # Updated line for the y-axis label
    ylab(expression(paste(mu, " Mratio"))) +  # Updated line for the x-axis label
    theme(axis.text = element_text(size = 10, family = "sans"),
          axis.title = element_text(size = 10, family = "sans"),
          plot.title = element_text(size = 10, family = "sans"))
  
  if (is.null(rho)) {
    plot <- plot + geom_smooth(method="lm", se=FALSE, size=.5)
  } else {
    slope <- rho * (sd(data[[y]]) / sd(data[[x]]))
    intercept <- mean(data[[y]]) - slope * mean(data[[x]])
    plot <- plot + geom_abline(slope = slope, intercept = intercept,
                               color = "blue", size = .5, alpha = 0.7)
    rho_text <- sprintf("ρ = %.2f", rho)
    plot <- plot + annotate("text", x = min(data[[x]]), y = max(data[[y]]), label = rho_text, hjust = 0, vjust = 1, size = 3)
  }
  
  return(plot)
}
