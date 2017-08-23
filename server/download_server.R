
output$downloadData <- downloadHandler(
  filename = function() { paste0(input$file_name, '.csv') },
  content = function(file) {
    #write.csv(retrieved(), file, row.names = FALSE)
    write.csv(hot_to_r(input$hot), file, row.names = FALSE)
  }
)

