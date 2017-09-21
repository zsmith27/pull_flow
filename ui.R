shinyUI(
  navbarPage(title = tags$a("", href = "http://icprbcoop.org/drupal4/self-breifing-conditions", target = "_blank",
                            tags$span(style="color:white", "CO-OP")),
             id = "tab",
             inverse = TRUE, 
             theme = shinythemes::shinytheme("spacelab"),
             source("ui/import_ui.R", local = TRUE)$value,
             source("ui/view_ui.R", local = TRUE)$value,
             source("ui/edit_ui.R", local = TRUE)$value,
#             source("ui/append_ui.R", local = TRUE)$value,
             source("ui/download_ui.R", local = TRUE)$value
  )
)
