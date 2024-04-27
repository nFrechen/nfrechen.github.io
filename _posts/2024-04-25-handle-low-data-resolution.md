---
layout: post
title: "Handle low data resolution"
excerpt: "Find resolution changes in the data set"
category: tutorial
language: English
author: "Nanu Frechen"
datasource: <a href="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/1_minute">DWD</a>
technique: unique, histogram, density, scatterplot
---
  
* auto-gen TOC:
{:toc}

It is not uncommon for datasets to contain a change in resolution when measurement devices are upgraded. If you want handle data with finer and coarser resolution differently you migth want to find the exact time of the devices upgrade. This is what I will be showing in this post. 

We will be using the following packages:


{% highlight r %}
library(readr)
library(dplyr)
library(lubridate)
library(ggplot2)
{% endhighlight %}



# example 1: wind data 
 
Download wind data:


{% highlight r %}
data_dir = "data/dwd/Cottbus"
dir.create(data_dir)
url <- "https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/hourly/wind/historical/stundenwerte_FF_00880_19830101_20231231_hist.zip"
destfile = file.path(data_dir, basename(url))
if(!file.exists(destfile)){
  download.file(url, destfile)
  unzip(destfile, exdir = data_dir)
}
{% endhighlight %}

Read wind data:


{% highlight r %}
wind_data <- read_delim("data/dwd/Cottbus/produkt_ff_stunde_19830101_20231231_00880.txt", delim = ";", na = "-999", trim_ws = T) %>%
  mutate(MESS_DATUM = as.POSIXct(as.character(MESS_DATUM), format="%Y%m%d%H")) %>%
  mutate(yday = yday(MESS_DATUM)) %>%
  rename(speed=F, direction=D) %>%
  mutate(direction = if_else(direction> 360, NA, direction)) %>%
  na.omit()
{% endhighlight %}
To find the min resolution we use a combination of `unique`, `diff` and `min`:


{% highlight r %}
wind_min_resolution <- wind_data$speed %>% unique %>% sort %>% diff %>% min
{% endhighlight %}


{% highlight r %}
wind_min_resolution
{% endhighlight %}



{% highlight text %}
## [1] 0.1
{% endhighlight %}

With the min resolution as bin width we can plot a histogram of the wind speed data:


{% highlight r %}
wind_data %>%
  ggplot() +
  aes(x=speed) +
  geom_histogram(binwidth=wind_min_resolution)
{% endhighlight %}

![plot of chunk histogram of wind data](/figure/source/2024-04-25-handle-low-data-resolution/histogram of wind data-1.png)
From the spikes in the histogram we see that the dataset contains data with coarser resolution. This might invalidate statitistics we want to derive from the dataset. Hence it is important to handle the coarser and finer data differently.

A scatterplot can show us when the switch to finer resolution took place:


{% highlight r %}
wind_data %>%
  ggplot() +
  aes(x=MESS_DATUM, y=speed) +
  geom_point(size=0.1)
{% endhighlight %}

![plot of chunk scatterplot of wind data](/figure/source/2024-04-25-handle-low-data-resolution/scatterplot of wind data-1.png)

To find the exact timing of the switch we query for the first date with non-integer values:


{% highlight r %}
first_with_new_resolution <- wind_data$MESS_DATUM[!(wind_data$speed %in% 0:20)] %>%
  first()
{% endhighlight %}

To confirm the date we use it to color the scatterplot:


{% highlight r %}
wind_data %>%
  mutate(fine_resolution = MESS_DATUM > first_with_new_resolution) %>%
  ggplot() +
  aes(x=MESS_DATUM, y=speed, col=fine_resolution) +
  geom_point(size=0.1)
{% endhighlight %}

![plot of chunk wind: plot fine and coarse resolution](/figure/source/2024-04-25-handle-low-data-resolution/wind: plot fine and coarse resolution-1.png)

Here a zoomed in view:


