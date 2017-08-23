tabPanel("Import",
         icon = icon("import", lib = "glyphicon"),
         fluidRow(
           column(4,
                  source("ui/import_sidebar_ui.R", local = TRUE)$value
           ),
           column(8,
                  dataTableOutput('retrieve_table')
           )
         ) # End fluidRow
) # End tabPanel