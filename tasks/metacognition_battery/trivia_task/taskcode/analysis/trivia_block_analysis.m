function [summary_data, variable_names] = trivia_block_analysis(data_filepath, bloclen, print)
%% General purpose function to check accuracy per block from the trivia experiment
%

% Takes a subject file as input, and returns a vector with the accuracy for each block.
% Takes an optional input to define the number of trials per block
% Takes the option to make plots or not.
%if it does make plots, it plots
% 1) the average accuracy per block (with error bars, see my previous papers for example plot)
% 2) the staircase values across all trials separate for each condition.
% It can plot the estimated threshold (e.g., median signal value) as a horizontal line through the stimulus 'trace'.

% Micah Allen & Camile Correa, 2019

% snippet to check accuracy over blocks

%options.printFigure = 1;
%option.bloclen = 1



%% optional inputs


if nargin < 1
    
    [file, filepath] = uigetfile('*.mat');
    
    data_filepath = [filepath file];
    
    bloclen = 50;
    print = 1;
    
elseif nargin < 2

    print = 1;
    
   
    
end


%% load the data

load(data_filepath);


%% How do I make bloclen change in the function?
%bloclen =20;

res =results.Corrects;
numtrials = length(res);

trialvec = 1:numtrials;

bins= trialvec(1):bloclen:trialvec(end);
bins(end+1) = numtrials;

b_acc = zeros(1, numel(bins)-1);
b_err = zeros(1, numel(bins)-1);
label = {};

for b = 1:numel(bins)-1
    
    b_acc(b) = mean(res(bins(b):bins(b+1)-1));
    b_err(b) = std(res(bins(b):bins(b+1)-1))/sqrt(numel(res(bins(b):bins(b+1)-1)));
    label{b} = sprintf('Block%i', b); 
end

%% package outputs

summary_data = b_acc;
variable_names = label;

%% make figures

if print
    
    figure
    errorbar(b_acc,b_err)
    xlim([0 b+1])
    ylim([.5 1])
end


end


