---
layout: post
title: 'Optimization'
author: "Nanu Frechen <nanu.frechen@b-tu.de>"
excerpt: Optimizing the calculation times of R code.
category: howto
language: English
technique: <a href="http://r-project.org">R</a>, system.time, apply, plyr, fread, data.table
---




R is a script language in contrast to compiled languages like C. Compiled languages are much faster since during compilation the code gets optimized for the hardware it will run on. This does not happen for a script language like R.

Nontheless a lot of the functions that you will use in R are not actually written in R. Most functions are written in C or Fortran[^1]. R just hands over the data to these functions and takes the calculated results back. Hence with those functions you are actually using compiled code to do your calculations, resultung in good performance. Consequentially, if you write an R script, you are chaining chunks of compiled code together, resulting in a program that is sligthly slower than an overall compiled program, but still much much faster than a program written purely in R.


What is the main conclusion to be drawn from this:

* The fever R commands you chain together, the more gets calculated in compiled code. Hence the code is faster.

And this also leads to the thing you mostly should avoid in R:

* Try to avoid writing loops in R, since this is a looped chaining of R commands.

And there are a lot of functions that help you to avoid writing loops! In fact R in many aspects is designed in a way that makes loops no necessity. 

Take for example how you are thought to do calculations on a vector of data in R, let's say multiply every element by 2:


{% highlight r %}
# comment in line
data <- 1:1000000
system.time( # comment after
  
  result <- data * 2

)
{% endhighlight %}



{% highlight text %}
##        User      System verstrichen 
##       0.043       0.003       0.047
{% endhighlight %}

Compare this to what time it takes to calculate this in a loop:

{% highlight r %}
system.time({
  
  result <- NULL
  for(i in 1:length(data)){
    data[i] * 2
  }

})
{% endhighlight %}



{% highlight text %}
##        User      System verstrichen 
##       0.317       0.009       0.332
{% endhighlight %}

It takes ten times the time to calculate the result with a loop.

`system.time()` is a function you can use to measure the calculation time of your script and hence to compare the performance of it to other approaches.


{% highlight r %}
vector_function <- function(x){
  result <- x * rev(x)
}  
{% endhighlight %}


{% highlight r %}
loop_function <- function(x){
  result <- NULL
  n <- length(x)
  for(i in 1:n){
    result[i] <- x[i] * x[n+1-i]
  }
  return(result)
}
{% endhighlight %}

![plot of chunk unnamed-chunk-3](/figure/source/2016-01-26-Optimization/unnamed-chunk-3-1.svg)

As you can see the calculation time for the vector method barely exceeds 0.002 seconds, while the maximum calculation time  for the loop method is 10 seconds. The maximum increase in performance is over 10000 and will further increase with higher n!

### Packages and functions to make your calculations faster

* Use `apply` whenever possible
* Use additional apply functions from the plyr package
* Read csv tables with `fread` of the data.table package.
[^2]

### Further readings:

The section ["Optimising code"](http://adv-r.had.co.nz/Profiling.html) of Hadley Wickham's book "Advanced R" teaches you a lot about how to find the bottlenecks in your code and speed up your calculations.



[^1]: About how to integrate compiled code written in C or Fortran into R consult the chapter 5.2 "Interface functions .C and .Fortran" of the manual "Writing R Extensions" you find in the home of the help system in R.
[^2]: Test ob das hier auch noch so aussieht
