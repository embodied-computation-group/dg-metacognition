function inside = IsInAnyRect(x,y,rects)
% inside = IsInAnyRect(x,y,rects)
%
% Modified from IsInRect
%
% input "rects" is a 4 x N matrix specifying N rects.
%
% output is true if x,y coords are in any of the N rects specified in "rects"

inRectByCoord = [ ...
    x >= rects(RectLeft,:); ...
    x <= rects(RectRight,:); ...
    y >= rects(RectTop,:); ...
    y <= rects(RectBottom,:)];

% all(inRectByCoord) is a row vector where element N indicates if x,y is in
% rect N
inside = any(all(inRectByCoord));