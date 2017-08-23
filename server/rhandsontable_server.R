output$hot <- renderRHandsontable({
  DF <- retrieved()
  if (!is.null(DF)) {
    rhandsontable(DF) %>% 
      hot_table(highlightCol = TRUE, highlightRow = TRUE) %>% 
      hot_cols(columnSorting = TRUE)
  }

})