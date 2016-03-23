---
layout: post
title: 'Grasreferenzverdunstung'
author: "Nanu Frechen"
excerpt: In dieser Übung wird erklärt, wie man die Grasreferenzverdunstung berechnet.
category: tutorial
language: German
---





* auto-gen TOC:
{:toc}

--------------------

Dies ist die zweite Übung aus einer Reihe von Übungen zu hydrologisch/metereologischen Datensätzen und deren Auswertung. Sie setzt die [Übung zu Streudiagrammen](/tutorial/Streudiagramme.html) fort.

--------------------

# Einleitung
In dieser Übung wollen wir so weit kommen, die Grasreferenzverdunstung ($$ET0$$) als potentielle Verdunstung aus den Klimadaten der Station Cottbus zu berechnen, um dann anschließend die klimatische Wasserbilanz zu bilden.

Die Berechnung der Grasreferenzverdunstung ist im ATV-DVWK-Merkblatt 504: Verdunstung in Bezug zu Landnutzung, Bewuchs und Boden, Hennef 2002 definiert.

Wir wollen die Grasreferenz in R als Funktion implementieren, mit der man die Grasreferenzverdunstung für ganze Zeitreihen berechnen kann. Dabei werden wir mehrere Unterfunktionen verwenden, um z.B. den Sättigungsdampfdruck oder die Steigung der Sättigungsdampfdruckkurve zu berechnen. Die etwas kompliziertere Formel für das Verdunstungsäquivalent der Nettostrahlung werden wir euch vorgeben.

# Anknüpfung an die letzte Übung
In der letzten Übung haben wir uns ein Streudiagramm angeschaut, dass die Abhängigkeit zwischen Dampfdruck und Temperatur darstellt. Die Messwerte überschreiten eigentlich nie eine Linie (rote Linie in der Grafik), die durch die  folgende Formel definiert ist:

$$e_s(T)=6.11\cdot e^{\frac{(17.62T)}{(243.12+T)} }$$

Diese Formel beschreibt den Sättigungsdampfdruck in Abghängigkeit von der Temperatur. Die Formel errechnet also die maximale Menge Wasser (den maximalen partiellen Dampfdruck von Wasserdampf), die die Luft bei dieser Temperatur aufnehmen kann.

![plot of chunk Streudiagramm-Temperatur-gegen-Dampfdruck-mit-Saettigungsdampfdruck](/figure/source/2016-01-11-Grasreferenzverdunstung/Streudiagramm-Temperatur-gegen-Dampfdruck-mit-Saettigungsdampfdruck-1.png)

Für die Hydrologie bedeutet das: liegen die Messwerte links von der Kurve, kann die Luft noch weitere Feuchtigkeit aufnehmen - es kann Verdunstung stattfinden! Man spricht auch von "atmospheric demand", also der Menge Wasser, die die Luft noch aufnehmen kann, die also potentiell verdunsten könnte. Daher wird aus dem Dampfdruck und dem Sättigungsdampfdruck auch meist die relative Feuchte berechnet, also die Feuchte, die die Luft relativ zu ihrer maximal physikalisch möglichen Feuchte hat. Die formel lautet:

$$rel.\,Feuchte\ [\%]=\frac{Dampfdruck}{Sättigungsdampfdruck(T)}\cdot100\%$$

Die Stationen des DWD messen die relative Feuchte über ein weiteres Messgerät. Wir können also die beiden Messmethoden miteinander vergleichen:

![plot of chunk relative-Feuchte-vergleich](/figure/source/2016-01-11-Grasreferenzverdunstung/relative-Feuchte-vergleich-1.png)

Man sieht eine deutliche Korrelation zwischem der direkt gemessenen relativen Luftfeucht und der aus Dampfdruck und Temperatur (über den Sättigungsdampfdruck) berechneten relativen Luftfeuchte. Trotzdem zeigen sich aber auch Abweichungen.

### Zwischenfragen
Diskutieren Sie:

* Woher kommen die Abweichungen zwischen berechneter und gemessener relativer Luftfeuchte?
* Kann die Luft bei gleicher relative Luftfeuchte aber unterschiedlichen Temperaturen die gleiche Menge Wasser aufnehmen?
* Welche weiteren Parameter vermutet ihr haben auch Einfluss auf die Verdunstung?


# Was ist die Grasreferenzverdunstung?

Die Gras-Referenzverdunstung basiert auf der Penman-Monteith-Beziehung. Sie ist der international einheitliche Standard zur Berechnung der potenziellen Verdunstung. Das Verfahren beschreibt den Verdunstungsvorgang physikalisch auf der Grundlage der meteorologischen Einflussgrößen und unterschiedlicher Widerstände, mit denen die Böden und Pflanzen das Wasser beim Verdunsten zurückhalten. 

