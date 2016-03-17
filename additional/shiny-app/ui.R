library(shiny)
library(leaflet)

shinyUI(navbarPage("DWD climate data browser", id="nav",
  tabPanel("select station on map",
    div(class="outer",
      tags$head(includeCSS("styles.css")),
      leafletOutput("map", width = "100%", height = "100%"),

      absolutePanel(id = "controls", class = "panel panel-default", fixed = TRUE, draggable = TRUE, top = 60, left = "auto", right = 20, bottom = "auto", width = 230, height = "auto",
          uiOutput("ui")
      )
    )
  ),
  tabPanel("select parameters",
           sidebarLayout(
             sidebarPanel(
               h4(textOutput("parameterselect_title")),
                uiOutput("download_button"),
                uiOutput("select_parameters")
             ),
             mainPanel(
               plotOutput("plot")
             )
           )

    ),
  tabPanel("results",
    h4(textOutput("result_title")),
    uiOutput("results")
  )
))
