clc; clear all; close all;
% A=imread('bar.png'); %Read in binary image
A=imread('dd.jpg'); %Read in binary image
I = A(:,:,2);
I = double(imresize(I, [256 256]));
figure;imshow(I,[]);

% I = double(I / 255);

p = I; r = 15;
eps = 0.1^2;
q = zeros(size(I));

% q(:, :, 1) = guidedFilter_R(I(:, :, 1), p(:, :, 1), r, eps);
% colfilt(imSrc, [2*r+1, 2*r+1], 'sliding', @sum);

[hei, wid] = size(I);
N = 17; % the size of each local patch; N=(2r+1)^2 except for boundary pixels.

mean_I = colfilt(I, [2*r+1, 2*r+1], 'sliding', @sum) ./ N;
mean_p = colfilt(p, [2*r+1, 2*r+1], 'sliding', @sum) ./ N;
mean_Ip = colfilt(I.*p, [2*r+1, 2*r+1], 'sliding', @sum) ./ N;
% mean_Ip = boxfilter(I.*p, r) ./ N;
cov_Ip = mean_Ip - mean_I .* mean_p; % this is the covariance of (I, p) in each local patch.

mean_II = colfilt(I.*I, [2*r+1, 2*r+1], 'sliding', @sum) ./ N;
var_I = mean_II - mean_I .* mean_I;

a = cov_Ip ./ (var_I + eps); % Eqn. (5) in the paper;
b = mean_p - a .* mean_I; % Eqn. (6) in the paper;

mean_a = colfilt(a, [2*r+1, 2*r+1], 'sliding', @sum) ./ N;
mean_b = colfilt(b, [2*r+1, 2*r+1], 'sliding', @sum) ./ N;

q = mean_a .* I - mean_b; % Eqn. (8) in the paper;

figure;imshow(q,[]);

figure;
ii= ((I - q) * 10);
imshow(ii,[]);


figure;
imshow((((q - I)*10)+ii),[]);
