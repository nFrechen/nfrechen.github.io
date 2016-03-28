while(!require(RgetDWDdata)) devtools::install_github("nFrechen/RgetDWDdata")
library(dygraphs)
library(xts)
library(xlsx)
library(rmarkdown)
library(knitr)
library(shiny)
library(leaflet)
library(RColorBrewer)
stations <- getDWDstations()
#save(stations, file="stations.RData")
#save(data, file="data.RData")
#load("stations.RData")

shinyServer(function(input, output, session) {

  # show map to select station from
  output$map <- renderLeaflet({
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

  # react to station selected on map
  output$stationInfo <- renderUI({
    if (is.null(input$map_marker_click)){
      h3("please select a station from the map")
    }else{
      ind <<- stations$geoLaenge==input$map_marker_click$lng & stations$geoBreite==input$map_marker_click$lat

      # populate download tab
      output$result_title <- renderText(stations$Stationsname[ind])
      output$variableselect_title <- renderText(stations$Stationsname[ind])
      output$download_button <- renderUI(actionButton("download", label = "download data"))
      output$select_variables <- renderUI({ }) # hide results from previous selection
      output$plot <- renderUI({ }) # hide results from previous selection

      # show station infos on the map when marker is selected (frame on the top-right)
      list(
        h3(stations$Stationsname[ind]),
        h4(paste("ID:", stations$Stations_id[ind])),
        h4(paste("State:", stations$Bundesland[ind])),
        h4(paste("Heigth:", stations$Stationshoehe[ind]), "m"),
        h4("Operation"),
        h4(paste("since:", stations$von_datum[ind])),
        h4(paste("until:", stations$bis_datum[ind])),
        h4("download station data in next tab")
      )
    }
  })

  # if download button is pressed:
  observeEvent(input$download,{
    print(stations$Stations_id[ind])
    data <- getDWDdata(stations$Stations_id[ind], historisch = F)
    #load("data.RData")

    if(is.null(data)){ # if download fails

      output$select_variables <- renderUI({
        h4("Sorry, this station does not seem to have downloadable data.")
      })

    }else{ # if download successfull

      data_names <- colnames(data[-1:-3])[apply(data[-1:-3], 2, function(x) all(!is.na(x)))]

      if(length(data_names)==0){
        output$select_variables <- renderUI({
          h4("Sorry, this station has no data that we can display.")
        })
      }else{
        # show variable selector:
        output$select_variables <- renderUI(
          list(
            tags$hr(),
            selectizeInput('variable_selection', 'select variables you want to display', choices = data_names, multiple = TRUE)
          )
        )

        # plot variables that were selected
        window <- NULL
        observeEvent(input$variable_selection, ignoreNULL = FALSE,{
          n <- length(input$variable_selection)
          if(n!=0){

            # get window size if it previously existed:
            isolate({
              win <- input[[paste0(input$variable_selection[1], "_date_window")]]
              if(!is.null(win)) window <<- win
            })

            # generate report button:
            output$generate_report <- renderUI({
              list(
              actionButton("generate_report", "generate download"),
              p("continue to next tab to download")

              )
            })
            observeEvent(input$generate_report, {

              # generate download_file button:
              output$results <- renderUI({
                list(
                  selectInput("which_to_download", "choose a file to download:", choices = c(PDF="pdf", Word="docx", CSV="csv", Excel="xlsx")),
                  downloadButton("download_file", "Download")
                )
              })

              # download button functions:
              output$download_file <- downloadHandler(
                filename = function() {
                  paste0(stations$Stationsname[ind], ".", input$which_to_download)
                },
                content = function(file) {
                  print(str(window))
                  switch(input$which_to_download,
                      "pdf" = rmarkdown::render("pdf-report.Rmd", pdf_document(), output_file=file),
                      "docx" = rmarkdown::render("pdf-report.Rmd", word_document(), output_file=file),
                      "csv" = write.csv(data[,c("MESS_DATUM", input$variable_selection)], file),
                      "xlsx" = xlsx::write.xlsx(data[,c("MESS_DATUM", input$variable_selection)], file)
                  )

                }
              )
            })


            # create graphic UIs
            output$plot <- renderUI({
              plotlist <- list()
              for(i in input$variable_selection){
                plotlist[[i]] <- dygraphOutput(i, height=600/n)
              }
              return(plotlist)
            })

            # populate graphic UIs
            num1 = TRUE
            for(i in input$variable_selection){
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
        })
      }
    }
  })
})