(der folgende Textauszug und die Gleichungen wurden dem „ATV-DVWK-Merkblatt 504: Verdunstung in Bezug zu Landnutzung, Bewuchs und Boden, Hennef 2002“ entnommen)

Bei der Landnutzung und der Wasserversorgung aus dem Boden wird dabei mit festen, definierten Pflanzen- und Bodenparametern gerechnet. Diese speziellen **Randbedingungen** sind: 

1.	Der **Boden ist das ganze Jahr über einheitlich mit Gras von 12 cm Höhe bedeckt**. 
Es ist in die Penman-Monteith-Beziehung ein von der Windgeschwindigkeit in 2 m Höhe abhängiger aerodynamischer Verdunstungswiderstand von ra = 208/v2 einzusetzen, angegeben in s/m. 
Dabei ist v2 die in 2 m Höhe gemessene Windgeschwindigkeit. Die Wind-Beziehung gilt streng genommen nur bei neutraler Schichtung in der unteren Atmosphäre, kann bei den geforderten Genauigkeiten hier aber generell angesetzt werden. 
2.	Es besteht **kein Trockenstress** für die Pflanzen. Diese Bedingung ist im Winter und Frühjahr sowie in feuchten Sommern erfüllt, wenn im Hauptwurzelraum die relative Bodenfeuchte Wrel größer als etwa 50 bis 60 % der nutzbaren Feldkapazität ist. Für Verdunstungsbedingungen ohne Trockenstress wird als minimaler Bestandswiderstand rc,min = 70 s/m angesetzt. 
3.	Zur Berechnung der Strahlungsbilanz aus der Globalstrahlung wird einheitlich eine **Albedo von α = 0,23** festgelegt, die im **Mittel für Grasbewuchs** und andere grüne Pflanzenbestände gilt, aber nicht generell für alle Oberflächen. 
Die überall unterschiedliche Bodenbedeckung (die Art der Landnutzung, Schneedecke, Wasserflächen, Siedlungen usw.) sowie die Bodenart sind bei der Gras-Referenzverdunstung nicht berücksichtigt. Auch gehen die unterschiedliche Wasserversorgung der Pflanzen, die Wasserspeicherfähigkeit der Böden und der kapillare Aufstieg aus dem Grundwasser nicht ein. 


# Wie programmiert man eine Formel?

Um die Grasreferenzverdunstung in R zu implementieren, werden wir Funktionen verwenden. Eine Funktion definiert man folgendermaßen:

{% highlight r %}
meineFunktion <- function(x,y){
	x*y
}
{% endhighlight %}

Die Variablen `x` und `y` innerhalb der runden Klammern von `function()` nennt man die Argumente (arguments) der Funktion. Das Ergebnis des letzten Befehls innerhalb der geschweiften Klammern wird zurück gegeben und nennt sich Rückgabewert (return value). Alternativ kann man auch den Befehl `return()` verwenden, um den Rückgabewert zu definieren.

Wenn man diesen Codeblock einmal ausgeführt hat, kann man die Funktion verwenden können. Z.B. so:

{% highlight r %}
meineFunktion(x=5, y=2)
{% endhighlight %}



{% highlight text %}
## [1] 10
{% endhighlight %}
oder ohne die Argumentennamen zu verwenden:

{% highlight r %}
meineFunktion(5, 2)
{% endhighlight %}



{% highlight text %}
## [1] 10
{% endhighlight %}
oder aber mit benannten Argumenten in anderer Reihenfolge:

{% highlight r %}
meineFunktion(y=2, x=5)
{% endhighlight %}



{% highlight text %}
## [1] 10
{% endhighlight %}

Für die Berechnungen muss man nur noch folgendes wissen:

* Potenzen (z.B.$$a^b$$) schreiben sich als: `a^b`.
* Die Exponentialfunktion ($$e^x$$) wird so geschrieben: `exp(x)`.

# Vorgehen
Um die Grasreferenzverdunstung zu berechnen müsst ihr die zentrale Funktionen definieren:

* `calcET0(temp, date, sunshine, U, v, v_height, latitude, albedo, gamma)`

Und dazu drei Unterfunktionen, die von der zentralen Funktion verwendet werden:

* `es(temp)`
* `s(temp)`
* `gammastern(gamma, v2)`

Für das Verdunstungsäquivalent der Nettostrahlung haben wir euch bereits eine Funktion geschrieben, die ihr in `calcET0()` verwenden könnt:

* `evap.net.radiation()` 

