cd('C:\Users\Astrid\Documents\DomainGen\ParameterRecovery');

%Set parameters:
simTwoGroupsD = struct();
simTwoGroupsD.params.d = 1; % Set task performance (d')
simTwoGroupsD.params.d_sigma = 0.08; % Include some between-subject variability
simTwoGroupsD.params.c = 0; % Set task bias (c)
simTwoGroupsD.params.c_sigma = 0.1; % Include some between-subject variability
simTwoGroupsD.params.Ntrials = 400; % Set the number of trials performed
simTwoGroupsD.params.Nratings = 7; % Choose the rating scale to use
simTwoGroupsD.params.Nsims = 322; % Specify the number of simulations for each session
simTwoGroupsD.params.Mratio(1) = 0.8; % Specify Mratio for session 1
simTwoGroupsD.params.Mratio(2) = 0.8; % Specify Mratio for session 2
simTwoGroupsD.params.Mratio_sigma = 0.1; % Include some variability in the Mratio scores
simTwoGroupsD.params.Mratio_rho = [-1 -0.75 -0.50 -0.25 0 0.25 0.50 0.75 1]; % Specify the correlations between the two Mratios

%Create the covariance matrixes:
for d = 1:length(simTwoGroupsD.params.Mratio_rho);
    simTwoGroupsD.params.covMatrix{d} = [simTwoGroupsD.params.Mratio_sigma^2 ...
        simTwoGroupsD.params.Mratio_rho(d).*simTwoGroupsD.params.Mratio_sigma^2;...
        simTwoGroupsD.params.Mratio_rho(d).*simTwoGroupsD.params.Mratio_sigma^2 ...
        simTwoGroupsD.params.Mratio_sigma^2];
end

% Preallocate variables:
MvMratio = NaN(8, max(simTwoGroupsD.params.Nsims));
values_d = NaN(8, max(simTwoGroupsD.params.Nsims));
values_c = NaN(8, max(simTwoGroupsD.params.Nsims));
values_metad = NaN(8, max(simTwoGroupsD.params.Nsims));
values_sims = NaN(8, max(simTwoGroupsD.params.Nsims));
responses_nR_S1  = struct()
responses_nR_S2 = struct()
tempfit = struct();
sim_rho = struct();
sim_mratio = struct();
pstruct = struct();
pcomstruct = struct();
psimstruct = struct();

%Predefine parameter variables.
params_d = [simTwoGroupsD.params.d];
params_c =simTwoGroupsD.params.c;
params_csigma=simTwoGroupsD.params.c_sigma;
params_dsigma=simTwoGroupsD.params.d_sigma;
params_mratio1=simTwoGroupsD.params.Mratio(1);
params_mratio2=simTwoGroupsD.params.Mratio(2);
params_covMatrix= simTwoGroupsD.params.covMatrix;
params_Nrating = simTwoGroupsD.params.Nratings;
params_Ntrials = simTwoGroupsD.params.Ntrials;
params_sims = simTwoGroupsD.params.Nsims;
nps = length(params_sims);
npcm = length(params_covMatrix);

%% Run the parameter recovery (20 times)

parfor runs = 1:20
    for vh = 1:nps
        vps = params_sims(vh);
        for h = 1:npcm
            pcm = params_covMatrix{h};
            for b = 1:vps
                % Generate the Mratio values from a multivariate normal distribution
                MvMratio = mvnrnd([params_mratio1 params_mratio2],...
                    pcm);
                for a = 1:2
                    % Generate dprime values
                    values_d = normrnd(params_d, params_dsigma);
                    % Generate bias values
                    values_c = normrnd(params_c, params_csigma);
                    % Generate meta-d values
                    values_metad = MvMratio(a).*values_d;
                    % Simulate data
                    values_sims = cpc_metad_sim(values_d,...
                        values_metad, values_c, params_Nrating,...
                        params_Ntrials);
                    responses_nR_S1(a,b) = [values_sims.nR_S1];
                    responses_nR_S2(a,b) = [values_sims.nR_S2];
                end
            end
            % fit data
            tempfit = fit_meta_d_mcmc_groupCorr(responses_nR_S1,...
                responses_nR_S2);
            
            sim_rho = [tempfit.rho];
            sim_mratio = [tempfit.Mratio];
            clear tempfit %clear tempfit;
            
            pstruct(h) = sim_rho;
        end
        pcomstruct(vh) = pstruct;
    end
    psimstruct(runs) = pcomstruct;
end
