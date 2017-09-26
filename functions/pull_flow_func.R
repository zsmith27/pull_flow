retrieve_flow <- function(gage = NULL, start.date = "1950-10-30",
                          end.date = Sys.Date(), service.type = "iv",
                          site.table) {
  if (service.type == "iv") {
    e.date <- end.date + lubridate::days(1)
  } else {
    e.date <- end.date
  }
  gage.df <- dataRetrieval::readNWISdata(service = service.type,
                                         site = gage,
                                         startDate = start.date,
                                         #startDate = "2016-01-01",
                                         endDate = end.date,
                                         asDateTime = FALSE,
                                         #tz = "America/New_York",
                                         # Dischrage Code.
                                         parameterCd = "00060")
  #--------------------------------------------------------------------------
  if (nrow(gage.df) == 0) {
    na.df <- data.frame(agency = NA,
                        site = NA,
                        date_time = NA,
                        wuql_code = NA,
                        timezone = NA,
                        flow = NA)
    return(na.df)
  }
  #--------------------------------------------------------------------------
  name.string <- site.table %>%
    filter(site_no == gage) %>% 
    pull(code)
  #--------------------------------------------------------------------------
  names(gage.df)[4:5] <- c("discharge_cfs", "qual_code")
  #--------------------------------------------------------------------------
  if (service.type == "iv") {
    gage.df <- gage.df %>% 
      dplyr::mutate(dateTime = as.POSIXct(dateTime, format = "%Y-%m-%dT%H:%M"),
                    dateTime = as.POSIXct(round(dateTime, units = "hours")),
                    # Subtract 5 hours to convert UTC to EST.
                    dateTime = dateTime - lubridate::hours(5),
                    tz_cd = "EST") %>% 
      dplyr::filter(dateTime >= start.date,
                    dateTime <= end.date)
  }
  #--------------------------------------------------------------------------
  final.df <- gage.df %>% 
    rename(agency = agency_cd,
           site = site_no, 
           timezone = tz_cd) %>% 
    group_by(agency, site, dateTime) %>% 
    summarize(flow = mean(discharge_cfs)) %>% 
    ungroup(dateTime) %>%
    mutate(site = name.string) %>% 
    rename(date_time = dateTime)
  #----------------------------------------------------------------------------
  return(final.df)
}
#------------------------------------------------------------------------------
isolate_retrieve_flow <- function(gages = NULL, start.date = "1950-10-30",
                       end.date = Sys.Date(), service.type = "iv",
                       site.table){
  shiny::isolate(retrieve_flow(gages, start.date,
                               end.date, service.type, site.table))
  
}
#------------------------------------------------------------------------------
pull_flow <- function(gages = NULL, start.date = "1950-10-30",
                      end.date = Sys.Date(), service.type = "iv",
                      shiny = FALSE, n.cores = NULL){
  if (!service.type %in% c("iv", "dv")) stop("service.type must be 'iv' (instantaneous) or 'dv' (daily values).")
  file.dir <- file.path("www/potomac_gages.csv")
  site.df <- data.table::fread(file.dir, data.table = FALSE,
                               colClasses = list(character = c("site_no"))) %>% 
    mutate(site_no = paste0("0", site_no))
  #----------------------------------------------------------------------------
  if(!is.null(gages)) site.df <- dplyr::filter(site.df, code %in% gages)
  #----------------------------------------------------------------------------
  site.vec <- site.df$site_no
  #----------------------------------------------------------------------------
  library(parallel)
  if (is.null(n.cores)) n.cores <- detectCores() - 1
  cl <- makeCluster(n.cores)
  on.exit(stopCluster(cl))
  clusterExport(cl = cl,
                varlist = c("site.df", "site.vec", "retrieve_flow", "isolate_retrieve_flow"),
                envir = environment())
  clusterEvalQ(cl, c(library(dplyr), library(dataRetrieval)))
  #----------------------------------------------------------------------------
  # This loop sequences through each site and imports new data.
  # The last input date in the COOP database table is used as the startDate input
  # for the readNWISdata function.  Any duplicated rows are then removed and the
  # new table overwrites the old table in the COOP database.
  # This method should ensure that no data is excluded from the table because
  # any disruption in the daily import schedual will allow the script to pick up
  # from the last import date.
  if (shiny == FALSE) {
    flow.list  <- parLapply(cl, site.vec, function(site.i) {
      retrieve_flow(site.i, start.date, end.date, service.type, site.df)
    })
  } else {
    flow.list  <- parLapply(cl, site.vec, function(site.i) {
      isolate_retrieve_flow(site.i, start.date, end.date, service.type, site.df)
    })
  }

  
  #------------------------------------------------------------------------------
  final.df <- bind_rows(flow.list)
  #------------------------------------------------------------------------------
  return(final.df)
}
