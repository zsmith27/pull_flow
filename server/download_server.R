output$downloadData <- downloadHandler(
  filename = function() { paste0(input$file_name, '.csv') },
  content = function(file) {
    #write.csv(retrieved(), file, row.names = FALSE)
    data.table::fwrite(final.df(), file)
    #write.csv(final.df(), file, row.names = FALSE)
  }
)
#------------------------------------------------------------------------------
source("server/final_dataframe_server.R", local = TRUE)



