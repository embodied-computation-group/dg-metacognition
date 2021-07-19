%% run path initialization

setup_paths


%% import data ids

import_data_master %which is a 331 X 6 table

%%
%Camile excluding
datamaster([53, 54, 63, 104, 109, 168, 252, 273, 323],:) = [];
%size(datamaster) %now it is a 322 x 6 table

sID = datamaster.sID;

save sID sID


%% collect data

move_data

%%

merge_all_data
%'missing subject 330, skipping'
