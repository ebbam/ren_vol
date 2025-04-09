### ENTSOE Cross-Border Physical Flows
library(here)
library(tidyverse)
library(lubridate)
library(xml2)
library(XML)
library(assertthat)
source(here("code/useful_functions.R"))

country_codes <- read.csv(here("data/raw/ENTSOE/Y_eicCodes.csv"), sep = ";") %>% tibble

# Germany imports from the following countries
importing_countries <- c("Austria",
                        "Belgium",
                        "Czech Republic",
                        "Denmark",
                        "France",
                        "Luxembourg",
                        "Netherlands",
                        "Norway",
                        "Poland",
                        "Sweden",
                        "Switzerland")

for(cty in importing_countries){
  print(cty)
  labs <- country_codes %>% 
    filter(EicLongName == cty) %>% 
    select(1:3)
  
  suffix = labs$EicDisplayName
  code = labs$EicCode

  temp_imports_df <- tibble()
  temp_exports_df <- tibble()
  for(i in 15:24){
    print(i)
    url_imports <- paste0("https://web-api.tp.entsoe.eu/api?documentType=A11&out_Domain=",
                  code, 
                  "&in_Domain=10Y1001A1001A83F&periodStart=20", 
                  as.character(i),
                  "01010000&periodEnd=20", 
                  as.character(i+1), 
                  "01010000&securityToken=9daaa5fa-b997-44fb-8bb3-b9138adc6412")

    temp_imp <- pull_ts(url_imports) %>% 
      group_by(date) %>% 
      summarise(value = mean(value, na.rm = TRUE)) %>% 
      rename_with(~paste0("imports_", suffix), value) 
    
    temp_imports_df <- rbind(temp_imports_df, temp_imp)
    
    url_exports <- paste0("https://web-api.tp.entsoe.eu/api?documentType=A11&out_Domain=10Y1001A1001A83F&in_Domain=",
                          code,
                          "&periodStart=20",
                          as.character(i),
                          "01010000&periodEnd=20",
                          as.character(i+1),
                          "01010000&securityToken=9daaa5fa-b997-44fb-8bb3-b9138adc6412")
    
    temp_exp <- pull_ts(url_exports) %>%
      group_by(date) %>%
      summarise(value = mean(value, na.rm = TRUE)) %>%
      rename_with(~paste0("exports_", suffix), value)
    
    temp_exports_df <- rbind(temp_exports_df, temp_exp)
  }
  assign(paste0("imports_df_", suffix), temp_imports_df)
  assign(paste0("exports_df_", suffix), temp_exports_df)
}

abbrevs <- country_codes %>% 
  filter(EicLongName %in% importing_countries) %>% 
  arrange(EicLongName, importing_countries) %>% 
  pull(EicDisplayName) %>% unique %>% paste0()

full_imports_df <- imports_df_AT %>% 
  group_by(date) %>% 
  summarise(imports_AT = max(imports_AT)) %>% 
  ungroup

full_exports_df <- exports_df_AT %>% 
  group_by(date) %>% 
  summarise(exports_AT = max(exports_AT)) %>% 
  ungroup

for(k in abbrevs[abbrevs != "AT"]){
  print(k)
  full_imports_df <- get(paste0("imports_df_", k)) %>% 
    group_by(date) %>% 
    summarise(value = max(get(paste0("imports_", k)))) %>% 
    rename_with(~paste0("imports_", k), value) %>% 
    full_join(full_imports_df, by = "date")
  
  full_exports_df <- get(paste0("exports_df_", k)) %>% 
    group_by(date) %>% 
    summarise(value = max(get(paste0("exports_", k)))) %>% 
    rename_with(~paste0("exports_", k), value) %>% 
    full_join(full_exports_df, by = "date")
}

exp_imp <- full_imports_df %>% 
  full_join(full_exports_df, by = "date") %>% 
  mutate(across(starts_with("imports"), 
                ~ . - get(gsub("imports", "exports", cur_column())), 
                .names = "net_{.col}")) 
# exp_imp %>% 
#   saveRDS(here("data/raw/ENTSOE/imports_exports_DE/imports_exports_DE.RDS"))
identical(exp_imp, readRDS(here("data/raw/ENTSOE/imports_exports_DE/imports_exports_DE.RDS")))
all.equal(exp_imp, readRDS(here("data/raw/ENTSOE/imports_exports_DE/imports_exports_DE.RDS")))

exp_imp %>% 
  select(date, starts_with('net_imports')) %>% 
  pivot_longer(!date) %>% 
  ggplot() + 
  geom_line(aes(x = date, y = value, color = name)) +
  theme(legend.position = "bottom")
