Utilities for R
===============

Miscellaneous utility functions for R.


dotchartdf
----------

**Usage**

	dotchartdf(data, xvar, yvar, title, alpha=0.05, dividers=TRUE,
	           log=FALSE, dotspacing=0.07, legend=TRUE)


**Description**

Creates a dotchart from a dataframe.

`xvar` is the name of the dataframe column that will be used as the factor.  
`yvar` is the name of the dataframe column that will be plotted.  
`title` will be used as the title of the plot.  
`alpha` sets the confidence interval. The default value is 0.05. If alpha is set to 0,
	no confidence intervals or mean/median lines will be drawn.  
`dividers` is a flag that will draw vertical dividers between factors if set to TRUE. Default is TRUE. 
`log` is a flag that will take the log of the yvar values if set to TRUE. Default is FALSE.  
`dotspacing` sets the horizontal spacing between dots with the same value in a factor.
	Setting dotspacing is useful when there are lots of dots or very few factors.  
`legend` is a flag that will draw a legend on the plot if set to TRUE. Default is TRUE.

**Sample usage**

	# These examples all use sample datasets that come with R.
	data(InsectSprays)
	dotchartdf(InsectSprays, "spray", "count", "Insect Deaths by Insecticide Type")

	data(airquality)
	dotchartdf(airquality, "Month", "Temp", "Temperature by Month")

	# Take the log of the Ozone values to try to get closer to a normal distribution
	dotchartdf(airquality, "Month", "Ozone", "Ozone by Month", alpha=0.01, log=TRUE)

	data(iris)
	dotchartdf(iris, "Species", "Sepal.Length", "Sepal Length by Species", dotspacing=0.04)

	# Not the greatest dataset to use, but a simple example of multiple dotcharts
	par(mfrow=c(2,2))
	for (param in c("Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width")) {
		dotchartdf(iris, "Species", param, paste(param,"by Species"), dotspacing=0.04, legend=FALSE)  
	}
	par(mfrow=c(1,1))


**Sample output**

![Insect Deaths by Insecticide Type](https://raw.github.com/itfrombit/rutils/master/dotchart_insecticide.png)


Author
------
Jeff Buck.

dotchartdf is based on sample code by [Brian Caffo](http://www.bcaffo.com) from his excellent 
[Mathematical Biostatistics Boot Camp](https://www.coursera.org/course/biostats) course.
Highly recommended. Damn the mosquitos.



