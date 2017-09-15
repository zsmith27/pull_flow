drupal_plots <- function(data.df, start.date, end.date,
                       min.flow, max.flow = NA,
                       gages.checked,
                       labels.vec = NULL, linesize.vec = NULL,
                       linetype.vec = NULL, color.vec = NULL,
                       x.class,
                       x.lab = "Date", y.lab = "Value") {
  #--------------------------------------------------------------------------
  start.date <- as.Date(start.date)
  end.date <- as.Date(end.date)
  if (x.class == "datetime") {
    start.date <- start.date  %>% 
      paste("00:00:00") %>% 
      as.POSIXct()
    end.date <- end.date  %>% 
      paste("00:00:00") %>% 
      as.POSIXct()
  }
  #----------------------------------------------------------------------------
  #  if (start.date > end.date) return(NULL)
  #  if (max(hourly.df$date_time) < start.date - lubridate::days(3)) {
  #    start.date <- max(hourly.df$date_time) - lubridate::days(3)
  #  }
  validate(
    need(length(gages.checked) != 0,
         "No variables selected. Please check at least one checkbox.")
  )
  #----------------------------------------------------------------------------
  if (is.null(data.df)) {
    sub.df <- NULL
  } else {
    sub.df <- data.df %>% 
      dplyr::filter(unique_id %in% gages.checked,
                    today >= start.date - lubridate::days(3) &
                      today <= end.date + lubridate::days(1))
  }
  #----------------------------------------------------------------------------
  validate(
    need(nrow(sub.df) != 0,
         "No data available for the selected date range. Please select a new date range.")
    
  )
  #----------------------------------------------------------------------------
  gage.vec <- unique(sub.df$unique_id)
  if (is.null(labels.vec)) labels.vec <- gage.vec
  #----------------------------------------------------------------------------
  sub.df <- sub.df %>% 
    dplyr::mutate(today = as.POSIXct(today))
  #----------------------------------------------------------------------------
  # plot flows
  final.plot <- ggplot(sub.df, aes(x = today, y = value,
                                   color = unique_id,
                                   linetype = unique_id,
                                   size = unique_id)) + 
    geom_line() +
    theme_minimal() +
    xlab(x.lab) +
    ylab(y.lab) +
    theme(legend.title = element_blank(),
          legend.text = element_text(size = 15),
          axis.text = element_text(size = 15),
          axis.title = element_text(size = 15))
  if (is.null(labels.vec)) labels.vec <- unique(sub.df$unique_id)
  #----------------------------------------------------------------------------
  if (!is.null(linesize.vec)) {
    final.plot <- final.plot + scale_size_manual(name = "type",
                                                 labels = labels.vec,
                                                 values = linesize.vec)
  } else {
    final.plot <- final.plot + scale_size_manual(name = "type",
                                                 labels = labels.vec,
                                                 values = rep(2, length(labels.vec)))
  }
  #----------------------------------------------------------------------------
  if (!is.null(linetype.vec)) {
    final.plot <- final.plot + scale_linetype_manual(name = "type",
                                                     labels = labels.vec,
                                                     values = linetype.vec)
  } else {
    final.plot <- final.plot + scale_linetype_manual(name = "type",
                                                     labels = labels.vec,
                                                     values = rep("solid", length(labels.vec)))
  } 
  #----------------------------------------------------------------------------
  if (!is.null(color.vec)) {
    final.plot <- final.plot + scale_colour_manual(name = "type",
                                                   labels = labels.vec,
                                                   values = color.vec)
  } else {
    final.plot <- final.plot + scale_colour_discrete(name = "type",
                                                     labels = labels.vec)
  }
  #----------------------------------------------------------------------------
  if (is.na(min.flow)) min.flow <- min(sub.df$value, na.rm = TRUE)
  if (is.na(max.flow)) max.flow <- max(sub.df$value, na.rm = TRUE)
  
  final.plot <- final.plot +
    coord_cartesian(xlim = c(as.POSIXct(start.date), as.POSIXct(end.date)),
                    ylim = c(min.flow, max.flow),
                    expand = FALSE)
  
  #----------------------------------------------------------------------------
  return(final.plot)
}


