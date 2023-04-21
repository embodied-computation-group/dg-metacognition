function [summary_data, variable_names] = summarize_trivia_data_ma(data_filepath, options)
%% General purpose function to summarize data from a metacognition experiment
% Takes a path to the subjects data and a structure of options as inputs. 
% Produces a vector of summary data for each condition and variable of
% interest. 
%
% Options include:
% options.printFigure, a binary flag to produce some diagnostic figures
% options.estimateModel, a binary flag to fit the meta-dprime model or not
%
%
% Micah Allen & Camille Correa, 2019

%% make inputs optional

if nargin < 2
    
    options.printFigure = 1;
    options.estimateModel = 1;

end


if nargin < 1
    
    [file, filepath] = uigetfile('*.mat');
  
    data_filepath = [filepath file];
         
end

%% load the data

load(data_filepath)


%% first, pull out the variables we need and put them in a new struct


raw_results = struct;
raw_results.confidence = results.Confidence;
raw_results.accuracy = results.Corrects;
raw_results.rt = results.RTS./1000;
raw_results.signal = results.DifferenceTarget;

conditions = results.WhichCondition;

%% exclude trials....



%%

nconditions = max(conditions); % 1 = food, 2 = gdp
variables = fieldnames(raw_results);
condition_names = {'food', 'gdp'};
summary_data = [];
variable_names = {};
counter = 0;

for this_variable = 1:length(variables)
    
    for this_conditon = 1:nconditions
        
    counter = counter+1;
    mean_data = nanmean(raw_results.(variables{this_variable})(conditions == this_conditon));   
    var_data = nanstd(raw_results.(variables{this_variable})(conditions == this_conditon));
    
   % summary_data = [summary_data, mean_data, var_data]
    summary_data = [summary_data, mean_data];
    
    variable_names{counter} = ['mean_' variables{this_variable} '_' condition_names{this_conditon}];
    
    end
    
end






%% produce some figures

if options.printFigure
   
figure 
bar(summary_data)
    
end



end