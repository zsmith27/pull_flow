#----------------------------------------------------------------------------
observeEvent(input$retrieve_table, {
  if (input$data_set == "usgs") {
    start.date <- retrieved()$date_time[1]
    min.date <- min(retrieved()$date_time, na.rm = TRUE)
    max.date <- max(retrieved()$date_time, na.rm = TRUE)
    diff.date <- lubridate::days(max.date) - lubridate::days(min.date)
    if(diff.date > hours(100)) {
      
    }
      

  } else {
    start.date <- retrieved()$today[1]
    if (nrow(retrieved()) < 100) {
      end.date <- max(retrieved()$today, na.rm = TRUE)
    } else {
      end.date <- retrieved()$today[100]
    }
  }

  updateDateRangeInput(session, "date.filter",
                       start = start.date,
                       end = end.date)
})