function y=three22(f)
f=double(f);
[m,n,np]=size(f);
y=zeros(m*n,np);
for i=1:np
    temp=f(:,:,i);
    y(:,i)=temp(:);
end
