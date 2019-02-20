function [metric] = compute_metric(left_desc, right_desc, option)
    if option == 1
        metric = sum((left_desc - right_desc).^2);
    elseif option == 2
        left_desc = left_desc - mean(left_desc);
        right_desc = right_desc - mean(right_desc);
        metric = (left_desc'*right_desc)/sqrt(dot(left_desc.^2, right_desc.^2));
    end
end