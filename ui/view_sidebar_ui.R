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
                   uiOutput("view_unique_cbox"),
                   actionButton("view_reset_usgs", "Reset"),
                   actionButton("view_clear_usgs", "Clear"),
                   hr()
  ), # End Conditional Panel usgs
  conditionalPanel(condition = "input.data_set == 'drupal'",
                   checkboxGroupInput("view_unique_cbox",  "Unique ID:",
                                      NULL),
                   actionButton("view_reset_drupal", "Reset"),
                   actionButton("view_clear_drupal", "Clear"),
                   hr(),
                   selectInput("view_dropdown_measurement_drupal", "Select a Measurement:",
                               choices = c("current usable storage", "daily average demand", 
                                           "daily average withdrawals", "daily discharge",            
                                           "estimated average discharge", "forecasted demand",
                                           "total usable capacity"),
                               selected = "daily average withdrawals"
                   ),
                   selectInput("view_dropdown_day_drupal", "Select a Day:",
                               choices = c("Yesterday", "Today", "Tomorrow"),
                               selected = "Today"
                   ),
                   selectInput("view_dropdown_time_drupal", "Select a Time:",
                               choices = c("AM", "PM"),
                               selected = "AM"
                   ),
                   hr()
  ), # End Conditional Panel drupal
  numericInput("min_flow", "Minimum Flow:",
               NA, min = 0, max = 10 * 9,
               width = "120px"),
  numericInput("max_flow", "Maximum Flow:",
               NA, min = 0, max = 10 * 9,
               width = "120px")
)