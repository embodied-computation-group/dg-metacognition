function [summary_data] = summarize_trivia_data(data_filepath, options)
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


%% This part will get Threshold, choice accuracy, confidence and RT per condition

%% create a condition index

Cond1 = results.WhichCondition == 1;
Cond2 = results.WhichCondition == 2;


% Percentage correct for cond1
CorrectCond1 = results.Corrects(Cond1);


% Percentage correct for cond2
CorrectCond2 = results.Corrects(Cond2);


% Getting the threshold for each condition
ThresholdCond1 = results.DifferenceTarget(Cond1);

mean(ThresholdCond1);%1.4090

ThresholdCond2 = results.DifferenceTarget(Cond2);

mean(ThresholdCond2);%195.6019


% Getting the confidence for each condition
ConfidenceCond1 = results.Confidence(Cond1);

mean(ConfidenceCond1); %64.62

ConfidenceCond2 = results.Confidence(Cond2);

mean(ConfidenceCond2) ; %72.32


% Getting the RT for choices in each condition
RTChoiceCond1 = results.RTS(Cond1)/1000;

mean(RTChoiceCond1);%2.98

RTChoiceCond2 = results.RTS(Cond2)/1000;

mean(RTChoiceCond2); %2.36


%Output vector of these to summary_data

summary_data = [mean(CorrectCond1) mean(ThresholdCond1) mean(ConfidenceCond1) mean(RTChoiceCond1)...
   mean(CorrectCond2) mean(ThresholdCond2) mean(ConfidenceCond2) mean(RTChoiceCond2) ];





fprintf('\n**Accuracy Condition 1 was %.2f%%**\n', nanmean(CorrectCond1)*100)
fprintf('\n**Accuracy Condition 2 was %.2f%%**\n', nanmean(CorrectCond2)*100)








%% produce some figures

if options.printFigure
   
figure 
bar(summary_data)
    
end



end