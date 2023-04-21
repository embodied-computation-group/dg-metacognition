function stimMatrix = adjustWeberContrast(stimMatrix, weberContrast, bgLuminance)
% stimMatrix = adjustWeberContrast(stimMatrix, weberContrast, bgLuminance)
%
% Adjust the Weber contrast of a stimulus stored in stimMatrix. Weber
% contrast is defined for small stimuli on a large isoluminant background.
% 
% Weber contrast is defined by
%
% Cw = (Lstim - Lbg) / Lbg
%
% Where Lstim is the luminance of the stimulus and Lbg is the luminance of
% the background. When the stimulus is darker than the bg, Cw ranges from
% -1 to 0. When the stimulus is brighter than the bg, Cw ranges from 0 to
% infinity.
% 
% for more see
% http://colorusage.arc.nasa.gov/luminance_cont.php

stimLuminance = bgLuminance + weberContrast * bgLuminance;
stimMatrix(stimMatrix ~= bgLuminance) = stimLuminance;