# Read data for the daily models

# read data for DK1
data <- read.table(here('code/rintamaki_replication/data/dk1_daily.txt'), header=TRUE) # read the whole data file
dates_dk1 <- data$date # observation dates
dates_dk1 <- as.Date(dates_dk1,"%d/%m/%Y") # format to R dates. These may be used for plotting
vol_dk1 <- data$dk1_price_vol # the logarithm of DK1 daily price volatility. In the paper, we use the letter v to denote volatility
load_dk1 <- data$dk1_load # the logarithm of average daily DK1 load forecast
wind_dk1 <- data$dk1_wind # the logarithm of average daily DK1 wind power forecast
wind_pen_dk1 <- data$dk1_wind_pen # the logarithm of average daily DK1 wind power penetration forecast (wind fcast/load fcast)
exim_op1_dk1 <- data$dk1_op1_exim # average DK1 spot market exchange (exports+imports) during the off-peak 1 hours (in GW)
exim_op2_dk1 <- data$dk1_op2_exim # average DK1 spot market exchange during the off-peak 2 hours (in GW)
exim_p_dk1 <- data$dk1_p_exim # average DK1 spot market exchange during the peak hours (in GW)
gas_dk1 <- data$dk1_gas # the logarithm of daily NCG spot gas prices

# read data for DK2
data <- read.table(here('code/rintamaki_replication/data/dk2_daily.txt'), header=TRUE)
dates_dk2 <- data$date 
dates_dk2 <- as.Date(dates_dk2,"%d/%m/%Y")
vol_dk2 <- data$dk2_price_vol # the logarithm of DK2 daily price volatility
load_dk2 <- data$dk2_load # the logarithm of average daily DK2 load forecast
wind_dk2 <- data$dk2_wind # the logarithm of average daily DK2 wind power forecast
wind_pen_dk2 <- data$dk2_wind_pen # the logarithm of average daily DK2 wind power penetration forecast
exim_op1_dk2 <- data$dk2_op1_exim # average DK2 spot market exchange during the off-peak 1 hours (in GW)
exim_op2_dk2 <- data$dk2_op2_exim # average DK2 spot market exchange during the off-peak 2 hours (in GW)
exim_p_dk2 <- data$dk2_p_exim # average DK2 spot market exchange during the peak hours (in GW)
gas_dk2 <- data$dk2_gas # the logarithm of daily NCG spot gas prices

# read data for DE
data <- read.table(here('code/rintamaki_replication/data/de_daily.txt'), header=TRUE)
dates_de <- data$date
dates_de <- as.Date(dates_de,"%d/%m/%Y")
vol_de <- data$de_price_vol # the logarithm of DE daily price volatility
load_de <- data$de_load # the logarithm of average daily DE load forecast
wind_de <- data$de_wind # the logarithm of average daily DE wind power forecast
solar_de <- data$de_solar # the logarithm of average daily DE solar power forecast
res_de <- data$de_res # the logarithm of average daily DE renewable generation (wind+solar) forecast
wind_pen_de <- data$de_wind_pen # the logarithm of average daily DE wind power penetration forecast
solar_pen_de <- data$de_solar_pen # the logarithm of average daily DE solar power penetration forecast
res_pen_de <- data$de_res_pen # the logarithm of average daily DE renewable generation penetration forecast
exim_op1_de <- data$de_op1_exim # average DE spot market exchange during the off-peak 1 hours (in GW)
exim_op2_de <- data$de_op2_exim # average DE spot market exchange during the off-peak 2 hours (in GW)
exim_p_de <- data$de_p_exim # average DE spot market exchange during the peak hours (in GW)
gas_de <- data$de_gas # the logarithm of daily NCG spot gas prices