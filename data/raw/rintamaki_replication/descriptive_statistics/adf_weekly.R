# CHANGE THE WORKING DIRECTORY!
working_directory = "/home/tuomas/empirical/" 
setwd(working_directory)

# import the required libraries
library(tseries)

# read data for the weekly models
source('models/read_weekly_data.R')
# NOTE: gas price data has been removed from the dataset because it originates from a proprietary data source. Please see the
# readme file for instructions how to obtain the data.

# Using the following code, one can run a ADF-test for each variable in the model.
# The variable names can be found in the script 'models/read_weekly_data.R'.
# In the following Tests, we show a number of examples how to obtain the results of the ADF test.

# Test 1: run the ADF-test at different lags for DK1 weekly price volatility 
x <- vol_dk1
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 2: run the ADF-test at different lags for average weekly DK1 wind power forecast
x <- wind_dk1
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 3: run the ADF-test at different lags for the standard deviation of average daily DK2 wind power forecasts
x <- wind_std_dk2
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 4: run the ADF-test at different lags for average weekly DE wind power forecast
x <- wind_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 5: run the ADF-test at different lags for average weekly DE wind power penetration forecast
x <- wind_pen_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 6: run the ADF-test at different lags for differenced average weekly DE wind power forecast
x <- diff(wind_de)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 7: run the ADF-test at different lags for differenced average weekly DE wind power penetration forecast
x <- diff(wind_pen_de)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 8: run the ADF-test at different lags for average weekly DE solar power forecast
x <- solar_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 9: run the ADF-test at different lags for differenced average weekly DE solar power forecast
x <- diff(solar_de)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 10: run the ADF-test at different lags for average weekly DE renewable generation forecast
x <- res_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 11: run the ADF-test at different lags for the standard deviation of average daily DE renewable generation forecasts
x <- res_std_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 12: run the ADF-test at different lags for average weekly DE renewable generation penetration forecasts
x <- res_pen_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 13: run the ADF-test at different lags for average weekly DK1 exports/imports in the spot market
x <- exim_dk1
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 15: run the ADF-test at different lags for average weekly DE exports/imports in the spot market
x <- exim_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 16: run the ADF-test at different lags for differenced average weekly DK1 exports/imports
x <- diff(exim_dk1)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 17: run the ADF-test at different lags for average weekly DE gas prices
x <- gas_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 18: run the ADF-test at different lags for differenced average weekly DE gas prices
x <- diff(gas_de)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

