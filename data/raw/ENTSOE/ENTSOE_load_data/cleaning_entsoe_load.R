#### CLEANING ENTSO-E Load Data ##
# https://www.entsoe.eu/data/power-stats/ - "Monthly Hourly Load Values"

library(here)
library(tidyverse)
library(readxl)
library(assertthat)
library(janitor)
library(lubridate)

full_df <- tibble()

#### 2019-2024
for(yr in 2019:2024){
  temp <- read_xlsx(here(paste0("data/raw/ENTSOE/ENTSOE_load_data/monthly_hourly_load_values_", yr, ".xlsx")))
  
  assert_that(n_distinct(temp$MeasureItem) == 1)
  assert_that(n_distinct(temp$Cov_ratio) == 1)
  
  full_df <- temp %>% 
    select(DateUTC, CountryCode, Value_ScaleTo100, Cov_ratio) %>% 
    clean_names %>% 
    rbind(full_df, .)
  
}

#### 2015-2018
### NOTE THAT COVERAGE RATIO IS NOT 100 for all observations in this (6% of observations have 98covratio) - Solved: ScaleTo100 corrects this!
# Sheet one includes data from 2015-2017
temp <- read_xlsx(here("data/raw/ENTSOE/ENTSOE_load_data/MHLV_data-2015-2019.xlsx"), sheet = 1)

assert_that(n_distinct(temp$MeasureItem) == 1)

full_df <- temp %>% 
  select(DateUTC, CountryCode, Value_ScaleTo100, Cov_ratio) %>% 
  clean_names %>% 
  rbind(full_df, .)

# Sheet 2 includes data from 2018
temp <- read_xlsx(here("data/raw/ENTSOE/ENTSOE_load_data/MHLV_data-2015-2019.xlsx"), sheet = 2)

assert_that(n_distinct(temp$MeasureItem) == 1)

full_df <- temp %>% 
  select(DateUTC, CountryCode, Value_ScaleTo100, Cov_ratio) %>% 
  clean_names %>% 
  rbind(full_df, .)


#### 2006-2015
full_df <- read_xlsx(here("data/raw/ENTSOE/ENTSOE_load_data/Monthly-hourly-load-values_2006-2015.xlsx"), skip = 3) %>% 
  pivot_longer(!c(Country, Year, Month, Day, `Coverage ratio`), names_to = "Hour") %>% 
  rename(cov_ratio = `Coverage ratio`, 
         country_code = Country) %>% 
  mutate(value_scale_to100 = value/(cov_ratio/100),
         date_utc = ymd_h(paste(Year, Month, Day, Hour, sep = "-"))) %>% 
  clean_names %>% 
  select(date_utc, country_code, value_scale_to100, cov_ratio) %>% 
  rbind(full_df, .) %>% 
  arrange(date_utc, country_code)


full_df %>% 
  ggplot() +
  geom_line(aes(x = date_utc, y = value_scale_to100)) +
  facet_wrap(~country_code, scales = "free")

full_df %>%
  rename(load = value_scale_to100) %>%
  saveRDS(here("data/out/entsoe_load_data_consolidated.rds"))
