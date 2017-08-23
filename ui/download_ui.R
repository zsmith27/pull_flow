tabPanel("Download",
         icon = icon("download"),
         fluidRow(
           column(3,
                  sidebarPanel(
                    width = 10,
                    textInput("file_name",
                              label = "Save As:",
                              width = "100%"),
                    downloadButton(outputId = "downloadData",
                                   lablel = "Download Data")
                  )
                  
           )
         ) # End fluidRow
) # End tabPanel