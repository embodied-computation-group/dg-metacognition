% unpack the variable names and values within a struct
% only works for 1x1 structs

eval(['structFieldNames = fieldnames(' structName ');']);
for fieldNameCounter = 1:length(structFieldNames)
    eval([structFieldNames{fieldNameCounter} ' = ' structName '.' structFieldNames{fieldNameCounter} ';']);
end