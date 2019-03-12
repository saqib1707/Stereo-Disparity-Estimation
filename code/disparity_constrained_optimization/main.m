clc; clear;
addpath(genpath('../'));
root_folder = '../../dataset/barn1/';
left_img_file = 'im2.ppm';
right_img_file = 'im6.ppm';
left_disp_file = 'disp2.pgm';
right_disp_file = 'disp6.pgm';

% hyper-parameters
window_size = 11;
assert(mod(window_size,2) == 1);
max_search_space = 50;
which_metric = 1;        % '1' -> euclidean distance based , '2' -> correlation based
canny_threshold = 0.1;
sigma = 0.1;
scale = 0.1;     % scale image (for faster computation) if dimensions are too large (of the order of ~ 2000)

% read stereo images and their corresponding ground-truth disparity map
left_img = imread(strcat(root_folder,left_img_file));
right_img = imread(strcat(root_folder,right_img_file));
left_disp_gt = imread(strcat(root_folder,left_disp_file));
right_disp_gt = imread(strcat(root_folder,right_disp_file));

% [left_img, right_img, left_disp_gt, right_disp_gt] = myresize(left_img,right_img,left_disp_gt,right_disp_gt,scale);

disparity_map = compute_disparity_full(left_img, right_img, window_size, max_search_space, which_metric, sigma);
% disparity_map = compute_disparity_edge(left_img, right_img, window_size, max_search_space, which_metric, canny_threshold, sigma);

figure;
subplot(2,2,1);imshow(left_img);title('left image');
subplot(2,2,2);imshow(right_disp_gt);title('disparity ground truth');
subplot(2,2,3);imshow(right_img);title('right image');
subplot(2,2,4);imshow(disparity_map);title('disparity computed');
figure;
subplot(1,2,1);imshow(right_disp_gt);title('disparity ground truth');
subplot(1,2,2);imshow(disparity_map);title('disparity computed');