function h = SDTplot(plotType, varargin)
% h = SDTplot(plotType, style, varargin)
%
% Plots SDT data and returns handles h to the plotted stuffs.
%
% Two modes are available. One is used to plot specific requests. This 
% allows precise control over the plot but requires more effort.
%
% The other plotting mode automatically generates a series of plots for 
% data structures output by SDTanalysis.m. This is good for getting a quick
% visual impression of the data, though there is no control over the
% formatting of the plots.
%
% Plotting specific requests
% --------------------------
%
% plotType specifies the kind of plot to create. Available types are
% 'sdt', 'ROC', 'ROCfit', 'z', 'zfit'
%
% SDTplot('sdt',style,d,c,s,SDunits)
% plots S1 and S2 distributions corresponding to d', c, and s.
% - style is a 1x3 cell containing markup style for the S1 and S2
%   distributions and the criterion. If a single markup string is entered, 
%   the same markup is used for all 3. Default is {'b-' 'r-' 'k'}
% - d is d'. Can be either d' or d_a.
% - c is criterion. Can be either c or c_a.
% - s is SD(S1)/SD(S2). Default value is 1.
% - SDunits specifies the decision axis units. 'S1' plots in terms of the
%   S1 standard dev, 'S2' in terms of S2 standard dev. Superfluous when s=1,
%   but makes a difference otherwise. Default is 'S1'.
%
% SDTplot('ROC',style,FAR,HR)
% plots a connect-the-dot ROC for vectors FAR and HR.
% - style is a string. Defaults to 'bd-'
% - FAR and HR are 1xN vectors containing N ROC points.
%
% SDTplot('ROCfit',style,FAR,HR)
% plots the best fit ROC for FAR and HR, assuming both are drawn from 
% Gaussian distributions. Any (F,H) pairs containing 0 or 1 are omitted.
% - style is a string. Defaults to 'b-'
% - FAR and HR are 1xN vectors containing N ROC points.
%
% SDTplot('z',style,FAR,HR)
% plots a connect-the-dot zROC for FAR and HR. Any (F,H) pairs containing 0 
% or 1 are omitted.
% - style is a string. Defaults to 'bd-'
% - FAR and HR are 1xN vectors containing N ROC points.
%
% SDTplot('zfit',style,FAR,HR)
% plots the best fit line for FAR and HR in zROC axes. Any (F,H) pairs 
% containing 0 or 1 are omitted.
% - style is a string. Defaults to 'b-'
% - FAR and HR are 1xN vectors containing N ROC points.
%
%
% Making automatic plots
% ----------------------
%
% Data structures that are output from SDTanalysis.m can be used as inputs
% to SDTplot. In this case, every plot appropriate to the data type will be
% plotted automatically, as summarized in the table below.
%
%                              PLOT TYPE
%                   sdt     ROC     ROCfit  z   zfit
%         summary    x
% DATA    basic      x
% TYPE    rating     x       x         x    x     x
%         type 2             x         x    x     x
%
% SDTplot(S1, S2, ..., Sn), where each Si is an output from SDTanalysis,
% plots the n input SDT data structs. Style markup is assigned automatically. 
% Data is plotted on the same figures where possible.
%
% For rating data, adjusted FAR and HR are used for plotting ROCfit, z, and
% zfit, in order to handle cases where FAR or HR = 0 or 1.
%
% Data in each plot are labeled in the legend according to the label and 
% type fields of the corresponding input (see SDTanalysis.m)

