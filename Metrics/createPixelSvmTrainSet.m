function  [TrainData, TestData] = createPixelSvmTrainSet(ClassCount,FS,TrainImg,varargin)
%CREATESVMTRAINSET 依据指的的训练样本图生成训练样本集合
% INPUT:
    % ClassCount: ClassCount
    % FS:feature stack
    % TrainImg: a image mask showing different class samples
% OUTPUT：
%  TrainData： 第一列为类别标记，后面为对应的特征
%  TestData： 第一列为类别标记，后面为对应的特征

%判断输入参数数量是否正确
narginchk(3,4);

%如果未说明则对FS每一维（）列特征均归一化处理到[-1，-1]或单位方差
if isempty(varargin) || isequal(varargin(1),'true')
%     %单位方差
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


%生成特征结构体P, 其中P{i}{1}为特征值，P{i}{2}为类别i的采集特征的数量
 P = cell(1,ClassCount);
 for i = 1:ClassCount
     P{i}{1} = FS(TrainImg==i,:);%特征值
     P{i}{2} = size(P{i}{1},1);%类别i的采集特征的数量
 end

%统计训练样本的总数量
Num_of_sample = 0;
m = size(FS,2);%特征维数
for i = 1:ClassCount
    Num_of_sample = Num_of_sample + P{i}{2};
end

%获得训练集
TrainData = zeros(Num_of_sample,m+1);
%训练集第一列赋值,表示类别
indx = 1;
for i = 1:ClassCount
    TrainData(indx:indx+P{i}{2}-1,1) = i;
    TrainData(indx:indx+P{i}{2}-1,2:m+1) = P{i}{1};
    indx = indx+P{i}{2};
end

fprintf(1,' 特征提取完成!\n');
