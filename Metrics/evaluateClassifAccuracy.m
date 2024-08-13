function State = evaluateClassifAccuracy(Ref, Test)
% EVALUATECLASSIFACCURACY calculates the classfication Accuracy
% input:
% Ref:              Reference labeled images (from 1)
% Test£º            Classification results obtained
% output:
% State.kappa:       kappa
% State.OverallAccuracy£º OverallAccuracy
% State.MixMatrix:  confusion matrix
%%
TestFlag = Ref;
SampCount = numel(TestFlag(TestFlag ~= 0));
Num_of_class = max(Ref(:));
MixMatrix = zeros(Num_of_class + 1);
for i=1:size(Ref,1)
    for j=1:size(Ref,2)
        u = Test(i,j);
        v = TestFlag(i,j);
        if (u~=0) &&(v~=0)
            MixMatrix(u,v) = MixMatrix(u,v)+1;
        end
    end
end
OverallAccuracy = sum(diag(MixMatrix)) / SampCount;
sumRowColumn = 0;
for i = 1:Num_of_class
    sumRowColumn =sumRowColumn + MixMatrix(i,1:end-1)*MixMatrix(1:end-1,i);
end
kappa = (SampCount*sum(diag(MixMatrix))-sumRowColumn)...
    /(SampCount.^2-sumRowColumn);
MixMatrix(end,:) =  (diag(MixMatrix))' ./ (sum(MixMatrix(1:end,1:end), 1));
MixMatrix(:,end) = diag(MixMatrix) ./  sum(MixMatrix(1:end,1:end), 2);
MixMatrix(end,end) = OverallAccuracy;
State.kappa = kappa;
State.OverallAccuracy = OverallAccuracy*100;
State.MixMatrix = MixMatrix;
end