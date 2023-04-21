%% example script to index pairwise items within a difference range
% 
% v1.0
% This is just a barebones example for going from a table of values and 
% image file paths to an index of which specific two images you want to
% show based on some difference criteria. Future tweaks could, e.g., 
% add flexiblity to make item 1 > item 2 or item 1 < item 2, and/or to
% round staircase values to the nearest whole number in the selected items.
% Another optional addition is to set some logic so that the selected
% difference is based on a higher or lower total calorie pair. 
%
% v1.1
%
% actually, the cool thing about it being a matrix is to make image 1 >
% image 2 or vice versa, you just change the sign of the difference target!
%
% micah allen, 2018

%% first, create some example data with random calorie values. 
clear all
calories = randi(10,1,100);

% also, we need some data labels
pre = 'food';
suff = '.png';

labels = {};
for k = 1:100
    labels = [labels;[pre,num2str(k,'%02d'), suff]];
end

%% now we want to sort the calories by ascending, and also the 
%  labels so we can look them up later


[calories, sort_index] = sort(calories, 'descend');

% and sort the labels by the same order

labels = labels(sort_index);


%% now create a matrix of all the pairwise differences

for r = 1:length(calories)
    
    for c = 1:length(calories)
    
    
diff_square(r,c) = calories(r) - calories(c);

    end    
    
end


%% now we need to find items in the table matching our difference

differenceTarget = 1; % for example - should be set from staircase on each trial

[row, col] = find(diff_square == differenceTarget);

% create vector of suitable pairs

coords = [row, col];

% select random pair from all suitable - could be made more complex

this_pair = coords(randi(length(coords)),:);


label_1= labels{this_pair(1)};
label_2= labels{this_pair(2)};

%% illustrate it works
% 
diff_idx = find(diff_square == differenceTarget);
diff_square_mask = diff_square;
diff_square_mask(diff_idx) = nan;


figure
subplot(2,1,1)
imagesc(diff_square); colorbar

subplot(2,1,2)
imagesc(diff_square_mask); colorbar; 
axis on
hold on
plot(this_pair(2),this_pair(1), 'r+', 'MarkerSize', 30, 'LineWidth', 2);
%text(this_pair(2), this_pair(1), [label1, label2])
xlabel(['im1:' label_1 ' im2: ' label_2])
%set(gca, 'XTickLabel', 1:100)
