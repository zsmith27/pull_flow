
retrieved <- eventReactive(input$retrieve_table, {
  withProgress(message = "Loading...", value = 0, {
    incProgress(1/2)
    if (input$data_set == "usgs") {
      pull.df <- pull_flow(gages = input$gages_cbox,
                           start.date = start.date(),
                           end.date = end.date(),
                           service.type = input$data_type,
                           shiny = TRUE,
                           n.cores = 2)
    } else if(input$data_set == "drupal") {
      pull.df <- pull_withdrawals(start.date = start.date(),
                                  end.date = end.date())
    }
    incProgress(1/2)
  })
  
  
  return(pull.df)
})
#------------------------------------------------------------------------------
output$retrieved_table <- renderTable({
  retrieved()
})
#------------------------------------------------------------------------------
data_table_retrieved <- reactive({
  final.dt <- datatable(retrieved(),
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