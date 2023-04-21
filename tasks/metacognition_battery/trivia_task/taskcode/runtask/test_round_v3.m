
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

gdp = log(p.list_countries.numList);
diff_square = [];

for r = 1:length(gdp)
    for c = 1:length(gdp)
        diff_square(r,c) = gdp(r) - gdp(c);
    end
end

p.diff_square{2}=round(diff_square, 3, 'significant'); 



%%

differenceTarget = round(0.872, 3, 'significant');
[row, col] = find(p.diff_square{2} == differenceTarget);
      coords = [row, col]

%%
    % create vector of suitable pairs
    
    coords = [row, col];
    
    if isempty(coords)
        
        matrix = p.diff_square{condition}; ref = differenceTarget;
        [value, ii] = min(abs(matrix(:)-ref));    %// linear index of closest entry
        [row, col] = ind2sub(size(matrix), ii);
        
        coords = [row, col];
    end