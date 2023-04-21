function params = getMemParams(subID, studyList, unstudyList)

params.subID = subID;

params.studiedListNum = studyList;

params.unstudiedListNum = unstudyList;

params.time = clock;

params.FixCrB=ones(20,20) * 127;
params.FixCrB(10:11,:)=0;
params.FixCrB(:,10:11)=0;

params.FixCrW=ones(20,20) * 127;
params.FixCrW(10:11,:)=80;
params.FixCrW(:,10:11)=80;


% params.rightPosition;
% params.leftPosition; 

params.positions = 'lr';

[notUsed, params.wordLists] = xlsread('wordLists.xls');
params.studiedPerm = randperm(size(params.wordLists,1));
params.unstudiedPerm = randperm(size(params.wordLists,1));


params.textColor = [0 0 0];
params.bgColor = [127 127 127];

                    
params.instructions1 = strcat('You will be presented with 50 words on the screen.\n',...
                             'You will be given x minute(s) to memorize as many of them as you can.\n',...
                             'After the time is up, you will be tested on which words were on this list.\n\n',... 
                             'Do your best to remember as many of them as you can.  Good luck!\n\n',...
                             'Please press any key to continue. The word list will be shown on the screen\n',...
                             'and your time will start the moment you press any key.');
                         

params.studyListDisplay1 = '';
params.studyListDisplay2 = '';
params.studyListDisplay3 = '';
params.studyListDisplay4 = '';
params.studyListDisplay5 = '';

for i = 1:10
        params.studyListDisplay1 = strcat(params.studyListDisplay1, params.wordLists{i,studyList}, '\n');
        params.studyListDisplay2 = strcat(params.studyListDisplay2, params.wordLists{i+10,studyList}, '\n');
        params.studyListDisplay3 = strcat(params.studyListDisplay3, params.wordLists{i+20,studyList}, '\n');
        params.studyListDisplay4 = strcat(params.studyListDisplay4, params.wordLists{i+30,studyList}, '\n');
        params.studyListDisplay5 = strcat(params.studyListDisplay5, params.wordLists{i+40,studyList}, '\n');
end                                        
                   
params.instructions2 = strcat('Time''s up!\n\n',...
    'Remember to use the left or right arrow key to indicate which word\n',...
    'was on the list. Then use the same keys to rate\n',...
    'your confidence on the sliding scale.\n\n\n',...
    'Press any key to begin the test.'); 
                       

% params.fileName=['memExpData' params.subID{1} '_' num2str(studyList) '.mat'];







