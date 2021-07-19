function [all_data] = combine_trivia_data()

%% setup paths and subject vector
setup_paths;

load sID


%%

all_data = [];



for n = 1:numel(sID)
    
    accuracy=[];
    response=[];
    signal =[];
    confidence = [];
    rt = [];
    rt_conf =[];
    contrast =[];
    
    clear results
    
    datfile = [metadir 'triviaData_' sprintf('%03d', sID(n)) '.mat'];
    
    try
        load(datfile)
        
        
        accuracy = [results.Corrects]';
        response = [results.Responses]';
        
        response(response == 1) = 0; % recode responses
        response(response == 2) = 1;
        
        confidence = [results.Confidence]';
        
        confidence = confidence.*6+1; % recode confidence from proportion to 7 point scale.
        rt = [results.RTS]'./1000;
        rt_conf = [results.RT_Confidence]';
        contrast = [results.DifferenceTarget]';
        trial = [results.trial]';
        
        %    modality = results.
        
        for t = 1:length(response)
            
            if response(t) == 0 & accuracy(t) == 1
                
                signal(t) = 0;
                
            elseif response(t) == 1 & accuracy(t) == 0
                
                signal(t) = 0;
                
            elseif response(t) == 0 & accuracy(t) == 0
                
                signal(t) = 1;
                
            elseif response(t) == 1 & accuracy(t) == 1
                
                signal(t) = 1;
                
            end
        end % encode signal
        
        
        signal = signal';
        
        % modality
        
        condition = results.WhichCondition;
        
        modality = cell(1, length(condition));
        
        modality(condition ==1) = {'GDP'};
        modality(condition ==2) = {'Calories'};
        modality = modality';
        subject_id_vector = [repmat(sID(n), 1, length(response))];
        subject = subject_id_vector';
        
        output_table = table(subject, modality, trial, signal, response, accuracy, confidence, rt, rt_conf, contrast);
        
        all_data = vertcat(all_data, output_table);
        
    catch
        
    end
end

end

