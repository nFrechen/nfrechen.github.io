---
layout: post
title: Webscraping  isotope data with rvest
excerpt: Harvest data from the IAEA WISER database
category: tutorial
language: English
author: Nanu Frechen
datasource: <a href="https://nucleus.iaea.org/wiser/gnip.php">IAEA WISER isotope data</a>
technique: <a href="http://r-project.org">R</a>, <a href="https://github.com/hadley/rvest">rvest</a>
---


<style type="text/css">
#markdown-toc{
  width: 200px;
}
</style>

Hydrologists use isotope signatures of precipitation water as a tracer to follow water flow pathways in the ground and in rivers. The [International Atomic Energy Ageny (IAEA)](https://www.iaea.org)
has setup a [Global Network of Isotopes in Precipitation (GNIP)](http://www-naweb.iaea.org/napc/ih/IHS_resources_gnip.html). We will have a look into this data set in this tutorial series about working with isotope data. 

* auto-gen TOC:
{:toc}

First thing we have to do is to download the data from their website. Of course we want to autotmate this! We will use a webscraping package called <a href="https://github.com/hadley/rvest">rvest</a> to get this done.

**Goals:**

* get all the download links for a certain region
* download all the `.csv` files



**Challenges:**

* master the login page form
* maintain a constant session from the login to the end of the last download
* implement file download which is not explicitly implemented in the rvest package

In this post we will give you a short [theoretical background](#theoretical-background) as a motivation about why we want to work with this data. Then we will show you how to [download the data with rvest step by step](#how-is-the-server-setup).

In follow-up tutorials linked to this tutorial we will show you:

* how to read all the .csv files and merge them into a big database
* how to derive the Local Meteoric Water Line (LMWL) for all stations with linear regression
* how to show the variation of parameters on an interactive map
* make correllations between the isotope signatures and parameters like longitude, latitude, elevation and climatic variables


# Theoretical Background

Water containts not only the usual $$H$$ and $$O$$ atoms. It contains also small amounts of the slightly heavier isotopes $$^2H$$ and $$^{18}O$$. Isotopes are atoms containing one or multiple additional neutrons in the core than the more abundant variety of the atom. 

Because of their slightly heavier mass (compare table below), they behave different from the abundant $$H$$ and $$O$$ isotopes. This shows mainly when the water evaporates or condensates: The heavier isotopes are slightly less likely to evaporate and a bit more likely to condensate before the lighter isotopes. Hence water that stems from evaporation (like clouds generally do) are depleted in the heavy isotopes (compared to the water remaining in the ocean). When clouds rain off, the water remaining in the cloud get's even more depleted of the heavy isotopes, since these condensate and rain down first.

--------------

isotope | name  | neutrons  | natural abundance* | molecular weight | stability
:----: | ----  | -----:       | ---:            | ---: | ---
$$^1H$$ | Protium  | 0  | $$99.988\, \%$$   |  $$1.0078\, u$$ | stable <!--$$3.347\, g·mol^{-1}$$-->
$$^2H$$ | Deuterium | 1 | $$0.012\, \%$$ |  $$2.0141\, u$$ | stable <!--$$4.028\, g·mol^{-1}$$-->
$$^3H$$ | Tritium | 2 | $$10^{−15}\, \%$$|  $$3.0160\, u$$ | decays <!--$$6.032\, g\cdot mol^{-1}$$-->
| | | | | 
$$^{16}O$$ |  | 8 | $$99.76\,\%$$ | $$15.994\, u$$ | stable
$$^{17}O$$ |  | 9 | $$0.04\,\%$$ | $$16.999\, u$$ | stable
$$^{18}O$$ | | 10 | $$0.20\,\%$$ | $$17.999\, u$$ | stable

\* abundance varies slightly in different water bodies (ocean, groundwater, river, cloud)

-----------

Due to this fractionation of the isotopes researchers can measure a difference in the isotope "fingerprint" of rainwater and water on the ground. The atmospheric fingerprint varies a lot, depending on the temperature and humidity conditions when the vater evaporated and during the time it traveled through the atmosphere. 

Water on the ground is a more stable mix of isotopes.
Therefore every rain event brings in a new pulse of water with different isotope signature.
Hence the $$H$$ and $$O$$ isotopes can be utilized as a natural tracer to visualize the flow pathways the water takes after raining down to the ground. Following the water with the isotope signature of the last rainfall shows reasearchers where the precipitation water ended up. Measuring a mixed signature between the ground water and the precipitation water means that the former stored water and the fresh water have mixed. Since isotopes don't chemically react, decay or get bound, they are also a very useful tracer. In the end they still are water and behave like water in most ways.

<!--The great water body of our oceans has a nearly constant isotope signature. Groundwater also has a very stable signature, since the water is stored in the ground for a long time and all the different pathways the water takes through the ground mix it fairly well. In rivers rainfall water and ground water mix. By measuring-->

The [International Atomic Energy Ageny (IAEA)](https://www.iaea.org)
has setup a [Global Network of Isotopes in Precipitation (GNIP)](http://www-naweb.iaea.org/napc/ih/IHS_resources_gnip.html). They maintain a database where measurements from different institutions from all over the world are gathered together and made available for everyone to use. The database access system is called [WISER (Water Isotope System for Data Analysis, Visualization, and Electronic Retrieval)](http://www-naweb.iaea.org/napc/ih/IHS_resources_isohis.html). You have to [register at websso.iaea.org](https://websso.iaea.org/IM/UserRegistrationPage.aspx?returnpage=http://nucleus.iaea.org/wiser/gnip.php?ll_latlon=&ur_latlon=&country=&wmo_region=&date_start=1953&date_end=2016&iso_o18=on&iso_h2=on&result_start=0&result_end=1000&action=Search), but then it is free to use for everyone (they just ask for your name, thats it). 

They also provide a similar database for isotopes signatures in rivers, the [Global Network of Isotopes in Rivers (GNIR)](http://www-naweb.iaea.org/napc/ih/IHS_resources_gnir.html).


# How is the server set up?

Generally the database can be accessed with the follwoing link: <https://nucleus.iaea.org/wiser/gnip.php?ll_latlon=&ur_latlon=&country=&wmo_region=&date_start=1953&date_end=2016&iso_o18=on&iso_h2=on&result_start=0&result_end=1000&action=Search>

This page is only accessable for registered users, hence if you are not logged in you get redirected to the login page. If you haven't done this [register to create an account](https://websso.iaea.org/IM/UserRegistrationPage.aspx?returnpage=http://nucleus.iaea.org/wiser/gnip.php?ll_latlon=&ur_latlon=&country=&wmo_region=&date_start=1953&date_end=2016&iso_o18=on&iso_h2=on&result_start=0&result_end=1000&action=Search).


If you visit the page and fiddle around with the form to select the region, the isotopes and other options, you can see how the url changes with these options. It is the usual syntax of the http request-response protocol [GET](http://www.w3schools.com/tags/ref_httpmethods.asp):


You have

* `country=` for selecting the country (for example `country=Germany`)
* `wmo_region=` which you can give a number (like `wmo_region=6` for the european wmo region)
* with `date_start=` and `date_end=` you can define the date range. Just give it a year
* `iso_018=on`, `iso_h2=on` and `iso_h3=on` define which isotopes have to have been measured at the stations you want to select
* `result_start=0` and `result_end=1000` define how many enries are shown on one page. You have the option to set `result_end` to 10, 20, 30 and 1000 (The 1000 corresponds to the "All" button on the page). Setting it to 1000 comes handy to download all available files (although if you select the whole world you end up with even more than a thousand stations). 

What we are looking for are the $$^{18}O$$ and $$^2H$$ isotopes. So we set `iso_018=on&iso_h2=on` and leave `iso_h3` out. We aks for stations of the whole world by setting `wmo_region=` and leaving it without any number. Add the end we have to add `action=Search` to initiate the search for stations. The url above is already setup with these options.

# What is rvest?

rvest is a package for webscraping—extracting content from web pages. It is not only about downloading files from the internet, but crawling through web pages, finding certain links inside the page and follow them to the next page and so on. You can select elements of the page by their [DOM](http://www.w3schools.com/js/js_htmldom.asp) (their html structure), their [id or class selectors](http://www.w3schools.com/css/css_syntax.asp). Then you can not only extract the text of the page, but also the html attributes like the `href=` of a link or the `src=` of an image (which contain the url of the link and the image respectively).

Let's go ahead and install rvest:


{% highlight r %}
install.packages("rvest")
{% endhighlight %}

After installing we have to laod it:


{% highlight r %}
library(rvest)
{% endhighlight %}


# Master the login form
To be able to access the data or even display the station list, we have to be logged in. After loggin in we have to maintain this login information when going to different pages. In rvest this is done by establishing a session and passing the session info to the next commands.

If you try to surf to the above mentioned link

{% highlight txt %}
https://nucleus.iaea.org/wiser/gnip.php?ll_latlon=&ur_latlon=&country=&wmo_region=&date_start=1953&date_end=2016&iso_o18=on&iso_h2=on&result_start=0&result_end=1000&action=Search
{% endhighlight %}
without beeing logged in you find yourself beeing redirected to another page with the following url:

{% highlight txt %}
https://websso.iaea.org/login/login.fcc?TYPE=33554433&REALMOID=06-ef4f28c9-f8dc-467e-8186-294fdf5e627b&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=$SM$e5utW7BvliO1ED%2btYsJY7ob8iaMTTe5bnP3rVRRDKcLtPDyvx7kOY%2b6YSwtMTLAv&TARGET=$SM$HTTPS%3a%2f%2fwebsso%2eiaea%2eorg%2flogin%2fbounce%2easp%3fDEST%3d$$SM$$HTTPS$%3a$%2f$%2fwebsso$%2eiaea$%2eorg$%2flogin$%2fredirect$%2easp$%3ftarget$%3dhttp$%3a$%2f$%2fnucleus$%2eiaea$%2eorg$%2fwiser$%2fgnip$%2ephp$%3fll_latlon$%3d$%26ur_latlon$%3d$%26country$%3d$%26wmo_region$%3d$%26date_start$%3d1953$%26date_end$%3d2016$%26iso_o18$%3don$%26iso_h2$%3don$%26result_start$%3d0$%26result_end$%3d1000$%26action$%3dSearch
{% endhighlight %}

Note how this page contains a redirect to the original link. So after you log in you get redirected to the page you originally requested.

With rvest we will establish a session with the link to the login page:

{% highlight r %}
nucl <- html_session("https://websso.iaea.org/login/login.fcc?TYPE=33554433&REALMOID=06-ef4f28c9-f8dc-467e-8186-294fdf5e627b&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=$SM$e5utW7BvliO1ED%2btYsJY7ob8iaMTTe5bnP3rVRRDKcLtPDyvx7kOY%2b6YSwtMTLAv&TARGET=$SM$HTTPS%3a%2f%2fwebsso%2eiaea%2eorg%2flogin%2fbounce%2easp%3fDEST%3d$$SM$$HTTPS$%3a$%2f$%2fwebsso$%2eiaea$%2eorg$%2flogin$%2fredirect$%2easp$%3ftarget$%3dhttp$%3a$%2f$%2fnucleus$%2eiaea$%2eorg$%2fwiser$%2fgnip$%2ephp$%3fll_latlon$%3d$%26ur_latlon$%3d$%26country$%3d$%26wmo_region$%3d$%26date_start$%3d1953$%26date_end$%3d2016$%26iso_o18$%3don$%26iso_h2$%3don$%26result_start$%3d0$%26result_end$%3d1000$%26action$%3dSearch")
{% endhighlight %}

We then have to fill in the login form.

First we extract the form:

{% highlight r %}
form <- html_form(nucl)[[1]]
{% endhighlight %}

Let's have a look:

{% highlight r %}
form
{% endhighlight %}



{% highlight text %}
## <form> 'Login' (POST )
##   <input hidden> 'SMENC': UTF-8
##   <input hidden> 'SMLOCALE': US-EN
##   <input hidden> 'target': HTTPS://websso.iaea.org/login/bounce.asp?DEST=$SM$HTTPS%3a%2f%2fwebsso%2eiaea%2eorg%2flogin%2fredirect%2easp%3ftarget%3dhttp%3a%2f%2fnucleus%2eiaea%2eorg%2fwiser%2fgnip%2ephp%3fll_latlon%3d%26ur_latlon%3d%26country%3d%26wmo_region%3d%26date_start%3d1953%26date_end%3d2016%26iso_o18%3don%26iso_h2%3don%26result_start%3d0%26result_end%3d1000%26action%3dSearch
##   <input hidden> 'smquerydata': 
##   <input hidden> 'smauthreason': 0
##   <input hidden> 'smagentname': e5utW7BvliO1ED+tYsJY7ob8iaMTTe5bnP3rVRRDKcLtPDyvx7kOY+6YSwtMTLAv
##   <input hidden> 'postpreservationdata': 
##   <input text> 'USER': 
##   <input password> 'PASSWORD': 
##   <button submit> 'SignIn
{% endhighlight %}

You see one input field for `'User'` and one for `'PASSWORD'`.


We then fill these out:

{% highlight r %}
form2 <- set_values(form, USER= "jklasd", PASSWORD=password)
{% endhighlight %}

Of course you first have to store a variable with the password:

{% highlight r %}
password <- "myPassword"
{% endhighlight %}

Next we do something we learned from [this stackoverflow answer](http://stackoverflow.com/a/35029644/2427707) to prevent an (cryptic) error when submitting the form:

{% highlight r %}
form2$url <- ""
{% endhighlight %}

Now we are ready to submit the form:

{% highlight r %}
nucl2 <- submit_form(session=nucl, form=form2)
{% endhighlight %}

We save a new session with the return of the form submission. The return is a redirect to the original page (the page with the station list). We now are logged in with a cookie stored in our session and are redirected to the page we originally intended to view.

# Extract station list

With the session stored under `nucl2` we now can extract the data from the table displayed on the page. 


{% highlight r %}
stations <- html_table(nucl2)[[3]]
stations$`WMO Code` <- formatC(stations$`WMO Code`, width = 7, flag=0) 
{% endhighlight %}
We use `[[3]]` to extract the third table.

Note how we reconvert the statin WMO Code back to a string with leading zeros. R recognizes it as a integer and deletes the leading zeros per default.

The station list looks like this:

{% highlight text %}
##             Name of site WMO Code Country Climate Zone Start Year End Year Samples Total Samples ¹⁸O Samples ²H Samples ³H Show on Map   Download Plots Statistics
## 1           QUITO-INAMHI  8407301 Ecuador          Cfb       1997     2014           204         160        163         13         Map csv | xlsx Plots Statistics
## 2                 MANAUS  8233100  Brazil           Af       1965     1990           312         187        160        180         Map csv | xlsx Plots Statistics
## 3                CALGARY  7187701  Canada          Dfb       1992     2001           120         116        118          0         Map csv | xlsx Plots Statistics
## 4 LEON/VIRGEN DEL CAMINO  0805500   Spain          Cfb       2000     2010           132         120        120        126         Map csv | xlsx Plots Statistics
## 5              ROVANIEMI  0284500 Finland          Dfc       2003     2010            96          83         83         54         Map csv | xlsx Plots Statistics
{% endhighlight %}

# Extract links

We now extract all links from the page:


{% highlight r %}
links <- html_nodes(nucl2, css="a")
{% endhighlight %}

With the part `css="a"` we extract all html `<a></a>` elements (the syntax for inserting links into html pages).

The following shows the links in one row of the station list:


{% highlight r %}
links[52:56]
{% endhighlight %}



{% highlight text %}
## {xml_nodeset (5)}
## [1] <a class="colorbox" href="load.php?siteId=172138&amp;page=gnip&amp;action=map&amp;format=html">Map</a>
## [2] <a href="download.php?siteId=172138&amp;page=gnip&amp;action=download&amp;format=csv">csv</a>
## [3] <a href="download.php?siteId=172138&amp;page=gnip&amp;action=download&amp;format=excel">xlsx</a>
## [4] <a class="colorbox" href="load.php?siteId=172138&amp;page=gnip&amp;format=html&amp;action=plot">Plots</a>
## [5] <a class="colorbox" href="load.php?siteId=172138&amp;page=gnip&amp;format=html&amp;action=statistics">Statistics</a>
{% endhighlight %}

Of course we only want the links referencing a csv file. All csv links have "csv " in the link text. So we make a list about which fo the links contain the keyword "csv":

{% highlight r %}
is_csv_link <- html_text(links) == "csv"
{% endhighlight %}

Now we extract the `href` attribute of all links linking a csv file (note how we use `is_csv_link` here):

{% highlight r %}
csv_links <- html_attr(links[is_csv_link], name="href")
{% endhighlight %}

# Prepare download

For the download we need a destination file name for every csv file. We will use the station WMO code for this:

{% highlight r %}
destfiles <- paste0( stations[, "WMO Code"], ".csv")
{% endhighlight %}

We also create a download folder:

{% highlight r %}
folder <- "data"
dir.create(folder)
{% endhighlight %}


# Download data
We now are ready to download the data. We use a loop over all the `csv_links`.
Because we can't pass the session info to `download.file()` we will use a different approach to download the files: 
With the command `jump_to()` we maintain the session while following the links. We then write the content of the loaded link to a file with `writeBin()` (the idea came from [this stackoverflow answer](http://stackoverflow.com/a/36204367/2427707)).

{% highlight r %}
for(i in 1:length(csv_links)){
  jump_to(nucl2, url=csv_links[i])$response$content %>%
    writeBin(file.path(folder, destfiles[i]))
  Sys.sleep(1)
}
{% endhighlight %}

We set `Sys.sleep(1)` to prevent sending too many request in short time to the server. Some servers deny service when we send requests in sequence too fast.

Now we populated our download folder with all the csv files linked in the station list. 

In follow-up tutorials we will show you how to:

* read all the .csv files and merge them into a big database
* derive the Local Meteoric Water Line (LMWL) for all stations with linear regression
* show the variation of parameters on an interactive map
* make correllations between the isotope signatures and parameters like longitude, latitude, elevation and climatic variables

# What can you do next?

Try to download data from the [Global Network of Isotopes in Rivers (GNIR)](http://www-naweb.iaea.org/napc/ih/IHS_resources_gnir.html)
