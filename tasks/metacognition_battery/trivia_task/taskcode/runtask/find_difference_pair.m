function [this_pair, results] = find_difference_pair(condition, differenceTarget, p, results, trial_counter)
    
%% find stimulus pair
    [row, col] = find(p.diff_square{condition} == differenceTarget);
    
    %% create vector of suitable pairs
    
    coords = [row, col];
    
    
    %% if the stimulus pair is empty, find the nearest to the target
    if isempty(coords)
        
        matrix = p.diff_square{condition}; ref = differenceTarget;
        [value, ii] = min(abs(matrix(:)-ref));    %// linear index of closest entry
        [row, col] = ind2sub(size(matrix), ii);
        
        coords = [row, col];
        results.interp_trials(trial_counter) = 1;
    else
        
        results.interp_trials(trial_counter) = 0;
        
    end
    
    
    %% select random pair from all suitable - could be made more complex
    
    if size(coords,1) > 1
        this_pair = coords(randi(length(coords)),:);
    else
        this_pair = coords;
    end
    
end