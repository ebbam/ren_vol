# CHANGE THE WORKING DIRECTORY!
working_directory = "/home/tuomas/empirical/" 
setwd(working_directory)

# import the required libraries
library(lmtest) # for testing the significance of the estimated parameters
library(portes) # Ljung-Box test for ARIMA models

# read data for the daily models
# see the file for further details
source('models/read_weekly_data.R')
# NOTE: gas price data has been removed from the dataset because it originates from a proprietary data source. Please see the
# readme file for instructions how to obtain the data.

# read helper code for fitting models
# see the file for further details
source('models/helper_code.R')

##################################################################################################################################
# Test 1: model 1 in Table 8. The impact of average weekly DK1 wind power forecasts on DK1 weekly price volatility.
# Using this and the Tests 2 and 3 as a reference, one can reproduce other results in Table 8.

# specify the dependent time-series (y) and the external regressors (ext)
y <- vol_dk1
ext <- wind_dk1

model1_dk1 <- fitModel(y, ext, 1, 0, 0, 1, 4)
model1_dk1 # report the model parameters and AIC
coeftest(model1_dk1) # test the significance of the model parameters using a Z-test
LjungBox(model1_dk1,lags=seq(2,30,1)) # do a Ljung-Box test

##################################################################################################################################
# Test 2: model 3 in Table 8. The impact of average weekly DK1 wind power forecasts and differenced average weekly exports/imports
# on DK1 weekly price volatility.

y <- fwd1(vol_dk1) # ignore the first element of the vector due to differencing in the external regressors
ext <- cbind(fwd1(wind_dk1), diff(exim_dk1)) # use cbind to combine vectors horizontally. exports/imports are differenced

model3_dk1 <- fitModel(y, ext, 1, 0, 0, 1, 4)
model3_dk1
coeftest(model3_dk1) 
LjungBox(model3_dk1,lags=seq(2,30,1))

##################################################################################################################################
# Test 3: model 5 in Table 8. The impact of the standard deviation of DK1 daily wind power forecasts on DK1 weekly price volatility.

y <- vol_dk1
ext <- wind_std_dk1

model5_dk1 <- fitModel(y, ext, 1, 0, 0, 1, 4)
model5_dk1
coeftest(model5_dk1) 
LjungBox(model5_dk1,lags=seq(2,30,1))

##################################################################################################################################
# Test 4: model 1 in Table 9. The impact of average weekly DK2 wind power forecasts on DK2 weekly price volatility.

y <- vol_dk2
ext <- wind_dk2

