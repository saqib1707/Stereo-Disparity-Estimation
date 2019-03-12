clc; clear;
addpath(genpath('../'));
root_folder = '../../dataset/barn1/';
left_img_file = 'im0.ppm';
left_disp_file = 'disp2.pgm';
right_disp_file = 'disp6.pgm';

for i=1:8
    right_img_file = strcat(strcat('im',int2str(i)),'.ppm');
    window_size = 11;
    assert(mod(window_size,2) == 1);
    max_search_space = 50;
    which_metric = 1;        % '1' -> euclidean distance based , '2' -> correlation based
    sigma = 1.0;
    canny_threshold = 0.1;
    scale = 0.1;

    left_img = imread(strcat(root_folder,left_img_file));
    right_img = imread(strcat(root_folder,right_img_file));
    left_disp_gt = imread(strcat(root_folder,left_disp_file));
    right_disp_gt = imread(strcat(root_folder,right_disp_file));

    % [left_img, right_img, left_disp_gt, right_disp_gt] = myresize(left_img,right_img,left_disp_gt,right_disp_gt,scale);

    left_edge_img = edge(rgb2gray(left_img),'canny',canny_threshold);
    right_edge_img = edge(rgb2gray(right_img),'canny',canny_threshold);

    disparity_map = compute_disparity_full(left_img, right_img, left_edge_img, right_edge_img, window_size, max_search_space, which_metric, sigma);
    % disparity_map = compute_disparity_edge(left_img, right_img, left_edge_img, right_edge_img, window_size, max_search_space, which_metric, sigma);

    if i==1
        final_img = disparity_map;
    else
        final_img = final_img + disparity_map;
    end
end
final_img = final_img/8;
figure;imshow(final_img);title('Depth Image from multiple cameras');