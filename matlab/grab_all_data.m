pardir = pwd;
datadir = [pardir '\data\Room 1A\'];
surveydir = [pardir '\data\surveys\'];

load subj_indx.mat

%% get trivia data


data = dir(fullfile(pwd, '**\triviaData*.mat'));
