clc; clear;
addpath(genpath('../'));
root_folder = '../../dataset/barn1/';
left_disp_file = 'disp2.pgm';
right_disp_file = 'disp6.pgm';

window_size = 9;
assert(mod(window_size,2) == 1);
max_search_space = 50;
which_metric = 1;        % '1' -> euclidean distance based , '2' -> correlation based
sigma = 1.0;
canny_threshold = 0.1;
scale = 0.1;

for index=0:7
    left_img_file = strcat(strcat('im', int2str(index)),'.ppm');
    right_img_file = strcat(strcat('im',int2str(index+1)),'.ppm');

    left_img = imread(strcat(root_folder,left_img_file));
    right_img = imread(strcat(root_folder,right_img_file));
    left_disp_gt = imread(strcat(root_folder,left_disp_file));
    right_disp_gt = imread(strcat(root_folder,right_disp_file));

    disparity_map = compute_disparity_full(left_img, right_img, window_size, max_search_space, which_metric, sigma);
    % disparity_map = compute_disparity_edge(left_img, right_img, window_size, max_search_space, which_metric, canny_threshold, sigma);
    depth_map = 1./disparity_map(:,1:end-1);
    
    if index == 0
        final_depth_map = depth_map;
    else
        final_depth_map = final_depth_map + depth_map;
    end
end
final_depth_map = final_depth_map/8;
final_depth_map = final_depth_map/max(max(final_depth_map));
fig1 = figure;imshow(final_depth_map);title('Depth Image from multiple cameras');
print(fig1, '-dpng', '-r0', '../../results/depth-from-multiple-cameras-results/barn1/ws_9_mss_50.png');