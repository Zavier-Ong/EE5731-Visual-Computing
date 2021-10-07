clear
close all
mkdir('output_img');
run('../vlfeat-0.9.21/toolbox/vl_setup');

% parameters
num_img = 6;
% matching
threshold = 1.5;
% ransac
iteration = 3000;
epsilon = 1;
n = 5;

% load all images
image_list = cell(1, num_img);
shuffled = [1,2,3,4,5,6];
for i=1:length(shuffled)
    img_path = sprintf('../%d.jpg', shuffled(i));
    % shuffled image list to make images unordered
    image_list{i} = im2double(imread(img_path));
end

% extract sift key points for all images
img_sift_list = cell(2, num_img);
for i=1:num_img
    img = image_list{i};
    img_gray = single(rgb2gray(img));
    [f, d] = vl_sift(img_gray);
    img_sift_list{1,i} = f;
    img_sift_list{2,i} = d;
end

% generating stitch order for unordered images
stitch_seq = generateStitchOrder(num_img, img_sift_list, threshold, iteration, epsilon, n);

fig = figure(1);
for i=1:num_img-1
    if i==1
        im2 = image_list{stitch_seq(1)};
        f2 = img_sift_list{1, stitch_seq(1)};
        d2 = img_sift_list{2, stitch_seq(1)};
    else
        im2 = stitched;
        img2 = single(rgb2gray(im2));
        [f2, d2] = vl_sift(img2);
    end
    im1 = image_list{stitch_seq(i+1)};
    f1 = img_sift_list{1, stitch_seq(i+1)};
    d1 = img_sift_list{2, stitch_seq(i+1)};
    
    matches = doMatch(d1, d2, threshold);
    [H, ~, ~] = doRANSAC(iteration, epsilon, n, f1, f2, matches);
    [t_im1, x_range, y_range] = image_transform(H, im1);
    stitched = doStitch(im2, t_im1, x_range, y_range);
    fprintf('%d images stitched\n', i+1);
end
imshow(stitched);
%saveas(fig, sprintf('output_img/%d_images_stitched.png',i+1));
