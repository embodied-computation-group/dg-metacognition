

%% get all data
 addpath('C:\Users\Micah Allen\Google Drive\ECG_root\Projects\in_progress\Domain_General_Metacognition\COBE_LAB\analysis')


clear all; close all
data = dir(fullfile(pwd, '**\triviaData*.mat'));


% loop over data


acc_data =[];
conf_data = [];


for n = 1:numel(data)
    
clear results
load(fullfile([data(n).folder '\' data(n).name]))

results.Confidence = discretize(results.Confidence, 7);

acc1 = results.Corrects(results.WhichCondition == 1);
acc2 = results.Corrects(results.WhichCondition == 2);


conf1 = results.Confidence(results.WhichCondition == 1);
conf2 = results.Confidence(results.WhichCondition == 2);




acc_data(n,:) = [mean(acc1) mean(acc2)];
conf_data(n, :) = [nanmean(conf1) nanmean(conf2)];









    
end




%% accuracy plot

[cb] = cbrewer('qual', 'Set3', 12, 'pchip');


cl(1, :) = cb(4, :);
cl(2, :) = cb(1, :);


d = {acc_data};
figure; %subplot(1,2,1); hold on

h1 = raincloud_plot(acc_data(:,1), 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0)

h2 = raincloud_plot(acc_data(:,2), 'box_on', 1, 'color', cb(4,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);

 
% legend([h1{1} h2{1}], {'GDP', 'Calories'});
 
set(gca,'XLim', [0.5 0.85], 'YLim', [-8 20]);
xlabel('Accuracy')


%% confidence


[cb] = cbrewer('qual', 'Set3', 12, 'pchip');


cl(1, :) = cb(4, :);
cl(2, :) = cb(1, :);

figure; hold on
%subplot(1,2,2); hold on

h1 = raincloud_plot(conf_data(:,1), 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);

h2 = raincloud_plot(conf_data(:,2), 'box_on', 1, 'color', cb(4,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .35, 'dot_dodge_amount', .35, 'box_col_match', 0);

 
 legend([h1{1} h2{1}], {'GDP', 'Calories'});
 
set(gca,'XLim', [1 7], 'YLim', [-0.3 1]);
xlabel('Confidence')
 
 

%% 

% results.WhichCondition
% results.Reversal
% results.S.Signal

%%
signal1 = results.DifferenceTarget(results.WhichCondition == 1);
signal2 = results.DifferenceTarget(results.WhichCondition == 2);
acc1 = results.Corrects(results.WhichCondition == 1);
acc2 = results.Corrects(results.WhichCondition == 2);

%%

figure; hold on, subplot(3,1,1)

plot(1:numel(signal1), signal1, '-o')


subplot(3,1,2)

plot(1:numel(signal2), signal2, '-o')

subplot(3,1,3)

bar(1:2, [mean(acc1) mean(acc2)]); ylim([.5 1])

[mean(acc1) mean(acc2)]