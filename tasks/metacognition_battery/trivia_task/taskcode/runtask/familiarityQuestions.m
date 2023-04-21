function [results]=familiarityQuestions(p, results, likert)
randomOrder = [1, 2];
randomOrder = Shuffle(randomOrder);

if likert==1
   if randomOrder(1) == 1
       [results] = countryFamLikert(p, results);
       [results] = foodFamLikert(p, results);
   elseif randomOrder(1) == 2
       [results] = foodFamLikert(p, results);
       [results] = countryFamLikert(p, results);
   end
elseif likert==0
    if randomOrder(1) == 1
        [results] = countryYesNo(p, results);
        [results] = foodYesNo(p, results);
    elseif randomOrder(1) == 2
        [results] = foodYesNo(p, results);
        [results] = countryYesNo(p, results);
    end
end
        
save(p.filename, 'results');
end




