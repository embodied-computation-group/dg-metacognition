function [all_data] = combine_percept_data(params)

%% setup
sID = params.sID;



%%

all_data =[];
for n=1:numel(sID)
    
    
    subject_data = [];
    
    
    datfile = [params.rawdatdir 'perceptData_' sprintf('%03d', sID(n)) '.mat'];
    
    clear DATA
    
    try
        load(datfile)
        
        response = [];
        rt = [];
        rt_conf = [];
        contrast = [];
        confidence = [];
        accuracy = [];
        
        for block = 1:8
            
            response = [response; DATA(block).results.response'];
            rt = [rt; DATA(block).results.rt'];
            rt_conf = [rt_conf; DATA(block).results.rtConf'];
            contrast = [contrast; DATA(block).results.contrast(1:end-1)'];
            confidence = [confidence; DATA(block).results.responseConf'];
            accuracy = [accuracy; DATA(block).results.correct'];
            
            
        end
        
        % convert 0-1 proportion into 7-point confidence
        confidence = confidence.*6+1;
        
        % transform response to SDT format
        response(response == 1) = 0;
        response(response == 2) = 1;
        
        % identify signal ID
        
        signal = nan(length(response),1);
        
        for t = 1:length(signal)
         
            if response(t) == 0 & accuracy(t) == 1
                
                signal(t) = 0;
                
            elseif response(t) == 1 & accuracy(t) == 0
                
                signal(t) = 0;
                
            elseif response(t) == 0 & accuracy(t) == 0
                
                signal(t) = 1;
                
            elseif response(t) == 1 & accuracy(t) == 1
                
                signal(t) = 1;
                
            end
        end
        
        subject_id_vector = [repmat(sID(n), 1, length(response))];
        modality = {'vision'};
        modality = [repmat(modality, 1, length(response))]';
        trial = [1:length(response)]';
        repeat_exclude = zeros(length(trial),1);
        
        subject_data = [subject_id_vector', trial, signal, response, accuracy, confidence, rt, rt_conf, contrast, repeat_exclude];
        
        subject = subject_id_vector';
        output_table = table(subject, modality, trial, signal, response, accuracy, confidence, rt, rt_conf, contrast, repeat_exclude);
        
       
        
        
        %% dump into all data vector, save subject file
        %variable_names = {'sID', 'trial', 'response', 'rt', 'rt_conf', 'contrast', 'confidence', 'accuracy'};
        %all_data = [all_data; subject_data];
        
        all_data = vertcat(all_data, output_table);
        sample_subject = subject_data;
        
        
    catch
        
    end
    
    
    
end


