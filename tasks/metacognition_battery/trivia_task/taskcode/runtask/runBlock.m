function [results, trial_counter] = runBlock(p,confidence, feedback, blockNumber, results, trial_counter)
%% function to run one block of the trivia task.


%% Set up staircases for each condition

nreversals = results.nreversals; % n columns per conditions
step_level = results.step_level;


%% Vector with list of conditions
condition_vector = repmat([1;p.nConditions], p.totalNumTrial/2,1);
condition_vector = Shuffle(condition_vector); %condition 1=countries, 2=food
results.ConditionVectors = condition_vector';

%%
results.condition_counter = [0 0];

%% run the block

for n=1:p.trialsPerBlock
    trial_counter = trial_counter + 1;
    
    %% initialize trial parameters
    condition = results.ConditionVectors(trial_counter); % 1=countries, 2=food
    differenceTarget = results.S(condition).Signal;
    this_stepsize = results.stepsize(condition, step_level(condition));
    
    if condition == 1
        results.condition_counter(1) = results.condition_counter(1)+1;
    
    else
        
        results.condition_counter(2) = results.condition_counter(2)+1;
        
    end
    
    [this_pair, results] = find_difference_pair(condition, differenceTarget, p, results, trial_counter);
    
    %% exception to slightly randomize difference target is the same as the last trial
    
    if results.condition_counter(1) > 1 && results.condition_counter(2) > 1 
        
        if  this_pair == results.last_pair{condition}
            
            % increment the step level slightly by the medium amount 
            differenceTarget = differenceTarget + p.stepsize(condition, 2)*sign(randn(1,1)); 
            
            [this_pair, results] = find_difference_pair(condition, differenceTarget, p, results, trial_counter);
            
        end
        
    end
        
   
    
    %% check if the stimulus has been used more than some threshold, if so randomize 
    
    
    if condition == 1
        
        %keep pseudo-randomly incrementing until a non-repeat is found
        while results.countries_repeat_list(this_pair(1)) > results.repeat_threshold ...
                || results.countries_repeat_list(this_pair(2)) > results.repeat_threshold
            
            differenceTarget = differenceTarget + p.stepsize(condition, 2)*sign(randn(1,1));
            [this_pair, results] = find_difference_pair(condition, differenceTarget, p, results, trial_counter);
            
        end
        
    elseif condition == 2
        
        while results.foods_repeat_list(this_pair(1)) > results.repeat_threshold ...
                || results.foods_repeat_list(this_pair(2)) > results.repeat_threshold
            
            differenceTarget = differenceTarget + p.stepsize(condition, 2)*sign(randn(1,1));
            [this_pair, results] = find_difference_pair(condition, differenceTarget, p, results, trial_counter);      
        end  
    end
    
        
    
    
    
    %% update stimuli counters
    
    if condition == 1
    
    results.countries_repeat_list(this_pair(1)) =  results.countries_repeat_list(this_pair(1))+1;
    results.countries_repeat_list(this_pair(2)) =  results.countries_repeat_list(this_pair(2))+1;
   
    elseif condition == 2
        
    results.foods_repeat_list(this_pair(1)) = results.foods_repeat_list(this_pair(1))+1;
    results.foods_repeat_list(this_pair(2)) = results.foods_repeat_list(this_pair(2))+1;   
    
    end
    
    
    
    %% log the last pair
      
    results.last_pair{condition} = this_pair;   
    
    
    %% Shuffle the pair, otherwise the highest is always first.
    this_pair = Shuffle(this_pair);
    
    
    %% Trial
    
    [responseNum, correct, scaledX, RT, RT_Conf]=runTrial(p, this_pair, confidence, feedback, condition);
    
    
    
    %% Update staircase
    results.S(condition)=StaircaseTrial(1, results.S(condition), correct);
    [results.S(condition), IsReversal] = UpdateStaircase(1, results.S(condition), -this_stepsize);
    differenceTarget = results.S(condition).Signal;
    
    
    if IsReversal == 1
        nreversals(condition) = nreversals(condition) + 1;
        results.Reversal(trial_counter) = 1;
    
    else
        
        results.Reversal(trial_counter) = 0;
    
    end
    
    
    %% Adapt stepsize
    
    if nreversals(condition) == 4
        
        step_level(condition) = 1;
        %this_stepsize = results.stepsize(condition, step_level(condition));
        
    elseif nreversals(condition) == 8
        
        step_level(condition) = 2;
       % this_stepsize = results.stepsize(condition, step_level(condition));
        
   elseif nreversals(condition) == 16
        
       step_level(condition) = 3;
     %   this_stepsize = results.Stepsize(condition, step_level(condition));
        
    end
    

   
    
    %% update and save results
    results.trial(trial_counter) = trial_counter;
    results.Responses(trial_counter) = responseNum;
    results.Corrects(trial_counter) = correct;
    results.Pairs{trial_counter} = this_pair;
    results.this_stepsize(trial_counter) = this_stepsize;
    results.nreversals = nreversals;
    results.RTS(trial_counter) = RT;
    results.BlockNumber(trial_counter) = blockNumber;
    results.WhichCondition(trial_counter) = condition;
    results.DifferenceTarget(trial_counter) = differenceTarget;
    results.step_level = step_level;
    results.p = p; 
    
    if confidence
        results.Confidence(trial_counter) = scaledX;
        results.RT_Confidence(trial_counter) = RT_Conf;
    end
  
    
    save(p.filename, 'results');
end
end