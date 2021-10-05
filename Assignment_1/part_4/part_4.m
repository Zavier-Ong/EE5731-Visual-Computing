clear
close all
mkdir('output_img')

% load image
im1 = imread('../im01.jpg');
im2 = imread('../im02.jpg');

imshow(im1);
title('Select 4 points');
im1_kp = ginput(4)';
imshow(im2);
title('Select 4 points');
im2_kp = ginput(4)';

H = computeH(im2_kp, im1_kp);

% find transformed corners of transformed im2 in im1 frame
[t_im2, x_range, y_range] = image_transform(H, im2);

% stitching
stitched_img = doStitch(im1, t_im2, x_range, y_range);
fig = figure(1);
imshow(stitched_img);
title('Manual Homography + Stitching (Img2 to Img1)');
saveas(fig, 'output_img/stitched2to1.png');

H = computeH(im1_kp, im2_kp);
[t_im1, x_range, y_range] = image_transform(H, im1);
stitched_img2 = doStitch(im2, t_im1, x_range, y_range);
fig = figure(2);
imshow(stitched_img2);
title('Manual Homography + Stitching (Img1 to Img2)');
saveas(fig, 'output_img/stitched1to2.png');
