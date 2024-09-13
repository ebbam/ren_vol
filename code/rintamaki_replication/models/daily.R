# CHANGE THE WORKING DIRECTORY!
working_directory = here("code/rintamaki_replication/") 
setwd(working_directory)

# import the required libraries
library(lmtest) # for testing the significance of the estimated parameters
library(portes) # Ljung-Box test for ARIMA models

# read data for the daily models
# see the file for further details
source('models/read_daily_data.R')
# NOTE: gas price data has been removed from the dataset because it originates from a proprietary data source. Please see the
# readme file for instructions how to obtain the data.

# read helper code for fitting models
# see the file for further details
source('models/helper_code.R')

##################################################################################################################################
# Test 1: model 1 in Table 2. The impact of DK1 wind power forecasts on daily DK1 price volatility. By changing the external 
# regressors, one may replicate other models in Table 2. Test 2 shows an example on how to replicate the results of another model.

# specify the dependent time-series (y) and the external regressors (ext)
y <- vol_dk1
ext <- wind_dk1

# Fit a SARMAX(p,q)(P,Q)[s] model with fitModel(y,ext,p,q,P,Q,s), where y is the dependent variable and ext the external regressors
model1_dk1 <- fitModel(y, ext, 2, 1, 2, 1, 7)
model1_dk1 # report the model parameters and AIC
coeftest(model1_dk1) # test the significance of the model parameters using a Z-test
[LjungBox(model1_dk1,lags=seq(2,30,1)) # do a Ljung-Box test. We report the lag at which the p-value of test goes below 0.01.

##################################################################################################################################
# Test 2: model 6 in Table 2. The impact of average daily DK1 wind power forecasts and differenced gas prices on daily DK1 price
# volatility.

# model 6 contains a differenced variable so we need to ignore the first element of non-differenced time-series
y <- fwd1(vol_dk1)
ext <- cbind(fwd1(wind_dk1), diff(gas_dk1)) # use cbind to concatenate vectors horizontally. diff(gas_dk1) does differencing.

model6_dk1 <- fitModel(y, ext, 2, 1, 2, 1, 7)
model6_dk1 # report the model parameters and AIC
coeftest(model6_dk1) # test the significance of the model parameters using a Z-test
LjungBox(model6_dk1,lags=seq(2,30,1)) # do a Ljung-Box test

##################################################################################################################################
# Test 3: model 1 in Table 3. The impact of average daily DK2 wind power forecasts on daily DK2 price volatility. By modifying
# this Test one may replicate other results in Table 3. Test 4 shows an example on how to replicate the results of another model.
y <- vol_dk2
ext <- wind_dk2

model1_dk2 <- fitModel(y, ext, 2, 1, 2, 1, 7)
model1_dk2
coeftest(model1_dk2)
LjungBox(model1_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 4: model 2 in Table 3. The impact of average daily DK2 wind power penetration forecasts on daily DK2 price volatility.
y <- vol_dk2
ext <- wind_pen_dk2

model2_dk2 <- fitModel(y, ext, 2, 1, 2, 1, 7)
model2_dk2
coeftest(model2_dk2)
LjungBox(model2_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 5: model 1 in Table 4. The impact of daily average DE wind power forecasts on daily DE price volatility. By modifying
# this Test one may replicate other results in Table 4. Tests 6-8 show how to replicate the results of other models.
y <- vol_de
ext <- wind_de

model1_de <- fitModel(y, ext, 2, 1, 2, 1, 7) # warnings may be produced due to the SMA(1) term
model1_de 
coeftest(model1_de)
LjungBox(model1_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 6: model 3 in Table 4. The impact of daily average DE wind power forecasts and differenced daily average solar power
# forecasts on daily DE price volatility.
y <- fwd1(vol_de)
ext <- cbind(fwd1(wind_de), diff(solar_de))

model3_de <- fitModel(y, ext, 2, 1, 2, 1, 7)
model3_de
coeftest(model3_de)
LjungBox(model3_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 7: model 4 in Table 4. The impact of daily average DE renewable generation forecasts on daily DE price volatility.
y <- vol_de
ext <- res_de

model4_de <- fitModel(y, ext, 2, 1, 2, 1, 7)
model4_de
coeftest(model4_de)
LjungBox(model4_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 8: model 9 in Table 4. The impact of average daily DE wind power forecasts and differenced average daily solar power
# forecasts and differenced gas prices on daily DE price volatility.
y <- fwd1(vol_de)
ext <- cbind(fwd1(wind_de), diff(solar_de), diff(gas_de))

model9_de <- fitModel(y, ext, 2, 1, 2, 1, 7) # warnings may be produced due to the SMA(1) term
model9_de
coeftest(model9_de)
LjungBox(model9_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 9 (replicate Figure 6): How to plot the ACF and PACF of the DK1, DK2, and DE model residuals
model <- model1_dk1
model.acf <- acf(resid(model))
model.acf$acf[1] <- NA
model.pacf <- pacf(resid(model))
model.pacf$pacf[1] <- NA
plot(model.acf, main="ACF of DK1 daily volatility model residuals")
plot(model.pacf, main="PACF of DK1 daily volatility model residuals")

model <- model1_dk2
model.acf <- acf(resid(model))
model.acf$acf[1] <- NA
model.pacf <- pacf(resid(model))
model.pacf$pacf[1] <- NA
plot(model.acf, main="ACF of DK2 daily volatility model residuals")
plot(model.pacf, main="PACF of DK2 daily volatility model residuals")

model <- model4_de # note that for DE we use the model 4 as specified in the paper
model.acf <- acf(resid(model))
model.acf$acf[1] <- NA
model.pacf <- pacf(resid(model))
model.pacf$pacf[1] <- NA
plot(model.acf, main="ACF of DE daily volatility model residuals")
plot(model.pacf, main="PACF of DE daily volatility model residuals")

##################################################################################################################################
# Test 10: Selection of the daily model for DK1.

y <- vol_dk1
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 1, 0, 7)
fit$aic # Initial AIC 3115.82
fit <- fitModel(y, ext, 1, 1, 1, 0, 7)
fit$aic # AIC improved to 3102.47 (< 3115.82)
fit <- fitModel(y, ext, 1, 0, 1, 1, 7)
fit$aic # AIC improved to 3022.43
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

fit <- fitModel(y, ext, 3, 1, 2, 1, 7)
fit$aic # no improvement compared to SARMA(2,1)(2,1)
fit <- fitModel(y, ext, 2, 1, 3, 1, 7)
fit$aic # no improvement compared to SARMA(2,1)(2,1)

# We will not introduce more third order p, q, P, or Q terms because no model with second order terms had better AIC than
# the ARIMA(2,1)(2,1)[7] model and adding third order terms to it does not improve the AIC

##################################################################################################################################
# Test 11: Selection of the daily model for DK2.

y <- vol_dk2
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 1, 0, 7)
fit$aic # Initial AIC 3403.952
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
fit$aic # here a 0.01 improvement is made but to obtain similar models for all areas, we choose SARMA(2,1)(2,1)
fit <- fitModel(y, ext, 2, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 2, 7)
fit$aic

# use the following function to do the L-B test
LjungBox(fit,lags=seq(2,30,1))

fit <- fitModel(y, ext, 3, 1, 2, 1, 7)
fit$aic # no improvement compared to SARMA(2,1)(2,1)
fit <- fitModel(y, ext, 2, 1, 3, 1, 7)
fit$aic # no improvement compared to SARMA(2,1)(2,1)

# We will not introduce more third order p, q, P, or Q terms because no model with second order terms had better AIC than
# the ARIMA(2,1)(2,1)[7] model and adding third order terms to it does not improve the AIC

##################################################################################################################################
# Test 12: Selection of the daily model for DE.

y <- vol_de
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 1, 0, 7)
fit$aic # Initial AIC 684.2967
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
fit$aic # here a 0.01 improvement is made but to obtain similar models for all areas, we choose SARMA(2,1)(2,1)
fit <- fitModel(y, ext, 2, 1, 2, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 1, 2, 7)
fit$aic
fit <- fitModel(y, ext, 2, 2, 2, 2, 7)
fit$aic

# use the following function to do the L-B test
LjungBox(fit,lags=seq(2,30,1))

fit <- fitModel(y, ext, 3, 1, 2, 1, 7)
fit$aic # no improvement compared to SARMA(2,1)(2,1)
fit <- fitModel(y, ext, 2, 1, 3, 1, 7)
fit$aic # no improvement compared to SARMA(2,1)(2,1)

# We will not introduce more third order p, q, P, or Q terms because no model with second order terms had better AIC than
# the ARIMA(2,1)(2,1)[7] model and adding third order terms to it does not improve the AIC

##################################################################################################################################
# Test 13: An alternative model specification for DK1. Replicates the column 1 of Table 16.

y <- vol_dk1
ext <- wind_dk1

alt_model1_dk1 <- fitModel(y, ext, 1, 2, 1, 2, 7)
alt_model1_dk1
coeftest(alt_model1_dk1)
LjungBox(alt_model1_dk1,lags=seq(2,30,1))

##################################################################################################################################
# Test 14: An alternative model specification for DK2. Replicates the column 2 of Table 16.

y <- vol_dk2
ext <- wind_dk2

alt_model1_dk2 <- fitModel(y, ext, 1, 2, 1, 2, 7)
alt_model1_dk2
coeftest(alt_model1_dk2)
LjungBox(alt_model1_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 15: An alternative model specification for DK1. Replicates the column 3 of Table 16.

y <- vol_de
ext <- wind_de

alt_model1_de <- fitModel(y, ext, 1, 2, 1, 2, 7)
alt_model1_de
coeftest(alt_model1_de)
LjungBox(alt_model1_de,lags=seq(2,30,1))
