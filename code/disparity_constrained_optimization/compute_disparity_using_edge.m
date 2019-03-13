function [disparity_map] = compute_disparity_using_edge(left_img, right_img, window_size, max_search_space, which_metric, canny_threshold, sigma)
    progress_bar = waitbar(0,'Performing Stereo Correspondency Matching...');
    [height,width,~] = size(left_img);     % size([left image]) = size([right image])
    left_padded_img = zeros(height+window_size-1,width+window_size-1,3);
    right_padded_img = zeros(height+window_size-1,width+window_size-1,3);
    temp_var = ceil(window_size/2);
    left_padded_img(temp_var:temp_var+height-1,temp_var:temp_var+width-1,:) = left_img;
    right_padded_img(temp_var:temp_var+height-1,temp_var:temp_var+width-1,:) = right_img;
    feature_size = 3*window_size^2;      % features taken across the 3-channels
    disparity = zeros(height,width);

    right_edge_img = edge(rgb2gray(right_img),'canny',canny_threshold);
    for row = 1:height
        for col = 1:width-1
            if (right_edge_img(row,col) == 1)
                metric_list = zeros(min(col+max_search_space,width)-col,1);
                count = 1;
                right_descriptor = reshape(right_padded_img(row:row+window_size-1,col:col+window_size-1,:),feature_size,1);
                for itr = col+1:min(col+max_search_space, width)
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
                XL = col + loc;
                XR = col;
                disparity(row,col) = XL - XR;
            end
        end
        waitbar(row/height, progress_bar);
    end
    close(progress_bar);
    disparity = disparity/max(max(disparity));
    % disparity_map = disparity;

    disparity_map = zeros(size(disparity));
%     disparity_map = imgaussfilt(disparity, sigma);  %     smooth the disparity map using gaussian blur
    
%     [y_nz, x_nz] = find(disparity_map ~= 0);
%     [y_z, x_z] = find(disparity_map == 0);
%     
%     non_zero_values = disparity_map(disparity_map ~= 0);
%     estimated_points = griddata(x_nz,y_nz,non_zero_values,x_z,y_z,'cubic');
%     estimated_points(isnan(estimated_points)) = 0;
%     
%     disparity_map(disparity_map == 0) = estimated_points;

    % optimization problem for smooth interpolation of disparity map
    progress_bar = waitbar(0,'Performing optimization ...');
    Aineq = [];
    bineq = [];
    Aeq = [];
    beq = [];
    patch_size = 20;
    N = patch_size^2;
    lower_bound(1:N,1) = 0;
    upper_bound(1:N,1) = 1.0;

    options = optimoptions('fmincon', 'Algorithm', 'sqp','MaxFunEvals', 200000, 'MaxIter', 1000, ...
    'Display', 'iter', 'GradObj', 'off', 'DerivativeCheck','off', 'FinDiffType', 'central');

    count = 0;
    for row = 1:floor(height/patch_size)
        for col = 1:floor(width/patch_size)
            starting_point = reshape(im2double(rgb2gray(right_img(patch_size*(row-1)+1:patch_size*row,patch_size*(col-1)+1:patch_size*col,:))),N,1);
            disparity_patch = disparity(patch_size*(row-1)+1:patch_size*row,patch_size*(col-1)+1:patch_size*col);
            obj_func = @(x)objective_function(x, disparity_patch);
            linearcons = @(x)constraints(x, disparity_patch);
            [opt_x, fval, exitflag, output] = fmincon(obj_func, starting_point, Aineq, bineq, Aeq, beq, lower_bound, upper_bound, linearcons, options);
            disparity_map(patch_size*(row-1)+1:patch_size*row,patch_size*(col-1)+1:patch_size*col) = reshape(opt_x,patch_size,patch_size);
            count = count + 1;
            waitbar(count/(floor(height/patch_size)*floor(width/patch_size)), progress_bar);
        end
    end
    close(progress_bar);
end