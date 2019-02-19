clc; clear;
left_img = imread('../dataset/barn1/im0.ppm');
right_img = imread('../dataset/barn1/im8.ppm');
left_disp_gt = imread('../dataset/barn1/disp2.pgm');
right_disp_gt = imread('../dataset/barn1/disp6.pgm');
left_edge_img = edge(rgb2gray(left_img),'canny',0.2);
right_edge_img = edge(rgb2gray(right_img),'canny',0.2);

figure;
subplot(2,2,1);imshow(left_img);
subplot(2,2,2);imshow(left_edge_img);
subplot(2,2,3);imshow(right_img);
subplot(2,2,4);imshow(right_edge_img);

window_size = 5;
max_search_space = 50;
option = 1;        % '1' -> euclidean distance based , '2' -> correlation based
disparity_map = compute_disparity(left_edge_img, right_edge_img, window_size, max_search_space, option);
figure;
subplot(2,2,1);imshow(right_img);
subplot(2,2,2);imshow(right_edge_img);
subplot(2,2,3);imshow(right_disp_gt);
subplot(2,2,4);imshow(disparity_map);