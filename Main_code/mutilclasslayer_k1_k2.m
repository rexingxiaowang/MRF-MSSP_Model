function f=mutilclasslayer_k1_k2(y,yini1,yini2,k1,k2,probility2,beta1,beta2,mra)

%%   Basic regional segmentation
[~, labels]=edison_wrapper(y, @RGB2Luv,'MinimumRegionArea',mra);
labels=double(labels+1);
y=double(y);
rgnCount = max(labels(:));
[statt, ~] = labels2edges_self(labels);

%%   Object-based labeled images
[m,n,~]=size(y);
object_k1_img=zeros(m,n);
object_k2_img=zeros(m,n);
object_k1_pos = getRegionClass(yini1, labels);
S_idxlist = regionprops(labels,'PixelIdxList');
for i = 1:k1
    idx = cell2mat(struct2cell(S_idxlist(object_k1_pos==i))');
    object_k1_img(idx) = i;
end

object_k2_pos = getRegionClass(yini2, labels);
S_idxlist = regionprops(labels,'PixelIdxList');

for i = 1:k2
    idx = cell2mat(struct2cell(S_idxlist(object_k2_pos==i))');
    object_k2_img(idx) = i;
end

%%   core algorithm

object_k1_img_pri=zeros(m,n);
object_k2_img_pri=zeros(m,n);
ite=0;
while sum(abs(object_k1_img_pri(:)-object_k1_img(:)))>0 && sum(abs(object_k2_img_pri(:)-object_k2_img(:)))>0 && ite <5
    ite=ite+1;
    object_k1_img_pri=object_k1_img;
    object_k2_img_pri=object_k2_img;
    object_k1_img=object_k2_to_k1(y,labels,rgnCount,k1,k2,object_k2_img,beta1,beta2,statt,object_k1_pos,object_k2_pos,object_k1_img);
    object_k2_img=object_k1_to_k2(y,labels,rgnCount,k1,k2,object_k2_img,beta1,beta2,statt,probility2,object_k2_pos,object_k1_pos,object_k1_img);
end
f=cat(3,object_k1_img,object_k2_img);
end