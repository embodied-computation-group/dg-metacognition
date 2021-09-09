%% run path initialization
clear all; close all; clc

params = setup_paths;

%% import data ids and create subject vector

data_master_file = [params.sumdatdir 'data_master.csv'];
data_master = readtable(data_master_file);

sID = data_master.sID;
exclude = logical(data_master.exclude);
excluded_subjects = sID(exclude);

params.sID = sID(~exclude);

%%

[all_mem_data, all_trivia_data, all_percept_data, all_data] = merge_all_data(params);
