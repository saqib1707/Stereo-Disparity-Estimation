function [ceq] = equality_constraints(x, disp_patch)
    [height, width] = size(disp_patch);
    img = reshape(x, height, width);
    loc = (disp_patch ~= 0);
    number_non_zero_pixels = sum(sum(loc));
    ceq(1:number_non_zero_pixels,1) = reshape((img(loc) - disp_patch(loc)), number_non_zero_pixels, 1);
end