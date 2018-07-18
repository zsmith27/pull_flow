library(dataRetrieval)
library(tidyverse)
#------------------------------------------------------------------------------
gages.df <- data.table::fread("misc/potomac_usgs_gages.csv") %>% 
  mutate(gage = paste0("0", gage))
gages.vec <- unique(gages.df$gage)
#------------------------------------------------------------------------------
counts.list <- lapply(gages.vec, function(gage.i) {
  to.print <- paste(which(gages.vec %in% gage.i), "/", length(gages.vec))
  print(to.print)
  whatNWISdata(siteNumber = gage.i) %>% 
    mutate(alt_acy_va = as.character(alt_acy_va))
})
#------------------------------------------------------------------------------
counts.df <- bind_rows(counts.list) %>% 
  rename(parameter_cd = parm_cd)
#------------------------------------------------------------------------------
param.df <- parameterCdFile
join.df <- left_join(counts.df, param.df, by = "parameter_cd")
unique.params <- join.df %>% 
  select(parameter_cd, parameter_nm) %>% 
  distinct()
data.table::fwrite(unique.params, "C:/Users/zsmith/Desktop/usgs_params.csv")
#------------------------------------------------------------------------------
keep.df <- data.table::fread("misc/usgs_params_1_keep.csv") %>% 
  mutate(parameter_cd = as.character(parameter_cd))
#------------------------------------------------------------------------------
final.df <- left_join(join.df, keep.df, by = c("parameter_cd", "parameter_nm")) %>% 
  filter(keep %in% "Y")
#------------------------------------------------------------------------------
data.table::fwrite(final.df, "C:/Users/zsmith/Desktop/usgs_params_summary.csv")
