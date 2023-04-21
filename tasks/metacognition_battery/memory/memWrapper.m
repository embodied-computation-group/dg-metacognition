function memWrapper(screenSize, sID)

%initialize idiomatic stuff for starting psychtoolbox
AssertOpenGL;
%screenSize = input('screen? 1=full, 2=test, 3=alt ')
%screenSize = 2;
Screen('Preference', 'SkipSyncTests', 0);
KbName('UnifyKeyNames');
PsychJavaTrouble()      
KbCheck;

if IsWin
    addpath([pwd '\functions']);
else
    addpath([pwd '/functions']);
end

olddebuglevel = Screen('Preference', 'VisualDebugLevel', 3);

%get params for experiment
%p = getExpParams;
p = getExpParams(sID);

p.subID = sID;


%if duplicate subID abort
if p.isTaken == 1;
    return
end

%open full screen window on main screen and set gamma to flat
if screenSize == 1
    screenDim = [];
    screenNum = 0;
elseif screenSize == 2
    screenDim = [0 0 500 500];    % set to [] for full screen
    screenNum = 0;
else
    screenDim = [];
    screens=Screen('Screens');
    screenNum=max(screens);
end

[wPtr,rect]=Screen('OpenWindow',screenNum, p.bgColor, screenDim);
HideCursor;
[p.midW p.midH] = getScreenMidpoint(wPtr);
i = 1;
if mod(p.listGroup,2) == 0
    i = -1;
end

roundNum = 1;
mem_instructions(wPtr, p, roundNum);
[results m] = memTest(p.subID, wPtr, rect, p.studyListOrder(1), p.studyListOrder(1) + i, p.studyTimeOrder(1), p, roundNum);
m.fileName=['memExpData_' p.subID '_' num2str(roundNum) '.mat']; %was curly brackets subID for ALL FOUR
cd data
save(m.fileName, 'results', 'p', 'm');
cd ..

roundNum = 2;
[results m] = memTest(p.subID, wPtr, rect, p.studyListOrder(2), p.studyListOrder(2) + i, p.studyTimeOrder(2), p, roundNum);
m.fileName=['memExpData_' p.subID '_' num2str(roundNum) '.mat'];
cd data
save(m.fileName, 'results', 'p', 'm');
cd ..

roundNum = 3;
[results m] = memTest(p.subID, wPtr, rect, p.studyListOrder(3), p.studyListOrder(3) + i, p.studyTimeOrder(3), p, roundNum);
m.fileName=['memExpData_' p.subID '_' num2str(roundNum) '.mat'];
cd data
save(m.fileName,'results', 'p', 'm');
cd ..

roundNum = 4;
[results m] = memTest(p.subID, wPtr, rect, p.studyListOrder(4), p.studyListOrder(4) + i, p.studyTimeOrder(4), p, roundNum);
m.fileName=['memExpData_' p.subID '_' num2str(roundNum) '.mat'];
cd data
save(m.fileName,'results', 'p', 'm');
cd ..

Screen('CloseAll');
ShowCursor;