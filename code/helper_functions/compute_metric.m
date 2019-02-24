function [metric] = compute_metric(left_desc, right_desc, which_metric)
    if which_metric == 1
        metric = sum((left_desc - right_desc).^2);
    elseif which_metric == 2
        left_desc = left_desc - mean(left_desc);
        right_desc = right_desc - mean(right_desc);
        metric = (left_desc'*right_desc)/sqrt((left_desc'*left_desc)*(right_desc'*right_desc));
    end
end