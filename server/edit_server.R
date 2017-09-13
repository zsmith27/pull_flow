#sub.import <- eventReactive({
  
#})




#------------------------------------------------------------------------------
output$hot <- renderRHandsontable({
  DF <- retrieved()
  if (!is.null(DF)) {
    rhandsontable(DF, width = 625, height = 700) %>% 
      hot_table(highlightCol = TRUE, highlightRow = TRUE) %>% 
      hot_cols(columnSorting = TRUE)
  }

})
#------------------------------------------------------------------------------
edited <- reactive({
  if (is.null(input$hot)) {
    return(NULL)
  } else {
    hot_to_r(input$hot)
  }
})