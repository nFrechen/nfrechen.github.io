# library(leaflet)
library(RgetDWDdata)
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

  output$result_title <- renderText("select parameters in previous tab")
  output$parameterselect_title <- renderText("select a station on the map in the previous tab")
    #  "select station on the map"
    #stations$Stationsname[index]

    output$ui <- renderUI({
      if (is.null(input$map_marker_click)){
        h3("please select a station from the map")
      }else{
        index <<- stations$geoLaenge==input$map_marker_click$lng & stations$geoBreite==input$map_marker_click$lat
        output$result_title <- renderText(stations$Stationsname[index])
        output$parameterselect_title <- renderText(stations$Stationsname[index])
        output$download_button <- renderUI({
          actionButton("download", label = "download data")
        })

        fluidPage(
          h3(stations$Stationsname[index]),
          h4(paste("ID:", stations$Stations_id[index])),
          h4(paste("State:", stations$Bundesland[index])),
          h4(paste("Heigth:", stations$Stationshoehe[index]), "m"),
          h4("In action"),
          h4(paste("since:", stations$von_datum[index])),
          h4(paste("until:", stations$bis_datum[index]))
        )
      }
    })
    observeEvent(input$download,{
      print(stations$Stations_id[index])
      data <- getDWDdata(stations$Stations_id[index], historisch = F)
      if(is.null(data)){
        output$select_parameters <- renderUI({
          h4("Sorry, the download for the selected station failed.")
        })
      }else{

        data_names <- colnames(data[-1:-3])[apply(data[-1:-3], 2, function(x) all(!is.na(x)))]
        if(length(data_names)==0){
          output$select_parameters <- renderUI({
            h4("Sorry, this station has no data that we can display.")
          })
        }else{
          output$select_parameters <- renderUI({
            selectizeInput('parameter_selection', 'select all parameters you want to analyze', choices = data_names, multiple = TRUE)
          })
          output$plot <- renderPlot({
            n <- length(input$parameter_selection)

            if(n!=0){
              par(mfrow=c(n,1), mar=c(3,4,0.1,0.1))
              for(i in input$parameter_selection){

                plot(data[,"MESS_DATUM"], data[,i], ylab=i)
              }

            }
          }, height = (500))
        }
      }
    })

})

