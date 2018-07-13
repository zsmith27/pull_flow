tabPanel("Edit",
         icon = icon("edit"),
         fluidRow(
           column(3#,
                  #source("ui/edit_sidebar_ui.R", local = TRUE)$value
           ),
           column(9,
                  align = "left",
                  rHandsontableOutput("hot")
           )
         ) # End fluidRow
) # End tabPanel
