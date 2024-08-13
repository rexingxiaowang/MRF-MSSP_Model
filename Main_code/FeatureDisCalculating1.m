function spectral_weights = FeatureDisCalculating1(Img,labels,statt)
[~,~,dim] = size(Img);
% ImgData = reshape(Img,row*col,dim);
rgnCount = max(labels(:));
SpectralMean = zeros(rgnCount,dim);

% for i = 1:rgnCount
%     SpectralMean(i,:) = mean(ImgData(labels==i,:));
% end

for i = 1:dim
    S = regionprops(labels,Img(:,:,i),"MeanIntensity");
    SpectralMean(:,i) = cell2mat(struct2cell(S(:)))';
end

[y,x] = find(statt');
% spectral_weights = sparse(rgnCount,rgnCount);
spectral_weights = zeros(rgnCount,rgnCount);
for i = 1:dim
    %     spec_dis = pdist2(SpectralMean(:,i),SpectralMean(:,i),'mahalanobis');
    %     spectral_weights(:,:,i) = spec_dis;

    spectralmean = SpectralMean(:,i);
    spec_dis = abs((spectralmean(x)-spectralmean(y))./(spectralmean(x)+spectralmean(y)));
    %     spectral_weight = sparse(rgnCount,rgnCount);
    spectral_weight = zeros(rgnCount,rgnCount);
    spectral_weight(statt~=0) = spec_dis;
    spectral_weight = spectral_weight';
    spectral_weights = spectral_weights + spectral_weight;
end

spectral_weights = exp(-1*(spectral_weights/3));
spectral_weights(statt==0) = 0;
end