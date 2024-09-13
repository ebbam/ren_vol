# CHANGE THE WORKING DIRECTORY!
working_directory = "/home/tuomas/empirical/" 
setwd(working_directory)

# import the required libraries
library(lmtest) # for testing the significance of the estimated parameters
library(portes) # Ljung-Box test for ARIMA models

# read data for the daily models
# see the file for further details
source('models/read_intraday_data.R')

# read helper code for fitting models
# see the file for further details
source('models/helper_code.R')

##################################################################################################################################
# Test 1: Estimate the impact of forecasted wind power and exports/imports on the average DK1 prices during off-peak 1,
# peak, and off-peak 2 hours. The following code replicates columns 1, 3, and 5 of Table 5. By modifying the following code,
# other columns in Table 5 can be reproduced.

# The effect of wind power forecasts and exports/imports on DK1 off-peak 1 prices
y <- price_op1_dk1
ext <- cbind(wind_op1_dk1, exim_op1_dk1) # use cbind to combine vectors horizontally

op1_dk1 <- fitModel(y, ext, 2, 1, 1, 1, 7) # fit model
op1_dk1 # report parameter estimates
coeftest(op1_dk1) # report the statistical significance of the parameter estimates using a Z-test
LjungBox(op1_dk1,lags=seq(2,30,1)) # do a Ljung-Box test on the model residuals

# The effect of wind power forecasts and exports/imports on DK1 peak prices
y <- price_p_dk1
ext <- cbind(wind_p_dk1, exim_p_dk1)

p_dk1 <- fitModel(y, ext, 2, 1, 1, 1, 7)
p_dk1
coeftest(p_dk1)
LjungBox(p_dk1,lags=seq(2,30,1))

# The effect of wind power forecasts and exports/imports on DK1 off-peak 2 prices
y <- price_op2_dk1
ext <- cbind(wind_op2_dk1, exim_op2_dk1)

op2_dk1 <- fitModel(y, ext, 2, 1, 1, 1, 7)
op2_dk1
coeftest(op2_dk1)
LjungBox(op2_dk1,lags=seq(2,30,1))

##################################################################################################################################
# Test 2: Estimate the impact of forecasted wind power and exports/imports on the average DK2 prices during off-peak 1,
# peak, and off-peak 2 hours. The following code replicates columns 1, 3, and 5 of Table 6. By modifying the following code,
# other columns in Table 6 can be reproduced.

# The effect of wind power forecasts and exports/imports on DK2 off-peak 1 prices
y <- price_op1_dk2
ext <- cbind(wind_op1_dk2, exim_op1_dk2)

op1_dk2 <- fitModel(y, ext, 2, 1, 1, 1, 7)
op1_dk2 
coeftest(op1_dk2)
LjungBox(op1_dk2,lags=seq(2,30,1))

# The effect of wind power forecasts and exports/imports on DK2 peak prices
y <- price_p_dk2
ext <- cbind(wind_p_dk2, exim_p_dk2)

p_dk2 <- fitModel(y, ext, 2, 1, 1, 1, 7)
p_dk2
coeftest(p_dk2)
LjungBox(p_dk2,lags=seq(2,30,1))

# The effect of wind power forecasts and exports/imports on DK2 off-peak 2 prices
y <- price_op2_dk2
ext <- cbind(wind_op2_dk2, exim_op2_dk2)

