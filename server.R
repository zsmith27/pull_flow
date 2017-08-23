shinyServer(function(input, output, session) {
  #----------------------------------------------------------------------------
  # Automatically stop session once browser window is closed.
  # Appears to work but when editing the ui.R errors will beging to appear in
  # to console.
  session$onSessionEnded(stopApp)
  #----------------------------------------------------------------------------
  source("server/reset_sel_server.R", local = TRUE)
  source("server/dates_server.R", local = TRUE)
  source("server/retrieve_server.R", local = TRUE)
  source("server/download_server.R", local = TRUE)
  source("server/rhandsontable_server.R", local = TRUE)
})