model1_dk2 <- fitModel(y, ext, 1, 0, 0, 1, 4)
model1_dk2
coeftest(model1_dk2) 
LjungBox(model1_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 5: model 5 in Table 9. The impact of the standard deviation of DK2 daily wind power forecasts on DK2 weekly price volatility.

y <- vol_dk2
ext <- wind_std_dk2

model5_dk2 <- fitModel(y, ext, 1, 0, 0, 1, 4)
model5_dk2
coeftest(model5_dk2) 
LjungBox(model5_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 6: model 1 in Table 10. The impact of differenced average weekly DE wind power forecasts on DE weekly price volatility.

y <- fwd1(vol_de)
ext <- diff(wind_de)

model1_de <- fitModel(y, ext, 1, 0, 0, 0, 4) # note that the model for DE is different from DK1 and DK2
model1_de
coeftest(model1_de) 
LjungBox(model1_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 7: model 3 in Table 10. The impact of differenced average weekly DE solar power forecasts on DE weekly price volatility.

y <- fwd1(vol_de)
ext <- diff(solar_de)

model3_de <- fitModel(y, ext, 1, 0, 0, 0, 4)
model3_de
coeftest(model3_de) 
LjungBox(model3_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 8: model 5 in Table 10. The impact of average weekly DE renewable generation forecasts on DE weekly price volatility.

y <- vol_de
ext <- res_de

model5_de <- fitModel(y, ext, 1, 0, 0, 0, 4)
model5_de
coeftest(model5_de) 
LjungBox(model5_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 9: model 8 in Table 10. The impact of differenced DE weekly wind power generation and exports/import on
# DE weekly price volatility.

y <- fwd1(vol_de)
ext <- cbind(diff(wind_de), fwd1(exim_de))

model8_de <- fitModel(y, ext, 1, 0, 0, 0, 4)
model8_de
coeftest(model8_de) 
LjungBox(model8_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 10: The selection of the DK1 weekly model

y <- vol_dk1
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 0, 0, 4)
fit$aic 
fit <- fitModel(y, ext, 0, 1, 0, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 0, 1, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 0, 0, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 1, 0, 1, 1, 4)
fit$aic
fit <- fitModel(y, ext, 0, 1, 1, 0, 4)
fit$aic
fit <- fitModel(y, ext, 0, 1, 0, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 0, 1, 1, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 0, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 1, 0, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 1, 1, 4)
fit$aic 

# L-B test for a fitted model
LjungBox(fit,lags=seq(2,30,1))

# Adding terms to SARMA(1,0)(0,1) does not improve the AIC so we do not explore models with second-order terms.

##################################################################################################################################
# Test 11: The selection of the DK2 weekly model

y <- vol_dk2
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 0, 0, 4)
fit$aic 
fit <- fitModel(y, ext, 0, 1, 0, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 0, 1, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 0, 0, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 1, 0, 1, 1, 4)
fit$aic
fit <- fitModel(y, ext, 0, 1, 1, 0, 4)
fit$aic
fit <- fitModel(y, ext, 0, 1, 0, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 0, 1, 1, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 0, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 1, 1, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 1, 0, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 1, 1, 4)
fit$aic 

# L-B test for a fitted model
LjungBox(fit,lags=seq(2,30,1))

# Adding terms to SARMA(1,0)(0,1) does not improve the AIC so we do not explore models with second-order terms.

##################################################################################################################################
# Test 12: The selection of the DE weekly model

y <- vol_de
# in model selection, we ignore external regressors
ext <- list() # a vector of length 0 which will be ignored in the fitting process
fit <- fitModel(y, ext, 1, 0, 0, 0, 4)
fit$aic 
fit <- fitModel(y, ext, 0, 1, 0, 0, 4)
fit$aic
fit <- fitModel(y, ext, 1, 0, 1, 0, 4)
fit$aic # improves AIC but the SAR(1) term is statistically insignificant. We do not add new terms to this model
fit <- fitModel(y, ext, 1, 0, 0, 1, 4)
fit$aic # improves AIC but the SMA(1) term is statistically insignificant. We do not add new terms to this model
fit <- fitModel(y, ext, 0, 1, 1, 0, 4)
fit$aic
fit <- fitModel(y, ext, 0, 1, 0, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 0, 1, 1, 1, 4)
fit$aic 
fit <- fitModel(y, ext, 1, 1, 0, 0, 4)
fit$aic

# L-B test for a fitted model
LjungBox(fit,lags=seq(2,30,1))

# Adding terms to AR(1) does not improve the AIC so we do not explore models with second-order terms.

##################################################################################################################################
# Test 13: An alternative specification for DK1. Replicates the column 1 of Table 18.

y <- vol_dk1
ext <- wind_dk1

alt_model1_dk1 <- fitModel(y, ext, 1, 1, 0, 0, 4)
alt_model1_dk1
coeftest(alt_model1_dk1) 
LjungBox(alt_model1_dk1,lags=seq(2,30,1))

##################################################################################################################################
# Test 14: An alternative specification for DK2. Replicates the column 2 of Table 18.

y <- vol_dk2
ext <- wind_dk2

alt_model1_dk2 <- fitModel(y, ext, 1, 1, 0, 0, 4)
alt_model1_dk2
coeftest(alt_model1_dk2) 
LjungBox(alt_model1_dk2,lags=seq(2,30,1))

##################################################################################################################################
# Test 15: An alternative specification for DE. Replicates the column 3 of Table 18.

y <- fwd1(vol_de)
ext <- diff(wind_de)

alt_model1_de <- fitModel(y, ext, 1, 1, 0, 0, 4)
alt_model1_de
coeftest(alt_model1_de) 
LjungBox(alt_model1_de,lags=seq(2,30,1))

##################################################################################################################################
# Test 16: An alternative specification for DE. Replicates the column 4 of Table 18.

y <- fwd1(vol_de)
ext <- diff(solar_de)

alt_model2_de <- fitModel(y, ext, 1, 1, 0, 0, 4)
alt_model2_de
coeftest(alt_model2_de) 
LjungBox(alt_model2_de,lags=seq(2,30,1))
