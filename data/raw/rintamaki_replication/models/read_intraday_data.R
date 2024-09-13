# Read data for the intraday models

# read data for DK1
data <- read.table(here("data/raw/rintamaki_replication/data/dk1_intraday.txt"), header=TRUE)
dates_dk1 <- data$date # observation dates
dates_dk1 <- as.Date(dates_dk1,"%d/%m/%Y") # format to R dates. This can be used for plotting
price_op1_dk1 <- data$op1_dk1_price # logarithm of the average DK1 price during the off-peak 1 hours. In the paper, we denote the variable by 'p'.
price_op2_dk1 <- data$op2_dk1_price # logarithm of the average DK1 price during the off-peak 2 hours
price_p_dk1 <- data$p_dk1_price # logarithm of the average DK1 price during the peak hours
load_op1_dk1 <- data$op1_dk1_load # logarithm of the average DK1 load forecast during off-peak 1 hours
load_op2_dk1 <- data$op2_dk1_load # logarithm of the average DK1 load forecast during off-peak 2 hours
load_p_dk1 <- data$p_dk1_load # logarithm of the average DK1 load forecast during peak hours
wind_op1_dk1 <- data$op1_dk1_wind # logarithm of the average DK1 wind power forecast during off-peak 1 hours
wind_op2_dk1 <- data$op2_dk1_wind # logarithm of the average DK1 wind power forecast during off-peak 2 hours
wind_p_dk1 <- data$p_dk1_wind # logarithm of the average DK1 wind power forecast during peak hours
wind_pen_op1_dk1 <- data$op1_dk1_pen # logarithm of the average DK1 wind power penetration forecast during off-peak 1 hours
wind_pen_op2_dk1 <- data$op2_dk1_pen # logarithm of the average DK1 wind power penetration forecast during off-peak 2 hours
wind_pen_p_dk1 <- data$p_dk1_pen # logarithm of the average DK1 wind power penetration forecast during peak hours
exim_op1_dk1 <- data$op1_dk1_exp # average spot market exports/imports at DK1 during off-peak 1 hours (in GW)
exim_op2_dk1 <- data$op2_dk1_exp # average spot market exports/imports at DK1 during off-peak 2 hours (in GW)
exim_p_dk1 <- data$p_dk1_exp # average spot market exports/imports at DK1 during peak hours (in GW)

# read data for DK2
data <- read.table(here("data/raw/rintamaki_replication/data/dk2_intraday.txt"), header=TRUE)
dates_dk2 <- data$date # observation dates
dates_dk2 <- as.Date(dates_dk2,"%d/%m/%Y") # format to R dates
price_op1_dk2 <- data$op1_dk2_price # logarithm of the average DK2 price during the off-peak 1 hours
price_op2_dk2 <- data$op2_dk2_price # logarithm of the average DK2 price during the off-peak 2 hours
price_p_dk2 <- data$p_dk2_price # logarithm of the average DK2 price during the peak hours
load_op1_dk2 <- data$op1_dk2_load # logarithm of the average DK2 load forecast during off-peak 1 hours
load_op2_dk2 <- data$op2_dk2_load # logarithm of the average DK2 load forecast during off-peak 2 hours
load_p_dk2 <- data$p_dk2_load # logarithm of the average DK2 load forecast during peak hours
wind_op1_dk2 <- data$op1_dk2_wind # logarithm of the average DK2 wind power forecast during off-peak 1 hours
wind_op2_dk2 <- data$op2_dk2_wind # logarithm of the average DK2 wind power forecast during off-peak 2 hours
wind_p_dk2 <- data$p_dk2_wind # logarithm of the average DK2 wind power forecast during peak hours
wind_pen_op1_dk2 <- data$op1_dk2_pen # logarithm of the average DK2 wind power penetration forecast during off-peak 1 hours
wind_pen_op2_dk2 <- data$op2_dk2_pen # logarithm of the average DK2 wind power penetration forecast during off-peak 2 hours
wind_pen_p_dk2 <- data$p_dk2_pen # logarithm of the average DK2 wind power penetration forecast during peak hours
exim_op1_dk2 <- data$op1_dk2_exp # average spot market exports/imports at DK2 during off-peak 1 hours
exim_op2_dk2 <- data$op2_dk2_exp # average spot market exports/imports at DK2 during off-peak 2 hours
exim_p_dk2 <- data$p_dk2_exp # average spot market exports/imports at DK2 during peak hours

# read data for DE
data <- read.table(here("data/raw/rintamaki_replication/data/de_intraday.txt"), header=TRUE)
dates_de <- data$date
dates_de <- as.Date(dates_de,"%d/%m/%Y")
price_op1_de <- data$op1_price # logarithm of the average DE price during the off-peak 1 hours
price_op2_de <- data$op2_price # logarithm of the average DE price during the off-peak 2 hours
price_p_de <- data$p_price # logarithm of the average DE price during the peak hours
load_op1_de <- data$op1_load # logarithm of the average DE load forecast during off-peak 1 hours
load_op2_de <- data$op2_load # logarithm of the average DE load forecast during off-peak 2 hours
load_p_de <- data$p_load # logarithm of the average DE load forecast during peak hours
wind_op1_de <- data$op1_wind # logarithm of the average DE wind power forecast during off-peak 1 hours
wind_op2_de <- data$op2_wind # logarithm of the average DE wind power forecast during off-peak 2 hours
wind_p_de <- data$p_wind # logarithm of the average DE wind power forecast during peak hours
wind_pen_op1_de <- data$op1_wind_pen # logarithm of the average DE wind power penetration forecast during off-peak 1 hours
wind_pen_op2_de <- data$op2_wind_pen # logarithm of the average DE wind power penetration forecast during off-peak 2 hours
wind_pen_p_de <- data$p_wind_pen # logarithm of the average DE wind power penetration forecast during peak hours
res_op1_de <- data$op1_res # logarithm of the average DE renewable generation forecast during off-peak 1 hours (wind+solar)
res_op2_de <- data$op2_res # logarithm of the average DE renewable generation forecast during off-peak 2 hours
res_p_de <- data$p_res # logarithm of the average DE renewable generation forecast during peak hours
res_pen_op1_de <- data$op1_res_pen # logarithm of the average DE renewable generation penetration forecast during off-peak 1 hours
res_pen_op2_de <- data$op2_res_pen # logarithm of the average DE renewable generation penetration forecast during off-peak 2 hours
res_pen_p_de <- data$p_res_pen # logarithm of the average DE renewable generation penetration forecast during peak hours
solar_p_de <- data$p_solar # logarithm of the average solar power forecast during peak hours
solar_pen_p_de <- data$p_solar_pen # logarithm of the average solar power penetration forecast during peak hours
exim_op1_de <- data$op1_exp # average spot market exports/imports at DE during off-peak 1 hours (in GW)
exim_op2_de <- data$op2_exp # average spot market exports/imports at DE during off-peak 2 hours (in GW)
exim_p_de <- data$p_exp # average spot market exports/imports at DE during peak hours (in GW)