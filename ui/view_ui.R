tabPanel("View",
         icon = icon("line-chart"),
         fluidRow(
           column(4,
                  source("ui/view_sidebar_ui.R", local = TRUE)$value
           ),
           column(8,
                  plotly::plotlyOutput("plot", height = plot.height, width = plot.width)
           )
         ) # End fluidRow
) # End tabPanel