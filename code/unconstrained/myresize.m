function [left_img, right_img, left_disp_gt, right_disp_gt] = myresize(a,b,c,d,scale)
    left_img = imresize(a,scale);
    right_img = imresize(b,scale);
    left_disp_gt = imresize(c,scale);
    right_disp_gt = imresize(d,scale);
end