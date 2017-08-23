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
# Load the dataRetrieval package created to pull USGS and EPA data into R.
library(dataRetrieval)
library(dplyr)
#==============================================================================
source("functions/pull_flow_func.R")
#------------------------------------------------------------------------------
system.time(
hourly.df <- pull_flow(gages = NULL,
                       start.date = "1900-01-01",
                       service.type = "iv")
)
#------------------------------------------------------------------------------
hourly.dir <- file.path("H:/Projects/COOP Data/flows/usgs/hourly", "hourly_flows.csv")
data.table::fwrite(hourly.df, hourly.dir)
#------------------------------------------------------------------------------
system.time(
daily.df <- pull_flow(gages = NULL,
                      #start.date = "1850-01-01",
                      start.date = "2017-01-01",
                      service.type = "dv")
)
#------------------------------------------------------------------------------
daily.dir <- file.path("H:/Projects/COOP Data/flows/usgs/daily", "daily_flows.csv")
data.table::fwrite(daily.df, daily.dir)
#------------------------------------------------------------------------------
