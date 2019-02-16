clc; clear;
file1 = '../dataset/barn1/im0.ppm';
file2 = '../dataset/barn1/im1.ppm';
img1 = imread(file1);
img2 = imread(file2);
img1 = im2single(rgb2gray(img1));
img2 = im2single(rgb2gray(img2));
[features1, descriptors1] = vl_sift(img1, 'PeakThresh', 0.03);
[features2, desciptors2] = vl_sift(img2, 'PeakThresh', 0.03);

h1 = vl_plotframe(features1);
h2 = vl_plotframe(features2);
set(h1, 'color', 'r', 'linewidth', 1);
set(h2, 'color', 'b', 'linewidth', 2);