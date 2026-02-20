# Various functions needed across project

# The following extracts the time series objcet from the XML file provided by the ENTSOE Transparency Platform
# Requires input URL including personal security token

# You can either pass a file name or a URL - disable link argument if you wish to read a regular or local xml file.
pull_ts <- function(file, end_date, link = TRUE){
  content_example = file
  if(link){
    response_example = httr::GET(file)
    content_example <- httr::content(response_example, encoding = "UTF-8")
  }
  content_list_example <- xml2::as_list(content_example)
  if ("Acknowledgement_MarketDocument" %in% names(content_list_example)) {
    reason <- content_list_example$Acknowledgement_MarketDocument$Reason$text[[1]]
    warning("ENTSO-E error: ", reason)
    return(tibble(t = numeric(), value = numeric(), date_exact = as.POSIXct(NA), date = as.POSIXct(NA)))
  }
  
  # Checking that it only returns one time series
  doc <- content_list_example$Publication_MarketDocument
  ts_nodes <- doc[names(doc) == "TimeSeries"]
  stopifnot("Multiple TimeSeries nodes returned — inspect response before proceeding" = length(ts_nodes) == 1)
  
  timeseries_example <- content_list_example$Publication_MarketDocument$TimeSeries 
  quants = timeseries_example$Period %>% unlist %>% .[names(.) == "Point.quantity"] %>% as.numeric(.)
  t = timeseries_example$Period %>% unlist %>% .[names(.) == "Point.position"] %>% as.numeric(.)
  interval = timeseries_example$Period %>% unlist %>% .[names(.) == "resolution"] %>% gsub("[^0-9]", "", .) %>% as.numeric
  t_start = timeseries_example$Period %>% unlist %>% .[names(.) == "timeInterval.start"] %>% ymd_hm(.)
  t_end = timeseries_example$Period %>% unlist %>% .[names(.) == "timeInterval.end"] %>% ymd_hm(.)
  
  test <- tibble(t = t, value = quants) %>% 
    mutate(date_exact = t_start + (minutes(interval)*t), 
           date = floor_date(date_exact, unit = "hour"))
  
  assert_that(test %>% slice(nrow(test)) %>% pull(date_exact) %>% identical(t_end))
  return(test)
}

