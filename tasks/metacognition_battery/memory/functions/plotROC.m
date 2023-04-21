function plottedROCdata = plotROC(sensitivityMeasure,varargin)
% plottedROCdata = 
% plotROC(sensitivityMeasure,style,axisType,pS2,s,ROCintercept,nCurves,nFARpoints,nHRpoints)
%
% Generate a set of ROC curves for a given function of false alarm rate (FAR) 
% and hit rate (HR). ROC curves are linearly spaced along the line defined
% by the input ROCintercept in the linear ROC graph, FAR vs HR. 
% The default ROCintercept is the minor diagonal.
%
% Inputs other than sensitivityMeasure are specified by entering the
% variable name as a string, followed by the desired value. Variable names
% are listed above. 
%
% e.g. to plot ROC curves for d(a) with s = 0.5 on z-coordinates using red lines 
% (see below for more detail), the input string would be
% 
% plotROC('dprime','axisType','z','style','r-','s',0.5);
%
% The output plottedROCdata is a struct containing the FAR axis values and 
% corresponding ROC points that have been plotted.
%
% * plottedROCdata.FARaxis is a vector containing values along the FAR axis 
% * plottedROCdata.ROCcurves is an nCurves x length(FARaxis) matrix. Each row 
%   specifies the HR values along an ROC curve corresponding to the FAR values 
%   stored in FARaxis.
%
% Inputs
% ------
% * sensitivityMeasure is a string specifying a function of FAR and HR. The
% string should be formatted like a normal line of Matlab code, with f
% standing for FAR and h standing for HR. For instance, for the measure
%
% d' = z(HR) - z(FAR)
%
% the proper string for sensitivityMeasure would be 'norminv(h)-norminv(f)'.
% 
% When using multiplication, division, or exponentiation, include the dot to 
% make it a point-by-point vector calculation. 
% e.g. use 'h ./ f' rather than 'h / f'.
%
% Some functions of f and h can be referenced by predefined string labels.
% These are as follows:
% 
% measure                  - label    
% ------------------------------------
% d'                       - dprime
% d'a (for s ~= 1)         - da
% corrected hit rate, H'C  - HprimeC  
% corrected hit rate, HC   - HC       
% percent correct, p(C)    - PC       
% skill test, Z            - Z        
% Kappa statistic, K       - K        
% Phi coefficient          - phi      
% p(S2|yes)                - ppv   [positive predictive value]  
% p(S2|no)                 - ppvc  [positive predictive value complement]
% p(S1|no)                 - npv   [negative predictive value]
% p(S1|yes)                - npvc  [negative predictive value complement]
% alpha                    - alpha
% log(alpha)               - lnalpha
% Choice theory measure    - nu       
% Log odds ratio           - LOR      
% Yule's Q                 - Q        
% power curve ROC          - powerROC 
%
% For more on these measures, see
%
% Swets JA. Indices of discrimination or diagnostic accuracy: their ROCs
% and implied models. Psychol Bull. 1986 Jan;99(1):100-17.
%
% The labels listed above can be incorporated into the sensitivity measure 
% input string like variables, as long as they are surrounded by blank 
% characters -- for instance, 'sqrt( phi ) - PC .^2 + h - f' would be a 
% valid (though bizarre!) input string.
%
% To make an empty ROC plot, use plotROC('empty')
%
% * style specifies the format for plotting the ROC curves. Format follows
% the convention for the plot function. Default is 'b-'.
%
% * axisType specifies the ROC axes. Default is linear. 'z' plots on
% z axes. 'log' plots on log odds axes.
%
% * pS2 specifies the prior probability of the S2 stimulus class. For some
% measures (like d') pS2 is superfluous, but for others (like p(C)) it is
% needed to make the calculation. Default is 0.5.
%
% * s is used for calculating a variant of d', d'a, when the S1 and S2 
% distributions are of unequal variance. s = sd(S1)/sd(S2). Default is s = 1.
%
% * ROCintercept defines the line along which linearly spaced values for
% the input sensitivityMeasure are sampled. Format is [f1 h1 f2 h2], where
% (f1, h1) and (f2, h2) define the endpoints of the ROC intercept. By
% default ROCintercept is set to the minor diagonal, i.e. [0, 1, 0.5, 0.5]. 
% Using an alternative ROCintercept is sometimes desirable, e.g. for
% plotting isobias curves that may not intersect the minor diagonal.
%
% * nCurves specifies the number of ROC curves to plot. Default is 10.
%
% * nFARpoints and nHRpoints specify the number of points along the FAR and 
% HR axes for which the ROC curves are estimated. Default values are
% nFARpoints = 100 and nHRpoints = 5000. Set these to higher values for 
% smoother curves, or lower values for faster plotting.

%% get info from varargin
for i=1:2:length(varargin)-1
    eval([varargin{i} ' = varargin{i+1};']);
end

%% set undefined variables
if ~exist('style','var') || isempty(style)
    style = 'b-';
end

if ~exist('axisType','var') || isempty(axisType)
    axisType = 'linear';
end

if ~exist('pS2','var') || isempty(pS2)
    pS2 = 0.5;
end
pS1 = 1 - pS2;

if ~exist('s','var') || isempty(s)
    s = 1;
end

if ~exist('ROCintercept','var') || isempty(ROCintercept)
    ROCintercept = [0 1 .5 .5];
end

if ~exist('nCurves','var') || isempty(nCurves)
    nCurves = 10;
end

if ~exist('nFARpoints','var') || isempty(nFARpoints)
    nFARpoints = 100;
end

if ~exist('nHRpoints','var') || isempty(nHRpoints)
    nHRpoints = 5000;
end

%% reformat sensitivity measure
plotEmptyROC = 0;
inputSensitivityMeasure = sensitivityMeasure;
reformattedSensitivityMeasure = [];
while ~isempty(sensitivityMeasure)
    [nextToken sensitivityMeasure] = strtok(sensitivityMeasure);
    switch nextToken
        case 'HC'
            nextToken = '((h-f)./(1-f))';
        case 'HprimeC'
            nextToken = '(h-f)';
        case 'PC'
            nextToken = '(pS2.*h + pS1.*(1-f))';
        case 'Z'
            nextToken = '(4.*pS2.*pS1.*(h-f))';
        case 'K'
            nextToken = '((2.*pS2.*pS1.*(h-f))./( (1-2.*pS2).*(pS2.*h+pS1.*f) + pS2 ))';
        case 'phi'
            nextToken = '((sqrt(pS1.*pS2).*(h-f)) ./ sqrt( (pS2.*h+pS1.*f).*(1-(pS2.*h+pS1.*f)) ))';
        case 'ppv'  % p(S2|yes)
            nextToken = '( pS2.*h ./ (pS2.*h+pS1.*f) )';
        case 'ppvc' % p(S2|no)
            nextToken = '( pS2.*(1-h) ./ (pS1.*(1-f)+pS2.*(1-h)) )';
        case 'npv'  % p(S1|no)
            nextToken = '( pS1.*(1-f) ./ (pS1.*(1-f)+pS2.*(1-h)) )';
        case 'npvc' % p(S1|yes)
            nextToken = '( pS1.*f ./ (pS1.*f+pS2.*h) )';            
        case 'alpha'
            nextToken = '(sqrt( (h.*(1-f))./(f.*(1-h)) ))';
        case 'alpha1'
            nextToken = '(sqrt( (f.*(1-h))./(h.*(1-f)) ))';
        case 'nu'
            nextToken = '(sqrt( (f.*(1-h))./(h.*(1-f)) ))';
        case 'LOR'
            nextToken = '(log( (h.*(1-f))./(f.*(1-h)) ))';
        case 'lnalpha'
            nextToken = '(log(sqrt( (h.*(1-f))./(f.*(1-h)) )))';
        case 'Q'
            nextToken = '((h-f)./(h-2.*h.*f+f))';
        case 'dprime'
            nextToken = '(norminv(h) - norminv(f))';
        case 'da'
            nextToken = '(sqrt(2./(1+s^2)).*(norminv(h) - s.*norminv(f)))';
        case 'powerROC'
            nextToken = '(log(h) ./ log(f))';
        case 'empty'
            plotEmptyROC = 1;
    end
    reformattedSensitivityMeasure = [reformattedSensitivityMeasure nextToken];
end
sensitivityMeasure = [reformattedSensitivityMeasure ';'];

if plotEmptyROC
    switch axisType
        case 'z'
            axisMax = norminv(.99);
            axisMin = norminv(.01);
            axisMid = norminv(.5);
            xaxisLabel = 'z(FAR)';
            yaxisLabel = 'z(HR)';
        case 'log'
            axisMax = log(.99/.01);
            axisMin = log(.01/.99);
            axisMid = log(.5/.5);        
            xaxisLabel = 'log(FAR / (1 - FAR))';
            yaxisLabel = 'log(HR / (1 - HR))';
        otherwise
            axisMax = 1;
            axisMin = 0;
            axisMid = .5;            
            xaxisLabel = 'FAR';
            yaxisLabel = 'HR';
    end


    holdIsOff = ~ishold;

    hold on
    axis([axisMin axisMax axisMin axisMax])
    axis square
    xlabel(xaxisLabel)
    ylabel(yaxisLabel)
    plot([axisMin axisMax],[axisMin axisMax],'k') % major diagonal
    plot([axisMin axisMid],[axisMax axisMid],'k') % minor diagonal

    if holdIsOff, hold off; end

    plottedROCdata.ROCcurves = [];
    plottedROCdata.FARaxis = [];
    return
end

%% calculate ROCs
fgrain=1/nFARpoints;
hgrain=1/nHRpoints;
fendpoint = 1/(nFARpoints * 100);

% define ROC curves linearly spaced along the ROC intercept
f1 = ROCintercept(1);
h1 = ROCintercept(2);
f2 = ROCintercept(3);
h2 = ROCintercept(4);

fvals=linspace(f1,f2,nCurves+2);
fvals=fvals(2:end-1);
hvals=linspace(h1,h2,nCurves+2);
hvals=hvals(2:end-1);

f=fvals;
h=hvals;
measureVals = eval(sensitivityMeasure);

% find the (f,h) points for the ROC curves
fvals=[fendpoint fgrain:fgrain:1-fgrain 1-fendpoint];
for findex=1:length(fvals)
    f=fvals(findex);
    h=1:-hgrain:0;fvals(findex);
    ROCvals = eval(sensitivityMeasure);
    
    for i=1:nCurves
        [minval hlocation] = min(abs(measureVals(i) - ROCvals));
        ROCcurves(i,findex) = 1-(hlocation-1)*hgrain;
    end
end


%% plot ROCs
f=[fendpoint fgrain:fgrain:1-fgrain 1-fendpoint];

switch axisType
    case 'z'
        f = norminv(f);
        ROCcurves = norminv(ROCcurves);
        axisMax = norminv(.99);
        axisMin = norminv(.01);
        axisMid = norminv(.5);
        xaxisLabel = 'z(FAR)';
        yaxisLabel = 'z(HR)';
    case 'log'
        f = log(f./(1-f));
        ROCcurves = log(ROCcurves./(1-ROCcurves));
        axisMax = log(.99/.01);
        axisMin = log(.01/.99);
        axisMid = log(.5/.5);        
        xaxisLabel = 'log(FAR / (1 - FAR))';
        yaxisLabel = 'log(HR / (1 - HR))';
    otherwise
        axisMax = 1;
        axisMin = 0;
        axisMid = .5;            
        xaxisLabel = 'FAR';
        yaxisLabel = 'HR';
end


plot(f,ROCcurves,style)

holdIsOff = ~ishold;

hold on
axis([axisMin axisMax axisMin axisMax])
axis square
xlabel(xaxisLabel)
ylabel(yaxisLabel)
% plot([f1 f2],[h1 h2],'k') % ROC intercept
plot([axisMin axisMax],[axisMin axisMax],'k') % major diagonal
plot([axisMin axisMid],[axisMax axisMid],'k') % minor diagonal

if holdIsOff, hold off; end

plottedROCdata.ROCcurves = ROCcurves;
plottedROCdata.FARaxis = f;