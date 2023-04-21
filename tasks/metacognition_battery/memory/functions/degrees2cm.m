function sizeOnScreen_inCm = degrees2cm(degrees, distFromScreen_inCm)
% sizeOnScreen_inCm = degrees2cm(degrees, distFromScreen_inCm)
%
% Converts degrees to centimeters, given distance from screen in centimeters. 
% Default value for distance from screen is 50 cm.

% default dist from screen is 50 cm
if ~exist('distFromScreen_inCm','var') || isempty(distFromScreen_inCm)
    distFromScreen_inCm = 50;
end

% convert degrees to centimeters
sizeOnScreen_inCm = 2 * distFromScreen_inCm * tan((degrees/2) * (pi/180));