{% highlight r %}
wind_data %>%
  filter(MESS_DATUM > first_with_new_resolution - months(1) & MESS_DATUM < first_with_new_resolution + months(1)) %>%
  mutate(fine_resolution = MESS_DATUM > first_with_new_resolution) %>%
  ggplot() +
  aes(x=MESS_DATUM, y=speed, col=fine_resolution) +
  geom_point(size=0.5)
{% endhighlight %}

![plot of chunk wind: plot fine and coarse resolution zoomed in](/figure/source/2024-04-25-handle-low-data-resolution/wind: plot fine and coarse resolution zoomed in-1.png)

Using that date we can devide the histogram plot into an early and late dataset:


{% highlight r %}
wind_data %>%
  mutate(fine_resolution = MESS_DATUM > first_with_new_resolution) %>%
  ggplot() +
  aes(x=speed) +
  geom_histogram(binwidth=wind_min_resolution) +
  facet_grid(fine_resolution~.)
{% endhighlight %}

![plot of chunk histogram wind data devidec](/figure/source/2024-04-25-handle-low-data-resolution/histogram wind data devidec-1.png)

Plotting the histogram and density of both subsets (with binwidth/bandwith of 1 according tho the coarser data) we see that the distributions are different:


{% highlight r %}
wind_data %>%
  mutate(fine_resolution = MESS_DATUM > first_with_new_resolution) %>%
  ggplot() +
  aes(x=speed, y=after_stat(density), fill=fine_resolution) +
  geom_histogram(binwidth = 1, alpha=0.3, position="identity") +
  geom_density(aes(col=fine_resolution), linewidth=1, fill=NA, alpha=1, bw=1)
{% endhighlight %}

![plot of chunk histogram and density wind data devided](/figure/source/2024-04-25-handle-low-data-resolution/histogram and density wind data devided-1.png)

Another approach would be to define a function to find the min or median resolution:


{% highlight r %}
find_resolution <- function(x, type="min"){
  diff = x %>% unique %>% sort %>% diff 
  if(type=="min"){
    return(diff %>% min(na.rm=T))
  }
  if(type=="median"){
    return(diff %>% median(na.rm=T))
  }
  stop("set type to min or median")
}
{% endhighlight %}


We can use that to find the resolution switch (by year): 


{% highlight r %}
wind_data %>%
  group_by(year = year(MESS_DATUM)) %>%
  summarise(speed_resolution = find_resolution(speed), direction_resolution = find_resolution(direction)) %>%
  head(15) %>%
  kable()
{% endhighlight %}



| year| speed_resolution| direction_resolution|
|----:|----------------:|--------------------:|
| 1983|              1.0|                   10|
| 1984|              1.0|                   10|
| 1985|              1.0|                   10|
| 1986|              1.0|                   10|
| 1987|              1.0|                   10|
| 1988|              1.0|                   10|
| 1989|              1.0|                   10|
| 1990|              1.0|                   10|
| 1991|              0.1|                   10|
| 1992|              0.1|                   10|
| 1993|              0.1|                   10|
| 1994|              0.1|                   10|
| 1995|              0.1|                   10|
| 1996|              0.1|                   10|
| 1997|              0.1|                   10|

This approach is not suitable to find the exact date of the switch, since we need a lot of data for the median or min statistics. Using data from one day or one hour might not be enough.

# example 2: radiation data

Data can be downloaded and read similar to the wind data above. 



Again we find the min resolution:


{% highlight r %}
solar_min_resolution <- solar_data$FG_LBERG %>% unique %>% sort %>% diff %>% min
solar_min_resolution
{% endhighlight %}



{% highlight text %}
## [1] 1
{% endhighlight %}

And plot a histogram.


{% highlight r %}
solar_data  %>%
  filter(FG_LBERG >0) %>%
  ggplot() +
  aes(x=FG_LBERG) +
  geom_histogram(binwidth = solar_min_resolution)
{% endhighlight %}

![plot of chunk solar: plot histogram](/figure/source/2024-04-25-handle-low-data-resolution/solar: plot histogram-1.png)

The histogram shows that the dataset contains data in multiple different resolutions.

