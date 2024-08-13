clc
clear
close all
tic
%%     This code is used to test the performance of Aerial image on the MRF-MSSP model
%      Code from J. Wang, Dr. L. Wang and Dr. C. Zheng
%      spectral dissimilarity and hierarchical semantic for remote sensing image 
%%   Input test data
%    Aerial image
%    y: The tested image
%    label_k2: ground truth
y=double(imread("..\Aerial image\image.bmp"));
label_k2 = double(imread('..\Aerial image\GroundTruth.bmp'));

%%   Initialization of the two-layer labels
%  High-level semantic label
load('..\Aerial image\initialization.mat')
k2=size(probility2,2); % number of classes for segmentation

%  Low-level semantic label
beta=1; % Weight of the label model
[yini1,k1] = Icm(y,k2,beta);

%%   Setting parameters
%  beta1: Weight of the feature model,  beta2: Weight of the label model, mra: Minimum region area
beta1=1;
beta2=30;
mra=420;

%%   running program
f=mutilclasslayer_k1_k2(y,yini1,yini2,k1,k2,probility2,beta1,beta2,mra);

%%   Segmentation precision evaluation
s2=evaluateClassifAccuracy(label_k2,f(:,:,2));
kappa_2=s2.kappa
oa_2=s2.OverallAccuracy

%%   Visualization of results
colorMap=[0,205,0;0,206,206;128,128,128;255,190,0]/255;
figure,imshow(label2rgb(f(:,:,2),colorMap));
%%   Save result
imwrite(f(:,:,2),colorMap,'..\Result\Result_aerial-image.bmp');
toc