function TriviaFoodTask(p, list_food_complete, feedback)

results_food = struct;

% Create a matrix of all the pairwise differences
food = zeros(length(list_food_complete), 1);

for v = 1: length(list_food_complete)
    food(v) = list_food_complete{v, 5}; % population is ranked from the most populated to the least
end

for r = 1:length(food)
    for c = 1:length(food)
        diff_square(r,c) = food(r) - food(c);
    end
end

% TRIAL LOOP

% Find items in the table matching our difference
stepsize = 5;
differenceTarget = 40; % for example - should be set from staircase on each trial. It should always start as < than nTrial.
results_food.S = SetupStaircase(1, differenceTarget, [1 length(list_food_complete)], [2,1]);
nreversals = 0;

for n=1:p.nTrials
results_food.DifferenceTarget(n) = differenceTarget;
[row, col] = find(diff_square == differenceTarget);

% create vector of suitable pairs

coords = [row, col];

% select random pair from all suitable - could be made more complex
this_pair = coords(randi(length(coords)),:);

% Shuffle the pair, otherwise the highest is always first.
this_pair = Shuffle(this_pair); 


% Trial Loop

[responseNum, correct, scaledX, RT, RT_Conf]=triviaTrialLoop_food(p, list_food_complete, this_pair, feedback);

% Update staircase
results_food.S=StaircaseTrial(1, results_food.S, correct);
[results_food.S, IsReversal] = UpdateStaircase(1, results_food.S, -stepsize);
differenceTarget = results_food.S.Signal;
if IsReversal == 1
    nreversals = nreversals + 1;
    results_food.i_trial_lastreversal = n;
    results_food.Reversal(n) = 1;
else 
    results_food.Reversal(n) = 0;
end


% Adapt stepsize
if nreversals == 4
    stepsize = 2;
elseif nreversals == 8
    stepsize = 1;
end


% list_responses(n) = responseNum;
% list_corrects(n) = correct;
% list_pairs{n} = this_pair;

results_food.Responses(n) = responseNum;
results_food.Corrects(n) = correct;
results_food.Pairs{n} = this_pair;
results_food.Stepsize(n) = stepsize;
results_food.NRevelsal = nreversals;
results_food.Confidence(n) = scaledX;
results_food.RTS(n) = RT;
results_food.RT_Confidence(n) = RT_Conf;
end




save(p.filename_food, 'results_food');

%%%%%%%%%%%%%%%%%% Plot %%%%%%%%%%%%%%%%%%
figure('Name','Food Staircase');
plot(1:length(results_food.DifferenceTarget), results_food.DifferenceTarget)
end