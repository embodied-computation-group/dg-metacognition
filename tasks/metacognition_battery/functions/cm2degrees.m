function degrees = cm2degrees(sizeOnScreen_inCm, distFromScreen_inCm)
% degrees = cm2degrees(sizeOnScreen_inCm, distFromScreen_inCm)
%
% Converts centimeters to degrees, given distance from screen in centimeters.
% Default value for distance from screen is 50 cm.

% default dist from screen is 50 cm
if ~exist('distFromScreen_inCm','var') || isempty(distFromScreen_inCm)
    distFromScreen_inCm = 50;
end

% convert centimeters to degrees
degrees = 2 * atan((sizeOnScreen_inCm/2) / distFromScreen_inCm) * (180/pi);