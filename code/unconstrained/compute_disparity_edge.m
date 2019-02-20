function [final_disparity] = compute_disparity_edge(left_img, right_img, left_edge_img, right_edge_img, window_size, max_search_space, option, sigma)
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
            if (right_edge_img(row,col) == 1)
                right_descriptor(:,col) = reshape(right_padded_img(row:row+window_size-1,col:col+window_size-1,:),feature_size,1);
            end
            if (left_edge_img(row,col) == 1)
                left_descriptor(:,col) = reshape(left_padded_img(row:row+window_size-1,col:col+window_size-1,:),feature_size,1);
            end
        end
        for col = 1:width
            if (right_edge_img(row,col) == 1)
                metric_list = zeros(min(col+max_search_space-1, width)-col+1,1);
                count = 1;
                for itr = col:min(col+max_search_space-1, width)
%                     if (left_edge_img(row,itr) == 1)
                        similarity_metric = compute_metric(left_descriptor(:,itr), right_descriptor(:,col), option);
                        metric_list(count,1) = similarity_metric;
%                     else
%                         if option == 1, metric_list(count,1) = inf; else metric_list(count,1) = -inf; end;
%                     end
                    count = count + 1;
                end
                if option == 1
                    [~,loc] = min(metric_list);
                elseif option == 2
                    [~,loc] = max(metric_list);
                end
                disparity(row,col) = loc;
            end
        end
        waitbar(row/height, progress_bar);
    end
    close(progress_bar);
    disparity = disparity/max(max(disparity));
    
    disparity_map = disparity;
    final_disparity = zeros(size(disparity_map));
    % smooth the disparity map using gaussian blur
%     disparity_map = imgaussfilt(disparity, sigma);
    
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
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    patch_size = 20;

%     starting_point = rand(N,1);
%     , 'TolFun', 1e-1, 'TolCon', 1e-2, 'TolX', 1e-10, ...
    options = optimoptions('fmincon', 'Algorithm', 'interior-point','MaxFunEvals', 100000, 'MaxIter', 100, ...
    'Display', 'iter', 'GradObj', 'off', 'DerivativeCheck','off', 'FinDiffType', 'central');

    for row=1:floor(height/patch_size)
        for col = 1:floor(width/patch_size)
            disp_patch = disparity_map(patch_size*(row-1)+1:patch_size*row,patch_size*(col-1)+1:patch_size*col);
            number_zero_loc = sum(sum(disp_patch == 0));
            N = number_zero_loc;
            lower_bound(1:N,1) = 0;
            upper_bound(1:N,1) = 1.0;
            starting_point = rand(N,1);
            [patch_height, patch_width] = size(disp_patch);
            obj_func = @(x)objective_function(x, patch_height, patch_width, disp_patch);
            linearcons = @(x)constraints(x);
            [opt_x, fval, exitflag, output] = fmincon(obj_func, starting_point, A, b, Aeq, beq, lower_bound, upper_bound, linearcons, options);
            final_disparity(patch_size*(row-1)+1:patch_size*row,patch_size*(col-1)+1:patch_size*col) = reshape(opt_x,patch_size,patch_size);
        end
        waitbar(row/(floor(height/patch_size)), progress_bar);
    end
    close(progress_bar);
end