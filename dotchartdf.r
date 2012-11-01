# Function for plotting dotcharts with data frames
# 
# 
# dotchartdf(InsectSprays, "spray", "count", "Insect Deaths by Insecticide Type", 0.05, log=FALSE)
dotchartdf <- function(data, xvar, yvar, title="", alpha=0.05, dividers=TRUE, log=FALSE) {
  d <- data[!is.na(data[,yvar]),]  # remove NA's
  if (log) {
    d[,yvar] <- log10(d[,yvar])
  }
  
  splitdata <- split(d, d[,xvar], drop=TRUE)  # factor by xvar
  plot(NULL, xlim=c(0.5, length(splitdata) + 0.5), ylim=range(d[,yvar]),
       xlab=xvar, ylab=yvar, main=title,
       xaxt='n')
  axis(side=1, at=1:length(splitdata), labels=names(splitdata))  # use factor names
  legend("bottomright", legend=c("mean", "median"), col=c("blue", "orange"), lty=2)
  if (dividers) {
    sapply(1:(length(splitdata)-1), function(x) { abline(v=x+0.5, col="gray") })  # dividers    
  }
  
  for (i in 1:length(splitdata)) {
    s <- splitdata[[i]][,yvar]  # get the ith factor
    ci <- mean(s) + c(-1, 1) * qnorm(1-alpha/2) * sd(s) / sqrt(length(s))
    normals <- (s > ci[1] & s < ci[2])  # bool vector for vals within ci
    points(jitter(rep(i, length(s[normals])), amount=0.1), s[normals],
           pch=21, bg="lightblue")
    points(jitter(rep(i, length(s[!normals])), amount=0.1), s[!normals],
           pch=21, bg="red")  # possible outliers

    xrange <- c(-0.3, 0.3)  # width of our annotation lines and box
    rect(i + xrange[1], ci[1], i + xrange[2], ci[2], lwd=1, border="blue")  # ci box
    lines(i + xrange, rep(mean(s), 2), lwd=1, col="blue", lty=2)  # mean
    lines(i + xrange, rep(median(s), 2), lwd=1, col="orange", lty=2)  # median
  }
}

# Sample usage:
#
# data(InsectSprays)
# data(airquality)
# data(iris)
# 
# dotchartdf(InsectSprays, "spray", "count", "Insect Deaths by Insecticide Type", 0.05, log=FALSE)
# dotchartdf(airquality, "Month", "Temp", "Temperature by Month")
# dotchartdf(airquality, "Month", "Ozone", "Ozone by Month", 0.05, log=TRUE)
# dotchartdf(iris, "Species", "Sepal.Length", "Sepal Length by Species", 0.05)
#
# Not the greatest dataset to use, but a simple example of multiple dotcharts
# par(mfrow=c(2,2))
# for (param in c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")) {
#   dotchartdf(iris, "Species", param, paste(param,"by Species"), 0.05)  
# }
# par(mfrow=c(1,1))