To find the resolution changes we again plot a scatterplot:


{% highlight r %}
solar_data %>%
  ggplot() +
  aes(x=MESS_DATUM, y=FG_LBERG) +
  scale_y_continuous(limits = c(0,50)) +
  geom_point(size=0.1)
{% endhighlight %}

![plot of chunk solar: scatterplot](/figure/source/2024-04-25-handle-low-data-resolution/solar: scatterplot-1.png)
Here we see that there are multiple earlier phases with coarser resolution. The resolution seems to be around 4, but there seems to be 3 phases with different alignment. Also there seem to be data with finer resolution between 0 and 4.

To find the date of the change to resolution 1 we select from the graph some values that are only in the later finer resolution data and not in the coarser resolution data: values 5, 6 or 7:


{% highlight r %}
resolution_switch <- solar_data %>%
  filter(!is.na(FG_LBERG)) %>%
  filter(FG_LBERG %in% c(5,6,7)) %>%
  {  first(.$MESS_DATUM) }
{% endhighlight %}

This gives us the start of the finer resolution measurements on January first of 1980:


{% highlight r %}
resolution_switch
{% endhighlight %}



{% highlight text %}
## [1] "1980-01-01 15:11:00 CET"
{% endhighlight %}


Again we can confirm that by coloring the scatterplot:


{% highlight r %}
solar_data %>%
  mutate(new_resolution = MESS_DATUM >= "1980-01-01 15:11:00") %>%
  ggplot() +
  aes(x=MESS_DATUM, y=FG_LBERG, col=new_resolution) +
  scale_y_continuous(limits = c(0,50)) +
  geom_point(size=0.1)
{% endhighlight %}

![plot of chunk solar: color scatterplot](/figure/source/2024-04-25-handle-low-data-resolution/solar: color scatterplot-1.png)

And look into the zoomed in plot:


{% highlight r %}
solar_data %>%
  filter(MESS_DATUM >= resolution_switch-months(1) & MESS_DATUM < resolution_switch+months(1)) %>%
  mutate(new_resolution = MESS_DATUM >= resolution_switch) %>%
  ggplot() +
  aes(x=MESS_DATUM, y=FG_LBERG, col=new_resolution) +
  scale_y_continuous(limits = c(0,50)) +
  geom_point(size=0.5)
{% endhighlight %}

![plot of chunk solar: zoomed colored scatterplot](/figure/source/2024-04-25-handle-low-data-resolution/solar: zoomed colored scatterplot-1.png)

Again we can use the found date to devide our histogram plot:


{% highlight r %}
solar_data  %>%
  mutate(period = MESS_DATUM >= resolution_switch) %>%
  filter(FG_LBERG >0) %>%
  ggplot() +
  aes(x=FG_LBERG) +
  geom_histogram(binwidth = 1) +
  facet_grid(period~.)
{% endhighlight %}

![plot of chunk solar: devided histogram](/figure/source/2024-04-25-handle-low-data-resolution/solar: devided histogram-1.png)

Again we can use the second approach to find the median resolution with our function:


{% highlight r %}
solar_data %>%
  group_by(month = floor_date(MESS_DATUM, "month")) %>%
  summarise(resolution = find_resolution(FG_LBERG, type="median")) %>%
  ggplot() +
  aes(x=month, y=resolution) +
  geom_line()
{% endhighlight %}

![plot of chunk solar: median resolution by month](/figure/source/2024-04-25-handle-low-data-resolution/solar: median resolution by month-1.png)



But this approach is rather unclear if we switch to weekly statistics. There is not enough data in a week to give a consistant median resolution:


{% highlight r %}
solar_data %>%
  group_by(month = floor_date(MESS_DATUM, "week")) %>%
  summarise(resolution = find_resolution(FG_LBERG, type="median")) %>%
  ggplot() +
  aes(x=month, y=resolution) +
  geom_line()
{% endhighlight %}

![plot of chunk solar: median resolution by week](/figure/source/2024-04-25-handle-low-data-resolution/solar: median resolution by week-1.png)


