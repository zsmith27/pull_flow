start.date <- reactive({
  start.date <- as.Date(input$date.range[1]) %>% 
    paste("00:00:00") %>% 
    as.POSIXct()
})
#------------------------------------------------------------------------------
end.date <- reactive({
  end.date <- as.Date(input$date.range[2]) %>% 
    paste("00:00:00") %>% 
    as.POSIXct()
})
#------------------------------------------------------------------------------