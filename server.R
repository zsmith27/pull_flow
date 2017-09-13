shinyServer(function(input, output, session) {
  #----------------------------------------------------------------------------
  # Automatically stop session once browser window is closed.
  # Appears to work but when editing the ui.R errors will beging to appear in
  # to console.
  session$onSessionEnded(stopApp)
  #----------------------------------------------------------------------------
  # Tab Import
  source("server/reset_sel_server.R", local = TRUE)
  source("server/dates_server.R", local = TRUE)
  source("server/import_server.R", local = TRUE)
  #----------------------------------------------------------------------------
  # Tab View
  source("server/view_server.R", local = TRUE)
  
  #----------------------------------------------------------------------------
  # Tab Edit
  source("server/edit_server.R", local = TRUE)
  #----------------------------------------------------------------------------
  # Tab Append
  source("server/append_server.R", local = TRUE)
  #----------------------------------------------------------------------------
  # Tab Download
  source("server/download_server.R", local = TRUE)
  #----------------------------------------------------------------------------
  #source("server/filter_server.R", local = TRUE)
})