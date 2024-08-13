function [WLV, Var, SD, WSD] = intrasegHomogn(Image, LabelMat,varargin)
%INTRASEGHOMOGN is a measure of intrasegment homogeneity
% Input:
%    image: image used for measuring����row, col,dim�� OR ��row*col,dim���� 
%    labelMat: label matrix L. Positive integer elements of L correspond to different regions.
%    Mask: a logical matric which defines regions used for statisting. if no defination, measure for all regions.  
% OutPut:
%    WLV: weighted intrasegment homogeneity�� equals a area-weighted Variance
%    mean of all segments
%    Var: a measure of mean of segment variances d 
%    SD: a measure of mean of segment stand deviations 
% Referance:
%    1.G. M. Espindola, G. Camara, I. A. Reis, L. S. Bins, and A. M. Monteiro, "Parameter selection for region�\growing image segmentation algorithms using spatial autocorrelation,
% " International Journal of Remote Sensing, 27:3035-3040, 2006/07/20 2006.
%    2.Dr��gu?, L., D. Tiede and S. R. Levick (2010). "ESP: a tool to estimate scale parameter for multiresolution image segmentation of remotely sensed data." 
%    International Journal of Geographical Information Science 24(6): 859-871.


%��������ǿ��ת��
if ~isa(Image,'double')
   Image = double(Image);
end

%����������Ӱ�񣬶���2ά���󣬽���ת��
if size(Image,3) >1
    Image = reshape(Image, size(LabelMat,1)*size(LabelMat,2), size(Image,3));
end

%������Ϣ
Stats = regionprops(LabelMat,'PixelIdxList','Area');

%������ָ����������
if nargin == 3
    Mask = varargin{1};
    TmpLabels = unique(LabelMat(Mask));
    Stats = Stats(TmpLabels);
end

%���в��ε����򷽲�
VariStack = zeros(length(Stats),size(Image,2));
for i = 1:length(Stats)
    Image(Stats(i).PixelIdxList,:) = bsxfun(@minus,Image(Stats(i).PixelIdxList,:),mean(Image(Stats(i).PixelIdxList,:),1)) ;
    VariStack(i,:) = sum(Image(Stats(i).PixelIdxList,:).^2)./(Stats(i).Area-1);
end
%�������򷽲�������Ȩ��ֵ
WLV = [Stats.Area]*mean(VariStack,2)/sum([Stats.Area]);

%�������򷽲�ľ�ֵ
Var = mean(mean(VariStack,2));

%���������׼����ľ�ֵ
SD = mean(mean(sqrt(VariStack),2));
WSD = [Stats.Area]*mean(sqrt(VariStack),2)/sum([Stats.Area]);

return;

