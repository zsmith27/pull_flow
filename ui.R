shinyUI(
  fluidPage(
    titlePanel("COOP Data Download"),
    source("ui/sidebar_ui.R", local = TRUE)$value,
    mainPanel(
      rHandsontableOutput("hot")
      #dataTableOutput('retrieve_table')
      ) # End mainPanel
  )
)
