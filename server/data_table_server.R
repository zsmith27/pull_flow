# Create the DataTable.
dt.react <- reactive({
  # Prevent red error message from appearing while data is loading.
  if (is.null(download.df$data)) return(NULL)
  
  
  final.dt <- datatable(download.df$data,
                        options = list(
                          scrollX = 2000, 
                          scrollY = 700,
                          autoWidth = TRUE,
                          columnDefs = list(list(className = 'dt-center',
                                                 targets = 1:ncol(download.df()))),
                          pageLength = 100,
                          color = "black"))
  
  return(final.dt)
})
#---------------------------------------------------------------------------- 
# Render a table representing the selected Site and Parameter.
output$retrieve_table <- DT::renderDataTable(dt.react()) # End output$param_table
