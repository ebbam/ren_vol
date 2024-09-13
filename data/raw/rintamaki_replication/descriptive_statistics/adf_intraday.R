# CHANGE THE WORKING DIRECTORY!
working_directory = "/home/tuomas/empirical/" 
setwd(working_directory)

# import the required libraries
library(tseries) # adf test

# read data for the intraday models
source('models/read_intraday_data.R')

# Using the following code, one can run a ADF-test for each variable in the model.
# The variable names can be found in the script 'models/read_intraday_data.R'.
# In the following Tests, we show a number of examples how to obtain the results of the ADF test.

# Test 1: run the ADF-test at different lags for average DK1 price during the off-peak 1 hours
x <- price_op1_dk1
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 2: run the ADF-test at different lags for average DK2 price during the peak hours
x <- price_p_dk2
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 3: run the ADF-test at different lags for DE solar
x <- solar_p_de
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

# Test 4: run the ADF-test at different lags for differenced DE solar
x <- diff(solar_p_de)
adf.test(x,k=5)
adf.test(x,k=10)
adf.test(x,k=15)

