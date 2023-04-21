
%% setup
clear all
close all
clc

% Camile is adding the 2 paths manually, bcs the addpaths below dont work.

%% Add path to the general lab function folder 

% for windows
%addpath('..\..\..\Code\MatlabToolboxes\general_functions')% Micah original

if ispc
    addpath('..\..\..\Code\MatlabToolboxes\general_functions')
else
    
    % for mac
    %addpath('Users/au632191/Google Drive/ECG_root/Code/MatlabToolboxes/general_functions')
    
    
    
    %addpath ('Users/au632191/Google Drive/ECG_root/Projects/Domain_General_Metacognition/trivia_task')
    
end
%% setup project specific paths

setup_trivia_paths % this goes to another .m and creates the directories


%% example wraper script with imaginary function
subject_id = [1 2]; % later we'll create this by loading the data master... 
subj_prefix = 'triviaData_cam';
nSubjects = length(subject_id);


options = struct;
options.printFigure = 1;
options.estimateModel = 2;
subject_summary_data = [];

for n = 1:nSubjects
    

%% create a string with the path to the subject    


if ispc
    subject_data_file = [data_directory '\' subj_prefix int2str(subject_id(n)) '.mat']; 
    
else
    subject_data_file = [data_directory '/' subj_prefix int2str(subject_id(n)) '.mat']; 
end




%% Now, run the summary function to get outputs



[subject_summary_data(n,:), colnames] = summarize_trivia_data_ma(subject_data_file, options);
[subject_bacc, variable_names] = trivia_block_analysis(subject_data_file, options);
    
end


%% write the data to a csv file! 

csvwriteh('example_data.csv', subject_summary_data, colnames)

%% Future trivia_analysis_block function

%[subject_summary_data(n,:), colnames] = trivia_block_analysis(subject_data_file, options);