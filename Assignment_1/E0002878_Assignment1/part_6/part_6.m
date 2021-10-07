clear
close all
mkdir('output_img');
run('../vlfeat-0.9.21/toolbox/vl_setup');

% parameters
num_img = 8;
% matching
threshold = 1.5;
% ransac
iteration = 3000;
epsilon = 1;
n = 5;

% load all images
image_list = cell(1, num_img);
for i=1:num_img
    %img_path = sprintf('../im%02d.jpg', i);
    img_path = sprintf('../%d.jpg', i);
    image_list{i} = im2double(imread(img_path));
end

% determine sequence of stitching starting from the middle to prevent huge
% disruptions at the ends of the panorama
stitch_seq = generateStitchOrder(num_img);

for i=1:num_img-1
    if i==1
        im2 = image_list{stitch_seq(1)};
    else
        im2 = stitched;
    end
    im1 = image_list{stitch_seq(i+1)};
    img1 = single(rgb2gray(im1));
    img2 = single(rgb2gray(im2));
    [f1, d1] = vl_sift(img1);
    [f2, d2] = vl_sift(img2);
    
    matches = doMatch(d1, d2, threshold);
    [H, ~, ~] = doRANSAC(iteration, epsilon, n, f1, f2, matches);
    [t_im1, x_range, y_range] = image_transform(H, im1);
    stitched = doStitch(im2, t_im1, x_range, y_range);
    fig = figure(i);
    imshow(stitched, []);
    saveas(fig, sprintf('output_img/%d_images_stitched.png',i+1));
end
