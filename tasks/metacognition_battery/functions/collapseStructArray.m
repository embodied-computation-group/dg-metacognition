function collapsedStruct = collapseStructArray(inputStruct)
% collapsedStruct = collapseStructArray(inputStruct)
%
% Given a struct vector, outputs a single struct whose fields are
% concatenations of the fields in each struct of the input.
%
% e.g. given inputStruct = s, where
%
% s(1).x = [1 2], s(1).y = [4 6]
% s(2).x = [3 4], s(2).y = [7 10]
%
% output c would be
% c.x = [1 2 3 4], c.y = [3 4 7 10]

names=fieldnames(inputStruct);
for n=1:length(names)
    eval(['collapsedStruct.' names{n} '=[];']);
    for m=1:length(inputStruct)
        eval(['collapsedStruct.' names{n} '=[collapsedStruct.' names{n} ' inputStruct(' num2str(m) ').' names{n} '];']);
    end
end