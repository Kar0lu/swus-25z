function stats = process_data(raw_data)
    % PROCESS_DATA Calculates statistics from raw latency arrays
    
    stats = struct([]);
    
    for i = 1:length(raw_data)
        L = raw_data(i).latencies;
        
        if isempty(L)
            continue;
        end
        
        % 1. Calc Mean
        calc_mean = mean(L);
        
        % 2. Calc Std Dev
        calc_std = std(L);
        
        % 3. Calc Jitter
        % Definition: Average of absolute differences between consecutive packets
        % (Common in VoIP/Networking, different from StdDev)
        if length(L) > 1
            calc_jitter = mean(abs(diff(L)));
        else
            calc_jitter = 0;
        end
        
        % 4. Calc 95% Confidence Interval
        % CI = Mean +/- (1.96 * (std / sqrt(N)))
        N = length(L);
        sem = calc_std / sqrt(N); % Standard Error of Mean
        ci95_margin = 1.96 * sem;
        
        % Store
        stats(i).scenario = raw_data(i).scenario;
        stats(i).calc_mean = calc_mean;
        stats(i).calc_std = calc_std;
        stats(i).calc_jitter = calc_jitter;
        stats(i).ci95 = ci95_margin; % Margin of error
        
        % Comparison Data (Difference)
        stats(i).rep_avg = raw_data(i).reported_avg;
        stats(i).rep_std = raw_data(i).reported_std;
        stats(i).diff_mean = calc_mean - raw_data(i).reported_avg;
        stats(i).diff_std = calc_std - raw_data(i).reported_std;
    end
end