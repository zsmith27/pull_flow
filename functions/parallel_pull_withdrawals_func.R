#------------------------------------------------------------------------------
pull_drupal_parallel <- function(start.date, end.date, supplier) {
  main.string <- "http://icprbcoop.org/drupal4/icprb/data-view?"
  wssc.string <- paste0("http://icprbcoop.org/drupal4/icprb/data-view?",
                        "yesterdays_daily_average_withdrawal_potomac_river=yesterdays_daily_average_withdrawal_potomac_river&",
                        "yesterdays_daily_average_withdrawal_patuxent_reser=yesterdays_daily_average_withdrawal_patuxent_reser&", 
                        "forecasted_demand_today_am=forecasted_demand_today_am&", 
                        "forecasted_demand_today_pm=forecasted_demand_today_pm&", 
                        "forecasted_demand_tomorrow_am=forecasted_demand_tomorrow_am&",
                        "forecasted_demand_tomorrow_pm=forecasted_demand_tomorrow_pm&", 
                        "patuxent_reservoirs_current_usable_storage=patuxent_reservoirs_current_usable_storage&", 
                        "patuxent_reservoirs_total_usable_capacity=patuxent_reservoirs_total_usable_capacity&", 
                        "little_seneca_reservoir_current_usable_storage=little_seneca_reservoir_current_usable_storage&", 
                        "little_seneca_reservoir_total_usable_capacity=little_seneca_reservoir_total_usable_capacity&")
  fw.string <- paste0("yesterdays_daily_average_withdrawals_potomac_river=yesterdays_daily_average_withdrawals_potomac_river&", 
                      "yesterdays_daily_average_withdrawals_occoquan_rese=yesterdays_daily_average_withdrawals_occoquan_rese&", 
                      "forecasted_demand_today_am=forecasted_demand_today_am&", 
                      "forecasted_demand_today_pm=forecasted_demand_today_pm&", 
                      "forecasted_demand_tomorrow_AM=forecasted_demand_tomorrow_AM&", 
                      "forecasted_demand_tomorrow_PM=forecasted_demand_tomorrow_PM&", 
                      "occoquan_reservoir_current_usable_storage=occoquan_reservoir_current_usable_storage&", 
                      "occoquan_reservoir_total_usable_capacity=occoquan_reservoir_total_usable_capacity&")
  wa.string <- paste0("yesterdays_daily_average_withdrawals_potomac_river=yesterdays_daily_average_withdrawals_potomac_river&", 
                      "13_yesterdays_daily_average_withdrawals_potomac_river=13_yesterdays_daily_average_withdrawals_potomac_river&",
                      "forecasted_demand_today_am=forecasted_demand_today_am&", 
                      "forecasted_demand_today_pm=forecasted_demand_today_pm&", 
                      "forecasted_demand_tomorrow_am=forecasted_demand_tomorrow_am&", 
                      "forecasted_demand_tomorrow_pm=forecasted_demand_tomorrow_pm&")
  lw.string <- paste0("yesterdays_demand_mgd=yesterdays_demand_mgd&", 
                      "todays_demand_mgd=todays_demand_mgd&", 
                      "tomorrows_demand_mgd=tomorrows_demand_mgd&", 
                      "yesterdays_broad_run_discharge_daily=yesterdays_broad_run_discharge_daily&", 
                      "todays_estimated_average_discharge___broad_run_mgd=todays_estimated_average_discharge___broad_run_mgd&", 
                      "tommorrows_daily_average_discharge___broad_run_mgd=tommorrows_daily_average_discharge___broad_run_mgd&")
  date.string <- paste0("startdate=", 
                        format_date(start.date), 
                        "enddate=", 
                        format_date(end.date),
                        "format=csv&", 
                        "submit=Submit")
  #---------------------------------------------------------------------------------------------------------
  if (supplier == "wssc") supplier.string <- wssc.string
  if (supplier == "fw") supplier.string <- fw.string
  if (supplier == "wa") supplier.string <- wa.string
  if (supplier == "lw") supplier.string <- lw.string
  
  drupal.url <- paste0(main.string, supplier.string, date.string)
  
  final.df <- RCurl::getURL(drupal.url) %>% 
    textConnection() %>% 
    read.csv()
  return(final.df)
}

