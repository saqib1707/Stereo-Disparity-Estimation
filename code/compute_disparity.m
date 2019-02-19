function [disparity] = compute_disparity(left_img, right_img, window_size, max_search_space, option)
    progress_bar = waitbar(0,'Performing Pixel Intensity Matching...');
    height = size(left_img,1);
    width = size(left_img,2);
    feature_size = window_size.^2;
    disparity = zeros(height-window_size+1, width-window_size+1);
    left_descriptor = zeros(feature_size, width-window_size+1);
    right_descriptor = zeros(feature_size,width-window_size+1);
    for i = 1:height-window_size+1
        for j = 1:width-window_size+1
            left_descriptor(:,j) = reshape(left_img(i:i+window_size-1,j:j+window_size-1),feature_size,1);
            right_descriptor(:,j) = reshape(right_img(i:i+window_size-1,j:j+window_size-1),feature_size,1);
        end;
        
        for j = 1:width-window_size+1
            metric_list = [];
            for k = j:min(j+max_search_space-1,width-window_size+1)
                similarity_metric = compute_metric(left_descriptor(:,k), right_descriptor(:,j), option);
                metric_list = [metric_list, similarity_metric];
            end
            if option == 1
                [~,loc] = min(metric_list);
            elseif option == 2
                [~,loc] = max(metric_list);
            end
            disparity(i,j) = loc;
        end
        waitbar(i/(height-window_size+1), progress_bar);
    end
    close(progress_bar);
    disparity = disparity/max(max(disparity));
end