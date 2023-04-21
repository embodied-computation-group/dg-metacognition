function Instructions_food(p, list_food_complete)



food_1_pos = 23; %KitKat
food_2_pos = 258; %Watermelon

%loading images
im_left = Screen('MakeTexture', p.window, list_food_complete{food_1_pos, 3});
im_right = Screen('MakeTexture', p.window, list_food_complete{food_2_pos, 3});
%  Assigning the word for the cities
word_left = list_food_complete(food_1_pos, 1);
word_right = list_food_complete(food_2_pos, 1);
word_left = char(word_left);
word_right = char(word_right);


Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window,['Get ready now to the second part of the experiment'...
    '\n\n Press any key to continue'],...
    'center',p.screenYpixels * 0.15, p.textColor);
Screen(p.window, 'Flip');

WaitSecs(1);
KbWait;


Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window,['In this task you will see the pictures and names of two food, as shown below.'...
    '\n\n In each trial we will ask you to choose which one has the highest calories'],...
    'center',p.screenYpixels * 0.15, p.textColor);
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.cityTextSize);
DrawFormattedText(p.window, word_left, p.textXpos_left, p.textYpos, p.textColor);
DrawFormattedText(p.window, word_right,p.textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawFormattedText(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

WaitSecs(3);
Screen('TextSize',p.window,20);
DrawFormattedText(p.window,'Press any key to continue ...',...
    p.screenXpixels - 300,p.screenYpixels * 0.90, p.textColor);

Screen(p.window, 'Flip');

WaitSecs(2);

KbWait;

Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window,'To practice, please press now the left or the right arrow to make your selection.',...
    'center',p.screenYpixels * 0.15, p.textColor);
DrawFormattedText(p.window,'Which food do you think has the most calories?',...
    'center',p.screenYpixels * 0.25, p.textColor);
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.cityTextSize);
DrawFormattedText(p.window, word_left, p.textXpos_left, p.textYpos, p.textColor);
DrawFormattedText(p.window, word_right,p.textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawFormattedText(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

Screen('Flip', p.window);
WaitSecs(1);



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

Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window,'To practice, please press now the left or the right arrow to make your selection.',...
    'center',p.screenYpixels * 0.15, p.textColor);
DrawFormattedText(p.window,'Which food do you think has the most calories?',...
    'center',p.screenYpixels * 0.25, p.textColor);
Screen('DrawTexture', p.window, im_left, [], p.imPos_left);
Screen('DrawTexture', p.window, im_right, [], p.imPos_right);
Screen('TextSize',p.window,p.cityTextSize);
DrawFormattedText(p.window, word_left, p.textXpos_left, p.textYpos, p.textColor);
DrawFormattedText(p.window, word_right,p.textXpos_right, p.textYpos, p.textColor);

Screen('TextSize',p.window,40);
DrawFormattedText(p.window, '+', p.xCenter, p.yCenter + 50, p.textColor);

Screen('TextSize',p.window,48);
if strcmp(response, 'LeftArrow')
    DrawFormattedText(p.window,'*', p.xCenter - 400, p.yCenter+250, p.textColor);
    resp = 1;
elseif strcmp(response, 'RightArrow')
    DrawFormattedText(p.window,'*', p.xCenter + 350, p.yCenter+250, p.textColor); 
    resp = 2;
end
Screen(p.window, 'Flip');

WaitSecs(1.5);



Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window,['Once you made your choice, we will ask you to rate' '\n \n how condifent you feel about your decision' '\n \n Select with the arrows and confirm it with the space bar'],...
    'center',p.screenYpixels * 0.40, p.textColor);


Screen('TextSize',p.window,20);
DrawFormattedText(p.window,'Press any key to continue ...',...
    p.screenXpixels - 300,p.screenYpixels * 0.90, p.textColor);

Screen(p.window, 'Flip');

WaitSecs(1);

KbWait;

WaitSecs(0.5);
practice = 1;
[scaledX, RT_Conf] = Confidence_Scale(p, practice);

scaledXstr = num2str(scaledX);
Screen('TextSize',p.window,p.textSize);
DrawFormattedText(p.window,['You felt ' scaledXstr '% confident about your decision'],...
    'center',p.screenYpixels * 0.45, p.textColor);
if resp==1
    DrawFormattedText(p.window,['And you were correct! Kitkat has more calories than watermelon.'],...
    'center',p.screenYpixels * 0.55, p.textColor);
elseif resp==2
    DrawFormattedText(p.window,['But you were not correct. Kitkat has more calories than watermelon.'],...
    'center',p.screenYpixels * 0.55, p.textColor);
end

Screen('TextSize',p.window,20);
DrawFormattedText(p.window,'Press any key to continue ...',...
    p.screenXpixels - 300,p.screenYpixels * 0.90, p.textColor);

Screen(p.window, 'Flip');

WaitSecs(1);

KbWait;


Screen('TextSize',p.window,p.textSize); 
DrawFormattedText(p.window,['Get now ready to start the task!' '\n \n You will see one pair of food after the other, and after each choice you make ' '\n you will be asked about your confidence.'...
    '\n \n During the task you will not be given any feedback.'...
    '\n \n If you have any questions, please ask one of the researchers.' '\n \n When you are ready, press any key to start.' '\n \n Good luck!'],...
    'center',p.screenYpixels * 0.30, p.textColor);
Screen(p.window, 'Flip');

WaitSecs(1);

KbWait;

end