%% Import data
clear;

filename = '../data/daily.xlsx'; % data location

% Take the logarithm of the data as specified in the paper
ln_volatility_dk1 = log(xlsread(filename, 1,  'B2:B1827'));
ln_volatility_dk2 = log(xlsread(filename, 2,  'B2:B1827'));
% There is different number of observations for Germany
ln_volatility_de = log(xlsread(filename, 3,  'B2:B1097'));
%% ACF and PACF of DK1 prices
% The functions autocorr and parcorr require Matlab Econometrics toolbox
% but similar functions are available in other software packages such as R.
% We are interested in the first 30 lags because data older than that is
% not likely to be relevant for the current observation.
% Type 'help autocorr' and 'help parcorr' for more details about the ACF
% and PACF functions, respectively.
[acf, lags, bounds] = autocorr(ln_volatility_dk1,30);
[pacf, pacf_lags, pacf_bounds] = parcorr(ln_volatility_dk1, 30);

% Plot ACF
h1 = figure;
stem(lags(2:end), acf(2:end)); % skip the first lag
set(h1, 'Position', [0 0 800 400]); % set the figure size
set(gca, 'FontSize', 13);
set(gca, 'XTick', lags(2:end)) % remove the first tick on the x-axis
set(gca,'Box','off')
xlabel('Lag'); ylabel('ACF');
title(strcat('ACF of DK1 daily price volatility'))

% Plot PACF
h1 = figure;
stem(lags(2:end), pacf(2:end));
set(h1, 'Position', [0 0 800 400]);
set(gca, 'FontSize', 13);
set(gca, 'XTick', lags(2:end))
set(gca,'Box','off')
xlabel('Lag'); ylabel('PACF');
title(strcat('PACF of DK1 daily price volatility'))
%% ACF and PACF of DK2 prices
[acf, lags, bounds] = autocorr(ln_volatility_dk2,30);
[pacf, pacf_lags, pacf_bounds] = parcorr(ln_volatility_dk2, 30);

h1 = figure;
stem(lags(2:end), acf(2:end));
set(h1, 'Position', [0 0 800 400]);
set(gca, 'FontSize', 13);
set(gca, 'XTick', lags(2:end))
set(gca,'Box','off')
xlabel('Lag'); ylabel('ACF');
title(strcat('ACF of DK2 daily price volatility'))

h1 = figure;
stem(lags(2:end), pacf(2:end));
set(h1, 'Position', [0 0 800 400]);
set(gca, 'FontSize', 13);
set(gca, 'XTick', lags(2:end))
set(gca,'Box','off')
xlabel('Lag'); ylabel('PACF');
title(strcat('PACF of DK2 daily price volatility'))
%% ACF and PACF of DE prices
[acf, lags, bounds] = autocorr(ln_volatility_de,30);
[pacf, pacf_lags, pacf_bounds] = parcorr(ln_volatility_de, 30);

h1 = figure;
stem(lags(2:end), acf(2:end));
set(h1, 'Position', [0 0 800 400]);
set(gca, 'FontSize', 13);
set(gca, 'XTick', lags(2:end))
set(gca,'Box','off')
xlabel('Lag'); ylabel('ACF');
title(strcat('ACF of DE daily price volatility'))

h1 = figure;
stem(lags(2:end), pacf(2:end));
set(h1, 'Position', [0 0 800 400]);
set(gca, 'FontSize', 13);
set(gca, 'XTick', lags(2:end))
set(gca,'Box','off')
xlabel('Lag'); ylabel('PACF');
title(strcat('PACF of DE daily price volatility'))

