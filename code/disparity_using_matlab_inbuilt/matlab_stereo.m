clc; clear;
addpath(genpath('../'));
root_folder = '../../dataset/venus/';
left_img_file = 'im2.ppm';
right_img_file = 'im6.ppm';
left_disp_file = 'disp2.pgm';
right_disp_file = 'disp6.pgm';

left_img = imread(strcat(root_folder,left_img_file));
right_img = imread(strcat(root_folder,right_img_file));
left_disp_gt = imread(strcat(root_folder,left_disp_file));
right_disp_gt = imread(strcat(root_folder,right_disp_file));

left_gray  = rgb2gray(left_img);
right_gray = rgb2gray(right_img);

disparity_map = im2double(disparity(left_gray, right_gray));
disparity_map = disparity_map/max(max(disparity_map));
figure;
subplot(2,2,1);imshow(left_img);title('left image');
subplot(2,2,3);imshow(right_img);title('right image');
subplot(2,2,2);imshow(left_disp_gt);title('disparity ground truth');
subplot(2,2,4);imshow(disparity_map);title('computed disparity (in-built)');