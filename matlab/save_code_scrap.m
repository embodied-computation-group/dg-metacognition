%% matlab version
    %     subject = [repmat(sID(n), 1, length(response))]';
    %     modality = {'memory'};
    %     modality = [repmat(modality, 1, length(response))]';
    %     trial = [1:length(response)]';
    %     contrast = nan(1, length(response));
    %
    %     subject_data = table(subject, modality, trial, signal, response, accuracy, confidence, rt, rt_conf, contrast);
    %
    %
    
    
    
    %     all_trials = [1:length(all_data)]';
    %     all_data = [all_data, all_trials, subject_id_vector'];
    %     variables = {'block_trial', 'accuracy', 'response', 'signal', 'confidence', 'rt','conf_rt', 'trial', 'subject'};
    %     combined_file = [metadir sprintf('%03d', sID(n)) '_mem_combined.mat'];
    %     save(combined_file, 'all_data', 'variables'