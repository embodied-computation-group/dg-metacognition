pardir = pwd;
%datadir = [pardir '\data\Room 1A\'];
%this is now:
datadir = [pardir '\data\Room 1A divided by days\'];
surveydir = [pardir '\data\surveys\'];
metadir = [pardir '\data\metadata\'];
%% trivia

data = dir(fullfile(datadir, '**\triviaData*.mat'));

for n = 1:length(data)
   
    
copyfile(fullfile([data(n).folder '\' data(n).name]), [metadir data(n).name], 'f')


    
    
end

%% vision


data = dir(fullfile(datadir, '**\perceptData*.mat'));

for n = 1:length(data)
   
    
copyfile(fullfile([data(n).folder '\' data(n).name]), [metadir data(n).name], 'f')


    
    
end


%% memory


data = dir(fullfile(datadir, '**\memExp*.mat'));

for n = 1:length(data)
   
    
copyfile(fullfile([data(n).folder '\' data(n).name]), [metadir data(n).name], 'f')


    
    
end