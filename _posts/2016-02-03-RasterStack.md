---
layout: post
title: "RasterStack"
excerpt: "Zeitreihen von räumlichen Daten mit Hilfe eines RasterStacks."
category: tutorial
language: German
author: "Nanu Frechen"
datasource: <a href="ftp://gimms.gsfc.nasa.gov/MODIS/std/GMOD09Q1/tif/NDVI/">gimms.gsfc.nasa.gov</a>
technique: <a href="http://r-project.org">R</a>, <a href="https://cran.r-project.org/web/packages/raster/index.html">raster</a>, stack
---



* auto-gen TOC:
{:toc}

------------

Als Vorbereitung auf diese Übung empfiehlt sich die [Übung zu räumlichen Daten](/tutorial/Raeumliche-Daten.html).

------------

# Einleitung

In diesem Tutorial wird der durch Moderate Resolution Imaging Spectroradiometer (MODIS) normalisierte
Difference Vegetation Index (NDVI) verwendet, der durch die Global Inventory Modeling and Mapping Studies (GIMMS) Group des NASA/Goddard Space Flight Center aufgenommen und verarbeitet wurde, sowie finanziell unterstützt wurde vom Global Agricultural Monitoring project der USDA’s Foreign Agricultural Service (FAS). Die Daten können unter <a href="https://gimms.gsfc.nasa.gov/MODIS/std/GMOD09Q1/tif/NDVI/" target="_blank">https://gimms.gsfc.nasa.gov/MODIS/std/GMOD09Q1/tif/NDVI/</a> abgerufen werden.

Die Daten liegen im GeoTIFF-Format vor. Messungen von 8 Tagen werden jeweils zu einer Datei zusammen gefasst. Der tatsächliche Messzeitpunkt für jeden Pixel wird seit 2012 in einem zweiten Raster gespeichert. Dies soll aber hier vernachlässigt werden und stattdessen nur der Beginn der 8-Tages-Periode verwendet werden.

Die folgende Readme-Datei gibt Auskunft über die Formatierung der Daten und die Konvention für die Dateinamenvergabe: <a href="https://gimms.gsfc.nasa.gov/MODIS/README.txt" target="_blank">https://gimms.gsfc.nasa.gov/MODIS/README.txt</a>

Wir wollen nun eine ganze Reihe dieser Raster-Dateien herunterladen, als RasterStack in R laden und anschließend mit dem `raster` package Zeitreihen für einzelne Koordinaten extrahieren.

# Daten herunterladen

Definieren wir zuerst die URL, von der wir die Daten herunter laden möchten:


{% highlight r %}
baseurl <- "https://gimms.gsfc.nasa.gov/MODIS/std/GMOD09Q1/tif/NDVI/"
{% endhighlight %}

Die Daten befinden sich in Unterordnern zu dieser baseurl. Der erste Unterordner definiert das Jahr (z.B. 2001), der zweite Unterordner den Tag des Jahres (z.B. 049 für den 49. Tag). In diesem Ordner liegen dann die Dateien, die ähnlich wie diese Datei benannt sind: `GMOD09Q1.A2010001.08d.latlon.x00y02.6v1.NDVI.tif`

Dabei bedeuten laut der Readme-Datei die einzelnen Teile des Dateinamen folgendes:


    Qualifier           Value       Description
    ---------           -----       -----------
    Dataset             GMOD09Q1    GIMMS MODIS Terra (MOD=Terra MYD=Aqua)
    Start date          A2010001    Starting year 2010, day-of-year 001
    Composite period    08d         8-day composite
    Projection          latlon      Lat/Lon grid
    9x9 Tile index      x00y02      Column 00, Row 02
    Versions            6v1         MODAPS collection 6, GIMMS version 1
    Layer name          NDVI        Normalized Vegetation Index
    File format         tif         Tagged Image File


Wir wollen z.B. die Daten von zwei Jahren herunterladen. Deshalb definieren wir zuersteinmal von welchen Jahren:

{% highlight r %}
Years <- 2001:2002
{% endhighlight %}
Damit haben wir definiert, dass wir die Jahre 2001 und 2002 herunter laden möchten.
Aus diesen Jahren wollen wir alle Tage herunterladen. Wenn wir uns die Unterordner anschauen, sehen wir dass die Daten von jeweils 8 Tagen in einer .tif-Datei aggregiert werden. Daher definieren wir folgende Tage:

{% highlight r %}
Days <- seq(1, 365, 8)
{% endhighlight %}

Dies müssen wir nun noch in einen Charakter mit 3 Stellen (und ggf. Nullen am Anfang) umwandeln:

{% highlight r %}
Days <- formatC(Days, width = 3, flag='0')
{% endhighlight %}

Desweiteren lesen wir in der Readme-Datei:

    Since the size of a global grid file may be too large for users,
    the grid is divided into 40 columns and 20 rows (starting at the
    upper left corner at 180W 90N) to create 9x9 degree tiles of
    4000 x 4000 pixels.
    
    Tiles are identified by {x,y} indexes and labeled in the filename 
    (5th qualifier).
		
    To calculate the {x,y} tile index for a given {Lon,Lat}:
		
            x = floor((180 + Lon) / 9)
            y = floor(( 90 - Lat) / 9)

