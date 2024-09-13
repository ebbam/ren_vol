%% Import data
clear;

filename = '../data/raw_data.xlsx'; % data location

% Read months and hours which are the subscripts for the renewable
% generation data. Please see the data files for checking the following
% hardcoded ranges.
dk_subs = xlsread(filename,1,'B35070:C43830'); % we use only data from 2014
dk_subs(:,2) = dk_subs(:,2)+1; % change the hour indexing from 0-23 to 1-24
de_subs = xlsread(filename,3,'B17548:C26308');
de_subs(:,2) = de_subs(:,2)+1;

% Read renewable generation data 
dk1_wind = xlsread(filename,1,'F35070:F43830');
dk2_wind = xlsread(filename,2,'F35070:F43830');
de_wind = xlsread(filename,3,'F17548:F26308');
de_solar = xlsread(filename,3,'G17548:G26308');
%% Subscript data
% Compute the mean wind/solar power generation during each hour in each
% month.
dk1_wind = accumarray(dk_subs, dk1_wind, [], @mean);
dk2_wind = accumarray(dk_subs, dk2_wind, [], @mean);
de_wind = accumarray(de_subs, de_wind, [], @mean);
de_solar = accumarray(de_subs, de_solar, [], @mean);
%% Select certain months for plotting
% Plotting all months in the same figure would make the figure messy.
months = 4; % the number of months to be plotted
month_names = {'Jan' , 'Apr', 'Jul', 'Oct'}; % month abbreviations for the legend
month_numbers = [1 4 7 10]; % one may modify the selected months

% Select the data and transpose the arrays
dk1_wind = dk1_wind(month_numbers,:)';
dk2_wind = dk2_wind(month_numbers,:)';
de_wind = de_wind(month_numbers,:)';
de_solar = de_solar(month_numbers,:)';

% x-axis values
hours = 1:24;
%% Plot DE wind
h1 = figure;
set(h1, 'Position', [0 0 700 500]); % fixes the chart size
% The following command plots exactly four months with different kinds of
% markers for clarity
plot(hours, de_wind(:,1), 'b', hours, de_wind(:,2), 'r--', hours, de_wind(:,3), 'g-+', hours, de_wind(:,4), 'k-o')
set(gca, 'FontSize', 13);
title('Average hourly wind power production in DE in 2014');
figure(1); xlim([1 max(hours)]); xlabel('hour'); ylabel('MW');
legend(month_names(1:months), 'Location', 'EastOutside');

%% DE solar
% The following code is essentially copy-paste from the above block except
% that de_wind is changed to de_solar and the titles etc. being changed
% correspondingly
h1 = figure;
set(h1, 'Position', [0 0 700 500]);
plot(hours, de_solar(:,1), 'b', hours, de_solar(:,2), 'r--', hours, de_solar(:,3), 'g-+', hours, de_solar(:,4), 'k-o')
set(gca, 'FontSize', 13);
title('Average hourly solar power production in DE in 2014');
figure(1); xlim([1 max(hours)]); xlabel('hour'); ylabel('MW');
legend(month_names(1:months), 'Location', 'EastOutside');

%% DK1 wind
h1 = figure;
set(h1, 'Position', [0 0 700 500]);
plot(hours, dk1_wind(:,1), 'b', hours, dk1_wind(:,2), 'r--', hours, dk1_wind(:,3), 'g-+', hours, dk1_wind(:,4), 'k-o')
set(gca, 'FontSize', 13);
title('Average hourly wind power production in DK1 in 2014');
figure(1); xlim([1 max(hours)]); xlabel('hour'); ylabel('MW');
legend(month_names(1:months), 'Location', 'EastOutside');

%% DK2 wind
h1 = figure;
set(h1, 'Position', [0 0 700 500]);
plot(hours, dk2_wind(:,1), 'b', hours, dk2_wind(:,2), 'r--', hours, dk2_wind(:,3), 'g-+', hours, dk2_wind(:,4), 'k-o')
set(gca, 'FontSize', 13);
title('Average hourly wind power production in DK2 in 2014');
figure(1); xlim([1 max(hours)]); xlabel('hour'); ylabel('MW');
legend(month_names(1:months), 'Location', 'EastOutside');
