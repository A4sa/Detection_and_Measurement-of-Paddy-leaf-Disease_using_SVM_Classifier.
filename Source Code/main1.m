clc
clear
close all
warning off

[file path] = uigetfile('*.bmp','Select Image');
I1 = imread(strcat(path,file));
figure,imshow(I1)
title('Input Image')
I1 = imresize(I1,[256 256]);

I = rgb2gray(I1);
figure,imshow(I)
title('Grey Image')
I = imresize(I,[256 256]);

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
area = sum(I_seg(:));

figure,
imhist(I)
title('Histogram of an image')
figure,
imhist(I_adhis)
title('Histogram of an Enhanced image')
his = imhist(I);

