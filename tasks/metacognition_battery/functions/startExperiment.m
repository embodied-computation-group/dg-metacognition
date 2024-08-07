function startData = startExperiment(experimentName, subID, inStage)



disp('working from directory')
disp([pwd ' ...'])
disp(' ')

if IsWin
    dataDir = [pwd '\gfcData\'];
else
    dataDir = [pwd '/gfcData/'];
end


subjectID = subID{1};

stage = inStage;

%% check stage 1 
% if stage is 1,
% make sure this subject/stage combination is not already taken
if stage == 1

    % check if this filename is OK
    currentFile = [experimentName ' ' subjectID ' stage ' num2str(stage) '.mat'];

    % check inputs
    d = dir(dataDir);

    isTaken = 0;

    for i = 1:length(d)
        if strcmp(currentFile,d(i).name)
            disp(' ')
            disp(' ')
            disp('This subjectID / stage combination is already taken! Please use a different subject ID.');
            disp(' ')
            disp(' ')

            isTaken = 1;
        end

    end

    startData.isTaken = isTaken;
    startData.did_stage1 = 1;
    if isTaken, return, end

%% check stage 2
elseif stage == 2
    
%% make sure there is stage 1 data for this subject 
    
    fileStage1 = [experimentName ' ' subjectID ' stage 1.mat'];

    % check inputs
    d = dir(dataDir);
    did_stage1 = 0;

    for i = 1:length(d)
        if strcmp(fileStage1,d(i).name)
            did_stage1 = 1;
        end
    end

    if ~did_stage1
        disp(' ')
        disp(' ')
        disp('You entered stage 2, but there is no stage 1 data for this subject ID! exiting program.')
        disp(' ')
        disp(' ')

    end

    startData.isTaken = 0;
    startData.did_stage1 = did_stage1;
    if ~did_stage1, return, end


%% get the unique numbering for this stage 2 block    
    suffix = 1;
    currentSuffixTaken = 1;  
    currentFile = [experimentName ' ' subjectID ' stage ' num2str(stage) '-' num2str(suffix) '.mat'];

    while currentSuffixTaken
        currentSuffixTaken = 0;
        for i = 1:length(d)
            if strcmp(currentFile,d(i).name)
                currentSuffixTaken = 1;
            end
        end
        
        if currentSuffixTaken
            suffix = suffix + 1;
        end

        currentFile = [experimentName ' ' subjectID ' stage ' num2str(stage) '-' num2str(suffix) '.mat'];
    
    end
    
end


% get condition
% if stage==1
%     cond = '';
%     while ~(strcmp(cond,'A') || strcmp(cond,'B'))
%         cond = input('What cond? (A or B):   ','s');
%     end
%     startData.cond = cond;
% end


% load contrast
if stage == 2
    load([dataDir fileStage1]);
    startData.contrast = 10^(median(QuestMean(q)));
end

startupTime = clock;
    
dataFile = [dataDir currentFile];

startData.dataDir             = dataDir;
startData.dataFile            = dataFile;
startData.startupTime         = startupTime;
startData.subjectID           = subjectID;
startData.stage               = stage;
