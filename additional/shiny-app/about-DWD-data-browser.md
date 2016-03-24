This is an example Shiny-App to demonstrate what can be done with the shiny package.

It is thought do demonstrate:

* how to integrate external data in your app
* how to select stations on a map
* how to select variables to be plotted
* how to plot variables in a way that you can zoom and scroll the timeline
* how to download the selected data in the formats `.csv` and `.xlsx` (Excel)

It facilitates the following technologies:

* [shiny](http://shiny.rstudio.com) of course
* [leaflet](http://rstudio.github.io/leaflet/basemaps.html) interactive maps
* [dygraphs](http://rstudio.github.io/dygraphs/) for the zoomable and scrollable timeline plots

The app uses climate data provided by the [German Weather Service (DWD)](http://dwd.de) which can be downloaded from their ftp server [ftp://ftp-cdc.dwd.de](ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/climate/daily/kl).

The weather stations shown on the map are taken from [this file](ftp://ftp-cdc.dwd.de/pub/CDC/observations_germany/climate/daily/kl/recent/KL_Tageswerte_Beschreibung_Stationen.txt). Please note that not all stations listed in this file actually have downloadable data. Therefore you get an download error for a lot of the statins. This is not the fault of this app.

To download the climate data the app facilitates a package called RgetDWDdata which automates the download and does a lot of conversions for you. If you want to use this package you find it at https://github.com/nFrechen/RgetDWDdata.
