%% script to setup paths for analyzing trivia task data
% run this script from the 

%% first, set up a dynamic path to the parent directory

if ispc
    parent_directory = pwd;
else
    parent_directory = '/Users/au632191/Google Drive/ECG_root/Projects/Domain_General_Metacognition/trivia_task';
    addpath (parent_directory)
end


if ispc
    
    code_directory = [parent_directory '\code\analysis'];
    figure_directory = [parent_directory '\figures'];
    data_directory = [parent_directory '\data'];
    
else
    
    code_directory = [parent_directory '/code/analysis'];
    figure_directory = [parent_directory '/figures'];
    data_directory = [parent_directory '/data'];
    
end



addpath(code_directory)
addpath(figure_directory)
addpath(data_directory)

