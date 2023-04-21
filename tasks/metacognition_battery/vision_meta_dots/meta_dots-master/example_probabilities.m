%% example script to calcuate 

clear all
probability_nasty = 0.7;

needed_trials = 14:2:22;



for n = 1:numel(needed_trials) 

number_nasty_trials = needed_trials(n) .* probability_nasty;
number_nice_trials = needed_trials(n) .* (1-probability_nasty);

real_probability = ceil(number_nasty_trials)/(ceil(number_nasty_trials)...
    +ceil(number_nice_trials));


trialvector = [ones(1, ceil(number_nasty_trials)), 2.*ones(1, ceil(number_nice_trials))]
 


rp1(n) = sum(trialvector==1)/numel(trialvector)

end

%% example script to calcuate 

clear all
close all
probability_nasty = 0.7;

needed_trials = [14 :70];



for n = 1:numel(needed_trials) 

number_nasty_trials = needed_trials(n) .* probability_nasty;
number_nice_trials = needed_trials(n) .* (1-probability_nasty);

real_probability = floor(number_nasty_trials)/(floor(number_nasty_trials)...
    +ceil(number_nice_trials));


trialvector = [ones(1, floor(number_nasty_trials)), 2.*ones(1, floor(number_nice_trials))];
 


rp1(n) = sum(trialvector==1)/numel(trialvector);

end

figure, hist(rp1)
mean(rp1)



%% example script to calcuate 

clear all
close all
probability_nasty = 0.7;

needed_trials = 14:2:22;



for n = 1:numel(needed_trials) 

number_nasty_trials = needed_trials(n) .* probability_nasty;
number_nice_trials = needed_trials(n) .* (1-probability_nasty);

real_probability = floor(number_nasty_trials)/(floor(number_nasty_trials)...
    +ceil(number_nice_trials));


trialvector = [ones(1, floor(number_nasty_trials)), 2.*ones(1, floor(number_nice_trials))]
 


rp1(n) = sum(trialvector==1)/numel(trialvector)

end

figure, hist(rp1)