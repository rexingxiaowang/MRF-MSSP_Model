function indexes = randomSelectTrainSet(TestLabels,n)
% Random Select certain number of samples from the whole set of ground
% truth as the train 

ClassNum = max(TestLabels(:));
% if ClassNum ~= numel(unique(TestLabels(:)))-1
%     error('Inputed TestLabels should start from 1 and continuing!');
% end
    
indexes = [];
for i = 1:ClassNum
    ClassIndex = find(TestLabels == i);
    tmpIndex = randperm(length(ClassIndex));
    if length(tmpIndex)>n
        indexes = [indexes, ClassIndex(tmpIndex(1:n))'];
    else
        indexes = [indexes, ClassIndex(tmpIndex(1:floor(length(tmpIndex)/2)))'];
    end
end
