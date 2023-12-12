function exclude_vector = exclude_repeats(results)

    % Initialize the exclude vector for all trials
    exclude_vector = zeros(1, length(results.Pairs));
    
    % Process for Condition A
    conditionA_indices = find(results.ConditionVectors == 1);
    these_pairs_A = results.Pairs(conditionA_indices);
    repeatsA = findRepeatedPairs(these_pairs_A);
    exclude_vector(conditionA_indices(repeatsA)) = 1;
    
    % Process for Condition B
    conditionB_indices = find(results.ConditionVectors == 2);
    these_pairs_B = results.Pairs(conditionB_indices);
    repeatsB = findRepeatedPairs(these_pairs_B);
    exclude_vector(conditionB_indices(repeatsB)) = 1;

end
