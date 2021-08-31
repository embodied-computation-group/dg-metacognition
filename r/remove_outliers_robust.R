remove_outliers_robust <- function(x, na.rm = TRUE, ...) {
  
  Z = abs(outliers(x))
  x[which(Z > 3.5)] <- NA
#  x[which(Z < -.5)] <- NA
  y <- x
  y
}

