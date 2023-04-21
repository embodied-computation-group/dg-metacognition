function [responseNum, correct, scaledX, RT, RT_Conf]=runTrial(p,this_pair, confidence, feedback, condition)
pos_1 = this_pair(1);
pos_2 = this_pair(2);


%loading images and labels
if condition==1
    first_im = strcat('./Flags/', p.list_countries.list_countries_complete{pos_1, 2});
    left_image = imread(first_im); im_left = Screen('MakeTexture',p.window, left_image);
    second_im = strcat('./Flags/', p.list_countries.list_countries_complete{pos_2, 2});
    right_image = imread(second_im); im_right = Screen('MakeTexture', p.window, right_image);
    word_left = p.list_countries.list_countries_complete(pos_1, 1);
    word_right = p.list_countries.list_countries_complete(pos_2, 1);
    stringText = 'Which country had the highest average GDP per capita (2010-2017)?';
elseif condition==2
    first_im = strcat('./Food/', p.list_food.list_food_complete{pos_1, 2});
    left_image = imread(first_im); im_left = Screen('MakeTexture',p.window, left_image);
    second_im = strcat('./Food/', p.list_food.list_food_complete{pos_2, 2});
    right_image = imread(second_im); im_right = Screen('MakeTexture', p.window, right_image);
    
    word_left = p.list_food.list_food_complete(pos_1, 1);
    word_right = p.list_food.list_food_complete(pos_2, 1);
    stringText = 'Which food has more calories?';
end

word_left = char(word_left);
word_right = char(word_right);


% Text Position
textRect_left = Screen('TextBounds', p.window, word_left);
textWidth_left = textRect_left(3);
textXpos_left = p.xposition_left - (textWidth_left/3);

textRect_right = Screen('TextBounds', p.window, word_right);
textWidth_right = textRect_right(3);
textXpos_right = p.xposition_right - (textWidth_right/3);


Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window, stringText, 'center', 150, p.textColor);
Screen('FrameRect', p.window, p.gray, p.framePos_left, 50); 
Screen('FrameRect', p.window, p.gray, p.framePos_right, 50); 
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.countriesTextSize);
DrawFormattedText(p.window, word_left, textXpos_left, p.textYpos, p.textColor);
DrawFormattedText(p.window, word_right,textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,p.textSize);
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

Screen('TextSize',p.window,p.textSize);  
DrawFormattedText(p.window, stringText, 'center', 150, p.textColor);
Screen('FrameRect', p.window, p.gray, p.framePos_left, 50); 
Screen('FrameRect', p.window, p.gray, p.framePos_right, 50); 
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.countriesTextSize);
DrawFormattedText(p.window, word_left, textXpos_left, p.textYpos, p.textColor);
DrawFormattedText(p.window, word_right, textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

Screen('TextSize',p.window,48);
if strcmp(response, 'LeftArrow')
    DrawFormattedText(p.window,'*', p.xCenter - 500, p.yCenter+400, p.textColor);
elseif strcmp(response, 'RightArrow')
    DrawFormattedText(p.window,'*', p.xCenter + 500, p.yCenter+400, p.textColor); 
end
Screen(p.window, 'Flip');
WaitSecs(p.Stimtime);


%% old confidence scale - VAS
% if confidence
%     [scaledX, RT_Conf] = Confidence_Scale(p, 0);
%     WaitSecs(p.ConfWait);
% else
%     scaledX = nan;
%     RT_Conf = nan;
% end


%% new confidence scale - Likert


if confidence
    [scaledX, RT_Conf] = collectConfidenceDiscrete(p.window, p);
%    WaitSecs(p.ConfWait);
else
    scaledX = nan;
    RT_Conf = nan;
    
end



if strcmp(response, 'LeftArrow')
    responseNum = 1;
    if pos_1 < pos_2
        correct = 1;
        WaitSecs(p.RespWait);
    elseif pos_1 > pos_2
        correct = 0;
        WaitSecs(p.RespWait);
    end
elseif strcmp(response, 'RightArrow')
    responseNum = 2;
    if pos_1 > pos_2
        correct = 1;
       WaitSecs(p.RespWait);
    elseif pos_1 < pos_2
        correct = 0;
        WaitSecs(p.RespWait);
    end
end


if feedback ==1
Screen('TextSize',p.window,p.textSize);
if responseNum == 1
    if pos_1 < pos_2
        DrawFormattedText(p.window, 'Correct!', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(p.FBWait);
    elseif pos_1 > pos_2
        DrawFormattedText(p.window, 'Not correct', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(p.FBWait);
    end
elseif responseNum == 2
    if pos_1 > pos_2
        DrawFormattedText(p.window, 'Correct!', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(p.FBWait);
    elseif pos_1 < pos_2
        DrawFormattedText(p.window, 'Not correct', 'center', 'Center', p.textColor);
        Screen(p.window, 'Flip');
        WaitSecs(p.FBWait);
    end
end
end

end