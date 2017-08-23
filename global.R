
source("functions/pull_flow_func.R", local = TRUE)
source("functions/pull_withdrawals_func.R", local = TRUE)
source("global/load_packages.R", local = TRUE)
source("global/usgs_plot_func.R", local = TRUE)
#------------------------------------------------------------------------------
file.dir <- file.path("www/potomac_gages.csv")
usgs.gages.df <- data.table::fread(file.dir, data.table = FALSE,
                             colClasses = list(character = c("site_no"))) %>% 
  mutate(site_no = paste0("0", site_no))
#------------------------------------------------------------------------------
plot.height <- "340px"
plot.width <- "95%"