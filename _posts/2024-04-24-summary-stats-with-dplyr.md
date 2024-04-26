---
layout: post
title: "Summary stats with dplyr"
excerpt: "calculate monthly mean"
category: tutorial
language: English
author: "Nanu Frechen"
datasource: <a href="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/1_minute">DWD</a>
technique: <a href="https://readr.tidyverse.org/">readr</a>, <a href="https://dplyr.tidyverse.org/">dplyr</a>, <a href="https://ggplot2.tidyverse.org/">ggplot2</a>, <a href="https://lubridate.tidyverse.org/">lubridate</a>
---
  
* auto-gen TOC:
{:toc}

Here I show how to do some simple summary statistics with the [dplyr package](https://dplyr.tidyverse.org/).


We will be using the followint packages:  
  

{% highlight r %}
library(lubridate)
library(dplyr)
library(readr)
library(ggplot2)
{% endhighlight %}



# get DWD data

- [station list](https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/KL_Tageswerte_Beschreibung_Stationen.txt)
- [variables description](https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/DESCRIPTION_obsgermany_climate_daily_kl_historical_en.pdf)


Files can be downloaded and unzipped by hand from [https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical](https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical). Or you can use the following script:


{% highlight r %}
data_dir = "data/dwd"
dir.create(data_dir)

urls <- c(Cottbus="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/tageswerte_KL_00880_18870101_20231231_hist.zip",
          Warnemünde="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/tageswerte_KL_04271_19470101_20231231_hist.zip",
          #Freiberg="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/tageswerte_KL_01441_19450701_19930430_hist.zip",
          #Stuttgart="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/tageswerte_KL_04927_19490801_19840731_hist.zip",
          "Garmisch-Patenkirchen"="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/tageswerte_KL_01550_19360101_20231231_hist.zip",
          Zugspitze="https://opendata.dwd.de/climate_environment/CDC/observations_germany/climate/daily/kl/historical/tageswerte_KL_05792_19000801_20231231_hist.zip")

for(url in urls){
  destfile = file.path(data_dir, basename(url))
  if(!file.exists(destfile)){
    download.file(url, destfile)
    unzip(destfile, exdir = data_dir)
  }
}
{% endhighlight %}



# read data

We use the [readr package](https://readr.tidyverse.org/) to read the csv files:


{% highlight r %}
data_files <- list.files(data_dir, pattern="produkt_klima_tag", full.names = T)

data <- read_delim(data_files, delim = ";", na = "-999", trim_ws = T) 
{% endhighlight %}
We use `list.files` to list all files starting with "produkt_klima_tag" in the data directory. The `read_delim` function reads all files into a single R object. Stations can be identified by their STATIONS_ID in the dataset.


See what's in the dataset:


{% highlight r %}
data
{% endhighlight %}



{% highlight text %}
## # A tibble: 153,294 × 19
##    STATIONS_ID MESS_DATUM  QN_3    FX    FM  QN_4   RSK  RSKF   SDK SHK_TAG
##          <dbl>      <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl> <dbl>   <dbl>
##  1         880   18870101    NA    NA    NA     1   0       0    NA       0
##  2         880   18870102    NA    NA    NA     1   0       0    NA       0
##  3         880   18870103    NA    NA    NA     1   0       0    NA       0
##  4         880   18870104    NA    NA    NA     1   0       0    NA       0
##  5         880   18870105    NA    NA    NA     1   0       0    NA       0
##  6         880   18870106    NA    NA    NA     1   0       0    NA       0
##  7         880   18870107    NA    NA    NA     1   3.3     4    NA       4
##  8         880   18870108    NA    NA    NA     1   0       0    NA       4
##  9         880   18870109    NA    NA    NA     1   0       0    NA       4
## 10         880   18870110    NA    NA    NA     1   0       0    NA       4
## # ℹ 153,284 more rows
## # ℹ 9 more variables: NM <dbl>, VPM <dbl>, PM <dbl>, TMK <dbl>, UPM <dbl>,
## #   TXK <dbl>, TNK <dbl>, TGK <dbl>, eor <chr>
{% endhighlight %}


# convert data

Convert date:


{% highlight r %}
data <- data %>%
  mutate(MESS_DATUM = as.POSIXct(as.character(MESS_DATUM), format="%Y%m%d")) %>%
  mutate(STATIONS_ID = as.factor(STATIONS_ID))
{% endhighlight %}

The `%>%` notation and `mutate` function comes from the [dplyr package](https://dplyr.tidyverse.org//).

Calculate yday and month:


{% highlight r %}
data <- data %>%
  mutate(yday = yday(MESS_DATUM)) %>%
  mutate(month = month(MESS_DATUM))
{% endhighlight %}

The `yday` and `month` functions come from the [lubridate package](https://lubridate.tidyverse.org/)

Add station names:


{% highlight r %}
stations <- tribble(
  ~STATION_NAME, ~STATIONS_ID,
  "Cottbus", "880",
  "Warnemünde", "4271",
  "Garmisch-Patenkirchen", "1550",
  "Zugspitze", "5792"
)

data <- data %>% left_join(stations)
{% endhighlight %}


# plot some data

We plot data with the [ggplot2 package](https://ggplot2.tidyverse.org/):


{% highlight r %}
data %>%
  ggplot() +
  aes(x=yday, y=TMK) +
  geom_point(size=0.1, alpha=0.1) +
  facet_wrap(STATION_NAME~.)
{% endhighlight %}

![plot of chunk plot temperature data](/figure/source/2024-04-24-summary-stats-with-dplyr/plot temperature data-1.png)
`facet_wrap` creates a single graph for each station.

# calculate mean for month


{% highlight r %}
longterm_average_month <- data %>%
  group_by(STATION_NAME, month) %>%
  summarise("temp longterm average" = mean(TMK, na.rm=T), "rain longterm average" = mean(RSK, na.rm=T))
{% endhighlight %}

With `group_by` and `summarise` we again use functions from the [dplyr package](https://dplyr.tidyverse.org//). The procedure is to form multiple subsets of the dataset with `group_by` and then calculate the summary statistics for those subsets. We group by STATION_NAME and month.

In the next plot we put all stations into one graph:


{% highlight r %}
longterm_average_month %>%
  ggplot() +
  aes(x=month, y=`temp longterm average`, col=STATION_NAME, group=STATION_NAME) +
  geom_line()
{% endhighlight %}

![plot of chunk plot temp monthly average](/figure/source/2024-04-24-summary-stats-with-dplyr/plot temp monthly average-1.png)



# calculate mean for yday


{% highlight r %}
longterm_average_yday <- data %>%
  group_by(STATION_NAME, yday) %>%
  summarise("temp longterm average" = mean(TMK, na.rm=T), "rain longterm average" = mean(RSK, na.rm=T))
{% endhighlight %}



{% highlight r %}
data %>%
  ggplot() +
  aes(x=yday, y=TMK) +
  geom_point(size=0.1, alpha=0.1) +
  geom_line(aes(x=yday, y=`temp longterm average`), data=longterm_average_yday, col="red") +
  facet_wrap(STATION_NAME~.)
{% endhighlight %}

![plot of chunk plot yday average with scatterplot](/figure/source/2024-04-24-summary-stats-with-dplyr/plot yday average with scatterplot-1.png)
# precipitation


{% highlight r %}
data %>%
  ggplot() +
  aes(x=yday, y=RSK) +
  scale_y_continuous(trans="log10") +
  geom_point(size=0.1, alpha=0.1) +
  facet_wrap(STATION_NAME~.)
{% endhighlight %}

![plot of chunk rain scatterplot](/figure/source/2024-04-24-summary-stats-with-dplyr/rain scatterplot-1.png)


{% highlight r %}
longterm_average_month %>%
  ggplot() +
  aes(x=month, y=`rain longterm average`, col=STATION_NAME, group=STATION_NAME) +
  #scale_y_continuous(trans="log10") +
  geom_line()
{% endhighlight %}

![plot of chunk rain monthly average plot](/figure/source/2024-04-24-summary-stats-with-dplyr/rain monthly average plot-1.png)

