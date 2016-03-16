library(shiny)
library(leaflet)

shinyUI(navbarPage("Mapbrowser", id="nav",
  tabPanel("select station on map",
    div(class="outer",
      tags$head(includeCSS("styles.css")),
      leafletOutput("map", width = "100%", height = "100%"),

      absolutePanel(id = "controls", class = "panel panel-default",
                  fixed = TRUE, draggable = TRUE, top = 60, left = "auto",
                  right = 20, bottom = "auto",
                  width = 330, height = "auto",
                  h3(textOutput("selectedMarker"))
      )
    )
  ),
  tabPanel("select parameter",
           numericInput("minScore", "Min score", min=0, max=100, value=0)
           )
))
