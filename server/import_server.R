
retrieved <- eventReactive(input$retrieve_table, {
  withProgress(message = "Loading...", value = 0, {
    incProgress(1/2)
    if (input$data_set == "usgs") {
      pull.df <- pull_flow(gages = input$gages_cbox,
                           start.date = start.date(),
                           end.date = end.date(),
                           service.type = input$data_type,
                           shiny = TRUE,
                           n.cores = 2) %>% 
        dplyr::left_join(usgs.gages.df, by = c("site" = "code")) %>% 
        dplyr::mutate(flow = if_else(flow < 0, as.numeric(NA), flow)) %>% 
        dplyr::select(agency, site_no, site, description, date_time, flow)
    } else if(input$data_set == "drupal") {
      pull.df <- pull_withdrawals(start.date = start.date(),
                                  end.date = end.date())
    }
    incProgress(1/2)
  })
  
  pull.df <- pull.df %>% 
    dplyr::mutate(comments = as.character(NA),
                  # rhandsontable does not currently handle POSIXct.
                  # convert POSIXct to class character.
                  date_time = as.character(date_time))
  return(pull.df)
})
#------------------------------------------------------------------------------
output$retrieved_table <- renderTable({
  retrieved()
})
#------------------------------------------------------------------------------
data_table_retrieved <- reactive({
  retrieved.df <- retrieved() %>% 
    dplyr::filter(rowSums(is.na(.)) != ncol(.))
  
  validate(
    need(nrow(retrieved.df) > 0,
         "No data available for the selected data.")
  )

  final.dt <- datatable(retrieved.df,
                        options = list(
                          #scrollX = 2000, 
                          scrollY = 700,
                          autoWidth = TRUE,
                          columnDefs = list(list(className = 'dt-center',
                                                 targets = 1:ncol(retrieved()))),
                          pageLength = 100,
                          color = "black"))
})
#------------------------------------------------------------------------------
output$retrieve_table <- DT::renderDataTable(data_table_retrieved())