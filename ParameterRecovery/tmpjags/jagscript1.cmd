load dic
model in "/users/k1764568/DomainGen/Bayes_metad_group_corr.txt"
data in jagsdata.R
compile, nchains(1)
parameters in jagsinit1.R
initialize
update 1000
monitor set d1, thin(1)
monitor set c1, thin(1)
monitor set mu_logMratio, thin(1)
monitor set sigma_logMratio, thin(1)
monitor set rho, thin(1)
monitor set Mratio, thin(1)
monitor deviance
update 10000
coda *, stem('CODA1')
