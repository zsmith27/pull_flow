sidebarPanel(
  width = 10,
  strong("Today's Date:"), 
  Sys.Date(),
  
  dateRangeInput("edit_date_range",
                 "Date Range:", 
                 start = Sys.Date() - 30,
                 end = Sys.Date(),
                 width = "200px"),
  hr(),
  conditionalPanel(condition = "input.data_set == 'usgs'",
  selectInput("edit_dropdown_gage", "Gage:",
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
                "Shenandoah River at Millville, WV" = "shen_mill"))
  ) # End conditionalPanel usgs.
  
) # End sidebarPanel