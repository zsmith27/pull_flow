final.df <- reactive({
  if (is.null(retrieved())) NULL
  
  if (!is.null(retrieved()) && is.null(edited()) && is.null(appended())) {
    final.df <- retrieved()
  } 
  
  if (!is.null(edited()) && is.null(appended())) final.df <- edited()

  
  if (!is.null(appended())) final.df <- edited()
  
  return(final.df)
})
#------------------------------------------------------------------------------
data_table_final <- reactive({
  final.dt <- datatable(final.df(),
                        options = list(
                          #scrollX = 2000, 
                          scrollY = 700,
                          autoWidth = TRUE,
                          columnDefs = list(list(className = 'dt-center',
                                                 targets = 1:ncol(final.df()))),
                          pageLength = 100,
                          color = "black"))
})
#------------------------------------------------------------------------------
output$final_table <- DT::renderDataTable(data_table_final())