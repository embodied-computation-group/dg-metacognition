plotBoot <- function (data) {
  
  df <- as_tibble(with(density(data$bootsamples),data.frame(x,y)))
  ci <- data$conf.int
  
  
  ggplot(df, aes(x=x, y=y)) + theme_bw() +
    geom_vline(xintercept = data$estimate, colour = "grey", size = 1) +
    geom_line(size = 2) +
    scale_x_continuous(breaks = seq(-1, 1, 0.1)) +
    theme(axis.text = element_text(size = 10),
          axis.title = element_text(size = 10),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank()) +
    labs(x = "Bootstrap means", y = "Density") +
    # confidence interval ----------------------
  geom_segment(x = ci[1], xend = ci[2],
               y = 0, yend = 0,
               lineend = "round", size = 1.5, colour = "orange") +
    annotate(geom = "label", x = ci[1], y = 0.1*max(df$y), size = 4,
             colour = "white", fill = "orange", fontface = "bold",
             label = paste("L = ", round(ci[1], digits = 2))) +
    annotate(geom = "label", x = ci[2], y = 0.1*max(df$y), size = 4,
             colour = "white", fill = "orange", fontface = "bold",
             label = paste("U = ", round(ci[2], digits = 2)))
  
  
}
  
