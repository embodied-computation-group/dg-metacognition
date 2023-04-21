
%% Load Mat files
p.list_countries = load('list_countries_complete.mat');
p.list_food = load('list_food_complete.mat');

%% Create a matrix of all the pairwise differences
p.diff_square = cell(2,1);

% Food  




calories = round(p.list_food.numList(:,1));
diff_square =[];

for r = 1:length(calories)
    for c = 1:length(calories)
        diff_square(r,c) = calories(r) - calories(c);
    end
end

p.diff_square{1}=diff_square; 

%%


% countries
% 
% Create a matrix of all the pairwise differences - RANK FROM ORDER
gdp = log(p.list_countries.numList);
diff_square = [];

for r = 1:length(gdp)
    for c = 1:length(gdp)
        diff_square(r,c) = gdp(r) - gdp(c);
    end
end

p.diff_square{2}=round(diff_square, 3, 'significant'); 






%% countries
test_square = p.diff_square{2};

test_square = round(test_square, 3, 'significant');




%%
clear check
tick = 0.1:0.01:5;
tick = round(tick, 3, 'significant');
check = [];
numpairs = [];
for n = 1:numel(tick)
    
check(n) =  isempty(find(test_square == tick(n))); 
numpairs(n) = numel(find(test_square == tick(n)));
end





%% foods

test_square = p.diff_square{1};

clear check
tick = 1:1:500;
tick = round(tick);
check = [];
numpairs = [];
for n = 1:numel(tick)
    
check(n) =  isempty(find(test_square == tick(n))); 
numpairs(n) = numel(find(test_square == tick(n)));
end



%%
find(test_square == tick(n))

figure; imagesc(check); colormap(gray)
sum(check)
check = logical(check)

empties = tick(check)

tick(check)

%%
find(test_square == tick(3))

[val, idx] = min(abs(test_square-tick(3)))

%%
find(test_square == 0.1)














%% there is pretty good coverage for steps sizes of 0.05 and 0.01 (log scale) size. We can try 
% to just round up or down when a missing coverage (a place with no
% corresponding pair for the requested stimulus values is given). To be
% fancy we can even round up or down depending on if the previous trial was
% correct or incorrect. Need to figure out how to find the nearest
% value.... 



while no_match
    
    if positive_step
    
    stimulus_target = stimulus_target + stepsize
    
    if negative_step
        
    stimulus_target = stimulus_target - stepsize
    
    nomatch = find... 
        
    end
    end
end
this would effectively continue stepping up or down the staircase until a match is found... 
    

    
    