Wir müssen uns also auch noch dafür entscheiden, welches dieser "tiles" wir herunterladen möchten. Wir definieren also einen Punkt, der für uns von Interesse ist, indem wir dessen Längen- und Breitengrad (Lon und Lat) definieren. Über die angegebene Formel können wir dann das x und y des benötighten tiles berechnen:

{% highlight r %}
Lon = 15
Lat = 51
{% endhighlight %}

Die Formel können wir zum Glück eins zu eins aus der Readme übernehmen, da sie ausführbarer R-Code ist:

{% highlight r %}
x = floor((180 + Lon) / 9)
y = floor(( 90 - Lat) / 9)
{% endhighlight %}

Wieder müssen wir dies in einen Charakter umwandeln:

{% highlight r %}
x <- formatC(x, width = 2, flag='0')
y <- formatC(y, width = 2, flag='0')
{% endhighlight %}


Den Datiepfad können wir nun aus der baseurl, dem Jahr und dem Tag erzeugen. Den Dateinamen erzeugen wir aus Jahr, Tag, x und y. Über zwei Schleifen können wir so alle Daten aus dem entsprechenden Zeitraum herunter laden.

Erzeugen wir noch einen Ordner, in den wir die Daten speichern wollen:

{% highlight r %}
folder <- "Daten"
dir.create(folder)
{% endhighlight %}

Und starten dann die Schleife:

{% highlight r %}
for(year in Years){
	for(day in Days){
		try({
			file <- paste0(baseurl, year, "/", day, "/GMOD09Q1.A", year, day, ".08d.latlon.x",x, "y", y, ".6v1.NDVI.tif.gz")
			cat("downloading", file, "\n")

			# Zip-Datei runterladen
			download.file(file, file.path(folder, basename(file)), method="curl", quiet=T)
			
			# Datei enptacken
			R.utils::gunzip(file.path(folder, basename(file)))
		})
	}
}
{% endhighlight %}

Wir verwenden `try()` um zu verhindern, dass die Schleife abbricht, wenn Dateien nicht vorhanden sind. 
Der Download kann natürlich eine ganze Weile dauern. Zum entpacken der `.gz` Dateien muss das Paket `R.utils` installiert sein. Falls dies noch nicht installiert ist einfach `install.packages("R.utils")` ausführen.


# Daten als Stack laden
Die heruntergeladenen Daten wollen wir nun mit dem `raster` package in R verarbeiten.

Laden wir also das Paket:

{% highlight r %}
library(raster)
{% endhighlight %}

Dann brauchen wir eine Liste aller .tif-Dateien:

{% highlight r %}
# Dateinamen ermitteln
files <- list.files(folder, pattern="*.tif$", full.names = T)
{% endhighlight %}


Mit diesem einfachen Befehl laden wir jetzt alle Dateien in einen RasterStack:

{% highlight r %}
NDVI_stack <- stack(files)
{% endhighlight %}

Dieser RasterStack enthält nun die Verweise auf die entsprechenden Dateien auf der Festplatte. Jede Datei ist eine Ebene im Rasterstack. Der Inhalt der Dateien wird erst abgefragt, wenn er gebraucht wird. Daher arbeitet diese Methode relativ schnell und verbraucht wenig Arbeitsspeicher.

Nun brauchen wir noch eine Zeitachse. Dazu extrahieren wir aus den Dateinamen die Zeit. Dazu verwenden wir das Paket `lubridate`:

{% highlight r %}
library(lubridate)
# Jahr und Tag des Jahres aus Dateinamen extrahieren:
timeline <- data.frame(
	year= as.numeric(substr(basename(files), start = 11, stop = 11+3)),
	doy= as.numeric(substr(basename(files), 15, 16+2))
)
# Datum für jede Datei errechnen:
timeline$date <- as.Date(paste0(timeline$year, "-01-01")) + days(timeline$doy - 1)

timeline$date
{% endhighlight %}



