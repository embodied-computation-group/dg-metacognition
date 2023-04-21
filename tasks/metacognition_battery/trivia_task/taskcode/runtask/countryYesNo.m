sca

function [results] = countryYesNo(p, results)

lengthList = length(p.list_countries.list_countries_complete);

randomisedList = randperm(lengthList, lengthList);
randomisedList = randomisedList';

for i =1:lengthList
    
    position = randomisedList(i);
    
    image_str = strcat('./Flags/', p.list_countries.list_countries_complete{position, 2});
    im = imread(image_str); flag = Screen('MakeTexture',p.window, im);
    country_name = p.list_countries.list_countries_complete{position, 1};
    
    
    
    Screen('TextSize',p.window,p.textSize);
    DrawFormattedText(p.window, 'Are you familiar with this country?', 'center', 150, p.textColor);
    DrawFormattedText(p.window, 'YES', p.screenXpixels .* .25, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'NO', p.screenXpixels .* .75, p.textYpos + 50, p.textColor);
    Screen('FrameRect', p.window, p.gray, p.framePos_center, 50);
    Screen('DrawTexture', p.window, flag, [], p.imPos_center);
    
    Screen('TextSize',p.window,p.textSize);
    DrawFormattedText(p.window, country_name, 'center', p.textYPosfam, p.textColor);
    
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
    DrawFormattedText(p.window, 'Are you familiar with this country?', 'center', 150, p.textColor);
    DrawFormattedText(p.window, 'YES', p.screenXpixels .* .25, p.textYpos + 50, p.textColor);
    DrawFormattedText(p.window, 'NO', p.screenXpixels .* .75, p.textYpos + 50, p.textColor);
    Screen('FrameRect', p.window, p.gray, p.framePos_center, 50);
    Screen('DrawTexture', p.window, flag, [], p.imPos_center);
    
    Screen('TextSize',p.window,p.textSize);
    DrawFormattedText(p.window, country_name, 'center', p.textYPosfam, p.textColor);
    
    Screen('TextSize',p.window,48);
    if strcmp(response, 'LeftArrow')
        DrawFormattedText(p.window,'*', p.screenXpixels .* .25, p.screenYpixels - 80, p.textColor);
    elseif strcmp(response, 'RightArrow')
        DrawFormattedText(p.window,'*', p.screenXpixels .* .75,p.screenYpixels - 80, p.textColor);
    end
    Screen(p.window, 'Flip');
    WaitSecs(0.4);
    
    results.CountriesFamiliarity.Country{i} = country_name;
    results.CountriesFamiliarity.Familiarity{i} = response;
    results.CountriesFamiliarity.Type = 'Yes/No';
    
    save(p.filename, 'results');
    
    
    
end


end