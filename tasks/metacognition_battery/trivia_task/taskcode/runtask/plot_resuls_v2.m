%% plot staircases

figure
signal_gdp = results.DifferenceTarget(results.WhichCondition ==1);
signal_calories = results.DifferenceTarget(results.WhichCondition ==2);
subplot(2,1,1)
plot(1:length(signal_gdp), signal_gdp, '-o')
subplot(2,1,2)

plot(1:length(signal_calories), signal_calories, '-o')

%% accuracy 

results.Corrects(1:20) = nan
results.WhichCondition(1:20) = nan

%%
nanmean(results.Corrects(results.WhichCondition == 1))
nanmean(results.Corrects(results.WhichCondition == 2))

%%
results.interp_trials(results.WhichCondition == 2)

%% pairs

pairs_1 = results.Pairs(results.WhichCondition == 1);
pairs_2= results.Pairs(results.WhichCondition == 2);


this_pair = [];
pairs = [];
for n = 1:length(pairs_1)
this_pair = pairs_1{n}
end

%% 

condition= results.WhichCondition

revs_1 = results.Reversal(condition==1);
revs_2 = results.Reversal(condition==2);

cumsum(revs_1)
cumsum(revs_2)

%%
condition = results.WhichCondition;

stim1 = results.DifferenceTarget(condition==1);
rt1 = results.RTS(condition==1); 

figure, plot(zscore(stim1), zscore(rt1), '*'); lsline

stim2 = results.DifferenceTarget(condition==2);
rt2 = results.RTS(condition==2s); 

figure, plot(zscore(stim2), zscore(rt2), '*'); lsline


