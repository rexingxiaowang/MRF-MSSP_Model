function noed=normalize_row(newmatrix)

%%   该函数是以行的总和为基准对每一行的数字进行归一化
% 该函数最初是为了将分割精度的混淆矩阵进行归一化而编写的

n=size(newmatrix,2);
noed=zeros(size(newmatrix));
for i=1:n
    total=sum(newmatrix,2);
    noed(i,:)=newmatrix(i,:)/total(i);
end

