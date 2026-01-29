% main.m
% Root script to organize iperf3/sockperf log analysis
clear; clc; close all;

% Configuration
dataDir = 'results_4'; % Folder containing log files

% 1. Scrap Results
fprintf('Scraping data from %s...\n', dataDir);
try
    raw_data = scrap_results(dataDir);
catch ME
    error('Error during scraping: %s', ME.message);
end

if isempty(raw_data)
    error('No data found. Check the "results" folder.');
end

% 2. Process Data
fprintf('Processing statistics...\n');
processed_stats = process_data(raw_data);

% 3. Plot and Compare
fprintf('Generating plots and report...\n');
plot_data(processed_stats);

fprintf('\nAnalysis Complete.\n');