# CHANGE THE WORKING DIRECTORY!
working_directory = "/home/tuomas/empirical/" 
setwd(working_directory)

# import the required libraries
library(tseries)

# read data for the daily models
source('models/read_daily_data.R')
# NOTE: gas price data has been removed from the dataset because it originates from a proprietary data source. Please see the
# readme file for instructions how to obtain the data.

# Using the following code, one can run a ADF-test for each variable in the model.
# The variable names can be found in the script 'models/read_daily_data.R'.
# In the following Tests, we show a number of examples how to obtain the results of the ADF test.

# Test 1: run the ADF-test at different lags for DK1 daily price volatility.
x <- vol_dk1
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 2: run the ADF-test at different lags for the average DK2 exports/imports during the off-peak 1 hours
x <- exim_op1_dk2
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 3: run the ADF-test at different lags for the average daily DE solar power forecast
x <- solar_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 4: run the ADF-test at different lags for differenced DE solar
x <- diff(solar_de)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 5: run the ADF-test at different lags for average daily DK1 gas prices
x <- gas_dk1
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 6: run the ADF-test at different lags for differenced DK1 gas prices
x <- diff(gas_dk1)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

