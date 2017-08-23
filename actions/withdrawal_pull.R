#==============================================================================
# Author: Zachary M. Smith
# Maintained: Zachary M. Smith
# Created: 08-22-2017
# Updated: 08-22-2017
# Purpose: The script was written to pull withdrawal data from the COOP 
#          drupal website.
#==============================================================================
#==============================================================================
library(tidyverse)
#==============================================================================
source("functions/pull_withdrawals_func.R")
#------------------------------------------------------------------------------
system.time(
  withdrawals.df <- pull_withdrawals("1950-10-30", Sys.Date())
)
#------------------------------------------------------------------------------
file.dir <- file.path("H:/Projects/COOP Data/flows/withdrawals", "withdrawals.csv")

data.table::fwrite(withdrawals.df, file.dir)
