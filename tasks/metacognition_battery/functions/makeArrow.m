function arrow = makeArrow(width,length,arrowWidth,BGcolor,arrowColor,direction)

if ~exist('arrowColor','var') || isempty(arrowColor)
    arrowColor=0;
end

if ~exist('direction','var') || isempty(direction)
    direction = 'left';
end

if rem(arrowWidth,2)==0
    arrowWidth=arrowWidth-1;
end

if rem(width,2)==0
    width=width-1;
end

length=length-(arrowWidth+1)/2;

% arrowhead starts off as a square of bgcolor
arrowhead=ones(arrowWidth,(arrowWidth+1)/2)*BGcolor;

% now we draw the arrow head, starting from the left
arrowInd=median(1:arrowWidth);
for i=1:(arrowWidth+1)/2
    arrowhead(arrowInd,i)=arrowColor;
    arrowInd = [arrowInd(1)-1 arrowInd arrowInd(end)+1];
end

% now draw arrow tail
arrowtail=ones(arrowWidth,length)*BGcolor;
tailtop    = median(1:arrowWidth)-(width-1)/2;
tailbottom = median(1:arrowWidth)+(width-1)/2;
arrowtail(tailtop:tailbottom,:)=arrowColor;

if strcmp(direction,'right')
    arrow=[arrowtail arrowhead(:,end:-1:1)];
else
    arrow=[arrowhead arrowtail];
end