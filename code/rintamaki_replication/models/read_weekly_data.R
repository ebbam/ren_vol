# Read data for the weekly models

# read data for DK1
data <- read.table(here("code/rintamaki_replication/data/dk1_weekly.txt"), header=TRUE)
dates_dk1 <- data$week # week numbers. This vector can be used for plotting
vol_dk1 <- data$dk1_price_vol # logarithm of DK1 weekly price volatility
load_dk1 <- data$dk1_load # logarithm of average weekly DK1 load forecast
wind_dk1 <- data$dk1_wind # logarithm of average weekly DK1 wind power forecast
wind_std_dk1 <- data$dk1_wind_vol # logarithm of the standard deviation of DK1 daily wind power forecasts over a week
wind_pen_dk1 <- data$dk1_pen # logarithm of average weekly DK1 wind power penetration forecast
exim_dk1 <- data$dk1_exim # logarithm of average weekly DK1 exports/imports in the spot market
gas_dk1 <- data$dk1_gas # logarithm of average weekly NCG gas prices

# read data for DK2
data <- read.table(here("code/rintamaki_replication/data/dk2_weekly.txt"), header=TRUE)
dates_dk2 <- data$week # week numbers
vol_dk2 <- data$dk2_price_vol # logarithm of DK2 weekly price volatility
load_dk2 <- data$dk2_load # logarithm of average weekly DK2 load forecast
wind_dk2 <- data$dk2_wind # logarithm of average weekly DK2 wind power forecast
wind_std_dk2 <- data$dk2_wind_vol # logarithm of the standard deviation of DK2 daily wind power forecasts over a week
wind_pen_dk2 <- data$dk2_pen # logarithm of average weekly DK2 wind power penetration forecast
exim_dk2 <- data$dk2_exim # logarithm of average weekly DK2 exports/imports in the spot market
gas_dk2 <- data$dk2_gas # logarithm of average weekly NCG gas prices

# read data for DE
data <- read.table(here("code/rintamaki_replication/data/de_weekly.txt"), header=TRUE)
dates_de <- data$week # week numbers
vol_de <- data$de_price_vol # logarithm of DE weekly price volatility
load_de <- data$de_load # logarithm of average weekly DE load forecast
wind_de <- data$de_wind # logarithm of average weekly DE wind power forecast
wind_std_de <- data$de_wind_vol # logarithm of the standard deviation of DE daily wind power forecasts over a week
wind_pen_de <- data$de_wind_pen # logarithm of average weekly DE wind power penetration forecast
solar_de <- data$de_solar # logarithm of average weekly DE solar power forecast
solar_pen_de <- data$de_solar_pen # logarithm of average weekly DE solar power penetration forecast
res_de <- data$de_res # logarithm of average weekly DE renewable generation forecast (wind+solar power)
res_std_de <- data$de_res_vol # logarithm of the standard deviation of DE daily renewable generation forecasts over a week
res_pen_de <- data$de_res_pen # logarithm of average weekly DE renewable generation penetration forecast
exim_de <- data$de_exim # logarithm of average weekly DE exports/imports in the spot market
gas_de <- data$de_gas # logarithm of average weekly NCG gas prices