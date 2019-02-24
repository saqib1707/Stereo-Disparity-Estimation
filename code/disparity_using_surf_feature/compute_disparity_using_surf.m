clc; clear;
addpath(genpath('../'));
left_img = imread('../../dataset/teddy/teddy_left.png');
right_img = imread('../../dataset/teddy/teddy_right.png');
left_disp_gt = imread('../../dataset/teddy/teddy_disparity_left.png');
right_disp_gt = imread('../../dataset/teddy/teddy_disparity_right.png');
left_img = rgb2gray(left_img);
right_img = rgb2gray(right_img);

[height, width] = size(left_img);    % left and right images have to be of equal size
% points1 = detectHarrisFeatures(left_img);
% points2 = detectHarrisFeatures(right_img);
% [features1,valid_points1] = extractFeatures(left_img,points1);
% [features2,valid_points2] = extractFeatures(right_img,points2);
% indexPairs = matchFeatures(features1,features2);
% matchedPoints1 = valid_points1(indexPairs(:,1),:);
% matchedPoints2 = valid_points2(indexPairs(:,2),:);
% figure; showMatchedFeatures(left_img,right_img,matchedPoints1,matchedPoints2);

points1 = detectSURFFeatures(left_img);
points2 = detectSURFFeatures(right_img);
[f1,vpts1] = extractFeatures(left_img,points1);
[f2,vpts2] = extractFeatures(right_img,points2);

% x = sort(vpts1.Location(:,1), 'descend');
% y = sort(vpts1.Location(:,2), 'descend');
% 
% x = x(1:5,1);
% y = y(1:5,1);
% imshow(left_img);
% hold on;
% plot(x,y,'r+','LineWidth', 1, 'MarkerSize', 5);
% % plot(vpts1.Location(:,1), vpts1.Location(:,2), 'r*', 'LineWidth', 1, 'MarkerSize', 5);hold on;
% % plot(floor(vpts1.Location(:,1)), floor(vpts1.Location(:,2)), 'g+', 'LineWidth', 1, 'MarkerSize', 5);
% title('feature points','FontSize',12);

disparity_map = zeros(height, width);

left_img_kpfeat = [vpts1.Location, f1];
right_img_kpfeat = [vpts2.Location, f2];

[~,idx] = sort(left_img_kpfeat(:,2));
left_img_kpfeat = left_img_kpfeat(idx,:);
[~,idx] = sort(right_img_kpfeat(:,2));
right_img_kpfeat = right_img_kpfeat(idx,:);

for index = 1:size(right_img_kpfeat,1)
    % assuming epipolar line as horizontal
    list_metric = [];
    potential_points = left_img_kpfeat(floor(left_img_kpfeat(:,2)) == floor(right_img_kpfeat(index,2)) & abs(left_img_kpfeat(:,1)-right_img_kpfeat(index,1)) <= 50,:);
    if size(potential_points,1) > 0
        for j=1:size(potential_points,1)
            metric = compute_metric(right_img_kpfeat(index,3:end), potential_points(j,3:end), 1);
            list_metric = [list_metric, metric];
        end
        [~,loc] = min(list_metric);
        disparity_map(floor(right_img_kpfeat(index,1)),floor(right_img_kpfeat(index,2))) = potential_points(loc,1) - right_img_kpfeat(index,1);
    end
end
disparity_map = disparity_map/max(max(disparity_map));
imshow(disparity_map);