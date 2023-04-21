function quadrantDestRect = makeQuadrantDestRect(quadrant,stimW,bufferW,stimH,bufferH,midW,midH)
% quadrantDestRect = makeQuadrantDestRect(quadrant,stimW,bufferW,stimH,bufferH,midW,midH)
%
% Returns the coordinates for a destination rectangle in a specified
% quadrant. Useful for visual experiments where stimuli are presented in
% one or more of the 4 screen quadrants.
% 
% "quadrant" specifies which quadrant of the screen quadrantDestRect is located in.
% - 'tl' = top left
% - 'tr' = top right
% - 'bl' = bottom left
% - 'br' = bottom right
% - 't' = top (both top left and top right quadrants)
% - 'b' = bottom
% - 'l' = left
% - 'r' = right
% - 'all' = all 4 quadrants
% 
% When N > 1 quadrants are specified, destRect is a 4 x N matrix where each
% column specifies a separate destination rect on the screen. This format
% of multiple rects can be used directly with the Screen('DrawTextures')
% function.
%
% "stimW" specifies the length of the stimulus to be drawn to destRect in
% pixels.
%
% "bufferW" specifies the horizontal spacing between the center of the
% screen and the edge of the stimulus, in pixels. If no value is specified, 
% bufferW is set to stimW / 2.
%
% "stimH" and "bufferH" are the horizontal analogs of stimW and bufferW. If
% stimH is not specified, stimH is set to stimW (i.e., a square stimulus is
% assumed). If bufferH is not specified, bufferH is set to bufferW (i.e. a 
% square buffer is assumed).
%
% "midW" and "midH" are the central pixel values for the width and height
% dimensions of the screen. They are retrieved using Screen('Rect') if not
% specified, so if you don't specify these values you must already have a
% PTB window open.
%
% REQUIRES: getScreenMidpoint.m
%
% History
% 11/20/07 BM wrote it.

%%%%% get default values for input variables, if not specified
if ~exist('bufferW','var') || isempty(bufferW)
    bufferW = round(stimW / 2);
end

if ~exist('stimH','var') || isempty(stimH)
    stimH = stimW;
end

if ~exist('bufferH','var') || isempty(bufferH)
    bufferH = bufferW;
end

if ~exist('midW','var') || ~exist('midH','var') || isempty(midW) || isempty(midH)
    [midW,midH] = getScreenMidpoint;
end

%%%%% define rects for all 4 quadrants
topLeft = [midW-bufferW-stimW midH-bufferH-stimH midW-bufferW midH-bufferH];
topRight = [midW+bufferW midH-bufferH-stimH midW+bufferW+stimW midH-bufferH];
bottomLeft = [midW-bufferW-stimW midH+bufferH midW-bufferW midH+bufferH+stimH];
bottomRight = [midW+bufferW midH+bufferH midW+bufferW+stimW midH+bufferH+stimH];

%%%%% select output depending on requested quadrant
switch quadrant
    case 'tl', quadrantDestRect = topLeft;
    case 'tr', quadrantDestRect = topRight;
    case 'bl', quadrantDestRect = bottomLeft;
    case 'br', quadrantDestRect = bottomRight;
    case 't', quadrantDestRect = [topLeft' topRight'];
    case 'b', quadrantDestRect = [bottomLeft' bottomRight'];
    case 'l', quadrantDestRect = [topLeft' bottomLeft'];
    case 'r', quadrantDestRect = [topRight' bottomRight'];
    case 'all', quadrantDestRect = [topLeft' topRight' bottomLeft' bottomRight'];
    otherwise disp('Unsupported quadrant request. See help makeDestRect.')
end
