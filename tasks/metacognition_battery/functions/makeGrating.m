function [grating gaussianMask] = makeGrating(width,height,contrast,gratingPeriod,gratingPeriodUnits,orientation)
% grating = makeGrating(width,height,contrast,gratingPeriod,gratingPeriodUnits,orientation)
%
% Adopted from PTB's GratingDemo.m
% 
% Returns a matrix representing pixel values for a sinusoidal grating.
% Use Screen('MakeTexture') and Screen('DrawTexture) or Screen('PutImage')
% to draw it on the PTB screen.
%
% Default values are set for input variables that are either not specified 
% or are  specified as the empty matrix [].
%
% width = width of the matrix containing the grating, in pixels
%
% height = height of the matrix containing the grating
%       Default = width
%
% contrast = contrast of the grating 
%       1 = maximal contrast b/t darker and lighter parts of the patch
%       0 = no contrast at all (all gray)
%       Intermediate values change the difference b/t darker and lighter
%       parts linearly.
%       
%       Default = 1
%
% gratindPeriod = the period of the grating
%       Period can be specified either in terms of pixels per period or 
%       in terms of how many periods should fit within the matrix 
%       (see gratingPeriodUnits)
%
%       Default: 10 grating periods in stimulus
%
% gratingPeriodUnits = type of units gratingPeriod is specified in.
%       'n' = specified in terms of the number of periods to be displayed
%       any other value = specified in units of pixels per period
%
% orientation = orientation of the grating
%       'horizontal' = grating is oriented horizontally
%       'vertical' = grating is oriented vertically
%
%       To display gratings rotated between vertical and horizontal
%       orientation, use the Screen('DrawTexture') rotation functionality


%% set parameter values if not specified
if ~exist('height','var') || isempty(height)
    height = width;
end

if ~exist('contrast','var') || isempty(contrast)
    contrast = 1;
end

if ~exist('orientation','var') || isempty(orientation)
    orientation = 'vertical';
end


%% handle specification of the grating period

% if no grating period is specified, set it to 2/3s of the Gaussian SD
if ~exist('gratingPeriod','var') || isempty(gratingPeriod)
    gratingPeriodUnits = 'n';
    gratingPeriod = 10;

% if grating period is given a value without a type specification,
% assume the grating period value is in pixels
elseif ~exist('gratingPeriodUnits','var') || isempty(gratingPeriodUnits)
    gratingPeriodUnits = 'n';
end

% compute the pixels per grating period
if gratingPeriodUnits == 'n'
    switch orientation
        case 'vertical'
            pixelsPerPeriod = width / gratingPeriod;
        case 'horizontal'
            pixelsPerPeriod = height / gratingPeriod;
        otherwise
            error('bad input for "orientation" input. see help');
    end
else
    pixelsPerPeriod = gratingPeriod;
end

spatialFrequency = 1 / pixelsPerPeriod; % How many periods/cycles are there in a pixel?
radiansPerPixel = spatialFrequency * (2 * pi); % = (periods per pixel) * (2 pi radians per period)


%% adjust contrast

gray = 255 / 2;

% compute maximum luminance at this contrast
maxLuminance = (255-gray) * contrast; 

% adjust black and white according to the specified contrast
black = gray - maxLuminance;
white = gray + maxLuminance;


%% make the patch

% if mod(width,2) == 1
%     width = width - 1;
% end
% 
% if mod(height,2) == 1
%     height = height - 1;
% end

% widthArray = -width/2 : width/2;  % widthArray is used in creating the meshgrid.
% heightArray = -height/2 : height/2;

widthArray  = [1:width] - median(1:width);
heightArray = [1:height] - median(1:height);

% Creates a two-dimensional square grid.  For each element i = i(x0, y0) of
% the grid, x = x(x0, y0) corresponds to the x-coordinate of element "i"
% and y = y(x0, y0) corresponds to the y-coordinate of element "i"
[x y] = meshgrid(widthArray, heightArray);

% Creates a sinusoidal grating, where the period of the sinusoid is 
% approximately equal to "pixelsPerGratingPeriod" pixels.
% Note that each entry of gratingMatrix varies between minus one and
% one; -1 <= gratingMatrix(x0, y0)  <= 1

% the grating is oriented horizontally unless otherwise specified.
switch orientation
    case 'vertical'
        grating = sin(radiansPerPixel .* x);
    case 'horizontal'
        grating = sin(radiansPerPixel .* y);
    otherwise
        error('bad input for "orientation" input. see help');
end

grating = grating * contrast;

% optional Gaussian mask for gabor patch ...
nSD = 6;
pixelsPerSD = width / nSD;
gaussianMask = exp(-((x .^ 2) + (y .^ 2)) / (2 * pixelsPerSD ^ 2));


% absoluteDifferenceBetweenWhiteAndGray = abs(white - gray);
% 
% grating = gray + absoluteDifferenceBetweenWhiteAndGray * grating;

