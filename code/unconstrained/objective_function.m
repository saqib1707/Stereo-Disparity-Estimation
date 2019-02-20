function [cost_value] = objective_function(x,disp_patch)
    [height, width] = size(disp_patch);
    img = zeros(height, width);
    non_zero_loc = (disp_patch ~= 0);
    zero_loc = (disp_patch == 0);
    img(non_zero_loc) = disp_patch(non_zero_loc);
    img(zero_loc) = x;
    [gradient_magnitude,~] = imgradient(img);
    cost_value = sum(sum(gradient_magnitude.^2));
end