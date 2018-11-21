clc; clear all; close all;

I = im2double(imread('cameraman.tif'));
imshow(I);
title('Original Image (courtesy of MIT)');

LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA);
blurred = imfilter(I, PSF, 'conv', 'circular');
imshow(blurred);figure;
title('Blurred Image');

wnr1 = deconvwnr(blurred, PSF, 0);
imshow(wnr1);
title('Restored Image');