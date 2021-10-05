clear
close all
mkdir('output_img');
run('../vlfeat-0.9.21/toolbox/vl_setup');

%load image
im1_ori = imread('../im01.jpg');
im2_ori = imread('../im02.jpg');

im1 = single(rgb2gray(im1_ori));
im2 = single(rgb2gray(im2_ori));
[f1, d1] = vl_sift(im1);
[f2, d2] = vl_sift(im2);

% matching parameter
threshold = 1.5;
matches = doMatch(d1, d2, threshold);

fig = figure(1);
canvas = [im1_ori im2_ori];
imshow(canvas);
axis image off
hold on
X = [f1(1, matches(1,:)); f2(1, matches(2,:))+size(im1_ori,2)];
Y = [f1(2, matches(1,:)); f2(2,matches(2,:))];
match_lines = line(X, Y);
set(match_lines,'linewidth', 1)
axis image off
title('Matched Keypoints')
saveas(fig, 'output_img/matched_keypoints.png');

% ransac
% ransac parameters
iteration = 1000;
epsilon = 1;
n = 5;

[best_H1to2, inlier1, inlier2] = doRANSAC(iteration, epsilon, n, f1, f2, matches);

fig = figure(2);
canvas = [im1_ori im2_ori];
imshow(canvas);
axis image off
hold on
X = [inlier1(1,:); inlier2(1,:)+size(im1_ori,2)];
Y = [inlier1(2,:); inlier2(2,:)];
ransac_lines = line(X, Y);
set(ransac_lines,'linewidth', 1)
axis image off
title('Matched Keypoints with RANSAC')
saveas(fig, 'output_img/matched_keypoints_ransac.png');

%finding transformed corners of transformed im1 in im2 frame
[t_im1, x_range, y_range] = image_transform(best_H1to2, im1_ori);

% stitching
stitched1to2 = doStitch(im2_ori, t_im1, x_range, y_range);

fig = figure(3);
imshow(stitched1to2);
title('Homography + RANSAC (Img1 to Img2)');
saveas(fig, 'output_img/stitched1to2.png');

H2to1 = computeH(inlier2, inlier1);
[t_im2, x_range, y_range] = image_transform(H2to1, im2_ori);
stitched2to1 = doStitch(im1_ori, t_im2, x_range, y_range);
fig = figure(4);
imshow(stitched2to1);
title('Homography + RANSAC (Img2 to Img1)');
saveas(fig, 'output_img/stitched2to1.png');
         