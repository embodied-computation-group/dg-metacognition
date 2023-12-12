function allRepeatIndices = findAllRepeats(cellArray)
    seenPairs = {};
    repeatPairs = {};
    allRepeatIndices = [];

    % First pass: identify all pairs that repeat
    for i = 1:length(cellArray)
        pair = sort(cellArray{i});
        pairStr = sprintf('%d-%d', pair(1), pair(2));

        if ismember(pairStr, seenPairs) && ~ismember(pairStr, repeatPairs)
            repeatPairs{end+1} = pairStr;
        else
            seenPairs{end+1} = pairStr;
        end
    end

    % Second pass: find all instances of these pairs
    for i = 1:length(cellArray)
        pair = sort(cellArray{i});
        pairStr = sprintf('%d-%d', pair(1), pair(2));

        if ismember(pairStr, repeatPairs)
            allRepeatIndices = [allRepeatIndices, i];
        end
    end
end
