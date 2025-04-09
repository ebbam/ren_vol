### ENTSOE Actual Generation per Production Type
library(here)
library(tidyverse)
library(lubridate)

full_df_de <- tibble()
for(i in 2015:2025){
  filepath <- here(paste0('data/raw/ENTSOE/generation_per_prod_type_DE/Actual Generation per Production Type_', as.character(i), '01010000-', as.character(i+1), '01010000.csv'))
  temp <- read_csv(filepath, 
                     col_types = c("c", "c", rep( "d", 22))) %>% 
    clean_names
  
  full_df_de <- temp %>% 
    mutate(across(!c(area, mtu), ~as.numeric(.))) %>% 
    separate(mtu, into = c("date", "hour"), sep = " ", extra = "drop") %>% 
    mutate(hour = paste0(substr(hour, 1, 3),"00")) %>% 
    group_by(date, hour) %>% 
    # sum hourly generation
    summarise(across(where(is.numeric), list(mean = ~mean(., na.rm = TRUE), sum = ~sum(., na.rm = TRUE)), .names = "{.fn}_{.col}")) %>% 
    ungroup %>% 
    rbind(full_df_de, .)
  
}

full_df_de %>% 
  mutate(date_utc = dmy_hm(as.character(paste(date, hour)))) %>% 
  relocate(date_utc) %>% 
  saveRDS(., here('data/raw/ENTSOE/generation_per_prod_type_DE/de_generation_consolidated.rds'))
