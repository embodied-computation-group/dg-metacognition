function repeatIndices = findRepeatedPairs(cellArray)
    % Initialize an empty cell array to store unique stimulus pairs
    seenPairs = {};
    % Initialize an empty vector to store indices of repeated trials
    repeatIndices = [];
    
    % Iterate over each trial in the cell array
    for i = 1:length(cellArray)
        % Sort the pair for consistent ordering
        pair = sort(cellArray{i});
        
        % Convert the pair to a string for easy comparison
        pairStr = sprintf('%d-%d', pair(1), pair(2));
        
        % Check if this pair has been seen before
        if ismember(pairStr, seenPairs)
            % If seen, add the index to repeatIndices
            repeatIndices = [repeatIndices, i];
        else
            % If not seen, add it to the seenPairs
            seenPairs{end+1} = pairStr;
        end
    end
end