op2_dk2 <- fitModel(y, ext, 2, 1, 1, 1, 7)
op2_dk2
coeftest(op2_dk2)
LjungBox(op2_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 3: Estimate the impact of forecasted wind power and exports/imports on the average DE prices during off-peak 1,
# peak, and off-peak 2 hours. The following code replicates columns 1, 3, and 9 of Table 7. By modifying the following code,
# other columns in Table 7 can be reproduced.

# The effect of wind power forecasts and exports/imports on DE off-peak 1 prices
y <- price_op1_de
ext <- cbind(wind_op1_de, exim_op1_de)

op1_de <- fitModel(y, ext, 2, 1, 1, 1, 7)
op1_de
coeftest(op1_de)
LjungBox(op1_de,lags=seq(2,30,1))

# The effect of wind power forecasts and exports/imports on DE peak prices
y <- price_p_de
ext <- cbind(wind_p_de, exim_p_de)

p_de <- fitModel(y, ext, 2, 1, 1, 1, 7)
p_de
coeftest(p_de)
LjungBox(p_de,lags=seq(2,30,1))

# The effect of wind power forecasts and exports/imports on DE off-peak 1 prices
y <- price_op2_de
ext <- cbind(wind_op2_de, exim_op2_de)

op2_de2 <- fitModel(y, ext, 2, 1, 1, 1, 7)
op2_de2
coeftest(op2_de2)
LjungBox(op2_de2,lags=seq(2,30,1))

##################################################################################################################################
# Test 4: The impact of the diffence of DE forecasted solar power generation and exports/imports on DE peak prices.
# Replicates the column 5 of Table 7.

y <- fwd1(price_p_de) # skip the first element of the vector due to the differencing
ext <- cbind(diff(solar_p_de), fwd1(exim_p_de)) # differenced solar power

p_de <- fitModel(y, ext, 2, 1, 1, 1, 7)
p_de
coeftest(p_de)
LjungBox(p_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 5: The impact of the DE forecasted renewable power generation and exports/imports on DE peak prices.
# Replicates the column 7 of Table 7.

y <- price_p_de
ext <- cbind(res_p_de, exim_p_de)

p_de <- fitModel(y, ext, 2, 1, 1, 1, 7)
p_de
coeftest(p_de)
LjungBox(p_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 6: Selection of the intraday model for DK1 using peak hour data

y <- price_p_dk1
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 1, 0, 7)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 1, 0, 7)
fit$aic
fit <- fitModel(y, ext, 1, 0, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 1, 7)
fit$aic # statistically insignificant coefficients
fit <- fitModel(y, ext, 2, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 2, 7)
fit$aic

# use the following function to do the L-B test
LjungBox(fit,lags=seq(2,30,1))

# The best model in terms of AIC is SARMA(2,1)(2,1) but adding more terms to it does not improve the AIC.
# Hence, we stop and do not introduce third order terms. Moreover, we step down to the more parsimonious model SARMA(2,1)(1,1)
# because it provides a good fit for other areas and less terms become statistically insignificant when the external regressors
# are added to the model. However, we provide alternative specifications in Table 17.

##################################################################################################################################
# Test 7: Selection of the intraday model for DK2 using peak hour data

y <- price_p_dk2
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 1, 0, 7)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 1, 0, 7)
fit$aic
fit <- fitModel(y, ext, 1, 0, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 2, 7)
fit$aic

# use the following function to do the L-B test
LjungBox(fit,lags=seq(2,30,1))

# Based on the AIC, the best model would be SARMA(1,2)(1,2). However, we take the simpler SARMA(2,1)(1,1) because it provides
# a good fit for all areas and adding the exogenous variables does not cause parameters to become statistically insignificant
# unlike in the higher-order models. However, we provide alternative specifications in Table 17.

##################################################################################################################################
# Test 8: Selection of the intraday model for DE using peak hour data

y <- price_p_de
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 1, 0, 7)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 1, 0, 7)
fit$aic
fit <- fitModel(y, ext, 1, 0, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 1, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 1, 2, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 1, 7)
fit$aic
fit <- fitModel(y, ext, 2, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 2, 7)
fit$aic

# The best fit was obtained with the SARMA(1,1)(1,2) model. Using similar reasoning as above, we use the SARMA(2,1)(1,1) model.

##################################################################################################################################
# Test 9: The effect of wind power forecasts on DK1 peak prices using an alternative specification.
# Replicates column 4 of Table 17. By modifying the following code, other columns in Table 17 can be reproduced. Tests 11 and 12
# provide two examples for DK2 and DE. Note that this is the best model for DK1 in terms of AIC but some of the higher-order
# terms become statistically insignificant

y <- price_p_dk1
ext <- wind_p_dk1

alt_p_dk1 <- fitModel(y, ext, 2, 1, 2, 1, 7)
alt_p_dk1
coeftest(alt_p_dk1)
LjungBox(alt_p_dk1,lags=seq(2,30,1))

##################################################################################################################################
# Test 10: The effect of wind power forecasts on DK2 peak prices using an alternative specification.
# Replicates column 5 of Table 17.

y <- price_p_dk2
ext <- wind_p_dk2

alt_p_dk2 <- fitModel(y, ext, 1, 2, 1, 2, 7)
alt_p_dk2
coeftest(alt_p_dk2)
LjungBox(alt_p_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 11: The effect of wind power forecasts on DE peak prices using an alternative specification.
# Replicates column 6 of Table 17. Note the statistically insignificant parameter estimates.

y <- price_p_de
ext <- wind_p_de

alt_p_de <- fitModel(y, ext, 1, 1, 1, 2, 7)
alt_p_de
coeftest(alt_p_de)
LjungBox(alt_p_de,lags=seq(2,30,1))

#DK1
y <- price_op2_dk1
ext <- wind_op2_dk1

alt_p_dk2 <- fitModel(y, ext, 2, 1, 2, 1, 7)
alt_p_dk2
coeftest(alt_p_dk2)
LjungBox(alt_p_dk2,lags=seq(2,30,1))

