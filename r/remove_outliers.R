remove_outliers <- function(x, na.rm = TRUE, ...) {
  Mi=0.6745*(x-median(x))/mad(x)
  y <- x
  y[Mi>3.5] <- NA
  y
}