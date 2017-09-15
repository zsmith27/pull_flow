#------------------------------------------------------------------------------
sites.vec <- reactive({
  if (input$data_set == "usgs") {
    site.vec <- unique(retrieved()$site)
    
    site.vec <- usgs.gages.df %>%  
      dplyr::filter(code %in% site.vec) %>% 
      dplyr::distinct() %>% 
      dplyr::arrange(code) 
  }
  
  if (input$data_set == "drupal") {
    site.vec <- unique(retrieved()$unique_id)
  }
  
  return(site.vec)
})
#------------------------------------------------------------------------------
output$view_unique_cbox <- renderUI({
  checkboxGroupInput("view_gages_cbox",  "USGS Gage",
                     sites.vec()$description,
                     selected = sites.vec()$description)
})
#------------------------------------------------------------------------------



output$plot <- renderPlot({
  start.date <- start.date()
  end.date <- end.date()
  #----------------------------------------------------------------------------
  if (input$data_set == "usgs") {
    usgs_plots(sub.df(),
              start.date = input$view_date_range[1],
              end.date = input$view_date_range[2], 
              min.flow = input$min_flow,
              max.flow = input$max_flow,
              gages.checked = input$view_unique_cbox,
#                c("conoco", "goose", "mon_jug", "barnum",
#                                "kitzmiller", "luke", "nbp_cumb", "opequan",
#                                "hanc", "paw", "por", "shepherdstown",
#                                "lfalls", "bloomington", "barton", 
#                                "seneca", "shen_mill"),
              labels.vec = c("conoco" = "Conococheague Creek at Fairfview, MD",
                              "goose" = "Goose Creek near Leesburg, VA",
                              "mon_jug" = "Monocacy River at Jug Bridge near Frederick, MD",
                              "barnum"  = "North Branch Potomac River at Barnum, WV",
                              "kitzmiller" = "North Branch Potomac River at Kitzmiller, MD",
                              "luke" = "North Branch Potomac River at Luke, MD",
                              "nbp_cumb" = "North Branch Potomac River near Cumberland, MD",
                              "opequan"  = "Opequon Creek near Martinsburg, WV",
                              "hanc" = "Potomac River at Hancock, MD",
                              "paw" = "Potomac River at Paw Paw, WV",
                              "por" = "Potomac River at Point of Rocks, MD",
                              "shepherdstown" = "Potomac River at Shepherdstown, WV",
                              "lfalls" = "Potomac River near Wash, DC Little Falls pump sta",
                              "bloomington" = "Savage River Below Savage River Dam Near Bloomington, MD",
                              "barton" = "Savage River Near Barton, MD",
                              "seneca" = "Seneca Creek at Dawsonville, MD",
                              "shen_mill" = "Shenandoah River at Millville, WV"),
#              color.vec = c("conoco",
#                             "goose",
#                             "mon_jug",
#                             "barnum",
#                             "kitzmiller",
#                             "luke",
#                             "nbp_cumb",
#                             "opequan",
#                           "hanc",
#                             "paw",
#                             "por",
#                             "shepherdstown",
#                             "lfalls",
#                             "bloomington",
#                             "barton", 
#                             "seneca",
#                             "shen_mill"),
              x.class = "date_time",
              y.lab = "CFS")
  } else {
    drupal_plots(sub.df(),
               start.date = input$view_date_range[1],
               end.date = input$view_date_range[2], 
               min.flow = input$min_flow,
               max.flow = input$max_flow,
               gages.checked = input$view_unique_cbox,
               #                c("conoco", "goose", "mon_jug", "barnum",
               #                                "kitzmiller", "luke", "nbp_cumb", "opequan",
               #                                "hanc", "paw", "por", "shepherdstown",
               #                                "lfalls", "bloomington", "barton", 
               #                                "seneca", "shen_mill"),
               labels.vec = unique(sub.df()$unique_id),
               x.class = "date_time",
               y.lab = unique(sub.df()$units))
  }
  
}) # End output$plot

#------------------------------------------------------------------------------

sub.df <- reactive({
  if (input$data_set == "usgs") {
    retrieved() %>% 
      filter(site %in% input$view_gages_cbox)
  } else if (input$data_set == "drupal") {
    retrieved() %>% 
      filter(unique_id %in% input$view_unique_cbox)
  }

})
