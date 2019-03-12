function [disparity_map] = compute_disparity_full(left_img, right_img, window_size, max_search_space, which_metric, sigma)
    progress_bar = waitbar(0,'Performing Stereo Correspondency Matching...');
    [height,width,~] = size(left_img);   % size([left image]) = size([right image])
    left_padded_img = zeros(height+window_size-1,width+window_size-1,3);
    right_padded_img = zeros(height+window_size-1,width+window_size-1,3);
    temp_var = ceil(window_size/2);
    left_padded_img(temp_var:temp_var+height-1,temp_var:temp_var+width-1,:) = left_img;
    right_padded_img(temp_var:temp_var+height-1,temp_var:temp_var+width-1,:) = right_img;
    feature_size = 3*window_size^2;   % features taken across the 3-channels
    disparity = zeros(height,width);
    
    for row = 1:height
        for col = 1:width
            metric_list = zeros(min(col+max_search_space-1, width)-col+1,1);
            count = 1;
            right_descriptor = reshape(right_padded_img(row:row+window_size-1,col:col+window_size-1,:),feature_size,1);
            for itr = col:min(col+max_search_space-1, width)
                left_descriptor = reshape(left_padded_img(row:row+window_size-1,itr:itr+window_size-1,:),feature_size,1);
                similarity_metric = compute_metric(left_descriptor, right_descriptor, which_metric);
                metric_list(count,1) = similarity_metric;
                count = count + 1;
            end
            if which_metric == 1
                [~,loc] = min(metric_list);
            elseif which_metric == 2
                [~,loc] = max(metric_list);
            end
            XL = col + loc - 1;
            XR = col;
            disparity(row,col) = XL - XR;
        end
        waitbar(row/height, progress_bar);
    end
    close(progress_bar);
    disparity_map = disparity/max(max(disparity));
    
    % disparity_map = imgaussfilt(disparity_map, sigma);   % smooth the disparity map using gaussian blur
end