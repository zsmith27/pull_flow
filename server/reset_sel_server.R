#----------------------------------------------------------------------------
observeEvent(input$reset.usgs, {
  updateCheckboxGroupInput(session, "gages_cbox", 
                           selected = c("conoco", "goose", "mon_jug", "barnum",
                                        "kitzmiller", "luke", "nbp_cumb", "opequan",
                                        "hanc", "paw", "por", "shepherdstown",
                                        "lfalls", "bloomington", "barton", 
                                        "seneca", "shen_mill"))
})
#----------------------------------------------------------------------------
observeEvent(input$clear.usgs, {
  updateCheckboxGroupInput(session, "gages_cbox", "USGS Gage",
                           c("Conococheague Creek at Fairfview, MD" = "conoco",
                             "Goose Creek near Leesburg, VA" = "goose",
                             "Monocacy River at Jug Bridge near Frederick, MD" = "mon_jug",
                             "North Branch Potomac River at Barnum, WV" = "barnum",
                             "North Branch Potomac River at Kitzmiller, MD" = "kitzmiller",
                             "North Branch Potomac River at Luke, MD" = "luke",
                             "North Branch Potomac River near Cumberland, MD" = "nbp_cumb",
                             "Opequon Creek near Martinsburg, WV" = "opequan",
                             "Potomac River at Hancock, MD" = "hanc",
                             "Potomac River at Paw Paw, WV" = "paw",
                             "Potomac River at Point of Rocks, MD" = "por",
                             "Potomac River at Shepherdstown, WV" = "shepherdstown",
                             "Potomac River near Wash, DC Little Falls pump sta" = "lfalls",
                             "Savage River Below Savage River Dam Near Bloomington, MD" = "bloomington",
                             "Savage River Near Barton, MD" = "barton",
                             "Seneca Creek at Dawsonville, MD" = "seneca",
                             "Shenandoah River at Millville, WV" = "shen_mill"),
                           selected = NULL)
})
#------------------------------------------------------------------------------
usgs.gages <- reactive({
  usgs.gages.df %>% 
    dplyr::filter(code %in% unique(retrieved()$site)) %>% 
    dplyr::arrange(description)
})


#----------------------------------------------------------------------------
observeEvent(input$view_reset_usgs, {
    updateCheckboxGroupInput(session, "view_gages_cbox", 
                             selected = sites.vec()$description)
    #                             c("conoco", "goose", "mon_jug", "barnum",
    #                                        "kitzmiller", "luke", "nbp_cumb", "opequan",
    #                                        "hanc", "paw", "por", "shepherdstown",
    #                                        "lfalls", "bloomington", "barton", 
    #                                        "seneca", "shen_mill"))
  })
#----------------------------------------------------------------------------
observeEvent(input$view_clear_usgs, {
  updateCheckboxGroupInput(session, "view_gages_cbox", "USGS Gage",
                           sites.vec()$description,
                           selected = NULL)
})
#----------------------------------------------------------------------------
#observeEvent(input$retrieve_table, {
#  updateCheckboxGroupInput(session, "view_unique_cbox", 
#                           choices = unique(retrieved()$unique_id),
#                           selected = unique(retrieved()$unique_id))
#})
#----------------------------------------------------------------------------
observeEvent(input$view_reset_drupal, {
  updateCheckboxGroupInput(session, "view_unique_cbox", 
                           selected = unique(retrieved()$unique_id))
})
#----------------------------------------------------------------------------
observeEvent(input$view_clear_drupal, {
  updateCheckboxGroupInput(session, "view_unique_cbox",
                           choices = unique(retrieved()$unique_id),
                           selected = NULL)
})