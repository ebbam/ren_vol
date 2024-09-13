%% Read data
clear;

filename = '../data/raw_data.xlsx'; % data location

% each DK1/2 price observation is associated with an hour
dk_hours = xlsread(filename, 1, 'C2:C43830'); 
dk1 = xlsread(filename, 1, 'D2:D43830'); % DK1 prices
dk2 = xlsread(filename, 2, 'D2:D43830'); % DK2 prices
% there is a different number of observations for Germany
de_hours = xlsread(filename, 3, 'C2:C26308'); % DE hours
de = xlsread(filename, 3, 'D2:D26308'); % DE prices
%% Compute means
% The following function computes the mean price for each hour.
% Alternatively, one may use Excel or R, for example.

% In the data, hours are indexed from 0 to 23 but here we index from 1 to
% 24. Also, accumarray requires positive subscripts as its first argument.
dk_hours = dk_hours+1;  % shift the indexing by 1
de_hours = de_hours+1;
dk1 = accumarray(dk_hours, dk1, [], @mean); % compute hourly mean of DK1 prices
dk2 = accumarray(dk_hours, dk2, [], @mean);
de = accumarray(de_hours, de, [], @mean);
%% Plot average prices
hours = 1:24; % x values

% The following reproduces Figure 1.
figure;
bar(hours,dk2);set(gca, 'FontSize', 13);xlabel('hour');ylabel('EUR/MWh');xlim([1 24]);ylim([0 60]);title('Average hourly prices in DK2');
figure;
bar(hours,dk1);set(gca, 'FontSize', 13);xlabel('hour');ylabel('EUR/MWh');xlim([1 24]);ylim([0 60]);title('Average hourly prices in DK1');
figure;
bar(hours,de);set(gca, 'FontSize', 13);xlabel('hour');ylabel('EUR/MWh');xlim([1 24]);ylim([0 60]);title('Average hourly prices in DE');