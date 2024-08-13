function  [TrainData, TestData] = createPixelSvmTrainSet(ClassCount,FS,TrainImg,varargin)
%CREATESVMTRAINSET ����ָ�ĵ�ѵ������ͼ����ѵ����������
% INPUT:
    % ClassCount: ClassCount
    % FS:feature stack
    % TrainImg: a image mask showing different class samples
% OUTPUT��
%  TrainData�� ��һ��Ϊ����ǣ�����Ϊ��Ӧ������
%  TestData�� ��һ��Ϊ����ǣ�����Ϊ��Ӧ������

%�ж�������������Ƿ���ȷ
narginchk(3,4);

%���δ˵�����FSÿһά��������������һ������[-1��-1]��λ����
if isempty(varargin) || isequal(varargin(1),'true')
%     %��λ����
%     FS = zscore(FS);
    
    %[-1,1]
    minData = min(FS,[],1);
    maxData = max(FS,[],1);
    k = 2./(maxData-minData);
    b = -(maxData+minData)./(maxData-minData);
    FS = bsxfun(@times,FS,k);
    FS = bsxfun(@plus,FS,b);
    TestData = FS;
else
    TestData = FS;
end


%���������ṹ��P, ����P{i}{1}Ϊ����ֵ��P{i}{2}Ϊ���i�Ĳɼ�����������
 P = cell(1,ClassCount);
 for i = 1:ClassCount
     P{i}{1} = FS(TrainImg==i,:);%����ֵ
     P{i}{2} = size(P{i}{1},1);%���i�Ĳɼ�����������
 end

%ͳ��ѵ��������������
Num_of_sample = 0;
m = size(FS,2);%����ά��
for i = 1:ClassCount
    Num_of_sample = Num_of_sample + P{i}{2};
end

%���ѵ����
TrainData = zeros(Num_of_sample,m+1);
%ѵ������һ�и�ֵ,��ʾ���
indx = 1;
for i = 1:ClassCount
    TrainData(indx:indx+P{i}{2}-1,1) = i;
    TrainData(indx:indx+P{i}{2}-1,2:m+1) = P{i}{1};
    indx = indx+P{i}{2};
end

fprintf(1,' ������ȡ���!\n');
