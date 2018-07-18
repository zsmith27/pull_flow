library(dataRetrieval)
library(tidyverse)
#------------------------------------------------------------------------------
gages.vec <- c("394352077134801", "394430077225001", "394449077114101",
               "394600077161601", "394740077171801", "394755077215501",
               "394806077150901", "394813077245401", "394836077204301",
               "394856077082801", "394901077173601", "395004077153201",
               "395008077125401", "395052077212601", "395055077100401",
               "395230077183201", "395555077114401", "395644077204701",
               "395700077073901", "395846077040601", "395931077074501")
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
#------------------------------------------------------------------------------
join.df <- left_join(counts.df, param.df, by = "parameter_cd")
#------------------------------------------------------------------------------
unique.params <- join.df %>% 
  select(parameter_cd, parameter_nm) %>% 
  distinct()
#------------------------------------------------------------------------------
site.i <- gages.vec[2]
final.df <- lapply(gages.vec, function(site.i) {
    dataRetrieval::readNWISdata(service = "gwlevels",
                                site = site.i,
                                startDate = "1900-01-01",
                                endDate = Sys.Date(),
                                asDateTime = FALSE,
                                tz = "America/New_York",
                                # Dischrage Code.
                                parameterCd = "72019")
}) %>% 
  bind_rows()
#------------------------------------------------------------------------------
data.table::fwrite(final.df, "C:/Users/zsmith/Desktop/groundwater_12_13_17.csv")

#------------------------------------------------------------------------------


#------------------------------------------------------------------------------


