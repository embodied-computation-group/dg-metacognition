function TriviacountriesTask(p, list_countries_complete, feedback)

results_countries = struct;

% Create a matrix of all the pairwise differences
population = zeros(length(list_countries_complete), 1);

for v = 1: length(list_countries_complete)
    population(v) = list_countries_complete{v, 5}; % population is ranked from the most populated to the least
end

for r = 1:length(population)
    for c = 1:length(population)
        diff_square(r,c) = population(r) - population(c);
    end
end

% TRIAL LOOP

% Find items in the table matching our difference
stepsize = 5;
differenceTarget = 40; % for example - should be set from staircase on each trial. It should always start as < than nTrial.
results_countries.S = SetupStaircase(1, differenceTarget, [1 length(list_countries_complete)], [2,1]);
nreversals = 0;

condition_vector = repmat([1;2], 50,1);
condition_vector = Shuffle(conditin_vector);


for n=1:p.nTrials
results_countries.DifferenceTarget(n) = differenceTarget;
[row, col] = find(diff_square == differenceTarget);

% create vector of suitable pairs

coords = [row, col];

% select random pair from all suitable - could be made more complex
this_pair = coords(randi(length(coords)),:);

% Shuffle the pair, otherwise the highest is always first.
this_pair = Shuffle(this_pair); 

% countries_1= list_countries_complete{this_pair(1)};
% countries_2= list_countries_complete{this_pair(2)};

% Trial Loop

[responseNum, correct, scaledX, RT, RT_Conf]=triviaTrialLoop_countries(p, list_countries_complete, this_pair, feedback);


% Update staircase
results_countries.S=StaircaseTrial(1, results_countries.S, correct);
[results_countries.S, IsReversal] = UpdateStaircase(1, results_countries.S, -stepsize);
differenceTarget = results_countries.S.Signal;
if IsReversal == 1
    nreversals = nreversals + 1;
    results_countries.i_trial_lastreversal = n;
    results_countries.Reversal(n) = 1;
else 
    results_countries.Reversal(n) = 0;
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

results_countries.Responses(n) = responseNum;
results_countries.Corrects(n) = correct;
results_countries.Pairs{n} = this_pair;
results_countries.Stepsize(n) = stepsize;
results_countries.NRevelsal = nreversals;
results_countries.Confidence(n) = scaledX;
results_countries.RTS(n) = RT;
results_countries.RT_Confidence(n) = RT_Conf;
end




save(p.filename_countries, 'results_countries');

%%%%%%%%%%%%%%%%%% Plot %%%%%%%%%%%%%%%%%%
figure('Name','Food Staircase');
plot(1:length(results_countries.DifferenceTarget), results_countries.DifferenceTarget)
end