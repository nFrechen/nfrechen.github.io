# library(leaflet)
# library(RgetDWDdata)
# stations <- getDWDstations()
# View(stations)
# save(stations, file="stations.RData")
#data <- getDWDdata(Messstelle = "Cottbus")
#save(data, file="weatherdata.RData")

library(shiny)
library(leaflet)
library(RColorBrewer)

shinyServer(function(input, output, session) {

  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    load("stations.RData")
    leaflet() %>%
      addTiles() %>%
    addMarkers(
      data = stations,
      ~geoLaenge,
      ~geoBreite,
      popup = paste(stations$Stationsname, "<br/> ID:", stations$Stations_id),
      clusterOptions = markerClusterOptions()
    )
  })
    #  "select station on the map"
    #stations$Stationsname[index]

    output$ui <- renderUI({
      if (is.null(input$map_marker_click)){
        h3("please select station from the map")
      }else{
        index <- stations$geoLaenge==input$map_marker_click$lng & stations$geoBreite==input$map_marker_click$lat
        fluidPage(
          h3(stations$Stationsname[index]),
          h4(paste("ID:", stations$Stations_id[index])),
          h4(paste("State:", stations$Bundesland[index])),
          h4(paste("Heigth:", stations$Stationshoehe[index]), "m"),
          h4("In action"),
          h4(paste("since:", stations$von_datum[index])),
          h4(paste("until:", stations$bis_datum[index])),
          actionButton("activate-parameterselect", label = "select this station")
        )
      }
    })

  })

