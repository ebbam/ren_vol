library(here)
library(tidyverse)
library(assertthat)
source(here("code/useful_functions.R"))

# Data downloaded from : https://www.netztransparenz.de/en/Ancillary-Services/System-operations/Redispatch
# From: 01/01/2021
# To: 01/04/2026

# Clue came from Titz et al. 2024, "Identifying drivers and mitigators for congestion and redispatch in the German electric power system with explainable AI", Applied Energy
# https://www.sciencedirect.com/science/article/pii/S0306261923017154#:~:text=In%20Germany%2C%20one%20of%20the%20pioneers%20of,around%202.3%20billion%20Euro%20in%202021%20[18].&text=The%20total%20cost%20of%20all%20congestion%20management,contributed%20approximately%201%20billion%20Euro%20[25]%2C%20cf.

# Alternatively available from ENTSO-E here: https://transparency.entsoe.eu/congestion-management/r2/redispatching-internal/show
# Notes:I considered replacing the dispatching data we had from [netztransparenz.de](http://netztransparenz.de) with that available from ENTSO-E. 
# However, ENTSO-E reports this at the TSO level rather than the aggregated country level, available from netztransparenz.de
# Rationale: netztransparenz aggregates reporting from all four German TSOs (50Hertz, Amprion, TenneT DE, TransnetBW) 
#mand is the statutory reporting platform for German redispatching. ENTSO-E requires separate control area queries per TSO 
# (documentType=A63, businessType=A85) and caps responses at 100 TimeSeries elements, 
# making aggregation more complex with no benefit over the netztransparenz source.

df <- read.csv(here("data/raw/netztransparenz_redispatching_costs/Redispatch_Daten.csv"), sep = ";") %>% 
  tibble %>% 
  mutate(RICHTUNG = gsub("¿",  "ö", RICHTUNG))


### Archived data pre-2021
redisp_archive <- read.csv(here("data/raw/netztransparenz_redispatching_costs/2025-09-17 Redispatch Export 2013-2020.csv"), row.names = NULL, sep = ";") %>% 
  tibble

stopifnot(identical(names(redisp_archive), names(df)))
stopifnot(identical(sort(unique(df$RICHTUNG)), sort(unique(redisp_archive$RICHTUNG))))


df_cleaned <- df %>%
  rbind(redisp_archive) %>%
  select(-c(ZEITZONE_VON, ZEITZONE_BIS)) %>%
  rename(
    start_date           = BEGINN_DATUM,
    start_hour           = BEGINN_UHRZEIT,
    end_date             = ENDE_DATUM,
    end_hour             = ENDE_UHRZEIT,
    redispatch_reason    = GRUND_DER_MASSNAHME,
    redispatch_direction = RICHTUNG,
    avg_performance_mw   = MITTLERE_LEISTUNG_MW,
    max_performance_mw   = MAXIMALE_LEISTUNG_MW,
    work_mwh             = GESAMTE_ARBEIT_MWH,
    # !!! Not sure about this translation
    instructor____       = ANWEISENDER_UENB,
    # !!! Not sure about this translation
    regulator____        = ANFORDERNDER_UENB,
    affected_system      = BETROFFENE_ANLAGE,
    primary_energy_type  = PRIMAERENERGIEART
  ) %>%
  mutate(
    start = dmy_hm(paste0(start_date, start_hour)),
    end   = dmy_hm(paste0(end_date, end_hour)),
    across(c(avg_performance_mw, max_performance_mw, work_mwh), as.numeric),
    primary_energy_type = case_when(
      primary_energy_type == ""           ~ NA_character_,
      primary_energy_type == "Erneuerbar"    ~ "Renewable",
      primary_energy_type == "Konventionell" ~ "Conventional",
      primary_energy_type == "Sonstiges"     ~ "Miscellaneous",
      TRUE ~ NA_character_
    ),
    redispatch_direction = case_when(
      grepl("reduzieren", redispatch_direction) ~ "Reduce",
      grepl("erhöhen",    redispatch_direction) ~ "Increase",
      TRUE ~ NA_character_
    )
  ) %>%
  # Expand each event across its full duration in 15-min intervals
  mutate(quarter_hour = map2(start, end, ~seq(.x, .y - minutes(15), by = "15 mins"))) %>%
  unnest(quarter_hour) %>%
  # Now aggregate by period - sum of active MW at each quarter-hour
  group_by(quarter_hour, primary_energy_type, redispatch_direction) %>%
  summarise(
    active_mw = sum(avg_performance_mw, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  # Convert instantaneous MW to MWh for the quarter-hour period
  mutate(active_mwh = active_mw * 0.25)

#saveRDS(df_cleaned, here("data/raw/netztransparenz_redispatching_costs/prelim_redispatching_costs.RDS")) 


p1 <- df_cleaned %>% 
  ggplot(aes(x = date, y = mean_work_mwh, color = primary_energy_type)) + 
  geom_line() +
  facet_wrap(~primary_energy_type) +
  theme_minimal() +
  labs(x = "Date", y = "Redispatching Work (mwh)", title = "Average By Energy Type") +
  theme(legend.position = "none")+
  scale_color_brewer(palette = "Set2", na.value = "grey50")


p2 <- df_cleaned %>% 
  ggplot(aes(x = date, y = total_work_mwh, color = primary_energy_type)) + 
  geom_line() +
  facet_wrap(~primary_energy_type) +
  theme_minimal() +
  labs(x = "Date", y = "Redispatching Work (mwh)", title = "Total Sum By Energy Type") +
  theme(legend.position = "none") +
  scale_color_brewer(palette = "Set2", na.value = "grey50")

p1 + p2

plots <- list()
for(unit in c("day", "week", "month", "year")){
  if(unit == "year"){
    pos = "bottom"
  }else{pos = "none"}
  plots[[unit]] <- df_cleaned %>%
    mutate(day = floor_date(date, unit = unit)) %>% 
    group_by(day, primary_energy_type) %>% 
    summarise(total_work_mwh = sum(total_work_mwh, na.rm = TRUE)) %>% 
    ggplot(aes(x = day, y = total_work_mwh, fill = primary_energy_type)) +
    geom_area(position = "stack") +
    theme_minimal() +
    labs(
      x = "Date",
      y = "Redispatching Work (MWh)",
      title = toupper(unit),
      fill = "Primary Energy Type"
    ) +
    theme(legend.position = pos) +
    scale_fill_brewer(palette = "Set2", na.value = "grey50")
}

grid.arrange(grobs = plots, top = "Total Redispatching Work by Primary Energy Type (Summarised for various intervals)")

redisp_df <- redisp %>% 
  group_by(date) %>% 
  summarise(total_work_mwh = sum(total_work_mwh, na.rm = TRUE)) %>% 
  ungroup %>% 
  rename(date_utc = date,
         redisp_work_mwh = total_work_mwh)

redisp_df %>% 
  ggplot(aes(x = date_utc, y = redisp_work_mwh)) +
  geom_line() +
  theme_minimal() +
  labs(
    x = "Date",
    y = "Redispatching Work (MWh)",
    title = "Redispatching Work (MWh) Total Across All Energy Types"
  )


