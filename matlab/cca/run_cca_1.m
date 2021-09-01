%%

%load allgroupdata.mat

A = allgroupdata.age;

B = allgroupdata.years_edu;

C = allgroupdata.gender;

cbin = zeros(length(C),1);

cbin(C=='Masculin') = 1;

cbin(C=='Feminin') = 2;

cbin(C=='non-binary') = 3;



confounds = [A,B,cbin];

%%



[pfwer,r,A,B,U,V] = permcca(table2array(ccay1),table2array(ccax),1000, confounds);

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

