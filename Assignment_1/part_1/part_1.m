clear
close all
mkdir('output_img');

%load image
img = imread('cat.jpg');
img_gray = rgb2gray(img);
fig = figure(1);
imshow(img_gray);
title('Grayscale');
saveas(fig, 'output_img/grayscale.png');

% sobel kernel
sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = sobel_x';

img_sobel_x = conv2d(img_gray, sobel_x);
img_sobel_y = conv2d(img_gray, sobel_y);
img_sobel = sqrt(img_sobel_x.^2 + img_sobel_y.^2);
fig = figure(2);
imshow(uint8(img_sobel_x));
title('Vertical');
saveas(fig, 'output_img/sobel_vertical.png');
fig = figure(3);
imshow(uint8(img_sobel_y));
title('Horizontal');
saveas(fig, 'output_img/sobel_horizontal.png');
fig = figure(4);
imshow(uint8(img_sobel));
title('Gradient magnitude');
saveas(fig, 'output_img/sobel_grad_mag.png');

%gaussian kernel
x = 3;
y = 3;
sigma = 5;
[X, Y] = meshgrid(-(x-1)/2:(x-1)/2, -(y-1)/2:(y-1)/2);
gaussian = exp(-(X.^2+Y.^2) / (2*sigma^2));
g_kernel = gaussian / sum(sum(gaussian)); %normalize

img_gaussian = conv2d(img_gray, g_kernel);
fig = figure(5);
imshow(uint8(img_gaussian));
title(sprintf('Gaussian x=%d, y=%d, sigma=%d', x, y, sigma));
saveas(fig, sprintf('output_img/gaussian_%dx_%dy_%dsigma.png', x, y, sigma'));

%haar-like masks
scale = 2;
for i = 1:5
    switch i
        case 1
            haar_mask = imresize([-1, 1], scale, 'nearest');
        case 2
            haar_mask = imresize([-1; 1], scale, 'nearest');
        case 3
            haar_mask = imresize([1, -1, 1], scale, 'nearest');
        case 4
            haar_mask = imresize([1; -1; 1], scale, 'nearest');
        case 5
            haar_mask = imresize([-1, 1; 1, -1], scale, 'nearest');
    end
    haar_img = conv2d(img_gray, haar_mask);
    fig = figure(i+5);
    imshow(uint8(haar_img));
    title(sprintf('Haar-like mask(Type=%d Scale=%d)', i, scale));
    saveas(fig, sprintf('output_img/haar_mask_%dt_%ds.png', i, scale));
end
            