function [cost_value] = objective_function(x, height, width)
    img = reshape(x, height, width);
    [gradient_magnitude,~] = imgradient(img);
    cost_value = sum(sum(gradient_magnitude.^2));
end