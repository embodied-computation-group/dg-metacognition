scatter <- function (data, x,y) {
  ggplot(data=data, aes(x=x, y=y)) + theme_bw() +
    geom_point() +
    theme(axis.text = element_text(size = 14),
          axis.title = element_text(size = 16)) + geom_smooth(method="lm", se=FALSE, size=1) +
    guides(fill="none") + 
    theme_cowplot() + theme(legend.position = "none")
  
  
  
  
}