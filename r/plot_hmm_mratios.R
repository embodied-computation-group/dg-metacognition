memPlot <- mcmc.sample %>%
  filter(Parameter == "mu_logMratio[1]") %>% 
  ggplot(aes(exp(value))) +
  geom_histogram(binwidth = 0.01, fill = "blue", colour = "grey", alpha = 0.5) +
  geom_vline(xintercept = exp(stat$mean[stat$name == "mu_logMratio[1]"]),linetype="dashed", size = 1) +
  geom_segment(aes(x = exp(HDI$lower[HDI$name == "mu_logMratio[1]"]), y = 50, xend = exp(HDI$upper[HDI$name == "mu_logMratio[1]"]), yend = 50), colour = "blue", size = 2.5) +
  apatheme +
  xlim(c(1, 1.25)) +
  ylim(c(0, 7000)) +
  ylab("Sample count") +
  ggtitle("Meta-Memory") +
  xlab(expression(paste(mu, " Mratio")))

calPlot <- mcmc.sample %>%
  filter(Parameter == "mu_logMratio[2]") %>% 
  ggplot(aes(exp(value))) +
  geom_histogram(binwidth = 0.01, fill = "blue", colour = "grey", alpha = 0.5) +
  geom_vline(xintercept = exp(stat$mean[stat$name == "mu_logMratio[2]"]),linetype="dashed", size = 1) +
  geom_segment(aes(x = exp(HDI$lower[HDI$name == "mu_logMratio[2]"]), y = 50, xend = exp(HDI$upper[HDI$name == "mu_logMratio[2]"]), yend = 50), colour = "blue", size = 2.5) +
  apatheme +
  xlim(c(0.5, 1)) +
  ylim(c(0, 7000)) +
  ggtitle("Meta-Calories") +
  ylab("Sample count") +
  xlab(expression(paste(mu, " Mratio")))

gdpPlot <- mcmc.sample %>%
  filter(Parameter == "mu_logMratio[3]") %>% 
  ggplot(aes(exp(value))) +
  geom_histogram(binwidth = 0.01, fill = "blue", colour = "grey", alpha = 0.5) +
  geom_vline(xintercept = exp(stat$mean[stat$name == "mu_logMratio[3]"]),linetype="dashed", size = 1) +
  geom_segment(aes(x = exp(HDI$lower[HDI$name == "mu_logMratio[3]"]), y = 50, xend = exp(HDI$upper[HDI$name == "mu_logMratio[3]"]), yend = 50), colour = "blue", size = 2.5) +
  apatheme +
  ggtitle("Meta-GDP") +
  xlim(c(1, 1.25)) +
  ylim(c(0, 7000)) +
  ylab("Sample count") +
  xlab(expression(paste(mu, " Mratio")))



visPlot <- mcmc.sample %>%
  filter(Parameter == "mu_logMratio[4]") %>% 
  ggplot(aes(exp(value))) +
  geom_histogram(binwidth = 0.01, fill = "blue", colour = "grey", alpha = 0.5) +
  geom_vline(xintercept = exp(stat$mean[stat$name == "mu_logMratio[4]"]),linetype="dashed", size = 1) +
  geom_segment(aes(x = exp(HDI$lower[HDI$name == "mu_logMratio[4]"]), y = 50, xend = exp(HDI$upper[HDI$name == "mu_logMratio[4]"]), yend = 50), colour = "blue", size = 2.5) +
  apatheme +
  ggtitle("Meta-Vision") +
  xlim(c(0.5, 1)) +
  ylim(c(0, 7000)) +
  ylab("Sample count") +
  xlab(expression(paste(mu, " Mratio")))

