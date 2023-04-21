function simData = getmetad5(t1c, t1d, t2f, t2h)

estimateDatabase = zeros(length(2:2),6);
index = 0;
for d=0:.001:2*t1d
    index = index+1;
    
    S1mu = -d/2;
    S2mu = d/2;
    S1sd = 1;
    S2sd = 1;
    
    grain = 1 / 100;
    
%     t2c2 = t1c+grain : grain : S2mu + 6;
%     t2c1 = t1c - (abs(t1c-t2c2));
% 
%     unadjusted_t1C_area = normcdf(t1c,S1mu,S1sd) + (1 - normcdf(t1c,S2mu,S2sd));
%     unadjusted_t1I_area = normcdf(t1c,S2mu,S2sd) + (1 - normcdf(t1c,S1mu,S1sd));
% 
%     unadjusted_t2h_area = normcdf(t2c1,S1mu,S1sd) + (1 - normcdf(t2c2,S2mu,S2sd));
%     unadjusted_t2f_area = normcdf(t2c1,S2mu,S2sd) + (1 - normcdf(t2c2,S1mu,S1sd));
% 
%     current_t2h = unadjusted_t2h_area ./ unadjusted_t1C_area;
%     current_t2f = unadjusted_t2f_area ./ unadjusted_t1I_area;
% 
%     SSE = (current_t2h - t2h).^2 + (current_t2f - t2f).^2;
%     [currentD_minDiff minInd] = min(SSE);

    t2c2 = t1c+grain : grain : S2mu + 4;
    t2c1 = t1c - (abs(t2c2-t1c));
    
    unadjusted_t1C_area = normcdf(t1c,S1mu,S1sd) + (1 - normcdf(t1c,S2mu,S2sd));
    unadjusted_t1I_area = normcdf(t1c,S2mu,S2sd) + (1 - normcdf(t1c,S1mu,S1sd));

    unadjusted_t2h_area = normcdf(t2c1,S1mu,S1sd) + (1 - normcdf(t2c2,S2mu,S2sd));
    unadjusted_t2f_area = normcdf(t2c1,S2mu,S2sd) + (1 - normcdf(t2c2,S1mu,S1sd));

    current_t2h = unadjusted_t2h_area ./ unadjusted_t1C_area;
    current_t2f = unadjusted_t2f_area ./ unadjusted_t1I_area;

    SSE = (current_t2h - t2h).^2 + (current_t2f - t2f).^2;
    [currentD_minDiff minIndex] = min(SSE); % currentD_minDiff is a vector with min SSEs for each t2c1, collapsed across t2c2
       
    currentD_t2h = current_t2h(minIndex);
    currentD_t2f = current_t2f(minIndex);
    currentD_t2c1 = t2c1(minIndex);
    currentD_t2c2 = t2c2(minIndex);
    
   
%     if estimateDiff < currentD_minDiff
%         currentD_minDiff = estimateDiff;
%         currentD_t2h = current_t2h;
%         currentD_t2f = current_t2f;
%         currentD_t2c1 = t2c1;
%         currentD_t2c2 = t2c2;
%     end
    
    estimateDatabase(index,1) = d;
    estimateDatabase(index,2) = currentD_t2h;
    estimateDatabase(index,3) = currentD_t2f;
    estimateDatabase(index,4) = currentD_minDiff;
    estimateDatabase(index,5) = currentD_t2c1;
    estimateDatabase(index,6) = currentD_t2c2;
end

[minval minindex] = min(estimateDatabase(:,4));
simData.M                  = estimateDatabase(minindex,1) / t1d;
simData.metad              = estimateDatabase(minindex,1);
simData.d                  = t1d;
simData.t2cDisplacement    = estimateDatabase(minindex,6) - t1c;
simData.estimates.est_t2h  = estimateDatabase(minindex,2);
simData.estimates.est_t2f  = estimateDatabase(minindex,3);
simData.estimates.SSE      = estimateDatabase(minindex,4);
simData.estimates.est_t2c1 = estimateDatabase(minindex,5);
simData.estimates.est_t2c2 = estimateDatabase(minindex,6);
simData.parameters.t1c     = t1c;
simData.parameters.t1d     = t1d;
simData.parameters.t2f     = t2f;
simData.parameters.t2h     = t2h;