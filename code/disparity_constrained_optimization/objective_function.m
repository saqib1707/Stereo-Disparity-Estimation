function [cost_value] = objective_function(x, disp_patch)
	[height,width] = size(disp_patch);
    img = reshape(x, height, width);
    [gradient_magnitude,~] = imgradient(img);
    cost_value = sum(sum(gradient_magnitude.^2));
end