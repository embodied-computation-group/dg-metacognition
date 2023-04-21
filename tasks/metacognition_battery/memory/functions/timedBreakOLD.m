function timedBreak(window,breakDuration,breakText,warningTime,keyboardNumber)
% timedBreak(window,breakDuration,breakText,warningTime)
%
% During a PTB experiment, take a break of predefined length. When the
% break is nearly over, display a countdown on the screen showing how many
% seconds are left.
%
% * breakDuration is the length of the break in seconds. If breakDuration
% is set to Inf, then the break ends when any button is pressed.
% * breakText is the text that is displayed to the subject during the
% break (e.g. "break time", or feedback on recent performance, etc).
% * warningTime specifies when the countdown for the break begins to be
% displayed. The countdown appears when there are warningTime seconds left
% in the break. If warningTime is not specified, no countdown is provided.

t0 = GetSecs;

if exist('warningTime','var') && warningTime > 0
    showWarning = 1;
else 
    showWarning = 0;
end

DrawFormattedText(window,breakText,'center','center');
Screen('Flip',window);

%% break ends when user presses button
if breakDuration == Inf
    KbWait(keyboardNumber);
    return

%% break ends in specified time; countdown warning is shown
elseif showWarning
    while GetSecs - t0 < breakDuration - warningTime, ;, end
    while GetSecs - t0 < breakDuration
        remainingTime_inSecs = breakDuration - ceil(GetSecs - t0) + 1;
        [nx ny] = DrawFormattedText(window,breakText,'center','center');
        DrawFormattedText(window,['\n\nexperiment resumes in\n' num2str(remainingTime_inSecs) ' seconds'],'center',ny);
        Screen('Flip',window);
    end
else
    
%% break ends in specified time, no countdown
    while GetSecs - t0 < breakDuration, ;, end
end