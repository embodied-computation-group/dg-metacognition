function trimmedMatrix = trimMatrixBorders(matrix,testValue,comparison)
% trimmedMatrix = trimMatrixBorders(matrix,testValue,operator)
%
% Given an input matrix, trims off the left and right-most columns, and top
% and bottom-most rows, of the matrix that don't have any elements where
% the comparison to the testValue is true.
%
% "comparison" is a string describing the point-wise comparison to be made.
% valid values are '==', '>', '>=', '<', '<='
%
% If not specified, default testValue is 0 and default comparison is '=='.
%
% Example:
% x = [ 0 0 0 0 0; 0 1 0 2 0; 0 0 0 3 0; 0 0 0 0 0]
% x =
%      0     0     0     0     0
%      0     1     0     2     0
%      0     0     0     3     0
%      0     0     0     0     0
% y=trimMatrix(x,1,'>=')
% y =
%      1     0     2
%      0     0     3
% 
% None of the elements in the 1st and 4th rows, or 1st and 5th columns,
% satisfied the condition of being greater than or equal to 1, so these
% rows and columns were trimmed. Although the middle column had no elements
% greater than or equal to 1, a portion of it survived the trimming because
% only the borders are trimmed.


if ~exist('testValue','var') || isempty(testValue)
    testValue = 0;
end

if ~exist('comparison','var') || isempty(comparison)
    comparison = '==';
end

r1=1;
r2=size(matrix,1);
c1=1;
c2=size(matrix,2);

r1_trimmed = [];
r2_trimmed = [];
c1_trimmed = [];
c2_trimmed = [];

for i=1:max(size(matrix,1),size(matrix,2))
    if eval(['any(matrix(r1,:) ' comparison ' testValue) && isempty(r1_trimmed)'])
        r1_trimmed = r1;
    end
    
    if eval(['any(matrix(r2,:) ' comparison ' testValue) && isempty(r2_trimmed)'])
        r2_trimmed = r2;
    end
    
    if eval(['any(matrix(:,c1) ' comparison ' testValue) && isempty(c1_trimmed)'])
        c1_trimmed = c1;
    end
    
    if eval(['any(matrix(:,c2) ' comparison ' testValue) && isempty(c2_trimmed)'])
        c2_trimmed = c2;
    end
    
    if ~isempty(r1_trimmed) && ~isempty(r2_trimmed) && ~isempty(c1_trimmed) && ~isempty(c2_trimmed)
        trimmedMatrix = matrix(r1_trimmed:r2_trimmed, c1_trimmed:c2_trimmed);
        break
    end
    
    if isempty(r1_trimmed), r1 = r1 + 1; end
    if isempty(r2_trimmed), r2 = r2 - 1; end
    if isempty(c1_trimmed), c1 = c1 + 1; end
    if isempty(c2_trimmed), c2 = c2 - 1; end

    if r1 > r2 || c1 > c2
        fprintf('The input matrix cannot be trimmed\n');
        trimmedMatrix = [];
        break
    end
end