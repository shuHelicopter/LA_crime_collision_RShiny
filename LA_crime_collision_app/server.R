######################################################
#################### by Shu Liu ######################
############ shutel at hotmail dot com ###############
################### 08/05/2016 #######################
###### Shiny project @ NYC Data Science Academy ######
######################################################

shinyServer(function(input, output){
  
  # show map using leaflet
  crime_map <- reactive({
    if (input$CMarea == 1) {
      filter(map_df, Year_occ %in% input$CMyear)
    }else {
      filter(map_df, Year_occ %in% input$CMyear, AREA.NAME %in% input$CMarea)
    }
  })
  
  output$mymap <- renderLeaflet({
    
    leaflet(crime_map()) %>%
      addTiles() %>%  # Add default OpenStreetMap map titles
      addMarkers(lat = crime_map()$locx, lng = crime_map()$locy,
                 clusterOptions = markerClusterOptions(),
                 popup = ~ paste('<b><font color="Red">', CrmCd.Desc, '</font></b><br/>', 
                                 'AREA: ', AREA.NAME, '<br/>', 
                                 'ADDRESS: ', Address, '<br/>',  
                                 'STATUS:', Status.Desc, '<br/>'))
  })
  
## Show daily crime using googleCal (Will be used in th future)
#  output$calendar <- renderGvis(
#    gvisCalendar(dycount_df, 
#                 datevar = "DATE.OCC", 
#                 numvar = "cnt",
#                 options = list(
#                   title = "Daily Crimes in Los Angeles",
#                   height = 620,
#                   calendar = "{yearLabel: { fontName: 'Times-Roman',
#                        fontSize: 32, color: '#1A8763', bold: true},
#                        cellSize: 10,
#                        cellColor: { stroke: 'red', strokeOpacity: 0.2 },
#                        focusedCellColor: {stroke:'green'}}")
#    ))
  
  crime1_map <- reactive({
      filter(crimedf, Year_occ %in% input$CMyear, AREA.NAME %in% input$CMarea)
  })
  
  # show crime areas using bar chart
  output$crm_area <- renderGvis({
    if(length(unique(crime_map()$AREA.NAME)) != 1){  #  'All areas' is selected by user
      gvisBarChart(areaTOTcount_df,
                   options = list(
                     title = 'Amount of Crimes&Collisions in LAPD Areas',
                     width = '600', 
                     height = '500',
                     legend = '{position: "top"}')
      )
    } else {
      areaSEPcount_df <- crime1_map() %>%
        group_by(Year_occ) %>%
        summarise(volume = n())
      
      gvisLineChart(areaSEPcount_df,
                    options = list(
                      title = 'Volume Changes of Crimes&Collisions from 2011 to 2014',
                      colors = "['red']",
                      width = '600',
                      height = '500', 
                      legend = '{position: "top"}')
      )
    }
  })
  
  
  # Show total volume changes of crimes using line chart
  output$crm_tot_chg <- renderGvis({
    gvisLineChart(TOTcount_df,
                  options = list(
                    title = 'Total Volume of Crimes&Collisions 2011 - 2014',
                    width = '600',
                    height = '500',
                    legend = '{position: "top"}')
    )
  })
  
  # Show crimes data table
  output$crm_table <- renderDataTable({
    dttable_df
  })
  
  # show crime time distribution analysis using 3D charts
  output$crm_time_3d <- renderPlotly({
    plot_ly(z = crime_time, 
            type = 'surface', 
            colors = 'YlOrRd') %>%
      layout(title = "Time Distribution Analysis of Crimes&Collisions", 
             scene = list(
               xaxis = list(title = 'time'), 
               yaxis = list(title = 'day'), 
               zaxis = list(title = 'volume')))
  })
  
  # Crime types world cloud & (season %in% input$tmprd)
  typecloud_df <- reactive({
    typecloud_df <- filter(ts_part_df, season %in% input$sen, tm_period %in% input$tmprd)
    typecloud_df <- typecloud_df %>% 
      group_by(CrmCd.Desc) %>%
      summarise(freq = n())
  })
  
  # show crime types using wordcloud
  output$crm_type <- renderPlot({
    wordcloud(typecloud_df()$CrmCd.Desc, 
              typecloud_df()$freq, 
              scale = c(5, 1), 
              max.words = 40,
              rot.per = 0,
              random.order = FALSE,
              random.color = FALSE,
              colors = brewer.pal(8, 'Set1'))
  })
  
  output$crm_sen_tm <- renderGvis({
    gvisBarChart(crm_sen_tm_df, xvar = 'tm_period', 
                 options = list(title = 'Total Crimes&Collisions in Season and Time',
                                legend = '{position: "top"}',
                                height = '600',
                                width = '500', 
                                colors = "['Red', 'Orange']",
                                isStacked = FALSE,
                                bar = '{groupWidth:"50%"}'))
  })
  
  
  # show crime status in days using bar chart
  output$crm_days_status <- renderGvis({
    gvisBarChart(daycount_df, xvar = 'Day_occ', 
                 options = list(title = 'Total Crimes&Collisions in Days',
                                width = 'auto',
                                height = 500,
                                colors = "['Orange']", 
                                legend = "{position: 'top'}",
                                bar="{groupWidth:'50%'}"))
  })
}
)
