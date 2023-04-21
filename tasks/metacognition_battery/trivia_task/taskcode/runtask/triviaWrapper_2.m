 %%%%%%%%%%%%%%%%%%%TRIVIAMETACOGNITIONTASK%%%%%%%%%%%% %%%%%%%% %%%%%%% %

 function out = triviaWrapper(sID)
 
KbName ('UnifyKeyNames');  
KbCheck;

p = triviaGetParams(sID); 
Screen('TextFont',p.window,'Helvetica'); 
Screen('TextSize', p.window, p.textSize);
HideCursor;



% Introduction
DrawFormattedText(p.window,['Welcome to the experiment!' '\n \n Press any key to continue'], 'center', 'center', p.textColor);
Screen('Flip', p.window);
KbWait;


%% initialize a dummy results
results = struct;

results.S(1) = p.S(1); % condition 1 staircase 
results.S(2) = p.S(2); % condition 2 staircase

results.nreversals = [0 0]; % n columns per conditions 
results.step_level = [1 1]; % step levels for each condition
results.stepsize = p.stepsize; 


results.countries_repeat_list = p.countries_repeat_list;
results.foods_repeat_list = p.foods_repeat_list;
results.repeat_threshold = p.repeat_threshold;




%% practice block
feedback = 0;
confidence =  1; 
enablePlotting = 1; 
trial_counter = 0; 
WaitSecs(1);
blockNumber = 1;
trivia_instructions(p.window, p);

[results, trial_counter] = runPracticeBlock(p,confidence, feedback, blockNumber, results, trial_counter);


DrawFormattedText(p.window,['Great! Please ask the experimenter if you have any questions.'...
                            '\n \n Outherwise, press any key to continue'], 'center', 'center', p.textColor);
Screen('Flip', p.window);
KbWait;

%% initialize a real results

results = struct;

results.S(1) = p.S(1); % condition 1 staircase 
results.S(2) = p.S(2); % condition 2 staircase

results.nreversals = [0 0]; % n columns per conditions 
results.step_level = [1 1]; % step levels for each condition
results.stepsize = p.stepsize; 


results.countries_repeat_list = p.countries_repeat_list;
results.foods_repeat_list = p.foods_repeat_list;
results.repeat_threshold = p.repeat_threshold;


%% Real Block
feedback = 0;
confidence =  1; 
enablePlotting = 1; 
trial_counter = 0; 
WaitSecs(1);
%expStart = tic;

for blockNumber = 1 : p.numberOfBlocks
   
    [results, trial_counter] = runBlock(p,confidence, feedback, blockNumber, results, trial_counter);
    
    string = ['End of block ', num2str(blockNumber), ' out of ', num2str(p.numberOfBlocks)];
    DrawFormattedText(p.window,[string '\n \n Press any key to continue'], 'center', 'center', p.textColor);
    Screen('Flip', p.window);
    KbWait;
    
    WaitSecs(.5);
    
end
%expEnd = toc;

%% FAMILIARITY SCALE
% 
% likert = 1; % 0 == YES/NO questions; 1 == likert scale 
% [results]=familiarityQuestions(p, results, likert);
% 

%% End
Screen('TextSize', p.window, p.textSize);
DrawFormattedText(p.window,['The experiment is finished!' '\n \n Thank you for participating.'], 'center', 'center', p.textColor);
Screen('Flip', p.window);
WaitSecs(2);

sca;       

out = [];

 end









 