function [disparity] = compute_disparity(left_img, right_img, window_size, max_search_space)
    progress_bar = waitbar(0,'Performing Pixel Intensity Matching...');
    rows = size(left_img,1);
    cols = size(left_img,2);
    feature_size = window_size.^2;
    disparity = zeros(rows-window_size+1,cols-window_size+1);
    left_descriptor = zeros(feature_size,cols-window_size+1);
    right_descriptor = zeros(feature_size,cols-window_size+1);
    for i=1:rows-window_size+1
        for j=1:cols-window_size+1
            left_descriptor(:,j) = reshape(left_img(i:i+window_size-1,j:j+window_size-1),feature_size,1);
            right_descriptor(:,j) = reshape(right_img(i:i+window_size-1,j:j+window_size-1),feature_size,1);
        end;
        
        for j=1:cols-window_size+1
            squared_error_list = [];
            for k=j:min(j+max_search_space-1,cols-window_size+1)
                squared_error = sum((left_descriptor(:,k) - right_descriptor(:,j)).^2);
                squared_error_list = [squared_error_list, squared_error];
            end
            [~,loc] = min(squared_error_list);
            disparity(i,j) = loc;
        end
        waitbar(i/rows, progress_bar);
    end
    close(progress_bar);
    disparity = disparity/max(max(disparity));
end

