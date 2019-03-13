function [left_img, right_img, left_disp_gt, right_disp_gt] = myresize(img1,img2,img3,img4,scale)
    left_img = imresize(img1,scale);
    right_img = imresize(img2,scale);
    left_disp_gt = imresize(img3,scale);
    right_disp_gt = imresize(img4,scale);
end