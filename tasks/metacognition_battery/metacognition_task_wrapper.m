    function out = metacognition_task_wrapper(task, sID)
%% wrapper function to excute metacognition tasks
% task as input a string task selector and subject ID string.
%
% tasks=
% 'memory'
%  'vision'    
 %  'trivia' 

 %% setup inputs

setup_paths;

tasklist = {'memory', 'vision', 'trivia'};

if nargin < 1
    
    sID = inputdlg('Please Enter the sID');
    sID = sID{:};
    
    [which_task] = listdlg('ListString',tasklist);
    
    task = tasklist{which_task};

elseif nargin < 2
    sID = inputdlg('Please Enter the sID');
    sID = sID{:};
    

    
end

%% excute task

switch task
    
    case 'memory'
    clc
    fprintf('%%%%\n\n %%%% RUNNING %s TASK\n\n%%%%', task)
        
    % add memory paths
    addpath(genpath(memdir))
    
    % cd to task dir
    cd(memdir)
    
    % execute task
    memWrapper(1, sID)
    
    % cd back to parent dir and reset path
    cd(parent_dir)
    rmpath(genpath(memdir))
    
    case 'vision'
  
    clc
    fprintf('%%%%\n\n %%%% RUNNING %s TASK\n\n%%%%', task)
  
        
    % add memory paths
    addpath(genpath(visiondir))
    
    % cd to task dir
    cd(visiondir)
    
    % execute task
    perceptWrapper(sID) 
    
    % cd back to parent dir and reset path
    cd(parent_dir)
    rmpath(genpath(visiondir))    
        
   
    case 'trivia'
    clc
    fprintf('%%%%\n\n %%%% RUNNING %s TASK\n\n%%%%', task)
  
    % add memory paths
    addpath(genpath(triviadir))
    
    % cd to task dir
    cd(triviadir) 
    
    % execute task
    
    %triviaWrapper(sID)
    triviaWrapper(sID)
    
    % cd back to parent dir and reset path
    cd(parent_dir)
    rmpath(genpath(triviadir))    
    
    otherwise
        
    errordlg('No task specified!')
        
end

%% clean up

%% copy data to export dir - OVERWRITES DATA 
setup_paths
cd(parent_dir)

datfiles = subdir(fullfile('*Data*mat'));

for n = 1:length(datfiles)
    
   
copyfile(datfiles(n).name, [proj_dir '\all_data\'], 'f')    
    
end
    


end