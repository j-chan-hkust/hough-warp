clc
clear

% Assignment 2
% img - original input image
% img_marked - image with marked sides and corners detected by Hough transform
% corners - the 4 corners of the target A4 paper
% img_warp - the standard A4-size target paper obtained by image warping
% n - determine the size of the result image

% define the n by yourself
n = 3;

% Manually detemine the corner points for six input images
Corners = [];


inputs = [1,2,3,4,5,6];
for i = 1:length(inputs)
    img_name = ['../input_imgs/Q1/', num2str(inputs(i)), '.JPG'];
    img = imread(img_name);
    % Run your Hough transform of Assignment 2 Q3 to obtain the corners.
    % You can also find the corners manually. If so, please change the following code accrodingly
    [img_marked, corners, corners_flipped] = hough_transform(img);
    % corners = Corners(i, :);
    %corners_flipped = [175 140; 738 179; 639 980; 96 894];
    img_warp = img_warping(img, corners_flipped, n);
    figure, 
    subplot(131),imshow(img);
    subplot(132),imshow(img_marked);
    subplot(133),imshow(img_warp);
end