#------------------------------------------------------------------------------
isolate_pull_drupal <- function(start.date, end.date, supplier){
  shiny::isolate(pull_drupal(start.date, end.date, supplier))
}
#-----------------------------------------------------------------------------------------------------------
pull_withdrawals_parallel <- function(start.date, end.date = Sys.Date(),
                                      n.cores = NULL,
                                      shiny = FALSE) {
  supplier.vec <- c("wssc", "fw", "wa", "lw")
  #----------------------------------------------------------------------------
  library(parallel)
  if (is.null(n.cores)) n.cores <- detectCores() - 1
  cl <- makeCluster(n.cores)
  clusterExport(cl = cl,
                varlist = c("supplier.vec", "pull_drupal",
                            "isolate_pull_drupal", "format_date"),
                envir = environment())
  clusterEvalQ(cl, c(library(dplyr)))
  #----------------------------------------------------------------------------
  if (shiny == FALSE) {
    drupal.list  <- parLapply(cl, supplier.vec, function(supplier.i) {
      pull_drupal(start.date, end.date, supplier.i)
    })
  } else {
    drupal.list  <- parLapply(cl, supplier.vec, function(supplier.i) {
      isolate_pull_drupal(start.date, end.date, supplier.i)
    })
  }
  
  on.exit(stopCluster(cl))
  #------------------------------------------------------------------------------
  final.df <- bind_rows(drupal.list) %>% 
    tidyr::gather(variable, value, -Today) %>% 
    dplyr::filter(!is.na(value)) %>% 
    dplyr::bind_cols(stringr::str_split(.$variable, "\\.\\.", simplify = TRUE) %>% data.frame()) %>% 
    dplyr::select(-variable) %>% 
    dplyr::rename(today = Today,
                  supplier = X1,
                  variable = X2,
                  units = X3) %>% 
    dplyr::mutate(units = stringr::str_replace(units, "\\.(?=\\.*$)", ""),
                  variable = stringr::str_replace_all(variable, "\\.", " ") %>% stringr::str_trim(),
                  location = case_when(
                    stringr::str_detect(variable, stringr::regex("Potomac River at Great Falls", ignore_case = TRUE)) ~ "Potomac River at Great Falls",
                    stringr::str_detect(variable, stringr::regex("Potomac River at Little Falls", ignore_case = TRUE)) ~ "Potomac River at Little Falls",
                    stringr::str_detect(variable, stringr::regex("Potomac River", ignore_case = TRUE)) ~ "Potomac River",
                    stringr::str_detect(variable, stringr::regex("Little Reservoir", ignore_case = TRUE)) ~ "Little Reservoir",
                    stringr::str_detect(variable, stringr::regex("Patuxent Reservoirs", ignore_case = TRUE)) ~ "Patuxent Reservoirs",
                    stringr::str_detect(variable, stringr::regex("Little Seneca Reservoir", ignore_case = TRUE)) ~ "Little Seneca Reservoir",
                    stringr::str_detect(variable, stringr::regex("Occoquan Reservoir", ignore_case = TRUE)) ~ "Occoquan Reservoir",
                    stringr::str_detect(variable, stringr::regex("broad run", ignore_case = TRUE)) ~ "Broad Run",
                    TRUE ~ as.character(NA)
                  ),
                  location = case_when(
                    is.na(location) & supplier == "WSSC" ~ "WSSC Demand",
                    is.na(location) & supplier == "FW" ~ "FW Demand",
                    is.na(location) & supplier == "LW" ~ "LW Demand",
                    is.na(location) & supplier == "WA" ~ "WA Demand",
                    TRUE ~ location
                  ),
                  day = case_when(
                    stringr::str_detect(variable, stringr::regex("Yesterday", ignore_case = TRUE)) ~ "yesterday",
                    stringr::str_detect(variable, stringr::regex("tomorrow", ignore_case = TRUE)) ~ "tomorrow",
                    stringr::str_detect(variable, stringr::regex("today", ignore_case = TRUE)) ~ "today",
                    TRUE ~ as.character(NA)
                  ),
                  time = case_when(
                    stringr::str_detect(variable, stringr::regex(" am", ignore_case = TRUE)) ~ "am",
                    stringr::str_detect(variable, stringr::regex(" pm", ignore_case = TRUE)) ~ "pm",
                    TRUE ~ as.character(NA)
                  ),
                  measurement = case_when(
                    stringr::str_detect(variable, stringr::regex("daily average withdrawals", ignore_case = TRUE)) ~ "daily average withdrawals",
                    stringr::str_detect(variable, stringr::regex("Forecasted demand", ignore_case = TRUE)) ~ "forecasted demand",
                    stringr::str_detect(variable, stringr::regex("current usable storage", ignore_case = TRUE)) ~ "current usable storage",
                    stringr::str_detect(variable, stringr::regex("total usable capacity", ignore_case = TRUE)) ~ "total usable capacity",
                    stringr::str_detect(variable, stringr::regex("daily average demand", ignore_case = TRUE)) ~ "daily average demand",
                    stringr::str_detect(variable, stringr::regex("estimated average discharge", ignore_case = TRUE)) ~ "estimated average discharge", 
                    stringr::str_detect(variable, stringr::regex("daily discharge", ignore_case = TRUE)) ~ "daily discharge",
                    TRUE ~ as.character(NA)
                  ),
                  unique_id = paste(supplier, location) %>% trimws(),
                  today = as.Date(today)
    ) %>% 
    select(unique_id, supplier, location, day, time, measurement, today, value, units)
  return(final.df)
}