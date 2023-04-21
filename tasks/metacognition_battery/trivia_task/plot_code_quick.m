
close all

f1 = figure('Position', [10 100 1000 500])

%% condition 1

signal_gdp = results.DifferenceTarget(results.WhichCondition ==1);
signal_calories = results.DifferenceTarget(results.WhichCondition ==2);
subplot(2,2,1); hold on
plot(1:length(signal_gdp), signal_gdp, '-*')

hline = repmat(median(signal_gdp), 1, length(signal_gdp));
plot(1:length(signal_gdp), hline, '-k')
legend('Signal', 'Threshold')
ylabel('Log GDP Difference')
xlabel('trial')

title('GDP Staircase')
xlim([0 100])
ylim([0 3])

%% condition 2

subplot(2,2,3); hold on

hline = repmat(median(signal_calories), 1, length(signal_calories));
plot(1:length(signal_calories), signal_calories, '-*r')
plot(1:length(signal_calories), hline, '-k')

legend('Signal', 'Threshold')

ylabel('Calorie Difference')
xlabel('trial')

xlim([0 100])
ylim([0 600])

title('Calorie Staircase')

%%

%figure;

accuracy_gdp = results.Corrects(results.WhichCondition ==1);
accuracy_food = results.Corrects(results.WhichCondition ==2);


rt_gdp = [results.RTS(results.WhichCondition ==1)]/1000;
rt_food = results.RTS(results.WhichCondition ==2)/1000;

rt_gdp = rt_gdp(1:90);
rt_food = rt_food(1:90);


%figure

%
subplot(2,2,2)
%notBoxPlot([rt_gdp', rt_food'])
gdpcol = [0.5 0.5 1];
calcol = [1 0.5 0.5];

raincloud_plot([rt_gdp], 'alpha', 0.5, 'color', gdpcol,...
    'box_on', 1, 'box_dodge', 1, 'box_dodge_amount', .20, 'box_col', gdpcol)
%set(gca, 'XTickLabel', {'GDP';'Calories'})
raincloud_plot([rt_food], 'alpha', 0.5, 'color', calcol,...
    'box_on', 1, 'box_dodge', 1, 'box_dodge_amount', .6, 'box_col', calcol)

xlabel('Reaction Time (seconds)')
ylabel('Probability Density')
title('Reaction Time')

subplot(2,2,4)

bar([1 2], [mean(accuracy_gdp), mean(accuracy_food)]); hold on
errorbar([1 2], [mean(accuracy_gdp) mean(accuracy_food)], [SEM_calc(accuracy_gdp) SEM_calc(accuracy_food)], '-k', 'LineStyle','none', 'LineWidth', 2)

ylabel('Hit Rate')
set(gca, 'XTickLabel', {'GDP';'Calories'})
set(gca, 'YTick', [0:.25:1], 'YTickLabel', [0:.25:1])
title('Accuracy')

print(f1, 'LW_p1_performance_trivia.jpg', '-djpeg', '-r300')