function object_k2_img=object_k1_to_k2(y,labels,rgnCount,k1,k2,object_k2_img,beta1,beta2,statt,probility2,object_k2_pos,object_k1_pos,object_k1_img)

%%   Initialization
[m,n,~]=size(y);
object_k2_img_p=zeros(m,n);
S_idxlist = regionprops(labels,'PixelIdxList');
S_Area = regionprops(labels,"Area");
S_Area = cell2mat(struct2cell(S_Area(:)))';

%%   Solving the MRF-MSSP model (Low-level semantic results)
ite=0;
while sum(abs(object_k2_img_p(:)-object_k2_img(:)))>0 && ite<3
    ite=ite+1;
    object_k2_img_p=object_k2_img;

    % transition probability matrix
    label_interactive=zeros(k1,k2);
    t=ones(m*n,1);

    for i=1:k1
        for j=1:k2
            label_interactive(i,j)=sum(t(object_k1_img==i & object_k2_img==j));
        end
    end

    label_inter_for_k1_k2=label_interactive./(repmat(sum(label_interactive,1),[k1,1]));
    energy_label_k1_for_k2=-log(label_inter_for_k1_k2+eps);

    % The feature model
    pixel_feature_k2=-log(probility2+eps);
    energy_feature_k2=zeros(rgnCount,k2);
    for i = 1:k2
        S2 = regionprops(labels,reshape(pixel_feature_k2(:,i),m,n),"MeanIntensity");
        energy_feature_k2(:,i) = cell2mat(struct2cell(S2(:)))'.*S_Area;
    end

    % Label model
    label_inidicate_object_k2=zeros(rgnCount,k2);
    for i = 1:k2
        label_inidicate_object_k2(:,i)=object_k2_pos==i;
    end
    spectral_weights = FeatureDisCalculating1(y,labels,statt);
    energy_label_1 = spectral_weights.*statt*(-1*label_inidicate_object_k2);
    energy_label_1=beta2*energy_label_1;
    energy_label_22 =30*energy_label_k1_for_k2(object_k1_pos,:);
    energy_label_total=energy_label_1+energy_label_22;

    % Temporary result
    total_energy=beta1*energy_feature_k2+energy_label_total;
    [~, label_object_k2]=min(total_energy,[],2);
    object_k2_pos=label_object_k2;
    for i = 1:k2
        idx = cell2mat(struct2cell(S_idxlist(label_object_k2==i))');
        object_k2_img(idx) = i;
    end
end
end