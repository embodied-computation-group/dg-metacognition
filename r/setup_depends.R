# check for pacman package and install if not found
if (!require("pacman")) install.packages("pacman")
pacman::p_load(afex, readr, dplyr, tidyr, ggplot2, cowplot, devtools, here, tidyverse,
               magrittr, reshape2, rjags, coda, lattice, ggmcmc, foreach, doParallel,
               ggpubr, ggpol, patchwork, ggcorrplot, ggstatsplot, GGally, BayesFactor,
               gridExtra, viridis, gghalves, gt, rstatix, scales, apaTables,
               ggside, ggExtra, corx, papaja, osfr, kableExtra, knitr, rempsyc)

# load the metaSDT package from github
if (!require("metaSDT")) devtools::install_github("craddm/metaSDT")
# load Rousselet correlation package 
if (!require("bootcorci")) devtools::install_github("GRousselet/bootcorci")
devtools::install_github("rempsyc/rempsyc")
# for papaja
if(!requireNamespace("tinytex", quietly = TRUE)) install.packages("tinytex")

tinytex::install_tinytex()

# source local functions and scripts
source(here("r", "remove_outliers_robust.R"))
source(here("r", "outliers.R"))
source(here("r", "trials2counts.R"))
source(here("r", "metad_indiv.R"))
source(here("r", "fit_mle.R"))
source(here("r", "sdt_functions.R"))
source(here("r", "Function_metad_groupcorr.R"))
source(here("r", "BootCorci.R"))
source(here("r", "Function_scatterplot.R"))
source(here("r", "function_rhoPlot.R"))
source(here("r", "function_apa.R"))
source(here("r", "function_rhoPlot.R"))
source(here("r", "Function_ind_hier.R"))
source(here("r", "APA_bootcortables.R"))
source(here("r", "rtfMakeDocument.R"))
source(here("r", "rtfMakeTable.R"))
source(here("r", "apaTables.R"))
