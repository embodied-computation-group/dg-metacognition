ind_hier <- function (data, x,y) {
  ggplot(data=data, aes(x=x, y=y)) + 
    geom_point() +
    theme_cowplot() + theme(legend.position = "none") + geom_smooth(method="lm", se=FALSE, size=1)+
    ylab(expression(paste(mu, " Mratio"))) +
    xlab(expression(paste(mu, " Mratio"))) + theme(axis.text = element_text(size = 14),
                                                  axis.title = element_text(size = 16)) 
}


