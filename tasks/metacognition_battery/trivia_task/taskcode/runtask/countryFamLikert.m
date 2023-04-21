function [results] = countryFamLikert(p, results)

lengthList = length(p.list_countries.list_countries_complete);

randomisedList = randperm(lengthList, lengthList);
randomisedList = randomisedList';

for i =1:lengthList
    
    position = randomisedList(i);
    
    image_str = strcat('./Flags/', p.list_countries.list_countries_complete{position, 2});
    im = imread(image_str); flag = Screen('MakeTexture',p.window, im);
    country_name = p.list_countries.list_countries_complete{position, 1};
    
    
    
    Screen('TextSize',p.window,p.textSize);
    DrawFormattedText(p.window, 'How familiar are you with this country?', 'center', 150, p.textColor);
    DrawFormattedText(p.window, 'Not at all', p.screenXpixels .* 1/5, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'A little', p.screenXpixels .* 2/5, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'Moderately', p.screenXpixels .* 3/5, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'Very', p.screenXpixels .* 4/5, p.textYpos + 50, p.textColor);   
   
    DrawFormattedText(p.window, '1', p.screenXpixels .* 1/5 + 40, p.textYpos + 90, p.textColor);
    DrawFormattedText(p.window, '2', p.screenXpixels .* 2/5 + 40, p.textYpos + 90, p.textColor);
    DrawFormattedText(p.window, '3', p.screenXpixels .* 3/5 + 40, p.textYpos + 90, p.textColor);
    DrawFormattedText(p.window, '4', p.screenXpixels .* 4/5 + 40, p.textYpos + 90, p.textColor);
    
    
    Screen('FrameRect', p.window, p.gray, p.framePos_center, 50);
    Screen('DrawTexture', p.window, flag, [], p.imPos_center);
    
    Screen('TextSize',p.window,p.textSize);
    DrawFormattedText(p.window, country_name, 'center', p.textYPosfam, p.textColor);
    
    t = Screen(p.window, 'Flip');
    
    FlushEvents;
    trialComplete = false;
    while ~trialComplete
        [k respTime keyCode] = KbCheck();
        if strcmp(KbName(keyCode),"1!") | strcmp(KbName(keyCode),"2@") | strcmp(KbName(keyCode),"3#")| strcmp(KbName(keyCode),"4$")
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
    DrawFormattedText(p.window, 'How familiar are you with this country?', 'center', 150, p.textColor);
    DrawFormattedText(p.window, 'Not at all', p.screenXpixels .* 1/5, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'A little', p.screenXpixels .* 2/5, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'Moderately', p.screenXpixels .* 3/5, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'Very', p.screenXpixels .* 4/5, p.textYpos + 50, p.textColor);
    
    DrawFormattedText(p.window, '1', p.screenXpixels .* 1/5 + 40, p.textYpos + 90, p.textColor);
    DrawFormattedText(p.window, '2', p.screenXpixels .* 2/5 + 40, p.textYpos + 90, p.textColor);
    DrawFormattedText(p.window, '3', p.screenXpixels .* 3/5 + 40, p.textYpos + 90, p.textColor);
    DrawFormattedText(p.window, '4', p.screenXpixels .* 4/5 + 40, p.textYpos + 90, p.textColor);
    
    
    
    Screen('FrameRect', p.window, p.gray, p.framePos_center, 50);
    Screen('DrawTexture', p.window, flag, [], p.imPos_center);
    
    Screen('TextSize',p.window,p.textSize);
    DrawFormattedText(p.window, country_name, 'center', p.textYPosfam, p.textColor);
    
    Screen('TextSize',p.window,48);
    if strcmp(response, '1!')
        DrawFormattedText(p.window,'*', p.screenXpixels .* 1/5 + 30, p.screenYpixels - 60, p.textColor);
        answer = 1;
    elseif strcmp(response, '2@')
        DrawFormattedText(p.window,'*', p.screenXpixels .* 2/5 + 30,p.screenYpixels - 60, p.textColor);
        answer = 2;
    elseif strcmp(response, '3#')
        DrawFormattedText(p.window,'*', p.screenXpixels .* 3/5 + 30, p.screenYpixels - 60, p.textColor);
        answer = 3;
    elseif strcmp(response, '4$')
        DrawFormattedText(p.window,'*', p.screenXpixels .* 4/5 + 30,p.screenYpixels - 60, p.textColor);
        answer = 4;
    end
    Screen(p.window, 'Flip');
    WaitSecs(0.4);
    
    results.CountriesFamiliarity.Country{i} = country_name;
    results.CountriesFamiliarity.Familiarity{i} = answer;
    results.CountriesFamiliarity.Type = 'LikertScale';
    
    save(p.filename, 'results');
    
    
    
end


end