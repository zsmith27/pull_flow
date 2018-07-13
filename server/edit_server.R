#sub.import <- eventReactive({
  
#})


# output$hot <- renderDT({
#   DF <- retrieved()
#   if (!is.null(DF)) {
#     DT::datatable(DF,
#                   width = 625,
#                   height = 700, 
#                   editable = TRUE)
#   }
# })

#------------------------------------------------------------------------------
output$hot <- renderRHandsontable({
  DF <- retrieved() %>% 
    mutate(comments = as.character(comments))
  if (!is.null(DF)) {
    rhandsontable(DF, height = 700) %>%
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