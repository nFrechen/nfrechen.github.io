# library(leaflet)
# library(RgetDWDdata)
# library(magrittr)
# stations <- getDWDstations()
# save(stations, file="stations.RData")
#


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
  output$selectedMarker <- renderText({
    index <- stations$geoLaenge==input$map_marker_click$lng & stations$geoBreite==input$map_marker_click$lat
    if(length(index)==0) {
      "select station on the map"
    }else{
    stations$Stationsname[index]
    }
  })

}
)
