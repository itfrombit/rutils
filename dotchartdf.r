## dotchartdf.r
##
## Function for plotting dotcharts from data frames.
##
## Author: Jeff Buck
## 
## dotchartdf <- function(data, xvar, yvar, title="", alpha=0.05, dividers=TRUE,
##                        log=FALSE, dotspacing=0.07, legend=TRUE)
##
##  data - a dataframe
##  xvar - name of the factor column in the dataframe
##  yvar - name of the numeric column in the dataframe to plot
##  title - chart title
##  alpha - confidence interval
##  dividers - whether to draw vertical dividers between factors
##  log - whether to first take the log of yvar values before plotting
##  dotspacing - fine-tune the space between dots in the plot
##               useful when there are lots of dots or very few factors
##  legend - whether to draw a legend on the plot
##
## Sample usage:
##
## data(InsectSprays)
## dotchartdf(InsectSprays, "spray", "count", "Insect Deaths by Insecticide Type")
##
## data(airquality)
## dotchartdf(airquality, "Month", "Temp", "Temperature by Month")
## dotchartdf(airquality, "Month", "Ozone", "log(Ozone) by Month", alpha=0.05, log=TRUE)
## 
## data(iris)
## dotchartdf(iris, "Species", "Sepal.Length", "Sepal Length by Species", alpha=0.01, dotspacing=0.04)
## 
## par(mfrow=c(2,2))
## for (param in c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")) {
##   dotchartdf(iris, "Species", param, paste(param,"by Species"))
## }
## par(mfrow=c(1,1))


## dotplotjitter - helper function to space and center the dots
dotplotjitter <- function(i, data, dotspacing = 0.07) {
  idx <- 1
  x <- rep(i, length(data))
  y <- rep(-1, length(data))
  tdata <- table(data)

  for (t in 1:length(tdata)) {
    # centerline is i
    value <- as.numeric(names(tdata[t]))
    
    startoff <- i - dotspacing * (tdata[t]-1)/2
    
    for (j in 1:tdata[t]) {
      y[idx] <- value
      x[idx] <- startoff + dotspacing * (j - 1)
      idx <- idx + 1
    }
  }
  
  cbind(x, y)
}


dotchartdf <- function(data, xvar, yvar, title="", alpha=0.05, dividers=TRUE,
                       log=FALSE, dotspacing=0.07, legend=TRUE) {
  d <- data[!is.na(data[,yvar]),]  # remove NA's
  if (log) {
    d[,yvar] <- log10(d[,yvar])
    ylab <- paste("log(", yvar, ")", sep="")
  }
  else
  {
    ylab <- yvar
  }

  if (alpha == 0.0) { legend = FALSE }

  splitdata <- split(d, d[,xvar], drop=TRUE)  # factor by xvar
  plot(NULL, xlim=c(0.5, length(splitdata) + 0.5), ylim=range(d[,yvar]),
       xlab=xvar, ylab=ylab, main=title, xaxt='n')
  axis(side=1, at=1:length(splitdata), labels=names(splitdata))  # use factor names
  
  if (legend) {
    legend("bottomright", legend=c("mean", "median", paste("alpha:", alpha)), 
           col=c("blue", "orange", "blue"), lty=c(2, 2, 1), cex=0.7)
  }
  if (dividers) {
    sapply(1:(length(splitdata)-1), function(x) { abline(v=x+0.5, col="gray") })
  }
  
  for (i in 1:length(splitdata)) {
    s <- splitdata[[i]][,yvar]  # get the ith factor
    ci <- mean(s) + c(-1, 1) * qnorm(1-alpha/2) * sd(s) / sqrt(length(s))
    
    plotdata <- dotplotjitter(i, s, dotspacing)
    normals <- (plotdata[,2] > ci[1] & plotdata[,2] < ci[2])
    points(plotdata[,1][normals], plotdata[,2][normals],
           pch=21, bg="lightblue")
    points(plotdata[,1][!normals], plotdata[,2][!normals],
           pch=21, bg="red")

    if (alpha != 0.0) {
      xrange <- c(-0.3, 0.3)  # width of our annotation lines and box
      rect(i + xrange[1], ci[1], i + xrange[2], ci[2], lwd=1, border="blue")  # ci box
      lines(i + xrange, rep(mean(s), 2), lwd=1, col="blue", lty=2)  # mean
      lines(i + xrange, rep(median(s), 2), lwd=1, col="orange", lty=2)  # median
    }
  }
}



