function [C,m]=covmatrix(X)
[K,n]=size(X);
X=double(X);
if K==1
    C=eye(n)*eps;
    m=X;
else
    m=sum(X,1)/K;  %,,求出每一列的均值，就是一共有K行，我把K行相加起来再除以K得到这一列的均值，也可视为这一波段的均值，m是一个行向量
    X=X-m(ones(K,1),:);  %  
    C=(X'*X)/(K-1);  %，求其方差
    m=m';
end
end
