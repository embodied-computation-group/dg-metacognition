function [responseNum, correct, scaledX, RT, RT_Conf]=triviaTrialLoop_countries(p, list_countries_complete,  this_pair, feedback)
practice = 0;

countries_1_pos = this_pair(1);
countries_2_pos = this_pair(2);


%loading images
im_left = Screen('MakeTexture', p.window, list_countries_complete{countries_1_pos, 3});
im_right = Screen('MakeTexture', p.window, list_countries_complete{countries_2_pos, 3});


%  Assigning the word for the countries
word_left = list_countries_complete(countries_1_pos, 1);
word_right = list_countries_complete(countries_2_pos, 1);
word_left = char(word_left);
word_right = char(word_right);


% Image Position
imBase = [0 0 450 300];
imPos_left = CenterRectOnPointd(imBase, p.screenXpixels * .25, p.screenYpixels/2);
imPos_right = CenterRectOnPointd(imBase, p.screenXpixels * .75, p.screenYpixels/2);

% Text Position
textRect_left = Screen('TextBounds', p.window, word_left);
textWidth_left = textRect_left(3);
textXpos_left = p.screenXpixels *.25 - textWidth_left/2;

textRect_right = Screen('TextBounds', p.window, word_right);
textWidth_right = textRect_right(3);
textXpos_right = p.screenXpixels *.75 - textWidth_right/2;

% textXpos_left = p.screenXpixels * .15;
% textXpos_right = p.screenXpixels * .70;
textYpos = p.yCenter + 200;


% startTime = GetSecs();
Screen('TextSize',p.window,40);
DrawFormattedText(p.window, 'Which country is the highest area surface?', 'center', 150, p.textColor);
Screen('DrawTexture', p.window, im_left, [], imPos_left);
Screen('DrawTexture', p.window, im_right, [], imPos_right);
Screen('TextSize',p.window,p.countriesTextSize);
DrawFormattedText(p.window, word_left, textXpos_left, textYpos, p.textColor);
DrawFormattedText(p.window, word_right,textXpos_right, textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawFormattedText(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);
t = Screen(p.window, 'Flip');

FlushEvents;
    trialComplete = false;
    while ~trialComplete
        [k respTime keyCode] = KbCheck();
        if strcmp(KbName(keyCode),'LeftArrow') | strcmp(KbName(keyCode),'RightArrow')
            trialComplete = true;
            
            RT = 1000.*(respTime - t);
        elseif strcmp(KbName(keyCode),'ESCAPE')
            Screen('CloseAll')
            RT = 0;
            return
        end
    end
    
response = KbName(keyCode);

Screen('TextSize',p.window,40);  
DrawFormattedText(p.window, 'Which country is the highest area surface?', 'center', 150, p.textColor);
Screen('DrawTexture', p.window, im_left, [], imPos_left);
Screen('DrawTexture', p.window, im_right, [], imPos_right);
Screen('TextSize',p.window,p.countriesTextSize);
DrawFormattedText(p.window, word_left, textXpos_left, textYpos, p.textColor);
DrawFormattedText(p.window, word_right, textXpos_right, textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawFormattedText(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

Screen('TextSize',p.window,48);
if strcmp(response, 'LeftArrow')
    DrawFormattedText(p.window,'*', p.xCenter - 400, p.yCenter+250, p.textColor);
elseif strcmp(response, 'RightArrow')
    DrawFormattedText(p.window,'*', p.xCenter + 350, p.yCenter+250, p.textColor); 
end
Screen(p.window, 'Flip');
WaitSecs(0.75);

[scaledX, RT_Conf] = Confidence_Scale(p, practice);

WaitSecs(0.5);

if strcmp(response, 'LeftArrow')
    responseNum = 1;
    if countries_1_pos < countries_2_pos
        correct = 1;
        WaitSecs(1);
    elseif countries_1_pos > countries_2_pos
        correct = 0;
        WaitSecs(1);
    end
elseif strcmp(response, 'RightArrow')
    responseNum = 2;
    if countries_1_pos > countries_2_pos
        correct = 1;
       WaitSecs(1);
    elseif countries_1_pos < countries_2_pos
        correct = 0;
        WaitSecs(1);
    end
end


if feedback ==1
Screen('TextSize',p.window,40);
if responseNum == 1
    if correct == 1
        DrawFormattedText(p.window, 'Correct!', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(1);
    elseif correct == 0
        DrawFormattedText(p.window, 'Not correct', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(1);
    end
elseif responseNum == 2
    if countries_1_pos > countries_2_pos
        DrawFormattedText(p.window, 'Correct!', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(1);
    elseif countries_1_pos < countries_2_pos
        DrawFormattedText(p.window, 'Not correct', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(1);
    end
end
end

end