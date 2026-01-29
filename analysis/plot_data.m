function plot_data(stats)
    
    if isempty(stats)
        return;
    end

    scenarios = {stats.scenario};
    means = [stats.calc_mean];
    stds_latency = [stats.calc_std];
    cis_latency = [stats.ci95_latency];
    
    jitters = [stats.calc_jitter];
    cis_jitter = [stats.ci95_jitter];
    
    % --- Konfiguracja kolorów ---
    bar_color = [0.2 0.6 0.8];      % Jasnoniebieski
    err_std_color = [1 0 1];        % Magenta (Std Dev)
    err_ci_color = [0 1 0];         % Zielony (CI 95%)
    
    % --- Plotting ---
    figure('Name', 'Sockperf Analysis', 'Position', [100, 100, 1200, 500]);
    
    % --- Wykres 1: Opóźnienie Średnie ---
    subplot(1, 2, 1);
    bar(means, 'FaceColor', bar_color);
    hold on;
    
    % Errorbar: Odchylenie Standardowe
    e_std = errorbar(1:length(means), means, stds_latency, stds_latency, ...
        'Color', err_std_color, 'LineStyle', 'none', 'LineWidth', 1.0, 'CapSize', 10);
        
    % Errorbar: Przedział Ufności 95%
    e_ci = errorbar(1:length(means), means, cis_latency, cis_latency, ...
        'Color', err_ci_color, 'LineStyle', 'none', 'LineWidth', 2.0, 'CapSize', 6);
    
    hold off;
    
    title('Opóźnienie Średnie');
    ylabel('Opóźnienie (\mus)');
    set(gca, 'XTick', 1:length(scenarios), 'XTickLabel', scenarios, 'TickLabelInterpreter', 'none');
    xtickangle(45);
    grid on;
    
    legend([e_std, e_ci], {'Odchylenie Std.', 'Przedział Ufności 95%'}, 'Location', 'northeast');

    % --- Wykres 2: Jitter ---
    subplot(1, 2, 2);
    bar(jitters, 'FaceColor', bar_color);
    hold on;
    
    % Errorbar: TYLKO Przedział Ufności 95% (usunięto std dev)
    e_ci_j = errorbar(1:length(jitters), jitters, cis_jitter, cis_jitter, ...
        'Color', err_ci_color, 'LineStyle', 'none', 'LineWidth', 2.0, 'CapSize', 6);
    
    hold off;
    
    title('Jitter');
    ylabel('Jitter (\mus)');
    set(gca, 'XTick', 1:length(scenarios), 'XTickLabel', scenarios, 'TickLabelInterpreter', 'none');
    xtickangle(45);
    grid on;
    
    ylim([0 inf]); 
    
    legend(e_ci_j, {'Przedział Ufności 95%'}, 'Location', 'northeast');
    
    % --- Command Line Output (Dwie Tabele) ---
    w_scen = 20;
    w_val  = 25;
    w_std  = 30;
    w_ci   = 20;
    
    total_len = w_scen + w_val + w_std + w_ci + 9;
    
    % Tabela 1: Średnia Opóźnienia
    fprintf('\n%s\n', repmat('=', 1, total_len));
    fprintf(' TABELA 1: OPÓŹNIENIE ŚREDNIE\n');
    fprintf('%s\n', repmat('-', 1, total_len));
    fprintf('%-*s | %-*s | %-*s | %-*s\n', ...
        w_scen, 'Scenariusz', ...
        w_val,  'Średnia (Calc/Rep)', ...
        w_std,  'Odchylenie Std. (Calc/Rep)', ...
        w_ci,   'CI 95%');
    fprintf('%s\n', repmat('-', 1, total_len));
    
    for i = 1:length(stats)
        % Formatowanie reported values
        rep_avg_str = sprintf('%.3f', stats(i).rep_avg);
        if isnan(stats(i).rep_avg), rep_avg_str = 'N/A'; end
        
        rep_std_str = sprintf('%.3f', stats(i).rep_std);
        if isnan(stats(i).rep_std), rep_std_str = 'N/A'; end
        
        str_mean = sprintf('%.3f / %s', stats(i).calc_mean, rep_avg_str);
        str_std  = sprintf('%.3f / %s', stats(i).calc_std, rep_std_str);
        str_ci   = sprintf('+/- %.3f', stats(i).ci95_latency);
        
        fprintf('%-*s | %-*s | %-*s | %-*s\n', ...
            w_scen, stats(i).scenario, ...
            w_val,  str_mean, ...
            w_std,  str_std, ...
            w_ci,   str_ci);
    end
    fprintf('%s\n', repmat('=', 1, total_len));
    fprintf('\n');
    
    % Tabela 2: Jitter
    fprintf('%s\n', repmat('=', 1, total_len));
    fprintf(' TABELA 2: JITTER\n');
    fprintf('%s\n', repmat('-', 1, total_len));
    fprintf('%-*s | %-*s | %-*s | %-*s\n', ...
        w_scen, 'Scenariusz', ...
        w_val,  'Jitter Średni', ...
        w_std,  'Odchylenie Std.', ...
        w_ci,   'CI 95%');
    fprintf('%s\n', repmat('-', 1, total_len));
    
    for i = 1:length(stats)
        str_ci_jit = sprintf('+/- %.3f', stats(i).ci95_jitter);
        str_jit    = sprintf('%.3f', stats(i).calc_jitter);
        
        fprintf('%-*s | %-*s | %-*.3f | %-*s\n', ...
            w_scen, stats(i).scenario, ...
            w_val,  str_jit, ...
            w_std,  stats(i).jitter_std, ...
            w_ci,   str_ci_jit);
    end
    fprintf('%s\n', repmat('=', 1, total_len));
end