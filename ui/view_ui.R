tabPanel("View",
         icon = icon("line-chart"),
         fluidRow(
           column(4,
                  sidebarPanel(
                    width = 10,
                    
                    strong("Today's Date:"), 
                    Sys.Date(),
                    
                    dateRangeInput("view_date_range",
                                   "Date Range:", 
                                   start = Sys.Date() - 30,
                                   end = Sys.Date(),
                                   width = "200px"),
                    hr(),
                    conditionalPanel(condition = "input.data_set == 'usgs'",
                                     checkboxGroupInput("view_gages_cbox",  "USGS Gage",
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
                                                        selected = c("conoco", "goose", "mon_jug", "barnum",
                                                                     "kitzmiller", "luke", "nbp_cumb", "opequan",
                                                                     "hanc", "paw", "por", "shepherdstown",
                                                                     "lfalls", "bloomington", "barton", 
                                                                     "seneca", "shen_mill")),
                                     actionButton("view_reset_usgs", "Reset"),
                                     actionButton("view_clear_usgs", "Clear"),
                                     hr()
                    ), # End Conditional Panel usgs
                    numericInput("min_flow", "Minimum Flow:",
                                 NA, min = 0, max = 10 * 9,
                                 width = "120px"),
                    numericInput("max_flow", "Maximum Flow:",
                                 NA, min = 0, max = 10 * 9,
                                 width = "120px")
                  )
           ),
           column(8,
                  plotOutput("plot", height = plot.height, width = plot.width)
           )
         ) # End fluidRow
) # End tabPanel