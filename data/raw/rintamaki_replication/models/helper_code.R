# Helper code for fitting models

# Fit a SARIMAX(p,q)(P,W)[s] model.
#
# Args:
#   y: dependent time-series such as price volatility
#   ext: external regressors such as load and wind power
# Returns:
#   fit: the fitted model
fitModel <- function(y, ext, p, q, P, Q, s) {
  if(length(ext)>0) {
    fit <- arima(y, order=c(p,0,q), seasonal=list(order=c(P,0,Q), period=s), xreg=ext) # fit the model with external regressors
  } else {
    fit <- arima(y, order=c(p,0,q), seasonal=list(order=c(P,0,Q), period=s)) # fit the model without external regressors
  }
  return(fit)
}

# Skip the first element of a vector.
#
# Args:
#   x: a vector N x 1
# Returns:
#   x': a vector (N-1) x 1, where the first element of x is skipped 
fwd1 = function (x) c(x[2:length(x)])