%% make a generic plot of the outputs from SDTanalysis
if isstruct(plotType)
    colors = 'kbrgcmy';

    % get the input data
    sdt{1} = plotType;
    types{1} = sdt{1}.type;
    if exist('varargin','var')
        for i=1:length(varargin)
            sdt{i+1} = varargin{i};
            types{i+1} = varargin{i}.type;
        end
    end
    
    uniqueTypes = unique(types);
    sdtplotIsOpen = 0;
    ratingplotIsOpen = 0;
    
    % open up the plots we need to plot on
    for i=1:length(uniqueTypes)
        if any(strcmp(uniqueTypes{i}, {'summary', 'basic', 'rating'}))
            if ~sdtplotIsOpen
                sdtplot = figure; 
                sdtplotIsOpen = 1;
                sdt_h = [];
            end
        end

        if any(strcmp(uniqueTypes{i}, {'rating', 'type 2'}))
            if ~ratingplotIsOpen
                ratingplot = figure; zplot = figure; 
                ratingplotIsOpen = 1;
                rating_h = [];
                z_h = [];
            end
        end
    end
    
    % plot the data, making labels for the legend along the way
    sdtlabels = {};
    ratinglabels = {};
    for i=1:length(sdt)
        if any(strcmp(sdt{i}.type, {'summary', 'basic', 'rating'}))
            sdtlabels{end+1} = [sdt{i}.label ' - ' sdt{i}.type];
            if strcmp(sdtlabels{end}(1:3), ' - '), sdtlabels{end} = sdtlabels{end}(3:end); end
            figure(sdtplot)
            hold on
            h = SDTplot('sdt',colors(mod(length(sdtlabels),length(colors))+1),sdt{i});
            sdt_h(end+1) = h(1);
        end
        
        if any(strcmp(sdt{i}.type, {'rating', 'type 2'}))
            ratinglabels{end+1} = [sdt{i}.label ' - ' sdt{i}.type];
            if strcmp(ratinglabels{end}(1:3), ' - '), ratinglabels{end} = ratinglabels{end}(3:end); end

            figure(ratingplot)
            hold on
            h = SDTplot('ROC',[colors(mod(length(ratinglabels),length(colors))+1) 'd-'],sdt{i});
            rating_h(end+1) = h(1);
            SDTplot('ROCfit',[colors(mod(length(ratinglabels),length(colors))+1) '-.'],sdt{i});

            figure(zplot)
            hold on
            h = SDTplot('z',[colors(mod(length(ratinglabels),length(colors))+1) 'd-'],sdt{i});
            z_h(end+1) = h(1);
            SDTplot('zfit',[colors(mod(length(ratinglabels),length(colors))+1) '-.'],sdt{i});
                
        end
    end

    % make legends
    if ratingplotIsOpen
        legendstr = 'legend(rating_h,';
        for i=1:length(ratinglabels)
            legendstr = [legendstr '''' ratinglabels{i} ''''];
            if i < length(ratinglabels), legendstr = [legendstr ','];
            else legendstr = [legendstr ',''Location'',''SouthEast'');'];
            end
        end
        figure(ratingplot)
        eval(legendstr)
        hold off
        
        legendstr = 'legend(z_h,';
        for i=1:length(ratinglabels)
            legendstr = [legendstr '''' ratinglabels{i} ''''];
            if i < length(ratinglabels), legendstr = [legendstr ','];
            else legendstr = [legendstr ',''Location'',''SouthEast'');'];
            end
        end
        figure(zplot)
        eval(legendstr)
        hold off
    end
    
    if sdtplotIsOpen
        legendstr = 'legend(sdt_h,';
        for i=1:length(sdtlabels)
            legendstr = [legendstr '''' sdtlabels{i} ''''];
            if i < length(sdtlabels), legendstr = [legendstr ','];
            else legendstr = [legendstr ');'];
            end
        end
        figure(sdtplot)
        eval(legendstr)
        hold off
    end
    h=[];
    return
end


%% handle specific plot requests here
switch plotType
    
%% plot rating data on an ROC; just connect the dots   
    case 'ROC'
        style = varargin{1};
        if isempty(style)
            style='bd-';
        end
        
        if isstruct(varargin{2})
            FAR = varargin{2}.ratingFAR;
            HR  = varargin{2}.ratingHR;
        else
            FAR = varargin{2};
            HR  = varargin{3};
        end
        
        [FAR sortIndex] = sort(FAR);
        HR  = HR(sortIndex);
        
        FAR = [0 FAR 1];
        HR  = [0 HR 1];
        
        h = plot(FAR,HR,style,[0 1],[0 1],'k-',[0 .5],[1 .5],'k');
        
        axis([0 1 0 1])
        axis square
        xlabel('FAR')
        ylabel('HR')
        
        
%% plot best fit ROC curve of rating data
    case 'ROCfit'
        style = varargin{1};
        if isempty(style)
            style='b-';
        end   
        
        if isstruct(varargin{2})
            FAR = varargin{2}.adjRatingFAR;
            HR  = varargin{2}.adjRatingHR;
        else
            FAR = varargin{2};
            HR  = varargin{3};
        end
        
        [FAR sortIndex] = sort(FAR);
        HR  = HR(sortIndex);
        
        FARadj = FAR(FAR > 0 & FAR < 1 & HR > 0 & HR < 1);
        HRadj  = HR(FAR > 0 & FAR < 1 & HR > 0 & HR < 1);
        
        FAR = FARadj;
        HR  = HRadj;
        
        if all(FAR == FAR(1))
            s = 1;
            zIntercept = mean(norminv(HR) - norminv(FAR));
        else
            p = polyfit(norminv(FAR), norminv(HR), 1);
            s = p(1);
            zIntercept = p(2);
        end
        
        zF = norminv(.001):.01:norminv(.999);
        zH = s * zF + zIntercept;
        
        FARfit = normcdf(zF);
        HRfit  = normcdf(zH);  

        h = plot(FARfit,HRfit,style,[0 1],[0 1],'k-',[0 .5],[1 .5],'k');
        
        axis([0 1 0 1])
        axis square
        xlabel('FAR')
        ylabel('HR')

        
%% plot rating data on z coordinates; connect the dots        
    case 'z'
        style = varargin{1};
        if isempty(style)
            style='bd-';
        end
        
        if isstruct(varargin{2})
            FAR = varargin{2}.adjRatingFAR;
            HR  = varargin{2}.adjRatingHR;
        else
            FAR = varargin{2};
            HR  = varargin{3};
        end
        
        [FAR sortIndex] = sort(FAR);
        HR  = HR(sortIndex);

        % omit maxed out data
        FARadj = FAR(FAR > 0 & FAR < 1 & HR > 0 & HR < 1);
        HRadj  = HR(FAR > 0 & FAR < 1 & HR > 0 & HR < 1);
        
        FAR = FARadj;
        HR  = HRadj;
        
        % now plot the z
        zFAR = norminv(FAR);
        zHR  = norminv(HR);
        
        h = plot(zFAR,zHR,style,[0 0],[norminv(.01) norminv(.99)],'k:',[norminv(.01) norminv(.99)],[0 0],'k:');
        
        axis([norminv(.01) norminv(.99) norminv(.01) norminv(.99)])
        axis square
        xlabel('zFAR')
        ylabel('zHR')

%% plot best fit of rating data on z coordinates
    case 'zfit'
        style = varargin{1};
        if isempty(style)
            style='b-';
        end          
        
        if isstruct(varargin{2})
            FAR = varargin{2}.adjRatingFAR;
            HR  = varargin{2}.adjRatingHR;
        else
            FAR = varargin{2};
            HR  = varargin{3};
        end
        
        [FAR sortIndex] = sort(FAR);
        HR  = HR(sortIndex);

        % omit maxed out data
        FARadj = FAR(FAR > 0 & FAR < 1 & HR > 0 & HR < 1);
        HRadj  = HR(FAR > 0 & FAR < 1 & HR > 0 & HR < 1);
        
        FAR = FARadj;
        HR  = HRadj;

        if all(FAR == FAR(1))
            s = 1;
            zIntercept = mean(norminv(HR) - norminv(FAR));
        else
            p = polyfit(norminv(FAR), norminv(HR), 1);
            s = p(1);
            zIntercept = p(2);
        end
        
        zFAR = norminv(.001):.01:norminv(.999);
        zHR = s * zFAR + zIntercept;  
        
        h = plot(zFAR,zHR,style,[0 0],[norminv(.01) norminv(.99)],'k:',[norminv(.01) norminv(.99)],[0 0],'k:');
        
        axis([norminv(.01) norminv(.99) norminv(.01) norminv(.99)])
        axis square
        xlabel('zFAR')
        ylabel('zHR')

        
%% SDT plot
    case 'sdt'
        style = varargin{1};
        if isempty(style)
            style{1}='b-'; style{2}='r-'; style{3} = 'k';
        elseif ~iscell(style) || length(style) == 1
            tmp = style;
            clear style
            style{1} = tmp; style{2} = tmp; style{3} = tmp;
        elseif iscell(style) && length(style) == 2
            style{3} = 'k';
        end          
        
        % get input parameters
        if isstruct(varargin{2})
            if strcmp(varargin{2}.type, 'basic')
                d_a = varargin{2}.dprime;
                c_a = varargin{2}.criterion;
                s   = 1;
            else
                d_a = varargin{2}.d_a;
                c_a = varargin{2}.c_a;
                c_a_acrossRatings = varargin{2}.c_a_acrossRatings;
                
                s   = varargin{2}.s;
            end
            plotInTermsOf = 'S1';
                
        else
            d_a = varargin{2};
            c_a = varargin{3};

            if length(varargin) < 3
                s = 1;
            else
                s = varargin{4};
            end

            if length(varargin) > 3
                plotInTermsOf = varargin{5};
                if ~strcmp(plotInTermsOf,'S1') && ~strcmp(plotInTermsOf,'S2')
                    plotInTermsOf = 'S1';
                end
            else
                plotInTermsOf = 'S1';
            end

        end
                
        % get stuff for plotting in terms of either S1 or S2
        switch plotInTermsOf
            case 'S1'
                d2   = d_a / (sqrt(2/(1+s^2)));
                d1   = d2 / s;
                c1   = c_a * (sqrt(1+s^2) / (sqrt(2)*s));
                if exist('c_a_acrossRatings','var')
                    t2c1 = c_a_acrossRatings * (sqrt(1+s^2) / (sqrt(2)*s));
                end
        
                muS1 = -d1/2;
                sdS1 = 1;
                muS2 = d1/2;
                sdS2 = 1/s;
                c    = c1;
                if exist('c_a_acrossRatings','var')
                   t2c  = t2c1;
                else 
                    t2c = [];
                end
                
            case 'S2'
                d2   = d_a / (sqrt(2/(1+s^2)));
                c2   = c_a * (sqrt(1+s^2) / sqrt(2));
                if exist('c_a_acrossRatings','var')              
                   t2c2 = c_a_acrossRatings * (sqrt(1+s^2) / sqrt(2));
                end
                
                muS1 = -d2/2;
                sdS1 = s;
                muS2 = d2/2;
                sdS2 = 1;
                c    = c2;
                if exist('c_a_acrossRatings','var')               
                    t2c  = t2c2;
                else
                    t2c = [];
                end
        end
        
        % make plotting stuff
        xS1  = muS1 - 3*sdS1 : .01 : muS1 + 3*sdS1;
        fxS1 = normpdf(xS1, muS1, sdS1);
         
        xS2  = muS2 - 3*sdS2 : .01 : muS2 + 3*sdS2;
        fxS2 = normpdf(xS2, muS2, sdS2);
        
        cHeight = mean([max(fxS1) max(fxS2)]);    
              
        plotstr = 'plot(xS1,fxS1,style{1},xS2,fxS2,style{2},[c c],[0 cHeight],style{3}';
        for k = 1:length(t2c)
            plotstr = [plotstr ',[t2c( ' num2str(k) ') t2c( ' num2str(k) ' )],[0 cHeight*.75],style{3}'];
        end
        plotstr = [plotstr ')'];
        
%         h = plot(xS1,fxS1,style{1},xS2,fxS2,style{2},[c c],[0 cHeight],style{3});

        h = eval(plotstr);
        xlabel(['SD units of the ' plotInTermsOf ' distribution'])
end