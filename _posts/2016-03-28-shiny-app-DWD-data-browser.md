---
layout: post
title: Shiny Apps
excerpt: Create web-apps with your R calculations using the shiny package
language: English
category: showcase
datasource: <a href="http://www.dwd.de/DE/klimaumwelt/cdc/cdc_node.html">Deutscher Wetterdienst</a>
technique: <a href="http://r-project.org">R</a>, <a href="http://shiny.rstudio.com/gallery/">shiny</a>, <a href="https://rstudio.github.io/leaflet/">Leaflet for R</a>, <a href="http://rstudio.github.io/dygraphs/">dygraphs</a>
---

[Shiny](http://shiny.rstudio.com) is an R package that you can use to produce interactive web-applications with your R code. In their [gallery](http://shiny.rstudio.com/gallery/) you can see a lot of examples about how to use shiny.

Oe the website [shinyapps.io](http://shinyapps.io) you can publish your shiny app so that everyone can us it. Here we show an [example Shiny-App]( https://ndim.shinyapps.io/shiny-app/) to demonstrate what can be done with the shiny package.

It is thought do demonstrate:

* how to integrate external data in your app
* how to select stations on a map
* how to select variables to be plotted
* how to plot variables in a way that you can zoom and scroll the timeline
* how to download the selected data in the formats `.csv` and `.xlsx` (Excel)
* how to provide a downloadable report of the selected data including data tables, graphics of the variables and some summary statistics.

It facilitates the following technologies:

* [shiny](http://shiny.rstudio.com) of course
* [leaflet](http://rstudio.github.io/leaflet/basemaps.html) interactive maps
* [dygraphs](http://rstudio.github.io/dygraphs/) for the zoomable and scrollable timeline plots

The app uses climate data provided by the [German Weather Service (DWD)](http://dwd.de) which can be downloaded from their ftp server [ftp://ftp-cdc.dwd.de](ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/climate/daily/kl).

The weather stations shown on the map are taken from [this file](ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/climate/daily/kl/recent/KL_Tageswerte_Beschreibung_Stationen.txt). Please note that not all stations listed in this file actually have downloadable data. Therefore you get an download error for a lot of the statins. This is not the fault of this app.

To download the climate data the app facilitates our package RgetDWDdata which automates the download and does a lot of conversions for you. If you want to use this package you find it at https://github.com/nFrechen/RgetDWDdata.
