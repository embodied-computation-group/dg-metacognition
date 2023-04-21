function [summary basicSDT ratingSDT type2SDT] = SDTanalysis(trialType, response, conf, label)
% [summary basicSDT ratingSDT type2SDT] = SDTanalysis(trialType, response, conf, label)
%
% Do some signal detect theory analysis on experimental data.
%
% Inputs
% ------
% * trialType is a vector of 1s and 0s. 1 denotes an S2 trial, 0 denotes an
% S1 trial. Values other than 0 or 1 are ignored.
%
% * response is a vector of 1s and 0s. 1 denotes a "yes" response (i.e. this
% trial was judged to be S2) and 0 denotes "no" (i.e. this trial was judged
% to be S1). Values other than 0 and 1 are ignored.
%
% * conf is a vector of confidence values. Min value is expected to be 1. Max
% value can be whatever the maximum confidence value is for this
% experiment. Values less than 1 are ignored.
%
% The ith element of each input vector should correspond to data from the
% same experimental trial.
%
% For rating experiments, this program can be used by reformatting ratings 
% into a response judgment + confidence judgment.
% 
% * label is a string used to label the output structs (e.g. a condition
% name). This data is used by the SDTplot function.
%
% Outputs
% -------
% Outputs are structs containing SDT analyses of the input data. summary
% and basicSDT are generated even when conf input is not provided.
% ratingSDT and type2SDT require a conf input.
%
% In addition to SDT data, each struct will contain a field called type,
% which specifies which data type this is (rating, type2, etc.), and a
% field called label, which can be used to name the condition or experiment
% that the data comes from.
%
%
% * summary contains some quick summary data.
% 
% * basicSDT contains some basic SDT analysis.
%
% * ratingSDT contains SDT analysis using response + conf judgments to create
% a rating analysis. Can be used to make an empirical ROC, check equality
% of distribution variances, etc.
%
% * type2SDT contains some type 2 SDT data.
%
% Data contained in these outputs can be viewed graphically using SDTplot.m

if ~exist('label','var'), label = []; end

%% filter out bad data, get p(S2) and p(C)

doConfAnalysis = exist('conf','var');

pS2 = sum(trialType==1) / (sum(trialType==1) + sum(trialType==0));
pR2 = sum(response==1) / (sum(response==1) + sum(response==0));

% bad trials = trial type or response < 0 or > 1
if doConfAnalysis
    conf = conf( (trialType == 0 | trialType == 1) & (response == 0 | response == 1) );
end

trialType_temp = trialType( (trialType == 0 | trialType == 1) & (response == 0 | response == 1) );
response = response( (trialType == 0 | trialType == 1) & (response == 0 | response == 1) );
trialType = trialType_temp;

pC = mean(response == trialType);
pI = 1 - pC;

%% basic SDT
b.type = 'basic';
b.label = label;

hits = response(trialType == 1);
FAs = response(trialType == 0);

nS2 = length(hits); b.nS2 = nS2;
nS1 = length(FAs); b.nS1 = nS1;

HR = mean(hits); b.HR = HR;
FAR = mean(FAs); b.FAR = FAR;

if HR == 1, HR = 1 - (1/(2*nS2)); end
if HR == 0, HR = 1/(2*nS2); end
if FAR == 1, FAR = 1 - (1/(2*nS1)); end
if FAR == 0, FAR = 1/(2*nS1); end

b.adjHR = HR;
b.adjFAR = FAR;

b.dprime = norminv(HR) - norminv(FAR);
b.criterion = -0.5 * (norminv(HR) + norminv(FAR));


%% rating analysis

if ~doConfAnalysis || all(conf < 1)
    summary.type      = 'summary';
    summary.label     = label;
    summary.dprime    = b.dprime;
    summary.criterion = b.criterion;
    summary.pC        = pC;
    summary.pS2       = pS2;
    summary.pR2       = pR2;
    ratingSDT         = [];
    type2SDT          = [];
    return
end

r.type = 'rating';
r.label = label;

% filter out bad conf data
trialType = trialType(conf >= 1);
response = response(conf >= 1);
conf = conf(conf >= 1);

nS2 = sum(trialType==1); r.nS2 = nS2;
nS1 = sum(trialType==0); r.nS1 = nS1;

% map resp + conf to single rating scale, e.g.
% 0 4, 0 3, 0 2, 0 1, 1 1, 1 2, 1 3, 1 4 ==>
%   1,   2,   3,   4,   5,   6,   7,   8
rating = max(conf) + conf; % e.g. resp 1, conf 1 2 3 4 ==> 5 6 7 8
rating(response==0) = max(conf)+1 - conf(response==0); % e.g. resp 0, conf 1 2 3 4 ==> 4 3 2 1

