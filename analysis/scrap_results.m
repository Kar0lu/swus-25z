function data = scrap_results(dataDir)
    
    % 1. Get all files
    files = dir(fullfile(dataDir, '*'));
    files = files(~[files.isdir]); % Remove directories
    
    % 2. Define Custom Sort Order
    desired_order = {'nothing', 'filter', 'filter_map', 'htb', 'filter_htb', 'filter_htb_map'};
    
    % Map file names to their rank in the desired_order
    file_names = {files.name};
    ranks = zeros(size(file_names));
    
    for i = 1:length(file_names)
        % Check if the filename exists in our priority list
        [found, idx] = ismember(file_names{i}, desired_order);
        
        if found
            ranks(i) = idx; % Assign rank (1 to 6)
        else
            ranks(i) = length(desired_order) + 1; % Place unknown files at the end
        end
    end
    
    % Sort the 'files' array based on the computed ranks
    [~, sort_idx] = sort(ranks);
    files = files(sort_idx);
    
    % 3. Process files in the sorted order
    data = struct([]);
    validFileCount = 0; % Counter for successfully read files
    
    for i = 1:length(files)
        fileName = files(i).name;
        filePath = fullfile(dataDir, fileName);
        
        % Skip hidden files (like .DS_Store or .git)
        if startsWith(fileName, '.')
            continue; 
        end
        
        validFileCount = validFileCount + 1;
        fprintf('  Reading file: %s ... ', fileName);
        
        fid = fopen(filePath, 'r');
        if fid == -1
            warning('Could not open file %s', fileName);
            continue;
        end
        
        rep_avg = NaN;
        rep_std = NaN;
        dataFound = false;
        
        % --- Phase 1: Parse Header Line-by-Line ---
        while ~feof(fid)
            line = fgetl(fid);
            
            % Search for reported Stats (Robust to ANSI colors)
            if contains(line, 'avg-latency=')
                tokens = regexp(line, 'avg-latency=([0-9.]+)', 'tokens');
                if ~isempty(tokens), rep_avg = str2double(tokens{1}{1}); end
                
                tokens_std = regexp(line, 'std-dev=([0-9.]+)', 'tokens');
                if ~isempty(tokens_std), rep_std = str2double(tokens_std{1}{1}); end
            end
            
            % Search for Data Header
            if contains(line, 'packet, txTime') && contains(line, 'latency')
                dataFound = true;
                break; 
            end
        end
        
        % --- Phase 2: Bulk Read Data ---
        if dataFound
            C = textscan(fid, '%f %f %f %f', 'Delimiter', ',');
            latencies = C{4}; % 4th column is latency
            latencies = latencies(~isnan(latencies));
        else
            warning('Data header not found in %s.', fileName);
            latencies = [];
        end
        
        fclose(fid);
        
        % Store
        data(validFileCount).scenario = fileName;
        data(validFileCount).reported_avg = rep_avg;
        data(validFileCount).reported_std = rep_std;
        data(validFileCount).latencies = latencies;
        
        fprintf('Done. (%d packets)\n', length(latencies));
    end
end