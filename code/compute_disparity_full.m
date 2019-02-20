function [disparity_map] = compute_disparity_full(left_img, right_img, left_edge_img, right_edge_img, window_size, max_search_space, option, sigma)
    progress_bar = waitbar(0,'Performing Pixel Intensity Matching...');
    [height,width,~] = size(left_img);
    left_padded_img = zeros(height+window_size-1,width+window_size-1,3);
    right_padded_img = zeros(height+window_size-1,width+window_size-1,3);
    temp = ceil(window_size/2);
    left_padded_img(temp:temp+height-1,temp:temp+width-1,:) = left_img;
    right_padded_img(temp:temp+height-1,temp:temp+width-1,:) = right_img;
    feature_size = 3*window_size.^2;
    disparity = zeros(height,width);
    left_descriptor = zeros(feature_size,width);
    right_descriptor = zeros(feature_size,width);
    
    for row = 1:height
        for col = 1:width
            right_descriptor(:,col) = reshape(right_padded_img(row:row+window_size-1,col:col+window_size-1,:),feature_size,1);
            left_descriptor(:,col) = reshape(left_padded_img(row:row+window_size-1,col:col+window_size-1,:),feature_size,1);
        end
        for col = 1:width
            metric_list = zeros(min(col+max_search_space-1, width)-col+1,1);
            count = 1;
            for itr = col:min(col+max_search_space-1, width)
                similarity_metric = compute_metric(left_descriptor(:,itr), right_descriptor(:,col), option);
                metric_list(count,1) = similarity_metric;
                count = count + 1;
            end
            if option == 1
                [~,loc] = min(metric_list);
            elseif option == 2
                [~,loc] = max(metric_list);
            end
            disparity(row,col) = loc;
        end
        waitbar(row/height, progress_bar);
    end
    close(progress_bar);
    disparity = disparity/max(max(disparity));
    
    % smooth the disparity map using gaussian blur
    disparity_map = imgaussfilt(disparity, sigma);
end