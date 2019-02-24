clc; clear;
addpath(genpath('../'));
root_folder = '../../dataset/mypics/';
left_img_file = 'im2.jpg';
right_img_file = 'im3.jpg';
left_disp_file = 'disp2.pgm';
right_disp_file = 'disp6.pgm';

left_img = imread(strcat(root_folder,left_img_file));
right_img = imread(strcat(root_folder,right_img_file));
left_disp_gt = imread(strcat(root_folder,left_disp_file));
right_disp_gt = imread(strcat(root_folder,right_disp_file));

scale = 0.1;
[left_img,right_img,~,~] = myresize(left_img,right_img,left_disp_gt,right_disp_gt,scale);

frameLeftGray  = rgb2gray(left_img);
frameRightGray = rgb2gray(right_img);

disparityMap = im2double(disparity(frameLeftGray, frameRightGray));
disparityMap = disparityMap/max(max(disparityMap));
figure;imshow(right_img);title('right image');
figure;imshow(disparityMap);title('Disparity Map');