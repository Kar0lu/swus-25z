function stats = process_data(raw_data)
    
    stats = struct([]);
    
    for i = 1:length(raw_data)
        L = raw_data(i).latencies;
        
        if isempty(L)
            continue;
        end
        
        % 1. Calc Mean
        calc_mean = mean(L);
        
        % 2. Calc Std Dev (Latency)
        calc_std = std(L);
        
        % 3. Calc 95% Confidence Interval (Latency)
        N = length(L);
        sem = calc_std / sqrt(N);
        ci95_latency = 1.96 * sem;
        
        % 4. Calc Jitter & Jitter CI
        % Jitter is based on the difference between consecutive packets
        if length(L) > 1
            diffs = abs(diff(L));
            
            calc_jitter = mean(diffs);
            jitter_std = std(diffs);
            
            % CI for Jitter
            N_diff = length(diffs);
            sem_jitter = jitter_std / sqrt(N_diff);
            ci95_jitter = 1.96 * sem_jitter;
        else
            calc_jitter = 0;
            jitter_std = 0;
            ci95_jitter = 0;
        end
        
        % Store
        stats(i).scenario = raw_data(i).scenario;
        stats(i).calc_mean = calc_mean;
        stats(i).calc_std = calc_std;
        stats(i).ci95_latency = ci95_latency;
        
        stats(i).calc_jitter = calc_jitter;
        stats(i).jitter_std = jitter_std;
        stats(i).ci95_jitter = ci95_jitter;
        
        % Comparison Data
        stats(i).rep_avg = raw_data(i).reported_avg;
        stats(i).rep_std = raw_data(i).reported_std;
    end
end