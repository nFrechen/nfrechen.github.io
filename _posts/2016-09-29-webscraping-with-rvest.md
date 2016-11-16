---
layout: post
title: Webscraping  isotope data with rvest
excerpt: Harvest data from the IAEA WISER database
category: tutorial
language: English
author: Nanu Frechen
datasource: <a href="https://nucleus.iaea.org/wiser/gnip.php">IAEA WISER isotope data</a>
technique: <a href="http://r-project.org">R</a>, <a href="https://github.com/hadley/rvest">rvest</a>, <a href="https://blog.rstudio.org/2014/07/22/introducing-tidyr/">tidyr</a>, <a href="https://cran.rstudio.com/web/packages/dplyr/vignettes/introduction.html">dplyr</a>, <a href="https://github.com/hadley/purrr">purrr</a>, <a href="https://blog.rstudio.org/2015/04/09/readr-0-1-0/">readr</a>
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
* do everything in a tidy dataframe

In this post we will give you a short [theoretical background](#theoretical-background) as a motivation about why we want to work with this data. Then we will show you how to [download the data with rvest step by step](#how-is-the-server-setup).

In follow-up tutorials linked to this tutorial we will show you:

* how to derive the Local Meteoric Water Line (LMWL) for all stations with linear regression
* how to show the variation of parameters on an interactive map
* make correllations between the isotope signatures and parameters like longitude, latitude, elevation and climatic variables


# Theoretical Background

<!-- http://wwwrcamnl.wr.usgs.gov/isoig/period/o_iig.html -->

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

Source: [https://de.wikipedia.org/wiki/Wasserstoff#Protium](), [http://www.wolframalpha.com/input/?i=16O+isotope]()

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
form2 <- set_values(form, USER= user, PASSWORD=password)
{% endhighlight %}

Of course you first have to store a variable with username and the password:

{% highlight r %}
user <- "myUser"
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
{% endhighlight %}
We use `[[3]]` to extract the third table.

# Convert to tidy data.frame

We want to work with a tidy data.frame (also called `tibble`). A `data.frame` stores observations (the rows) in variables (the colums). Each column can have a different data type (like integer, character, logical, etc.). Have a look at `help(typeof)` to learn more about object types. What the rows of a column are not allowed to contain is other object classes like `list` or `matrix`. Consult `help(class)` to learn the difference between an object class and the object type.

Therefore traditionally everyone tended to introduce a new variable (for example `data <- list()`) to store data that don't fit into the data.frame. The problem is, there is no direct link between the data.frame (let's say it is called `stations`) and the data stored in the list called `data`. If we change one of the objects (for example we drop some rows of the data.frame), the other object doesn't change. So later on we cannot link the rows of the table to the elements of the list.

With a tibble we can store all the data we will later download in a column of the station list. This way we maintain a constant link between the data and the station list.

Let's convert the station data.frame to a tibble. The package `tibble` is automatically loaded when loading the package `dplyr` (which contains additional useful functions like `mutate` for working with tidy data).


{% highlight r %}
library(dplyr)
{% endhighlight %}

Convert the station list:


{% highlight r %}
stations <- as.tbl(stations)
{% endhighlight %}

If we display the tibble you see the difference to a data.frame:


{% highlight r %}
stations
{% endhighlight %}



{% highlight text %}
## # A tibble: 917 × 14
##            `Name of site` `WMO Code`     Country `Climate Zone` `Start Year` `End Year` `Samples Total` `Samples ¹⁸O` `Samples ²H` `Samples ³H` `Show on Map`   Download Plots Statistics
##                     <chr>      <int>       <chr>          <chr>        <int>      <int>           <int>         <int>        <int>        <int>         <chr>      <chr> <chr>      <chr>
## 1            QUITO-INAMHI    8407301     Ecuador            Cfb         1997       2014             204           160          163           13           Map csv | xlsx Plots Statistics
## 2                  MANAUS    8233100      Brazil             Af         1965       1990             312           187          160          180           Map csv | xlsx Plots Statistics
## 3                 CALGARY    7187701      Canada            Dfb         1992       2001             120           116          118            0           Map csv | xlsx Plots Statistics
## 4  LEON/VIRGEN DEL CAMINO     805500       Spain            Cfb         2000       2010             132           120          120          126           Map csv | xlsx Plots Statistics
## 5               ROVANIEMI     284500     Finland            Dfc         2003       2010              96            83           83           54           Map csv | xlsx Plots Statistics
## 6       KABUL (KARIZIMIR)    4094900 Afghanistan            BSk         1962       1991             360           109           86          123           Map csv | xlsx Plots Statistics
## 7                 MALANGE    6621500      Angola             Aw         1969       1983             180            85           66           74           Map csv | xlsx Plots Statistics
## 8                MENONGUE    6641000      Angola            Cwa         1969       1983             180            59           46           57           Map csv | xlsx Plots Statistics
## 9              HALLEY BAY    8902200  Antarctica             EF         1965       2014             600           552          533          504           Map csv | xlsx Plots Statistics
## 10          ROTHERA POINT    8906200  Antarctica             EF         1996       2014             228           196          196           57           Map csv | xlsx Plots Statistics
## # ... with 907 more rows
{% endhighlight %}

With the `mutate()` function we can introduce new columns. Here we replace the column `WMO Code`:


{% highlight r %}
stations <- mutate(stations, `WMO Code`= formatC(`WMO Code`, width = 7, flag=0))
{% endhighlight %}

With this we add back the leading 0s of the WMO Code that where stripped in the table read process.

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

The extracted links we add into the station list with `mutate`:


{% highlight r %}
stations <- mutate(stations, link=csv_links)
{% endhighlight %}

# Prepare download

First we create a download folder:

{% highlight r %}
folder <- "data"
dir.create(folder)
{% endhighlight %}
For the download we need a destination file name for every csv file. We will use the station WMO code for this:

{% highlight r %}
stations <- mutate(stations, destfile=paste0(folder, "/", `WMO Code`, ".csv"))
{% endhighlight %}



# Download data
We now are ready to download the data. We use a loop over all the `csv_links`.
Because we can't pass the session info to `download.file()` we will use a different approach to download the files: 
With the command `jump_to()` we maintain the session while following the links. We then write the content of the loaded link to a file with `writeBin()` (the idea came from [this stackoverflow answer](http://stackoverflow.com/a/36204367/2427707)).

{% highlight r %}
for(i in 1:nrow(stations)){
  jump_to(nucl2, url=stations$link[i])$response$content %>%
    writeBin(file.path(stations$destfile[i]))
  Sys.sleep(1)
}
{% endhighlight %}

We set `Sys.sleep(1)` to prevent sending too many request in short time to the server. Some servers deny service when we send requests in sequence too fast.

# Read csv files
Finally we want to add the station data to our tidy data.frame. For reading we use the package `readr`, which reads csv files a lot faster and reads it directly into a tibble. Advantage of the latter is for example, that column names get preserved in the format they have in the csv file.  We also need the function `map` of the 
`purr` package. `map` is an apply function that can be executed on the elements of a vector. Install these packages with `install.packages("readr")` and `install.packages("purrr")`.


{% highlight r %}
library(readr)
library(purrr)
stations <- mutate(stations, data=map(destfile, read_csv))
{% endhighlight %}

To check what we have done just now we display the data for the first station:


{% highlight r %}
stations$data[[1]]
{% endhighlight %}



{% highlight text %}
## # A tibble: 204 × 24
##    `Name of site` Country `WMO Code`  Latitude Longitude Altitude                     `Type of Site`  `Source of Information` `Sample Name`                 `Media Type`    Date `Begin of Period` `End of Period` Comment   O18 `O18 Laboratory`    H2 `H2 Laboratory`    H3 `H3 Error` `H3 Laboratory` Precipitation `Air Temperature` `Vapour Pressure`
##             <chr>   <chr>      <int>     <dbl>     <dbl>    <int>                              <chr>                    <chr>         <int>                        <chr>   <chr>            <date>          <date>   <chr> <dbl>            <chr> <dbl>           <chr> <dbl>      <dbl>           <chr>         <dbl>             <dbl>             <dbl>
## 1    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199701 Water - Precipitation - rain 1997-01        1997-01-01      1997-01-31    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 2    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199702 Water - Precipitation - rain 1997-02        1997-02-01      1997-02-28    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 3    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199703 Water - Precipitation - rain 1997-03        1997-03-01      1997-03-31    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 4    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199704 Water - Precipitation - rain 1997-04        1997-04-01      1997-04-30    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 5    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199705 Water - Precipitation - rain 1997-05        1997-05-01      1997-05-31    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 6    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199706 Water - Precipitation - rain 1997-06        1997-06-01      1997-06-30    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 7    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199707 Water - Precipitation - rain 1997-07        1997-07-01      1997-07-31    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 8    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199708 Water - Precipitation - rain 1997-08        1997-08-01      1997-08-31    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 9    QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199709 Water - Precipitation - rain 1997-09        1997-09-01      1997-09-30    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>            NA                NA                NA
## 10   QUITO-INAMHI      EC    8407301 -0.166667 -78.48333     2789 Precipitation collectors - unknown [Partner: INAMHI, Quito]        199710 Water - Precipitation - rain 1997-10        1997-10-01      1997-10-31    <NA>    NA             <NA>    NA            <NA>    NA         NA            <NA>           153                NA                NA
## # ... with 194 more rows
{% endhighlight %}

Finally have a look with what a "tidy dataframe" we ended up with:

{% highlight r %}
stations
{% endhighlight %}



{% highlight text %}
## # A tibble: 917 × 17
##            `Name of site` `WMO Code`     Country `Climate Zone` `Start Year` `End Year` `Samples Total` `Samples ¹⁸O` `Samples ²H` `Samples ³H` `Show on Map`   Download Plots Statistics                                                            link         destfile                data
##                     <chr>      <chr>       <chr>          <chr>        <int>      <int>           <int>         <int>        <int>        <int>         <chr>      <chr> <chr>      <chr>                                                           <chr>            <chr>              <list>
## 1            QUITO-INAMHI    8407301     Ecuador            Cfb         1997       2014             204           160          163           13           Map csv | xlsx Plots Statistics download.php?siteId=172136&page=gnip&action=download&format=csv data/8407301.csv <tibble [204 × 24]>
## 2                  MANAUS    8233100      Brazil             Af         1965       1990             312           187          160          180           Map csv | xlsx Plots Statistics download.php?siteId=172137&page=gnip&action=download&format=csv data/8233100.csv <tibble [312 × 24]>
## 3                 CALGARY    7187701      Canada            Dfb         1992       2001             120           116          118            0           Map csv | xlsx Plots Statistics download.php?siteId=172138&page=gnip&action=download&format=csv data/7187701.csv <tibble [120 × 24]>
## 4  LEON/VIRGEN DEL CAMINO    0805500       Spain            Cfb         2000       2010             132           120          120          126           Map csv | xlsx Plots Statistics download.php?siteId=172139&page=gnip&action=download&format=csv data/0805500.csv <tibble [132 × 24]>
## 5               ROVANIEMI    0284500     Finland            Dfc         2003       2010              96            83           83           54           Map csv | xlsx Plots Statistics download.php?siteId=172140&page=gnip&action=download&format=csv data/0284500.csv  <tibble [96 × 24]>
## 6       KABUL (KARIZIMIR)    4094900 Afghanistan            BSk         1962       1991             360           109           86          123           Map csv | xlsx Plots Statistics download.php?siteId=172141&page=gnip&action=download&format=csv data/4094900.csv <tibble [360 × 24]>
## 7                 MALANGE    6621500      Angola             Aw         1969       1983             180            85           66           74           Map csv | xlsx Plots Statistics download.php?siteId=172142&page=gnip&action=download&format=csv data/6621500.csv <tibble [180 × 24]>
## 8                MENONGUE    6641000      Angola            Cwa         1969       1983             180            59           46           57           Map csv | xlsx Plots Statistics download.php?siteId=172143&page=gnip&action=download&format=csv data/6641000.csv <tibble [180 × 24]>
## 9              HALLEY BAY    8902200  Antarctica             EF         1965       2014             600           552          533          504           Map csv | xlsx Plots Statistics download.php?siteId=172144&page=gnip&action=download&format=csv data/8902200.csv <tibble [600 × 24]>
## 10          ROTHERA POINT    8906200  Antarctica             EF         1996       2014             228           196          196           57           Map csv | xlsx Plots Statistics download.php?siteId=172145&page=gnip&action=download&format=csv data/8906200.csv <tibble [228 × 24]>
## # ... with 907 more rows
{% endhighlight %}

# The short version

Using the pipe operator `%>%` very often you can get rid of a lot of the temporary variables and compact the code quite a lot:


{% highlight r %}
password <- "myPassword"
library(rvest)
library(dplyr)
folder <- "data"
dir.create(folder)

# establish session
nucl <- html_session("https://websso.iaea.org/login/login.fcc?TYPE=33554433&REALMOID=06-ef4f28c9-f8dc-467e-8186-294fdf5e627b&GUID=&SMAUTHREASON=0&METHOD=GET&SMAGENTNAME=$SM$e5utW7BvliO1ED%2btYsJY7ob8iaMTTe5bnP3rVRRDKcLtPDyvx7kOY%2b6YSwtMTLAv&TARGET=$SM$HTTPS%3a%2f%2fwebsso%2eiaea%2eorg%2flogin%2fbounce%2easp%3fDEST%3d$$SM$$HTTPS$%3a$%2f$%2fwebsso$%2eiaea$%2eorg$%2flogin$%2fredirect$%2easp$%3ftarget$%3dhttp$%3a$%2f$%2fnucleus$%2eiaea$%2eorg$%2fwiser$%2fgnip$%2ephp$%3fll_latlon$%3d$%26ur_latlon$%3d$%26country$%3d$%26wmo_region$%3d$%26date_start$%3d1953$%26date_end$%3d2016$%26iso_o18$%3don$%26iso_h2$%3don$%26result_start$%3d0$%26result_end$%3d1000$%26action$%3dSearch")
form <- html_form(nucl)[[1]] %>% set_values(USER= "jklasd", PASSWORD=password)
form$url <- ""
nucl2 <- submit_form(session=nucl, form=form)

# extract links
links <- html_nodes(nucl2, css="a") %>% .[html_text(.) == "csv"] %>% html_attr(name="href") 

# function for downloading the data
readFun <- function(x) read_csv(jump_to(nucl2, url=x)$response$content)

# downlaod station list
stations <- html_table(nucl2)[[3]] %>% as.tbl %>%
  mutate(`WMO Code`= formatC(`WMO Code`, width = 7, flag=0)) %>%
  mutate(link=links) %>%
  mutate(destfile=paste0(folder, "/", `WMO Code`, ".csv")) %>%
  .[1:5,] %>% # for testing I download only the first 5 lines (remove this line to download all)
  mutate(data=map(link, readFun))
{% endhighlight %}


# Conclusion

We now downloaded all the data and added it to our tidy data.frame. 

In follow-up tutorials we will show you how to:

* derive the Local Meteoric Water Line (LMWL) for all stations with linear regression
* show the variation of parameters on an interactive map
* make correllations between the isotope signatures and parameters like longitude, latitude, elevation and climatic variables

# What can you do next?

Try to download data from the [Global Network of Isotopes in Rivers (GNIR)](http://www-naweb.iaea.org/napc/ih/IHS_resources_gnir.html)
