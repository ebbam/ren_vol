library(here)
library(tidyverse)
library(assertthat)
source(here("code/useful_functions.R"))

# Data downloaded from : https://www.netztransparenz.de/en/Ancillary-Services/System-operations/Redispatch
# From: 31/12/2025
# To: 03/06/2025

# Clue came from Titz et al. 2024, "Identifying drivers and mitigators for congestion and redispatch in the German electric power system with explainable AI", Applied Energy
# https://www.sciencedirect.com/science/article/pii/S0306261923017154#:~:text=In%20Germany%2C%20one%20of%20the%20pioneers%20of,around%202.3%20billion%20Euro%20in%202021%20[18].&text=The%20total%20cost%20of%20all%20congestion%20management,contributed%20approximately%201%20billion%20Euro%20[25]%2C%20cf.

# Alternatively available from ENTSO-E here: https://transparency.entsoe.eu/congestion-management/r2/redispatching-internal/show
df <- read.csv(here("data/raw/netztransparenz_redispatching_costs/Redispatch_Daten.csv"), sep = ";") %>% 
  tibble

df_cleaned <- df %>% 
  mutate(date = dmy_hm(paste0(BEGINN_DATUM, BEGINN_UHRZEIT))) %>% 
  #summarise(across(everything(), ~n_distinct(.)))
  # Removing columsn that only have one unique value
  select(-c(ZEITZONE_VON, ZEITZONE_BIS)) %>% 
  rename(start_date = BEGINN_DATUM,
    start_hour = BEGINN_UHRZEIT,
    end_date = ENDE_DATUM, 
    end_hour = ENDE_UHRZEIT,
    redispatch_reason = GRUND_DER_MASSNAHME,
    redispatch_direction = RICHTUNG,
    avg_performance_mw = MITTLERE_LEISTUNG_MW,
    max_performance_mw = MAXIMALE_LEISTUNG_MW,
    work_mwh = GESAMTE_ARBEIT_MWH,
    # !!! Not sure about this translation
    instructor____ = ANWEISENDER_UENB,
    # !!! Not sure about this translation
    regulator____ = ANFORDERNDER_UENB,
    affected_system = BETROFFENE_ANLAGE,
    primary_energy_type = PRIMAERENERGIEART) %>% 
  mutate(across(c(avg_performance_mw, max_performance_mw, work_mwh), ~as.numeric(.)),
         primary_energy_type = case_when(primary_energy_type == "" ~ NA,
                   primary_energy_type == "Erneuerbar" ~"Renewable",
                   primary_energy_type == "Konventionell" ~ "Conventional",
                   primary_energy_type == "Sonstiges" ~ "Miscellaneous")) %>% 
  group_by(date, primary_energy_type) %>% 
  summarise(across(c(avg_performance_mw, max_performance_mw, work_mwh), 
                   list(mean = ~mean(as.numeric(.), na.rm = TRUE),
                        total = ~sum(as.numeric(.), na.rm = TRUE)),
                   .names = "{fn}_{.col}")) %>% 
  ungroup() 

#saveRDS(df_cleaned, here("data/raw/netztransparenz_redispatching_costs/prelim_redispatching_costs.RDS"))
