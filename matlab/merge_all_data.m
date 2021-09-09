function [all_mem_data, all_trivia_data, all_percept_data, all_data] = merge_all_data(params)


%% get memory, trivia, and percept data
all_mem_data = combine_mem_data(params);

all_trivia_data = combine_trivia_data(params);

all_percept_data = combine_percept_data(params);

%% concatenate into one giant matrix

all_data = vertcat(all_mem_data,all_trivia_data);
all_data = vertcat(all_data,all_percept_data);


%% write data to dir
filename = [params.sumdatdir 'metacognition_trialData_master.csv'];
writetable(all_data, filename)


end