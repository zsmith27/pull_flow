

shinyUI(
  fluidPage(
    titlePanel("COOP Data Download"),
    mainPanel(
      tabsetPanel(
        source("ui/view_ui.R", local = TRUE)$value
      ) # End tabsetPanel
    ) # End mainPanel
  ) # End fluidPage
) # End shinyUI
