%%
clear all
load data

ccax(:,1) = [];
ccay(:,1) = [];
ccaconfounds(:,1) = [];


%%
C = ccaconfounds.gender;
cbin = zeros(length(ccaconfounds.gender),1);

cbin(C=='Masculin') = 1;

cbin(C=='Feminin') = 2;

cbin(C=='non-binary') = 3;

ccaconfounds.gender = cbin;
confounds = table2array(ccaconfounds);

X = table2array(ccax);
Y = table2array(ccay);


%%



%[pfwer,r,A,B,U,V] = permcca(Y,X,1000, confounds);

[pfwer,r,A,B,U,V,pA,pB] = permloads(Y,X,1000,confounds,[],[],true,false,2)


%%

ynames = ccax.Properties.VariableNames;
xnames = ccay.Properties.VariableNames;

%%
pfwer

close all
figure, 

subplot(1,2,1)

h1 = heatmap(A(:,1))
h1.YDisplayLabels = xnames

subplot(1,2,2)

h2  = heatmap(B(:,1))
h2.YDisplayLabels = ynames


figure, plot(U(:,1), V(:,1), 'o')
ylabel("Metacognitive Variate")
xlabel("Mind-wandering Variate")
lsline

%%

save all_data

