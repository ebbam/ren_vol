# ENTSOE Generation Forecast solar wind
# Transparency Platform Restful API / Generation / 14.1.D Generation Forecasts for Wind and Solar
library(here)
library(tidyverse)
library(lubridate)
library(xml2)
library(XML)
library(assertthat)
source(here("code/useful_functions.R"))

full_df <- tibble()
for(i in 15:24){
  print(i)
  file <- read_xml(here(
    paste0("data/raw/ENTSOE/generation_forecasts_solar_wind/response_gen_fcast_solar_wind_", 
           as.character(i), "_", 
           as.character(i + 1), ".xml")))
  
  all_divs <- xml_find_all(file, "//d1:TimeSeries", xml_ns(file))
  
  #bus_type <- list() # 2 types - A93 and A94
  #obj_agg <- list() # 1 type - A08
  #curve <- list() # 1 type - A01 - day-ahead
  #psrtype <- list() # 3 types - B16, B18, B19 - solar, offshore wind, onshore wind
  #date <- list()

  for(k in all_divs){
    timeseries_example <- k %>% xml2::as_list(.) %>% unlist
    temp_df = tibble(
      quants = timeseries_example %>% .[names(.) == "Period.Point.quantity"] %>% as.numeric(),
      t = timeseries_example %>% .[names(.) == "Period.Point.position"] %>% as.numeric(),
      interval = timeseries_example %>% .[names(.) == "Period.resolution"] %>% gsub("[^0-9]", "", .) %>% as.numeric(),
      t_start = timeseries_example %>% .[names(.) == "Period.timeInterval.start"] %>% ymd_hm(.),
      t_end = timeseries_example %>% .[names(.) == "Period.timeInterval.end"] %>% ymd_hm(.),
      tech = timeseries_example %>% .[names(.) == "MktPSRType.psrType"] %>% as.character(),
      bus_type = timeseries_example %>% .[names(.) == "businessType"] %>% as.character(),
      obj_agg = timeseries_example %>% .[names(.) == "objectAggregation"] %>% as.character(),
      curve = timeseries_example %>% .[names(.) == "curveType"] %>% as.character()  
    ) %>% 
      mutate(date_exact = t_start + (minutes(interval)*t), 
                 date = floor_date(date_exact, unit = "hour")) 
    full_df <- rbind(full_df, temp_df)
  }
}
  
consol_df <- full_df %>% 
  arrange(date_exact) %>% 
  group_by(date_exact, date, tech, bus_type, obj_agg, curve) %>% 
  summarise(quants = max(quants))

consol_df %>% 
  group_by(date_exact, tech) %>% 
  n_groups() == nrow(consol_df)

test <- consol_df %>% 
  group_by(date, tech) %>% 
  summarise(quants = mean(quants, na.rm = TRUE)) %>% 
  mutate(tech_code = tech, 
         tech = case_when(tech_code == "B16" ~ "fcast_solar",
                          tech_code == "B18" ~'fcast_wind_offshore',
                          tech_code == "B19" ~ "fcast_wind_onshore")) %>% 
  pivot_wider(id_cols = c(date), names_from = tech, values_from = quants) %>% 
  ungroup

test %>% saveRDS(here("data/raw/ENTSOE/generation_forecasts_solar_wind/de_forecasts_solar_wind_consolidated.RDS"))
