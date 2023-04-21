function [results m] = memTest(subID, wPtr, rect, studyList, unstudiedList, studyTime, p, roundNum)

%get params for experiment
m = getMemParams(subID, studyList, unstudiedList);

if IsWin
    dataDir = [pwd '\memData\'];
else
    dataDir = [pwd '/memData/'];
end

if IsWin
    addpath([pwd '\functions']);
else
    addpath([pwd '/functions']);
end

KbName('UnifyKeyNames');

%initialize results struct
results.subID = m.subID;
results.studiedListNum = m.studiedListNum;
results.unstudiedListNum = m.unstudiedListNum;
results.studiedOrder = m.studiedPerm;
results.unstudiedOrder = m.unstudiedPerm;
results.studiedWordList = m.wordLists(results.studiedOrder,results.studiedListNum);
results.unstudiedWordList = m.wordLists(results.unstudiedOrder,results.unstudiedListNum);
results.studiedWord = {};
results.unstudiedWord = {};
results.studiedSide = {};
results.rtChoice = [];
results.rtConf = [];
results.responseChoice = {};
results.responseConf = [];

%screen center
[mx, my] = RectCenter(rect);
[p.mx,p.my] = RectCenter(rect);
%text positions
positions = [mx - 200, mx + 100];
fixCrossBlack = Screen('MakeTexture', wPtr, m.FixCrB);
fixCrossWhite = Screen('MakeTexture', wPtr, m.FixCrW);

%% Do some practice trials
if roundNum == 1
    Screen('TextSize',wPtr,24);
    DrawFormattedText(wPtr, 'Press any key to see a practice example...', 'center', 'center', m.textColor, [], [], [], 1.5);
    studyStart = Screen('Flip', wPtr);
    KbWait;
    
    practiceWords = {'TEA','RAISIN','PENGUIN','HEAVY','TOMORROW','MOONLIGHT','RUNNING','BICYCLE','HIGHWAY','BUFFALO','PAINTING','TODAY'};
    j=1;
    for i = 1:length(practiceWords)/2
        
        sidechoice = randperm(2);
        
        DrawFormattedText(wPtr,practiceWords{j}, positions(sidechoice(1)), 'center', m.textColor);
        DrawFormattedText(wPtr,practiceWords{j+1}, positions(sidechoice(2)), 'center', m.textColor);
        
        Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
        vbl = Screen('Flip',wPtr);
        
        FlushEvents;
        trialComplete = false;
        while ~trialComplete
            [k respTime keyCode] = KbCheck();
            if strcmp(KbName(keyCode),'LeftArrow') | strcmp(KbName(keyCode),'RightArrow')
                trialComplete = true;
            end
        end
        response = KbName(keyCode);
        rt = respTime - vbl;
        
        % show confirmation of response
        DrawFormattedText(wPtr,practiceWords{j}, positions(sidechoice(1)), 'center', m.textColor);
        DrawFormattedText(wPtr,practiceWords{j+1}, positions(sidechoice(2)), 'center', m.textColor);
        Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
        
        Screen('TextSize',wPtr,48);
        if strcmp(response, 'LeftArrow')
            DrawFormattedText(wPtr,'*', positions(1), my-100, m.textColor);
        elseif strcmp(response, 'RightArrow')
            DrawFormattedText(wPtr,'*', positions(2), my-100, m.textColor);
        end
        Screen('TextSize',wPtr,24);
        vbl = Screen('Flip',wPtr);
        pause(p.memConfirm_inSecs);
        
        if (k == 1)
            
            % now collect confidence
            [conf RT] = collectConfidenceDiscrete(wPtr,p);
            
        else
            DrawFormattedText(wPtr,'No response!','center','center');
            Screen('Flip',wPtr);
            pause(p.confFBDuration_inSecs + p.confDuration_inSecs);
            
        end
        j=j+2;
    end
end

%% Main experiment
% Get ready to see the display
Screen('TextSize',wPtr,24);
if roundNum == 1
    DrawFormattedText(wPtr, 'We will now show you the first list of words to study...', 'center', my-200, m.textColor, [], [], [], 1.5);
else
    DrawFormattedText(wPtr, 'We will now show you the next list of words to study...', 'center', my-200, m.textColor, [], [], [], 1.5);
end
DrawFormattedText(wPtr, 'Press any key to start studying!', 'center', 'center', m.textColor, [], [], [], 1.5);
studyStart = Screen('Flip', wPtr);
KbWait;

%display list to study
DrawFormattedText(wPtr,m.studyListDisplay1, mx-450, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay2, mx-250, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay3, mx-50, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay4, mx+150, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay5, mx+350, 'center', m.textColor, [], [], [], 1.5);
studyStart = Screen('Flip', wPtr);
disp(studyStart);
disp(studyTime);
disp(studyStart + (studyTime - 10));
%WaitSecs(studyTime - 10);
DrawFormattedText(wPtr,m.studyListDisplay1, mx-450, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay2, mx-250, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay3, mx-50, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay4, mx+150, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,m.studyListDisplay5, mx+350, 'center', m.textColor, [], [], [], 1.5);
DrawFormattedText(wPtr,'10 seconds left...', 'center', my*2 - 200, m.textColor, [], [], [], 1.5);
thirtySecsLeft = Screen('Flip', wPtr, studyStart + (studyTime - 10));
%WaitSecs(10);

DrawFormattedText(wPtr,m.instructions2, 'center', 'center', m.textColor);
Screen('Flip', wPtr, thirtySecsLeft + 10);
KbWait;

for i = 1:size(m.wordLists,1)
    
    sidechoice = randperm(2);
    
    DrawFormattedText(wPtr,results.studiedWordList{i}, positions(sidechoice(1)), 'center', m.textColor);
    DrawFormattedText(wPtr,results.unstudiedWordList{i}, positions(sidechoice(2)), 'center', m.textColor);
    Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
    vbl = Screen('Flip',wPtr);
    
    FlushEvents;
    trialComplete = false;
    while ~trialComplete
        [k respTime keyCode] = KbCheck();
        if strcmp(KbName(keyCode),'LeftArrow') | strcmp(KbName(keyCode),'RightArrow')
            trialComplete = true;
        elseif strcmp(KbName(keyCode),'ESCAPE')
            Screen('CloseAll')
            return
        end
    end
    response = KbName(keyCode);
    rt = respTime - vbl;
    
    % show confirmation of response
    DrawFormattedText(wPtr,results.studiedWordList{i}, positions(sidechoice(1)), 'center', m.textColor);
    DrawFormattedText(wPtr,results.unstudiedWordList{i}, positions(sidechoice(2)), 'center', m.textColor);
    Screen('DrawTexture', wPtr, fixCrossBlack,[],[mx-10,my-10,mx+10,my+10]);
    
    Screen('TextSize',wPtr,48);
    if strcmp(response, 'LeftArrow')
        DrawFormattedText(wPtr,'*', positions(1), my-100, m.textColor);
    elseif strcmp(response, 'RightArrow')
        DrawFormattedText(wPtr,'*', positions(2), my-100, m.textColor);
    end
    Screen('TextSize',wPtr,24);
    vbl = Screen('Flip',wPtr);
    pause(p.memConfirm_inSecs);
    
    %record results
    results.studiedWord{i} = results.studiedWordList{i};
    results.unstudiedWord{i} = results.unstudiedWordList{i};
    results.studiedSide{i} = m.positions(sidechoice(1));
    results.rtChoice(i) = rt;
    results.responseChoice{i} = response;
    
    if (k == 1)
        
        % now collect confidence
        [conf RT] = collectConfidenceDiscrete(wPtr,p);
        
        results.responseConf(i) = conf;
        results.rtConf(i) = RT;
    else
        DrawFormattedText(wPtr,'No response!','center','center');
        Screen('Flip',wPtr);
        pause(p.confFBDuration_inSecs + p.confDuration_inSecs);
        
        results.responseConf(i) = NaN;
        results.rtConf(i) = NaN;
    end
%     
%     if i == size(m.wordLists,1)/2   % give a break halfway through
%         DrawFormattedText(wPtr, 'Please take a break!', 'center', my-150, m.textColor, [], [], [], 1.5);
%         DrawFormattedText(wPtr, 'Press any key to answer the remaining questions on this list...', 'center', 'center', m.textColor, [], [], [], 1.5);
%         Screen('Flip', wPtr);
%         KbWait;
%     end
%     
end
