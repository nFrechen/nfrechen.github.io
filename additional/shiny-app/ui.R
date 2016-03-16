library(shiny)
library(leaflet)

shinyUI(navbarPage("Mapbrowser", id="nav",
  tabPanel("select station on map",
    div(class="outer",
      tags$head(includeCSS("styles.css")),
      leafletOutput("map", width = "100%", height = "100%"),

      absolutePanel(id = "controls", class = "panel panel-default",
                  fixed = TRUE, draggable = TRUE, top = 60, left = "auto",
                  right = 20, bottom = "auto", width = 230, height = "auto",
                  uiOutput("ui")
      )
    )
  ),
  tabPanel("select parameter",
           selectizeInput(
             'parameterSelection', 'select parameters to analyze', choices = colnames(data), multiple = TRUE
           ),
           sliderInput("slider2", label = h3("Slider Range"), min = 0,
                       max = 100, value = c(40, 60)),
           actionButton("parameters-selected", label = "show data for this selection")
           ),
  uiOutput("show-results")

))
