sidebarPanel(
  width = 10,
  selectInput("dropdown_gage", "Gage:",
              c("Cylinders" = "cyl",
                "Transmission" = "am",
                "Gears" = "gear")),

  strong("Today's Date:"), 
  Sys.Date(),
  
  dateRangeInput("view_date_range",
                 "Date Range:", 
                 start = Sys.Date() - 30,
                 end = Sys.Date(),
                 width = "200px")
) # End sidebarPanel