function summary_data = summarize_mem_data(datacol, plot)

pardir = pwd;
datadir = [pardir '\data\Room 1A\'];
surveydir = [pardir '\data\surveys\'];
metadir = [pardir '\data\metadata\'];

load sID

summary_data = [];

%% Some cute code to summarize mem data
for n=1:numel(sID)
    
    clear all_data
    combined_file = [metadir sprintf('%03d', sID(n)) '_mem_combined.mat'];
    
    try
        load(combined_file)
        
        %% col 2 is accuracy
        
        this_subject_data = nanmean(all_data(:,datacol));
        
        summary_data(n) = this_subject_data;
    catch
        
        summary_data(n) = nan;
        
        
    end
    
end


%% plots
if plot
figure

[cb] = cbrewer('qual', 'Set3', 12, 'pchip');


cl(1, :) = cb(4, :);
cl(2, :) = cb(1, :);

h1 = raincloud_plot(summary_data, 'box_on', 1, 'color', cb(1,:), 'alpha', 0.5,...
     'box_dodge', 1, 'box_dodge_amount', .15, 'dot_dodge_amount', .15,...
     'box_col_match', 0);
 
end
 
end

