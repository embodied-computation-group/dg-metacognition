function degrees = pixels2degrees(pixels, distFromScreen_inCm, pixels_perCm, screenNumber)
% degrees = pixels2degrees(pixels, distFromScreen_inCm, pixels_perCm, screenNumber)
%
% Converts pixels to degrees, given distance from screen in centimeters
% and pixels per centimeter.
%
% Default value for distance from screen is 50 cm.
% If not specified, pixels per cm is measured using Screen('Resolution', 
% screenNumber) and Screen('DisplaySize', screenNumber). Default for
% screenNumber is max(Screen('Screens')).

% default dist from screen is 50 cm
if ~exist('distFromScreen_inCm','var') || isempty(distFromScreen_inCm)
    distFromScreen_inCm = 50;
end

% figure out pixels per cm if not specified
if ~exist('pixels_perCm','var') || isempty(pixels_perCm)
    
    if ~exist('screenNumber','var') || isempty(screenNumber)
        screenNumber = max(Screen('Screens'));
    end
    
    resolution = Screen('Resolution',screenNumber);
    widthOfScreen_inPixels = resolution.width;
    heightOfScreen_inPixels = resolution.height;
    
    [widthOfScreen_inMm, heightOfScreen_inMm] = Screen('DisplaySize',screenNumber);
    widthOfScreen_inCm = widthOfScreen_inMm / 10;
    
    % note, pixels per cm can also be calculated using the height of screen
    % in pixels and cm, which may give a different value
    pixels_perCm = widthOfScreen_inPixels / widthOfScreen_inCm;
end

% convert pixels to centimeters
sizeOnScreen_inCm = pixels / pixels_perCm;

% convert centimeters to degrees
degrees = 2 * atan((sizeOnScreen_inCm/2) / distFromScreen_inCm) * (180/pi);