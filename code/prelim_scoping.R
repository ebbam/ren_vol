library(tidyverse)
library(here)
library(janitor)
library(gridExtra)


ppi_cpi <- readxl::read_xlsx(here('data/raw/Energy Prices/CPI_PPI_energy prices_quarterly.xlsx'), skip = 3, n_max = 1928) %>% 
  slice(-1) %>% 
  select(-4) %>% 
  rename(country = Flow, year = 2, quarter = 3, us_exrate = 4, ppi = `Producer price index`, cpi = `Consumer price index`, cpi_energy = `CPI energy`) %>% 
  fill(country, year, .direction = "down") %>% 
  mutate(us_exrate = as.numeric(us_exrate))
 

 
#OECD > IEA > Energy Prices and Taxes > End Use Prices > Wholesale and Retail Price Indices for Energy Products
#International Energy Agency: Energy Prices and Taxes (2022Q3 Edition). UK Data Service. https://doi.org/10.5257/iea/ept/2022Q3
price_inds <- read.csv(here('data/raw/Energy Prices/Wholesale and Retail Price Indices for Energy Products/IEA_EPT_FG_01022024121330973.csv')) %>% tibble

price_inds_annual <- price_inds %>% 
  filter(Frequency == "Annual") %>% 
  select(-c(Flag.Codes, Flags, Frequency, FREQUENCY, INDEX, PRODUCT, LOCATION, TIME)) 
  

price_inds_quart <- price_inds %>% 
  filter(Frequency == "Quarterly") %>% 
  select(-c(Flag.Codes, Flags, Frequency, FREQUENCY, INDEX, PRODUCT, LOCATION)) 

                      
price_inds_annual %>% 
  #pivot_wider(id_cols = c(Country, Product, Time), values_from = Value, names_from = Index) %>% 
  filter(Country == "United States") %>% 
  ggplot() + 
  geom_line(aes(x = Time, y = Value, group = Index, color = Index))+
  facet_wrap(~Product, scales = "free")

p_list <- list()

for(country in c("France", "Germany", "Sweden", "United Kingdom", "United States")){
  p <- price_inds_quart %>% 
      #pivot_wider(id_cols = c(Country, Product, Time), values_from = Value, names_from = Index) %>% 
      filter(Country == country & Product != "Electricity") %>% 
      ggplot() + 
      geom_line(aes(x = Time, y = Value, group = Index, color = Index))+
      facet_wrap(~Product, scales = "free") +
    labs(title = country)
  
  p_list <- append(p_list, list(p))
}

do.call(grid.arrange, p_list)

# Our world in data
# Electricity production by source: https://ourworldindata.org/electricity-mix
test <- read.csv(here('data/raw/electricity-prod-source-stacked.csv')) %>% 
  tibble %>% 
  rename_with(~gsub(".", "_", gsub("...TWh..adapted.for.visualization.of.chart.electricity.prod.source.stacked.", "",.x), fixed = TRUE))
  
  
  test %>% mutate(elec_renewables = sum(Other_renewables_excluding_bioenergy,
                               Electricity_from_bioenergy, Electricity_from_solar,              
                               Electricity_from_wind,Electricity_from_hydro, na.rm = TRUE),
         elec_ff = sum(elec_renewables, Electricity_from_nuclear, na.rm = TRUE),
           elec_low_carbon = sum(Electricity_from_oil, Electricity_from_gas,
                                 Electricity_from_coal, na.rm = TRUE),
         total_elec = elec_renewables + elec_low_carbon,
         across(!c(Entity, Code, Year), ~(.x/total_elec)*100, .names = "{.col}_pct")) %>% 
  select(Entity, Year, contains("pct")) %>% 
  filter(Year == 2022 & Entity == "World") %>% 
  select(Entity, Year, Electricity_from_oil_pct)
  


  