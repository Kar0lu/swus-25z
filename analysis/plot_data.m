function plot_data(stats)
    % PLOT_DATA Visualizes stats in subplots and prints detailed report
    
    if isempty(stats)
        return;
    end

    scenarios = {stats.scenario};
    means = [stats.calc_mean];
    stds = [stats.calc_std];
    jitters = [stats.calc_jitter];
    cis = [stats.ci95];
    
    % --- Plotting ---
    figure('Name', 'Sockperf Analysis', 'Position', [100, 100, 1400, 500]);
    
    % 1. Mean Latency
    subplot(1, 3, 1);
    bar(means);
    title('Opóźnienie Średnie');
    ylabel('Opóźnienie (\mus)');
    set(gca, 'XTickLabel', scenarios, 'TickLabelInterpreter', 'none');
    xtickangle(45);
    grid on;

    % 2. Standard Deviation
    subplot(1, 3, 2);
    bar(stds);
    title('Odchylenie Standardowe');
    ylabel('Opóźnienie (\mus)');
    set(gca, 'XTickLabel', scenarios, 'TickLabelInterpreter', 'none');
    xtickangle(45);
    grid on;

    % 3. Jitter
    subplot(1, 3, 3);
    bar(jitters);
    title('Jitter');
    ylabel('Opóźnienie (\mus)');
    set(gca, 'XTickLabel', scenarios, 'TickLabelInterpreter', 'none');
    xtickangle(45);
    grid on;
    
    % --- Command Line Output ---
    % Define column widths to fit the long Polish headers
    w_scen = 20;
    w_mean = 32;
    w_std  = 36;
    w_jit  = 10;
    w_ci   = 24;
    
    total_len = w_scen + w_mean + w_std + w_jit + w_ci + 12; % +12 for separators
    fprintf('\n%s\n', repmat('-', 1, total_len));
    
    % Print Header with dynamic width
    fprintf('%-*s | %-*s | %-*s | %-*s | %-*s\n', ...
        w_scen, 'Scenariusz', ...
        w_mean, 'Opóźnienie Średnie (Calc/Rep)', ...
        w_std,  'Odchylenie Std. (Calc/Rep)', ...
        w_jit,  'Jitter', ...
        w_ci,   'Przedział Ufności 95%');
        
    fprintf('%s\n', repmat('-', 1, total_len));
    
    for i = 1:length(stats)
        % Handle NaNs in reported values
        rep_avg_str = sprintf('%.3f', stats(i).rep_avg);
        if isnan(stats(i).rep_avg), rep_avg_str = 'N/A'; end
        
        rep_std_str = sprintf('%.3f', stats(i).rep_std);
        if isnan(stats(i).rep_std), rep_std_str = 'N/A'; end
        
        % Create composite strings for the columns
        str_mean_val = sprintf('%.3f / %s', stats(i).calc_mean, rep_avg_str);
        str_std_val  = sprintf('%.3f / %s', stats(i).calc_std, rep_std_str);
        str_ci_val   = sprintf('+/- %.3f', stats(i).ci95);
        
        % Print Row
        fprintf('%-*s | %-*s | %-*s | %-*.3f | %-*s\n', ...
            w_scen, stats(i).scenario, ...
            w_mean, str_mean_val, ...
            w_std,  str_std_val, ...
            w_jit,  stats(i).calc_jitter, ...
            w_ci,   str_ci_val);
    end
    fprintf('%s\n', repmat('-', 1, total_len));
    fprintf('"Rep" = Obliczone przez Sockperf\n"Calc" = Obliczone na podstawie pojedynczych opóźnień\n');
end