% get HR and FAR for each rating criterion
ratingHR  = [];
ratingFAR = [];
for c = max(rating)-1:-1:1
    currentResponse = rating;
    currentResponse(rating <= c) = 0;
    currentResponse(rating > c) = 1;
    
    hits = currentResponse(trialType == 1);
    FAs = currentResponse(trialType == 0);

    HR = mean(hits);
    FAR = mean(FAs);
    
    ratingHR(end+1)  = HR;
    ratingFAR(end+1) = FAR;
end

r.ratingHR = ratingHR;
r.ratingFAR = ratingFAR;

ratingHR(ratingHR == 1) = 1 - (1/(2*nS2));
ratingHR(ratingHR == 0) = 1/(2*nS2);
ratingFAR(ratingFAR == 0) = 1/(2*nS1);
ratingFAR(ratingFAR == 1) = 1 - (1/(2*nS1));

r.adjRatingHR = ratingHR;
r.adjRatingFAR = ratingFAR;

if all(ratingFAR == ratingFAR(1))
    s = 1;
    zIntercept = mean(norminv(ratingHR) - norminv(ratingFAR));
else
    p = polyfit(norminv(ratingFAR), norminv(ratingHR), 1);
    s = p(1);
    zIntercept = p(2);
end

r.d_a = sqrt(2/(1+s^2)) * (norminv(b.adjHR) - s*norminv(b.adjFAR));
r.c_a = ( (-sqrt(2)*s) / (sqrt(1+s^2)*(1+s)) ) * (norminv(b.adjHR) + norminv(b.adjFAR));
r.s = s;
r.zIntercept = zIntercept;

r.d_a_acrossRatings = sqrt(2/(1+s^2)) * (norminv(r.adjRatingHR) - s*norminv(r.adjRatingFAR));
r.c_a_acrossRatings = ( (-sqrt(2)*s) / (sqrt(1+s^2)*(1+s)) ) * (norminv(r.adjRatingHR) + norminv(r.adjRatingFAR));


Ag = 0;
F = [0 r.adjRatingFAR 1];
H = [0 r.adjRatingHR 1];
for i=1:length(F)-1
    Ag = Ag + (F(i+1) - F(i)) * (H(i+1) + H(i));
end

r.Ag = 0.5*Ag;
r.Az = normcdf(r.d_a / sqrt(2));

%% type II
t2.type = 'type 2';
t2.label = label;

correct = response == trialType;
nC = sum(correct==1); t2.nC = nC;
nI = sum(correct==0); t2.nI = nI;

ratingHR  = [];
ratingFAR = [];
for c = max(conf)-1:-1:1
    currentT2response = conf;
    currentT2response(conf <= c) = 0;
    currentT2response(conf > c) = 1;
    
    hits = currentT2response(correct == 1);
    FAs = currentT2response(correct == 0);

    HR = mean(hits);
    FAR = mean(FAs);
    
    ratingHR(end+1)  = HR;
    ratingFAR(end+1) = FAR;
end

t2.ratingHR = ratingHR;
t2.ratingFAR = ratingFAR;

ratingHR(ratingHR == 1) = 1 - (1/(2*nC));
ratingHR(ratingHR == 0) = 1/(2*nC);
ratingFAR(ratingFAR == 0) = 1/(2*nI);
ratingFAR(ratingFAR == 1) = 1 - (1/(2*nI));

t2.adjRatingHR = ratingHR;
t2.adjRatingFAR = ratingFAR;

if all(ratingFAR == ratingFAR(1))
    t2.s = 1;
    t2.zIntercept = mean(norminv(ratingHR) - norminv(ratingFAR));
else
    p = polyfit(norminv(ratingFAR), norminv(ratingHR), 1);
    t2.s = p(1);
    t2.zIntercept = p(2);
end

F = t2.adjRatingFAR;
H = t2.adjRatingHR;
t2.phi = (sqrt(pI*pC)*(H-F)) ./ sqrt( (pC*H+pI*F).*(1-(pC*H+pI*F)) );

t2.tau = corr(correct',conf','type','Kendall');

Ag = 0;
F = [0 t2.adjRatingFAR 1];
H = [0 t2.adjRatingHR 1];
for i=1:length(F)-1
    Ag = Ag + (F(i+1) - F(i)) * (H(i+1) + H(i));
end

t2.Ag = 0.5*Ag;

%% get outputs ready
summary.type = 'summary';
summary.label = label;
summary.dprime = b.dprime;
summary.criterion = b.criterion;
summary.d_a = r.d_a;
summary.c_a = r.c_a;
summary.s = r.s;
summary.t1_Ag = r.Ag;
summary.t2_Ag = t2.Ag;
summary.meanConf = mean(conf);
summary.pC = pC;
summary.pS2 = pS2;
summary.pR2 = pR2;

basicSDT = b;
ratingSDT = r;
type2SDT = t2;