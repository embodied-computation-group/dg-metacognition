function p = triviaGetParams(inArg)
% Params for trivia metacognition task
% GM 2019

%% Load Mat files

p.list_countries = load('list_countries_complete.mat');
p.list_food = load('list_food_complete.mat');

%%  Subject Parameters

if nargin < 1
    
    p.subID = inputdlg('Please Enter SubjectID', 'SubjectID');
    
    
else
    p.subID = inArg;

end

p.filename = ['triviaData_' p.subID '.mat'];

if IsWin
    dataDir = [pwd '\triviaData\'];
else
    dataDir = [pwd '/triviaData/'];
end

if ~exist('triviaData')
    mkdir triviaData
end


p.filename = [dataDir p.filename];


%% instruction texts

p.instruction_text{1} = ['In this task you will make choices about different foods and countries.\n', ...
                      ' For example, you will decide which of two countries has a higher wealth,\n'...
                      ' measured by the average gross domestic product (GDP) per capita,\n'...
                      ' and which of two plates of food has more calories.\n'...
                      ' On each trial, you should make your decision using the left and right arrow keys\n'... 
                      ' as quickly and accurately as possible. Afterwards, you will rate how confident you feel that\n'...
                      ' your decision was correct.\n\n Press SPACE to continue.\n\n'];

p.instruction_text{2} = ['On many trials, you may feel very uncertain about the correct answer;\n', ...
                       ' just do your best to make the accurate answer and carefully rate your confidence.\n' ...
                       ' In general, you should try to use the entire width of the confidence scale\n' ...
                       ' to reflect your subjective uncertainty. You confirm your confidence by pressing the space bar.\n\nPress SPACE to continue.\n\n'];
              
p.instruction_text{3} = ['We will begin with a short practice round so you can understand how to make your responses.\n', ...
                       ' After the practice, please let the experimenter know if you have any questions about the task.\n' ...
                       ' \n\nPress SPACE to continue to the practice.\n\n'];



%% Windows parameters
p.gray = [127 127 127 ]; p.white = [255 255 255]; p.black = [0 0 0];
p.red = [250 0 0]; p.green = [0 250 50]; p.blue = [50 0 250];
p.bgcolor = p.black;
p.textColor = p.white;
p.textSize = 40;
p.countriesTextSize = 24;

%p.screensize = [0 0 2000 2000];
p.screensize = [];

p.screenNum = 0;

%PsychDebugWindowConfiguration(0, 0.5)
Screen('Preference', 'SkipSyncTests', 0);
[p.window, p.rect] = Screen('OpenWindow', p.screenNum, p.black, p.screensize);
Screen('FillRect', p.window, p.bgcolor);
[p.xCenter, p.yCenter] = RectCenter(p.rect);
[p.screenXpixels, p.screenYpixels] = Screen('WindowSize', p.window);

%[p.screenXpixels, p.screenYpixels] = Screen('WindowSize', [0 0 500 500]);
% Screen(p.window, 'Flip');

%% Task Parameters
p.totalNumPracticeTrial = 20;
% Number of conditions
p.nConditions = 2;

% Number of blocks
p.numberOfBlocks = 5;

%Number of trials per block per condition, the total number of trials will be (p.trialsPerCondit * p.nConditions * p.numberOfBlocks)
p.trialsPerCondit = 20; 

p.trialsPerBlock = p.trialsPerCondit * p.nConditions;

p.totalNumTrial = p.trialsPerBlock * p.numberOfBlocks;


%% trial timings

p.Stimtime = 0.25;
p.ConfWait = 0.25;
p.RespWait = 0.25;
p.FBWait = 0.25 ;

%% staircase parameters

% condition 1 stepsizes
p.stepsize(1,1) = 0.5; % in log(GDP) units
p.stepsize(1,2) = 0.25;
p.stepsize(1,3) = 0.125; 

% condition 2 stepsizes
p.stepsize(2,1) = 100; % calories
p.stepsize(2,2) = 50;
p.stepsize(2,3) = 25; 


p.countries_srange = [0.1 5];
p.food_srange = [1 500];

p.thisDifferenceTarget_gdp = 1; % initial difference target
p.thisDifferenceTarget_calories = 200; % initial difference target


p.S(1) = SetupStaircase(1, [p.thisDifferenceTarget_gdp], p.countries_srange, [2,1]);
p.S(2) = SetupStaircase(1, [p.thisDifferenceTarget_calories], p.food_srange, [2,1]);

%% countries Image and Text parameters

p.xposition_left = p.screenXpixels * .25;
p.xposition_right = p.screenXpixels * .75;

scaling = 500;

% Image Position
imBase = [0 0 300+scaling 200+scaling];
p.imPos_left = CenterRectOnPointd(imBase, p.xposition_left, p.screenYpixels/2);
p.imPos_right = CenterRectOnPointd(imBase, p.xposition_right, p.screenYpixels/2);
p.imPos_center = CenterRectOnPointd(imBase, p.screenXpixels/2, p.screenYpixels/2 - 60);


% Frame Position
frameBase = [0 0 305+scaling 205+scaling];
p.framePos_left = CenterRectOnPointd(frameBase, p.xposition_left, p.screenYpixels/2);
p.framePos_right = CenterRectOnPointd(frameBase, p.xposition_right, p.screenYpixels/2);
p.framePos_center = CenterRectOnPointd(frameBase, p.screenXpixels/2, p.screenYpixels/2 - 60);



% Text Position

% p.textXpos_left = p.screenXpixels * .15;
% p.textXpos_right = p.screenXpixels * .70;

%p.textYpos = p.yCenter + 200;


p.textYpos = p.yCenter + 400;



p.textYPosfam = p.yCenter + 300;



%% for discrete confidence scale

[p.mx,p.my] = RectCenter(p.rect);
p.sittingDist = 40;

% confidence scale
p.stim.scaleType = 'discrete'; % discrete or continuous
p.stim.VASwidth_inDegrees = 15;
p.stim.VASheight_inDegrees = 2;
p.stim.VASoffset_inDegrees = 0;
p.stim.arrowWidth_inDegrees = 0.5;

p.stim.VASwidth_inPixels = degrees2pixels(p.stim.VASwidth_inDegrees, p.sittingDist);
p.stim.VASheight_inPixels = degrees2pixels(p.stim.VASheight_inDegrees, p.sittingDist);
p.stim.VASoffset_inPixels = degrees2pixels(p.stim.VASoffset_inDegrees, p.sittingDist);
p.stim.arrowWidth_inPixels = degrees2pixels(p.stim.arrowWidth_inDegrees, p.sittingDist);

p.times.confDuration_inSecs = 4;
p.times.confFBDuration_inSecs = 0.250;

%% Create a matrix of all the pairwise differences
p.diff_square = cell(2,1);

% Food  



%%


% countries
% 
% Create a matrix of all the pairwise differences - RANK FROM ORDER
gdp = log(p.list_countries.numList);
diff_square = [];

for r = 1:length(gdp)
    for c = 1:length(gdp)
        diff_square(r,c) = gdp(r) - gdp(c);
    end
end

p.diff_square{1}=round(diff_square, 3, 'significant'); 

%% calories


calories = round(p.list_food.numList(:,1));
diff_square =[];

for r = 1:length(calories)
    for c = 1:length(calories)
        diff_square(r,c) = calories(r) - calories(c);
    end
end

p.diff_square{2}=diff_square; 



%% initialize usage counters for all stimuli

p.countries_repeat_list = zeros(1,length(gdp));
p.foods_repeat_list = zeros(1,length(calories));
p.repeat_threshold = 4;


end