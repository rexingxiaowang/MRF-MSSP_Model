function object_k1_img=object_k2_to_k1(y,labels,rgnCount,k1,k2,object_k2_img,beta1,beta2,statt,object_k1_pos,object_k2_pos,object_k1_img)

%%   Initialization
[m,n,z]=size(y);
object_k1_img_p=zeros(m,n);
yy=reshape(y,m*n,z);
S_idxlist = regionprops(labels,'PixelIdxList');
S_Area = regionprops(labels,"Area");
S_Area = cell2mat(struct2cell(S_Area(:)))';

%%   Solving the MRF-MSSP model (Low-level semantic results)
ite=0;
while sum(abs(object_k1_img_p(:)-object_k1_img(:)))>0 && ite<3
    ite=ite+1;
    object_k1_img_p=object_k1_img;

    % transition probability matrix
    label_interactive=zeros(k1,k2);
    t=ones(m*n,1);

    for i=1:k1
        for j=1:k2
            label_interactive(i,j)=sum(t(object_k1_img==i & object_k2_img==j));
        end
    end

    label_inter_for_k1_k2=label_interactive./(repmat(sum(label_interactive,2),[1,k2]));
    energy_label_k1_for_k2=-log(label_inter_for_k1_k2+eps);

    % The feature model is assumed to follow a normal distribution 
    mu_l2_k1 = zeros(k1, z);
    sigma_l2_k1 = zeros(z,z,k1);
    E_ob_object_l2_k1=zeros(m*n,k1); 

    for i = 1:k1
        Im_i_2_k1 = yy(object_k1_img_p == i,:);
        [I1, ~]=size(Im_i_2_k1);
        if I1>0
            [sigma_l2_k1(:,:,i),mu_l2_k1(i,:)] = covmatrix(Im_i_2_k1);
            mu_i_l2_k1 = mu_l2_k1(i,:);
            sigma_i_l2_k1 = sigma_l2_k1(:,:,i);
            diff_i_l2_k1 = yy - repmat(mu_i_l2_k1,[n*m,1]);  
            E_ob_object_l2_k1(:,i) = sum(diff_i_l2_k1 /(sigma_i_l2_k1) .* diff_i_l2_k1, 2) + log(det(sigma_i_l2_k1));
        else
            E_ob_object_l2_k1(:,i)=1/eps;
        end
    end

    energy_feature_k1=zeros(rgnCount,k1);
    for i = 1:k1
        S1 = regionprops(labels,reshape(E_ob_object_l2_k1(:,i),m,n),"MeanIntensity");
        energy_feature_k1(:,i) = cell2mat(struct2cell(S1(:)))'.*S_Area;
    end

    % Label model
    label_inidicate_object_k1=zeros(rgnCount,k1);
    for i = 1:k1
        label_inidicate_object_k1(:,i)=object_k1_pos==i;
    end
    spectral_weights = FeatureDisCalculating1(y,labels,statt);
    energy_label_1 = spectral_weights.*statt*(-1*label_inidicate_object_k1);
    energy_label_1=beta2*energy_label_1;
    energy_label_21 = S_Area.*energy_label_k1_for_k2(:,object_k2_pos)';
    energy_label_total=energy_label_1+30*energy_label_21;
    
    % Temporary result
    total_energy=beta1*energy_feature_k1+energy_label_total;
    [~, label_object_k1]=min(total_energy,[],2);
    for i = 1:k1
        idx = cell2mat(struct2cell(S_idxlist(label_object_k1==i))');
        object_k1_img(idx) = i;
    end
    object_k1_pos=label_object_k1;
end
end