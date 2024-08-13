function [yini1,k]=Icm(y,k1,beta)
% y: original image, k: number of classes for segmentation, beta: label model weight

%%  initialization
[m,n,np]=size(y);
yy=reshape(y,m*n,np);
rand('state',0);
k=2*k1-1;
ini_k=kmeans(yy,k);
pos_labels=reshape(ini_k,m,n);
pri_labels=zeros(m,n);
%%  running program
ite=0;
error=sum(sum(abs(pri_labels-pos_labels)));
while error>0 && ite<5
    ite=ite+1;
    pri_labels=pos_labels;
    mu = zeros(k, np);
    sigma = zeros(np,np,k);
    for i = 1:k
        Im_i = yy(pri_labels == i,:);
        [sigma(:,:,i),mu(i,:)] = covmatrix(Im_i);
    end
    E_ob=zeros(m*n,k);
    labels_nei=NeiX(pri_labels);
    nein=three22(labels_nei);
    E_labels=zeros(m*n,k);
    for i = 1:k
        mu_i = mu(i,:);
        sigma_i = sigma(:,:,i);
        diff_i = yy - repmat(mu_i,[n*m,1]);
        E_ob(:,i) = sum(diff_i * inv(sigma_i) .* diff_i, 2) + log(det(sigma_i));
        E_labels(:,i)=2*sum(nein~=i,2)-8;
    end  
    E_total=E_ob+beta*E_labels;
    [~, pos_labels]=min(E_total,[],2);
    pos_labels=reshape(pos_labels,m,n);
    error=sum(sum(abs(pri_labels-pos_labels)));
end
yini1=pos_labels;
end