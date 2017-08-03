#==============================================================================
# Author: Zachary M. Smith
# Created: 1-17-2017
# Updated: 1-19-2017
# Maintained: Zachary M. Smith
# Purpose: The script was written to pull information from the Potomac River
#          USGS NWIS gages daily and import the data into a PostgreSQL database.
# URL: https://waterdata.usgs.gov/md/nwis/current/?type=flow&group_key=basin_cd
# Output: Eventually, the script will pull information from the USGS website
# daily and the information will be stored in an PostGreSQL database.
#==============================================================================
#==============================================================================
# Laod the dataRetrieval package created to pull USGS and EPA data into R.
library(dataRetrieval)
# dplyr and RPostgreSQL aid in the communication between R and Postgresql.
library(dplyr)
library(RPostgreSQL)
#==============================================================================
# Import a list of USGS gages for which we want to pull flow data.
#setwd("C:/Users/zsmith/Desktop/COOP/Data_COOP/Site_Info")

#==============================================================================
# Connect to the PostgreSQL database "COOP".
# Connect to the PostgreSQL database "COOP".
#source("db/connect.R")
#==============================================================================
file.dir <- "C:/Users/Owner/Desktop/ICPRB/COOP/pull_flow/data/potomac_gages.csv"
site.df <- data.table::fread(file.dir, data.table = FALSE,
                             colClasses = list(character = c("site_no")))
site.vec <- site.df$site_no
#==============================================================================
library(parallel)
n.cores <- detectCores() - 1
cl <- makeCluster(n.cores)
clusterExport(cl = cl, varlist = c("site.df", "site.vec"))
clusterEvalQ(cl, c(library(dplyr), library(dataRetrieval)))
#==============================================================================
# This loop sequences through each site and imports new data.
# The last input date in the COOP database table is used as the startDate input
# for the readNWISdata function.  Any duplicated rows are then removed and the
# new table overwrites the old table in the COOP database.
# This method should ensure that no data is excluded from the table because
# any disruption in the daily import schedual will allow the script to pick up
# from the last import date.
flow.list  <- parLapply(cl, site.vec, function(site.i) {
  #print(paste(rep("=", 80), collapse = ""))
  #print(paste("Job: ", i,"/", length(site.vec), sep = ""))
  #print(paste("Start:", site.i))
  #--------------------------------------------------------------------------
  # Use this fuction from the dataRetrieval package to pull the latest 
  # dischrage data.
  gage.df <- readNWISdata(service = "iv",
                          site = site.i,
                          #startDate = "1950-10-30",
                          startDate = "2016-01-01",
                          endDate = Sys.Date(),
                          asDateTime = FALSE,
                          #tz = "America/New_York",
                          # Dischrage Code.
                          parameterCd = "00060")
  #--------------------------------------------------------------------------
  name.string <- site.df %>%
    filter(site_no == site.i) %>% 
    pull(code)
  #--------------------------------------------------------------------------
  final.df <- gage.df %>% 
    rename(agency = agency_cd,
           site = site_no, 
           discharge_cfs = X_00060_00000,
           qual_code = X_00060_00000_cd,
           timezone = tz_cd) %>% 
    mutate(dateTime = as.POSIXct(dateTime, format = "%Y-%m-%dT%H:%M"),
           dateTime = as.POSIXct(round(dateTime, units = "hours"))) %>% 
    group_by(agency, site, dateTime, qual_code, timezone) %>% 
    summarize(flow = mean(discharge_cfs)) %>% 
    ungroup(dateTime) %>%
    mutate(site = name.string) %>% 
    #      mutate(dateTime = as.POSIXct(dateTime),
    #             date = format(dateTime, "%Y-%m-%d"),
    #             month = format(dateTime, "%m"),
    #             year = format(dateTime, "%Y"),
    #             time = format(dateTime, "%H:%M"),
    #             date_time = as.POSIXct(dateTime) + 3600) %>% 
    rename(date_time = dateTime)
  #--------------------------------------------------------------------------
  # Export the table to the COOP database and overwrite the old table within
  # the database.
  #dbWriteTable(con, name.string, final.df, overwrite = TRUE , row.names = FALSE)
  #--------------------------------------------------------------------------
  #print(paste("End:", site.i))
  return(final.df)
})
stopCluster(cl)
#------------------------------------------------------------------------------
final.df <- bind_rows(flow.list)
#------------------------------------------------------------------------------
file.name <- file.path("C:/Users/Owner/Desktop/ICPRB/COOP/pull_flow", 
                       paste0("flows", format(Sys.time(), "%H_%M"), ".csv"))
data.table::fwrite(final.df, file.name)
