function [all_mem_data] = combine_mem_data(params)
%% function to combine all memory data into one master table

sID = params.sID;

%% loop and combine
all_mem_data =[];

for n=1:numel(sID)
     
    
  
    accuracy=[];
    response=[];
    signal =[];
    confidence = [];
    rt = [];
    rt_conf =[];
    contrast =[];
    
    
    for block = 1:4
        try
        block_response =[];
        block_accuracy =[];
        block_confidence = [];
        block_signal =[];
        block_contrast = [];
        
        
        datfile = [params.rawdatdir 'memExpData_' sprintf('%03d', sID(n)) '_' int2str(block) '.mat'];
        
        
        clear results
        
        this_accuracy=[];
        this_response=[];
        this_signal =[];
        
        
        load(datfile)
        
        block_study_time = p.studyTimes(block);
        
        % convert proportion to 7 point scale.
        block_confidence = [results.responseConf.*6+1]';
        block_rt = [results.rtChoice]';
        block_conf_rt = [results.rtConf]';
        
        for t = 1:length(block_confidence)
            
            
            if strcmp(results.studiedSide{t}, 'r') & strcmp(results.responseChoice{t}, 'RightArrow')
                
                this_accuracy = 1; % right response, right is correct
                this_signal = 1;
                this_response = 1;
                
            elseif strcmp(results.studiedSide{t}, 'l') & strcmp(results.responseChoice{t}, 'LeftArrow')
                
                this_accuracy = 1; % left response, left is correct
                this_signal = 0;
                this_response = 0;
                
            elseif strcmp(results.studiedSide{t}, 'r') & strcmp(results.responseChoice{t}, 'LeftArrow')
                
                this_accuracy = 0; % left response, right is correct
                this_signal = 1;
                this_response = 0;
                
            elseif strcmp(results.studiedSide{t}, 'l') & strcmp(results.responseChoice{t}, 'RightArrow')
                
                this_accuracy = 0; % right response, left is correct
                this_signal = 0;
                this_response = 1;
                
            else
                this_accuracy = 0;
                this_signal = NaN;
                this_response = NaN;
                
            end
            
            
            
            block_accuracy(t) = this_accuracy;
            block_response(t) = this_response;
            block_signal(t) = this_signal;
            
            
            
            
        end
        
        
        
        signal = [signal; block_signal'];
        response = [response; block_response'];
        accuracy = [accuracy; block_accuracy'];
        confidence = [confidence; block_confidence];
        rt = [rt; block_rt];
        rt_conf = [rt_conf; block_conf_rt];
        
        % for memory, 'contrast' is study time!
        block_contrast = [repmat(block_study_time, 1, length(block_signal))];
        
        contrast = [contrast; block_contrast'];
        
        catch
        
        
        end
        
    end
    
    subject = [repmat(sID(n), 1, length(response))]';
    modality = {'memory'};
    modality = [repmat(modality, 1, length(response))]';
    trial = [1:length(response)]';
    %do_exclude = [repmat(exclude(n), 1, length(response))]';
    
    repeat_exclude = zeros(length(trial), 1);
    
    subject_data = table(subject, modality, trial, signal, response, accuracy, confidence,...
        rt, rt_conf, contrast, repeat_exclude);
    
    %subject_data = table(subject, modality, trial, signal, response, accuracy, confidence,...
        %rt, rt_conf, contrast, do_exclude);
    
    
    
    
    all_mem_data = vertcat(all_mem_data, subject_data);
    
    end




sprintf('missing subject %d, skipping', sID(n))


end