Schaut euch also die Formeln aus der ATV-DVWK an, überlegt euch, wie ihr die Formeln in R umsetzt und an welchen Stellen die Unterfunktionen verwendet werden müssen.

Ob eure Funktion richtig rechnet könnt ihr anhand der folgenden Werte überprüfen:

{% highlight r %}
es(temp = c(-10, 5, 25))
{% endhighlight %}



{% highlight text %}
## [1]  2.869371  8.714575 31.590229
{% endhighlight %}



{% highlight r %}
s(temp = c(-10, 5, 25))
{% endhighlight %}



{% highlight text %}
## [1] 0.2261919 0.6064181 1.8825383
{% endhighlight %}



{% highlight r %}
gammastar(v_2 = c(1,2,3), gamma = 0.65)
{% endhighlight %}



{% highlight text %}
## [1] 0.871 1.092 1.313
{% endhighlight %}



{% highlight r %}
calcET0(temp = 15, date = as.Date("2015-02-13"), sunshine = 15, U = 80, v = 1.2, v_height = 2, latitude = 51, albedo = 0.23, gamma = 0.65)
{% endhighlight %}



{% highlight text %}
## [1] 0.8950756
{% endhighlight %}



{% highlight r %}
calcET0(temp = 32, date = as.Date("2015-06-18"), sunshine = 20, U = 60, v = 2.5, v_height = 2, latitude = 51, albedo = 0.23, gamma = 0.65)
{% endhighlight %}



{% highlight text %}
## [1] 8.645097
{% endhighlight %}


Zum Schluss berechnen wir mit der fertigen Funktion aus den Klimadaten, die wir in der letzten Übung vom DWD herunter geladen haben eine Zeitreihe für die Grasreferenzverdunstung. Diese speichern wir als weitere Spalte in den `data.frame` der Klimadaten:

{% highlight r %}
Cottbus$ET0 <- calcET0(...)
{% endhighlight %}




Anschließend berechnen wir noch die klimatische Wasserbilanz und speichern diese als weitere Spalte:

{% highlight r %}
Cottbus$KWB <- Cottbus$NIEDERSCHLAGSHOEHE - Cottbus$ET0
{% endhighlight %}


# Formeln
Hier die nötigen Formeln aus dem ATV-DVWK-Merkblatt 504:

![Formeln 1](/images/ET0Formeln/1.png)
![Formeln 2](/images/ET0Formeln/2.png)
![Formeln 3](/images/ET0Formeln/3.png)

Zusätzlich verwenden wir noch die folgende Formel, um Windgeschwindigkeiten ($$v_z$$), die in anderen Höhen ($$z$$) gemessen wurden in die Windgeschwindigkeit in 2m Höhe ($$v_2$$) umzurechnen:

$$v_2 = v_z \cdot \frac{4.2}{log(z) + 3.5}$$


# Fragen
Bitte klären Sie die folgenden Fragen rechnerisch mit Hilfe ihrer programmierten Funktion:

* Kann die Luft bei gleicher relative Luftfeuchte aber unterschiedlichen Temperaturen die gleiche Menge Wasser aufnehmen?




* steigt die Grasreferenzverdunstung mit steigender Temperatur?



* steigt die Grasreferenzverdunstung mit steigender relativer Luftfeuchte?


* steigt die Grasreferenzverdunstung mit steigender Windgeschwindigkeit?


Erzeugen Sie zur Klärung der folgenden Fragen Streudiagramme:

* Ist die Grasreferenzverdunstung an der Cottbuser Station im Sommer im Mittel höher oder niedriger als im Winter?

* Ist die die Grasreferenzverdunstung im Sommer oder im Winter variabler?



* In welchen Jahreszeiten ist die klimatische Wasserbilanz im mittel positiv, in welchen negativ?



* Ist die Grasreferenzverdunstung bei einem Dampfdruck von 5 hPa generell niedriger als bei 15 hPa?



Diskutieren Sie die folgenden Verständnisfragen:

* Gilt die Grasreferenzverdunstung auch für ein Waldstück? Wie muss die Formel eventuell angepasst werden?

* Kann man mit der Grasreferenzverdunstung berechnen, wie weit sich der Grundwasserabstand im Sommer verringert?

* Macht die Grasreferenzverdunstung eine Aussage darüber, wie viel tatsächlich verdunstet?

* Warum sind die Böden in Brandenburg im Sommer tendenziell trockener als im Winter?

-----------------

Die nächste Übung in dieser Reihe ist die [Übung zu empirischen Verteilungsfunktionen](/tutorial/Histogramm-und-empirische-Verteilungsfunktion.html).
