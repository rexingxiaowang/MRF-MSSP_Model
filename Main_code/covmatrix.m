function [C,m]=covmatrix(X)
[K,n]=size(X);
X=double(X);
if K==1
    C=eye(n)*eps;
    m=X;
else
    m=sum(X,1)/K;  %,,���ÿһ�еľ�ֵ������һ����K�У��Ұ�K����������ٳ���K�õ���һ�еľ�ֵ��Ҳ����Ϊ��һ���εľ�ֵ��m��һ��������
    X=X-m(ones(K,1),:);  %  
    C=(X'*X)/(K-1);  %�����䷽��
    m=m';
end
end
