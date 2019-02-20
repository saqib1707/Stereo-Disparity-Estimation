clc; clear;
root_folder = '../../dataset/teddy/';
left_img_file = 'teddy_left.png';
right_img_file = 'teddy_right.png';
left_disp_file = 'teddy_disparity_left.png';
right_disp_file = 'teddy_disparity_right.png';

left_img = imread(strcat(root_folder,left_img_file));
right_img = imread(strcat(root_folder,right_img_file));
left_disp_gt = imread(strcat(root_folder,left_disp_file));
right_disp_gt = imread(strcat(root_folder,right_disp_file));

[left_img, right_img, left_disp_gt, right_disp_gt] = myresize(left_img,right_img,left_disp_gt,right_disp_gt,0.5);

left_edge_img = edge(rgb2gray(left_img),'canny',0.1);
right_edge_img = edge(rgb2gray(right_img),'canny',0.1);

window_size = 5;
assert(mod(window_size,2) == 1);
max_search_space = 50;
option = 2;        % '1' -> euclidean distance based , '2' -> correlation based
sigma = 1.0;

%disparity_map = compute_disparity_full(left_img, right_img, left_edge_img, right_edge_img, window_size, max_search_space, option, sigma);
disparity_map = compute_disparity_edge(left_img, right_img, left_edge_img, right_edge_img, window_size, max_search_space, option, sigma);

figure;
subplot(2,2,1);imshow(left_img);
subplot(2,2,2);imshow(left_edge_img);
subplot(2,2,3);imshow(right_img);
subplot(2,2,4);imshow(right_edge_img);

figure;
subplot(2,2,1);imshow(right_img);
subplot(2,2,2);imshow(right_edge_img);
subplot(2,2,3);imshow(right_disp_gt);
subplot(2,2,4);imshow(disparity_map);