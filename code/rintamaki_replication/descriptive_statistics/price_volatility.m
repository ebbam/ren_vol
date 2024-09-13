%% Import data
clear;
filename = '../data/daily.xlsx'; % data location

% Take the logarithm of the data as specified in the paper
ln_volatility_dk1 = log(xlsread(filename, 1,  'B2:B1827'));
ln_volatility_dk2 = log(xlsread(filename, 2,  'B2:B1827'));
% There is different number of observations for Germany
ln_volatility_de = log(xlsread(filename, 4,  'C2:C1827'));

% Read dates for the daily price volatility observations. The dates will be
% on the x-axis in the figures.
dates_dk = xlsread(filename, 1, 'I2:I1827');
% Convert Excel date integers to Matlab date integers
dates_dk = dates_dk + datenum('30-Dec-1899'); 
dates_de = xlsread(filename, 4, 'B2:B1827');
dates_de = dates_de + datenum('30-Dec-1899');
%% Plot DK1
h1 = figure;
set(h1, 'Position', [0 0 700 500]); % figure size
plot(dates_dk, ln_volatility_dk1); % plot data
set(gca,'XTick',dates_dk, 'FontSize', 13) % date x-axis
datetick('x','mm/yy') % format the x-axis
xlim([dates_dk(1) dates_dk(end)]) % set x-axis limits
title('Natural logarithm of daily price volatility in DK1');
xlabel('date')
ylabel('log daily price volatility')
%% Plot DK2
h1 = figure;
set(h1, 'Position', [0 0 700 500]);
plot(dates_dk, ln_volatility_dk2);
set(gca,'XTick',dates_dk, 'FontSize', 13)
datetick('x','mm/yy')
xlim([dates_dk(1) dates_dk(end)])
title('Natural logarithm of daily price volatility in DK2');
xlabel('date')
ylabel('log daily price volatility')
%% Plot DE
h1 = figure;
set(h1, 'Position', [0 0 700 500]);
plot(dates_de, ln_volatility_de);
set(gca,'XTick',dates_de, 'FontSize', 13)
datetick('x','mm/yy')
xlim([dates_de(1) dates_de(end)])
title('Natural logarithm daily price volatility in DE');
xlabel('date')
ylabel('log daily price volatility')


