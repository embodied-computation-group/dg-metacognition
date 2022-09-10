remove_outliers_robust <- function(x, na.rm = TRUE, ...) {
  
  Z = abs(outliers(x))
  x[which(Z > 3.5)] <- NA
 # sprintf("found %d outliers", sum(Z>3.5))
  y <- x
  return(y)
  
}

