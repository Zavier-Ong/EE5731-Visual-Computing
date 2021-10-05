clear
close all
mkdir('output_img');
run('../vlfeat-0.9.21/toolbox/vl_setup');

% load image
img = imread('../im01.jpg');

fig = figure(1);
image(img);
axis off;
hold on;

img = single(rgb2gray(img));
[f,d] = vl_sift(img);

% randomly select n keypoints for descriptor visualization
n = 50;
perm = randperm(size(f,2)) ;
selected_kp  = perm(1:n) ;
keypoint_outline = vl_plotframe(f(:,selected_kp)) ;
keypoint = vl_plotframe(f(:,selected_kp)) ;
set(keypoint_outline,'color','k','linewidth',3) ;
set(keypoint,'color','y','linewidth',2) ;
descriptor = vl_plotsiftdescriptor(d(:,selected_kp),f(:,selected_kp)) ;
set(descriptor,'color','g') ;
saveas(fig, 'output_img/sift_50kp.png');