{% highlight text %}
##  [1] "2001-01-01" "2001-01-09" "2001-01-17" "2001-01-25" "2001-02-02"
##  [6] "2001-02-10" "2001-02-18" "2001-02-26" "2001-03-06" "2001-03-14"
## [11] "2001-03-22" "2001-03-30" "2001-04-07" "2001-04-15" "2001-04-23"
## [16] "2001-05-01" "2001-05-09" "2001-05-17" "2001-05-25" "2001-06-02"
## [21] "2001-06-10" "2001-06-18" "2001-06-26" "2001-07-04" "2001-07-12"
## [26] "2001-07-20" "2001-07-28" "2001-08-05" "2001-08-13" "2001-08-21"
## [31] "2001-08-29" "2001-09-06" "2001-09-14" "2001-09-22" "2001-09-30"
## [36] "2001-10-08" "2001-10-16" "2001-10-24" "2001-11-01" "2001-11-09"
## [41] "2001-11-17" "2001-11-25" "2001-12-03" "2001-12-11" "2001-12-19"
## [46] "2001-12-27" "2002-01-01" "2002-01-09" "2002-01-17" "2002-01-25"
## [51] "2002-02-02" "2002-02-10" "2002-02-18" "2002-02-26" "2002-03-06"
## [56] "2002-03-14" "2002-03-22" "2002-03-30" "2002-04-07" "2002-04-15"
## [61] "2002-04-23" "2002-05-01" "2002-05-09" "2002-05-17" "2002-05-25"
## [66] "2002-06-02" "2002-06-10" "2002-06-18" "2002-06-26" "2002-07-04"
## [71] "2002-07-12" "2002-07-20" "2002-07-28" "2002-08-05" "2002-08-13"
## [76] "2002-08-21" "2002-08-29" "2002-09-06" "2002-09-14" "2002-09-22"
## [81] "2002-09-30" "2002-10-08" "2002-10-16" "2002-10-24" "2002-11-01"
## [86] "2002-11-09" "2002-11-17" "2002-11-25" "2002-12-03" "2002-12-11"
## [91] "2002-12-19" "2002-12-27"
{% endhighlight %}


# Daten plotten
Mit `NDVI_stack[[i]]` können wir nun die Ebene `i` aus dem Rasterstack abfragen. Nutzen wir dies, um eine Karte von Ebene 1 auszugeben. Den Titel des plots entnehmen wir aus der `timeline`, ebenfalls mit dem index 1. Zusätzlich zeichnen wir noch unsere anfangs definierte Koordinate ein.


{% highlight r %}
plot(NDVI_stack[[1]], main=timeline$date[1])
points(Lon, Lat, pch=21, bg="red")
{% endhighlight %}

![plot of chunk plot](/figure/source/2016-02-03-RasterStack/plot-1.svg)

Etwas ist hier noch falsch! Aus der Readme-Datei können wir entnehmen, dass alle Werte über 250 keine tatsächlichen NDVI-Daten darstellen und dass wir die Werte darunter noch umrechnen müssen:

    The valid range of NDVI, 8-bit layers is [0 - 250].
    
    Values ranging [251 - 255] are reserved for mask values:
    
            Value   Description
            -----   -----------
            251     (empty)
            252     (empty)
            253     Invalid land (out of range NDVI)
            254     Water
            255     No data (unfilled, cloudy, or snow contaminated)
    
    To convert from NDVI 8-bit unsigned integer [0 - 250] to
    floating-point [0.0 - 1.0]:
    
            <FLOAT NDVI> = <UINT8 NDVI> x 0.004

Wir definieren deshalb eine Funktion, die alle Werte über 250 durch NA ersezt und alle darunter mit 0.004 multipliziert:


{% highlight r %}
remap <- function(x){
	x[x>250] <- NA
	x <- x * 0.004
	return(x)
}
{% endhighlight %}

Mit dieser Funktion können wir nun die Daten vor dem Plotten umrechnen:


{% highlight r %}
plot(calc(NDVI_stack[[1]], fun=remap), main=timeline$date[1])
points(Lon, Lat, pch=21, bg="red")
{% endhighlight %}

![plot of chunk plot-remapped](/figure/source/2016-02-03-RasterStack/plot-remapped-1.svg)

Die NDVI-Werte gehen nun von 0 bis 1. Man sieht, dass für 2001-01-01 ein Großteil der Daten tatsächlich Fehldaten sind. 

Die Umrechnung braucht eine Weile. Von daher werden wir uns sparen, diese Umrechnung für den ganzen RasterStack anzuwenden.

Stattdessen extrahieren wir nun eine Zeitreihe von dar anfangs definierten Koordinate:

# Zeitreihen extrahieren


{% highlight r %}
Punkt1 <- data.frame(x=Lon, y=Lat)
cellnumber <- cellFromXY(NDVI_stack, xy = Punkt1)
timeline$NDVI <- as.vector(extract(NDVI_stack, cellnumber))
{% endhighlight %}

Die extrahierte Reihe müssen wir mit `remap` wieder umrechnen und können sie dann als Liniendiagramm plotten:


{% highlight r %}
timeline$NDVI <- remap(timeline$NDVI)
plot(NDVI~date, timeline, col="green", type="b", lwd=2, pch=20)
{% endhighlight %}

![plot of chunk remap-extracted](/figure/source/2016-02-03-RasterStack/remap-extracted-1.svg)

Auch in der Zeitreihe erkennt man, dass einige Daten fehlen.

**Ein kleiner Tipp zum Schluss:**

Um weitere Koordinaten abzufragen kann man z.B. mit folgender Methode von Grad, Minuten und Sekunden in Dezimalgrad umrechnen:

{% highlight r %}
as.numeric(char2dms("51°46'22.8\"N", "°", "'", "\""))
{% endhighlight %}



{% highlight text %}
## [1] 51.773
{% endhighlight %}

