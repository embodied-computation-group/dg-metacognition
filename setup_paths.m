
function params = setup_paths()
%% run this function from the parent directory ./dg-metacognition before running the data extraction.
% Micah Allen, 2021


params = struct;
params.pardir = pwd;

%%
tf = ispc;

if tf
    params.filesep = '\';

else
    params.filesep = '/';
    
end


%%

% dir for raw subject data
params.rawdatdir = [params.pardir params.filesep 'data_raw' params.filesep 'matfiles' params.filesep];
addpath(params.rawdatdir)


%  dir for summary table data & surveys
params.sumdatdir = [params.pardir params.filesep 'data_summary' params.filesep];
addpath(params.sumdatdir)

% dir for figures
params.figdir = [params.pardir params.filesep 'figures' params.filesep];
addpath(params.figdir)


% dir for matlab code
params.matlabdir = [params.pardir params.filesep 'matlab' params.filesep];
addpath(params.matlabdir)

end


