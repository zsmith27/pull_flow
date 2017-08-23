shinyUI(
  navbarPage("COOP",
             id = "tab",
             inverse = TRUE, 
             theme = shinythemes::shinytheme("spacelab"),
             source("ui/import_ui.R", local = TRUE)$value,
             source("ui/view_ui.R", local = TRUE)$value,
             source("ui/edit_ui.R", local = TRUE)$value,
             source("ui/append_ui.R", local = TRUE)$value,
             source("ui/download_ui.R", local = TRUE)$value
  )
)
