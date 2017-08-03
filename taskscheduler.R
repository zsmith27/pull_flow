library(taskscheduleR)
myscript <- "C:/Users/Owner/Desktop/ICPRB/COOP/pull_flow/hourly_pull.R"

## Run every minute, giving some command line arguments
taskscheduler_create(taskname = "myfancyscript", rscript = myscript,
                     schedule = "ONCE", starttime = format(Sys.time() + 120, "%H:%M"))
taskscheduler_delete(taskname = "myfancyscript")
