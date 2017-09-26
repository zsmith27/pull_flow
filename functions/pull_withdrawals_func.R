
#------------------------------------------------------------------------------
format_date <- function(date) {
  new.date <- lubridate::as_date(date)
  
  date.final <- paste0(lubridate::month(new.date), "%2F",
                       lubridate::day(new.date), "%2F",
                       lubridate::year(new.date), "&")
  return(date.final)
}
#------------------------------------------------------------------------------
pull_drupal <- function(start.date, end.date) {
  #  drupal.url <- "http://icprbcoop.org/drupal4/icprb/data-view?yesterdays_daily_average_withdrawal_potomac_river=yesterdays_daily_average_withdrawal_potomac_river&yesterdays_daily_average_withdrawal_patuxent_reser=yesterdays_daily_average_withdrawal_patuxent_reser&forecasted_demand_today_am=forecasted_demand_today_am&forecasted_demand_today_pm=forecasted_demand_today_pm&forecasted_demand_tomorrow_am=forecasted_demand_tomorrow_am&forecasted_demand_tomorrow_pm=forecasted_demand_tomorrow_pm&patuxent_reservoirs_current_usable_storage=patuxent_reservoirs_current_usable_storage&patuxent_reservoirs_total_usable_capacity=patuxent_reservoirs_total_usable_capacity&little_seneca_reservoir_current_usable_storage=little_seneca_reservoir_current_usable_storage&little_seneca_reservoir_total_usable_capacity=little_seneca_reservoir_total_usable_capacity&yesterdays_daily_average_withdrawals_potomac_river=yesterdays_daily_average_withdrawals_potomac_river&yesterdays_daily_average_withdrawals_occoquan_rese=yesterdays_daily_average_withdrawals_occoquan_rese&forecasted_demand_today_am=forecasted_demand_today_am&forecasted_demand_today_pm=forecasted_demand_today_pm&forecasted_demand_tomorrow_AM=forecasted_demand_tomorrow_AM&forecasted_demand_tomorrow_PM=forecasted_demand_tomorrow_PM&occoquan_reservoir_current_usable_storage=occoquan_reservoir_current_usable_storage&occoquan_reservoir_total_usable_capacity=occoquan_reservoir_total_usable_capacity&yesterdays_daily_average_withdrawals_potomac_river=yesterdays_daily_average_withdrawals_potomac_river&13_yesterdays_daily_average_withdrawals_potomac_river=13_yesterdays_daily_average_withdrawals_potomac_river&forecasted_demand_today_am=forecasted_demand_today_am&forecasted_demand_today_pm=forecasted_demand_today_pm&forecasted_demand_tomorrow_am=forecasted_demand_tomorrow_am&forecasted_demand_tomorrow_pm=forecasted_demand_tomorrow_pm&startdate=08%2F14%2F2017&enddate=08%2F21%2F2017&format=csv&submit=Submit"
  drupal.url <- paste("http://icprbcoop.org/drupal4/icprb/data-view?",
                      "yesterdays_daily_average_withdrawal_potomac_river=yesterdays_daily_average_withdrawal_potomac_river&",
                      "yesterdays_daily_average_withdrawal_patuxent_reser=yesterdays_daily_average_withdrawal_patuxent_reser&", 
                      "forecasted_demand_today_am=forecasted_demand_today_am&", 
                      "forecasted_demand_today_pm=forecasted_demand_today_pm&", 
                      "forecasted_demand_tomorrow_am=forecasted_demand_tomorrow_am&",
                      "forecasted_demand_tomorrow_pm=forecasted_demand_tomorrow_pm&", 
                      "patuxent_reservoirs_current_usable_storage=patuxent_reservoirs_current_usable_storage&", 
                      "patuxent_reservoirs_total_usable_capacity=patuxent_reservoirs_total_usable_capacity&", 
                      "little_seneca_reservoir_current_usable_storage=little_seneca_reservoir_current_usable_storage&", 
                      "little_seneca_reservoir_total_usable_capacity=little_seneca_reservoir_total_usable_capacity&", 
                      "yesterdays_daily_average_withdrawals_potomac_river=yesterdays_daily_average_withdrawals_potomac_river&", 
                      "yesterdays_daily_average_withdrawals_occoquan_rese=yesterdays_daily_average_withdrawals_occoquan_rese&", 
                      "forecasted_demand_today_am=forecasted_demand_today_am&", 
                      "forecasted_demand_today_pm=forecasted_demand_today_pm&", 
                      "forecasted_demand_tomorrow_AM=forecasted_demand_tomorrow_AM&", 
                      "forecasted_demand_tomorrow_PM=forecasted_demand_tomorrow_PM&", 
                      "occoquan_reservoir_current_usable_storage=occoquan_reservoir_current_usable_storage&", 
                      "occoquan_reservoir_total_usable_capacity=occoquan_reservoir_total_usable_capacity&", 
                      "yesterdays_daily_average_withdrawals_potomac_river=yesterdays_daily_average_withdrawals_potomac_river&", 
                      "13_yesterdays_daily_average_withdrawals_potomac_river=13_yesterdays_daily_average_withdrawals_potomac_river&",
                      "forecasted_demand_today_am=forecasted_demand_today_am&", 
                      "forecasted_demand_today_pm=forecasted_demand_today_pm&", 
                      "forecasted_demand_tomorrow_am=forecasted_demand_tomorrow_am&", 
                      "forecasted_demand_tomorrow_pm=forecasted_demand_tomorrow_pm&", 
                      "yesterdays_demand_mgd=yesterdays_demand_mgd&", 
                      "todays_demand_mgd=todays_demand_mgd&", 
                      "tomorrows_demand_mgd=tomorrows_demand_mgd&", 
                      "yesterdays_broad_run_discharge_daily=yesterdays_broad_run_discharge_daily&", 
                      "todays_estimated_average_discharge___broad_run_mgd=todays_estimated_average_discharge___broad_run_mgd&", 
                      "tommorrows_daily_average_discharge___broad_run_mgd=tommorrows_daily_average_discharge___broad_run_mgd&", 
                      "startdate=", 
                      format_date(start.date), 
                      "enddate=", 
                      format_date(end.date),
                      "format=csv&", 
                      "submit=Submit", sep = "")
  #---------------------------------------------------------------------------------------------------------
  final.df <- RCurl::getURL(drupal.url) %>% 
    #textConnection() %>% 
    data.table::fread(showProgress = FALSE)
  return(final.df)
}
#-----------------------------------------------------------------------------------------------------------
pull_withdrawals <- function(start.date, end.date = Sys.Date()) {
  e.date <- end.date + lubridate::days(1)
  final.df <- pull_drupal(start.date, e.date) %>% 
    tidyr::gather(variable, value, -Today) %>% 
    dplyr::filter(!is.na(value)) %>% 
    # dplyr::bind_cols(stringr::str_split(.$variable, " ", simplify = TRUE) %>% data.frame()) %>% 
    #dplyr::select(-variable) %>% 
    dplyr::rename_all(tolower) %>% 
    dplyr::mutate(variable = stringr::str_replace_all(variable, "\\.", " ") %>% stringr::str_trim(),
                  units = gsub("\\(([^()]*)\\)|.", "\\1", variable, perl = TRUE),
                  supplier = gsub(" -.*", "", variable, perl = TRUE),
                  location = case_when(
                    stringr::str_detect(variable, stringr::regex("Potomac River at Great Falls", ignore_case = TRUE)) ~ "Potomac River",
                    stringr::str_detect(variable, stringr::regex("Potomac River at Little Falls", ignore_case = TRUE)) ~ "Potomac River",
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
                  unique_id = if_else(grepl("demand|Demand", location),
                                      paste(location, measurement) %>% trimws(),
                                      paste(supplier, location, measurement) %>% trimws()),
                  today = as.Date(today),
                  date_time = dplyr::case_when(
                    is.na(day) ~ today,
                    day == "yesterday" ~ today - lubridate::days(1),
                    day == "tomorrow" ~ today + lubridate::days(1),
                    TRUE ~ today
                  ) 
    ) %>% 
    dplyr::filter(date_time >= as.Date(start.date),
                  date_time <= as.Date(end.date)) %>% 
    select(unique_id, supplier, location, date_time, day, time, measurement, today, value, units)
  return(final.df)
}







