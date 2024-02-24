clc
%clear
close all
warning off

length_t = [];
width_t = [];
his_t = [];
area_t = [];
addpath('/leafs')
datab = imageSet('leafs')
for i = 1:datab.Count
[file path] = uigetfile('*.bmp','Select Image');
if path==0
    msgbox('Image not selected')
    return
end
data(i).name = file;
data(i).num = i;
I1 = imread(strcat(path,file));
figure,imshow(I1)
title('Input Image')
I1 = imresize(I1,[360 360]);

img1=I1;
for c = 1 : 3
   filt_img(:, :, c) = medfilt2(img1(:, :, c));
end
% removing blur if any using wiener filter

I = im2double(filt_img);
PSF = fspecial('gaussian',7,10);
Blur_img = imfilter(I,PSF,'conv','circular');
filt_wien = deconvwnr(Blur_img, PSF, 0);
%masking green pixels
mask=(filt_img(:,:,2)>filt_img(:,:,1)) & (filt_img(:,:,2)>filt_img(:,:,3));
threshold_image=bsxfun(@times, filt_img, cast(imcomplement(mask), 'like', filt_img));
figure,imshow(threshold_image); title('masked image');
ff = imfuse(I1,threshold_image);
figure,imshow(ff)
title('Fused Image')

I = rgb2gray(I1);
figure,imshow(I)
title('Grey Image')
I = imresize(I,[360 360]);

I_filt = imadjust(I);
figure,imshow(I_filt)
title('Fitered Image')

I_adhis = adapthisteq(I_filt);
figure,imshow(I_adhis)
title('Enhanced Image')

[~,I_seg] = kmeans(I_filt,2);
figure,imshow(I_seg)
title('Segmented Image')
ff = imfuse(I1,I_seg);
figure,imshow(ff)
title('Fused Image')

length = sum(I_seg(:,round(size(I_seg,2)/2)));
width = sum(I_seg(round(size(I_seg,1)/2),:));
length_t = [length_t;length];
width_t = [width_t;width];
area = sum(I_seg(:));
area_t = [area_t;area];

figure,
imhist(I)
title('Histogram of an image')
figure,
imhist(I_adhis)
title('Histogram of an Enhanced image')
his = imhist(I);
his_t = [his_t;his'];
title('Color information')
end

query = input('Enter which image to test:');
%% Fuzzy classifier
color =   sum(his_t');
color_f = color./max(color);
len = length_t';
len_f = len./max(len);
wid = width_t';
wid_f = wid./max(wid);
area1 = area_t';
area_f = area1./max(area1);

fis = readfis('fuzzyrules.fis');
out = round(evalfis([len_f(query) wid_f(query) color_f(query)],fis)*query); 
fprintf('Detection using FUZZY : %s\n',data(out).name(1:end-4))
%% ANN Classifier
Inputs_ann = [len_f;wid_f;color_f;area_f];
Targets_ann = [1:15]; 
x = Inputs_ann;
t = Targets_ann;

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 10;
net = patternnet(hiddenLayerSize, trainFcn);

% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);
e = gsubtract(t,y);
error_performance = perform(net,t,y);
tind = vec2ind(t);
yind = vec2ind(y);
percentErrors = sum(tind ~= yind)/numel(tind);
fprintf('Detection using ANN : %s\n',data(query).name(1:end-4))
%% SVM classifier

% SVM classification
TrainingSet=Inputs_ann; 
TestSet=Inputs_ann(:,query); 
GroupTrain=[1;2;3;4;5;6;7;8;9;10;11;12;13;14;15];

mdl = fitcecoc(TrainingSet',GroupTrain);
label_svm = predict(mdl,TestSet');
fprintf('Detection using SVM : %s\n',data(label_svm).name(1:end-4))
