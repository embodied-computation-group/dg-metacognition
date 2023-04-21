function p = getExpParams(sID)
% Modified by SF 24/10/12 to have only one day, six sessions


p.subID = int2str(sID);
p.textColor = [0 0 0];
p.bgColor = [127 127 127];
p.sittingDist = 60; % in cm

p.exitKey='ESCAPE';

if IsOSX
    p.keyboardNumber = getKeyboardNumber;
else
    p.keyboardNumber = [];
end

p.isTaken = 0;
% p.age = inputdlg('Age? ','Age');
% p.gender = inputdlg('Gender? M/F','Gender');
% p.hand = inputdlg('Handedness? R/L ','Hand');

% check if this filename is OK
p.filename = ['memData' p.subID '.mat'];
%p.filename = ['memData' int2str(sID) '.mat'];


if IsWin
    dataDir = [pwd '\memData\'];
else
    dataDir = [pwd '/memData/'];
end

% check inputs
d = dir(dataDir);

for i = 1:length(d)
    if strcmp(p.filename,d(i).name)
        disp('This subjectID / day combination is already taken! Please use a different subject ID.');
        p.isTaken = 1;
        return
    end
end

p.filename = [dataDir p.filename];

% confidence scale
p.VASwidth_inDegrees = 6;
p.VASheight_inDegrees = 2;
p.VASoffset_inDegrees = 0;
p.arrowWidth_inDegrees = 0.5;


p.VASwidth_inPixels = degrees2pixels(p.VASwidth_inDegrees, p.sittingDist);
p.VASheight_inPixels = degrees2pixels(p.VASheight_inDegrees, p.sittingDist);
p.VASoffset_inPixels = degrees2pixels(p.VASoffset_inDegrees, p.sittingDist);
p.arrowWidth_inPixels = degrees2pixels(p.arrowWidth_inDegrees, p.sittingDist);

% Stimulus timings

p.chDuration_inSecs       = 0.7;
p.memDuration_inSecs = Inf;
p.memConfirm_inSecs = .5;
p.confDuration_inSecs = 4;
p.confFBDuration_inSecs = 0.25;
p.ITIDuration_inSecs      = 0.25;  % extra time at end of trial to finalize data collection

%% STUDY TIME ORDER, FULLY RANDOMIZED

p.studyTimes = [0.5 1 1 1.5]*60;
p.studyTimeShuff = Shuffle([1 2 3 4]);
p.studyTimeOrder = p.studyTimes(p.studyTimeShuff);

%% study list orders, counterbalenced by 1-6 number
p.studyListOrder1 = [1 3 5 7 9 11];
p.studyListOrder2 = [2 4 6 8 10 12];
p.studyListOrder3 = [11 9 7 5 3 1];
p.studyListOrder4 = [12 10 8 7 4 2];
p.studyListOrder5 = [1 4 7 10 13 16];
p.studyListOrder6 = [2 5 8 11 14 17];

p.listGroup = 0;
while (p.listGroup < 1 || p.listGroup > 6)
    p.listGroup = inputdlg('Please Enter Subject Group (1-6)','List Group');
    p.listGroup = str2num(p.listGroup{1});
end
eval(['p.studyListOrder = p.studyListOrder' num2str(p.listGroup) '([1 2 3 4 5 6]);']);

