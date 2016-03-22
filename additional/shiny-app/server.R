while(!require(RgetDWDdata)) devtools::install_github("nFrechen/RgetDWDdata")
library(dygraphs)
library(xts)

library(shiny)
library(leaflet)
library(RColorBrewer)
stations <- getDWDstations()

shinyServer(function(input, output, session) {

  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
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

  output$result_title <- renderText("select variables in previous tab")
  output$variableselect_title <- renderText("select a station on the map in the previous tab")

    output$ui <- renderUI({
      if (is.null(input$map_marker_click)){
        h3("please select a station from the map")
      }else{
        ind <<- stations$geoLaenge==input$map_marker_click$lng & stations$geoBreite==input$map_marker_click$lat
        output$result_title <- renderText(stations$Stationsname[ind])
        output$variableselect_title <- renderText(stations$Stationsname[ind])
        output$download_button <- renderUI({
          actionButton("download", label = "download data")
        })
        output$select_variables <- renderUI({
        })
        output$plot <- renderUI({
        })

        list(
          h3(stations$Stationsname[ind]),
          h4(paste("ID:", stations$Stations_id[ind])),
          h4(paste("State:", stations$Bundesland[ind])),
          h4(paste("Heigth:", stations$Stationshoehe[ind]), "m"),
          h4("Operation"),
          h4(paste("since:", stations$von_datum[ind])),
          h4(paste("until:", stations$bis_datum[ind]))
        )
      }
    })
    observeEvent(input$download,{
      print(stations$Stations_id[ind])
      data <- getDWDdata(stations$Stations_id[ind], historisch = F)
      if(is.null(data)){
        output$select_variables <- renderUI({
          h4("Sorry, this station does not seem to have downloadable data.")
        })
      }else{

        data_names <- colnames(data[-1:-3])[apply(data[-1:-3], 2, function(x) all(!is.na(x)))]
        if(length(data_names)==0){
          output$select_variables <- renderUI({
            h4("Sorry, this station has no data that we can display.")
          })
        }else{
          output$select_variables <- renderUI(
            list(
              tags$hr(),
              selectizeInput('variable_selection', 'select variables you want to display', choices = data_names, multiple = TRUE)
            )
          )
          window <- NULL
          observeEvent(input$variable_selection,{
            n <- length(input$variable_selection)
            if(n!=0){
              isolate({
                win <- input[[paste0(input$variable_selection[1], "_date_window")]]
                if(!is.null(win)) window <<- win
              })

              output$plot <- renderUI({
                plotlist <- list()
                for(i in input$variable_selection){
                  plotlist[[i]] <- dygraphOutput(i, height=600/n)
                }
                return(plotlist)
              })

              num1 = TRUE
              for(i in input$variable_selection){
                print(paste0("output$", i))
                local({
                  j <- i # this is assignment is important!
                  output[[j]] <- renderDygraph({
                      if(num1) {
                        num1 <<- FALSE
                        dygraph(xts(data[,j], data[,"MESS_DATUM"]), ylab=j, group="graphs") %>%
                        dyRangeSelector(window)

                      }else{
                        dygraph(xts(data[,j], data[,"MESS_DATUM"]), ylab=j, group="graphs") %>% dyRangeSelector()
                      }
                  })
                })
              }
            }
          }, ignoreNULL = FALSE)
        }
      }
    })

})

