clear
close all
mkdir('output_img');

%load image
img = im2double(imread('bicyclewall.jpg'));
fig = figure(1);
imshow(img, []);
title('Grayscale');
saveas(fig, 'output_img/grayscale.png');

% % sobel kernel
sobel_x = [-1 0 1; -2 0 2; -1 0 1];
sobel_y = sobel_x';

img_sobel_x = conv2d(img, sobel_x);
img_sobel_y = conv2d(img, sobel_y);
img_sobel = sqrt(img_sobel_x.^2 + img_sobel_y.^2);
fig = figure(2);
imshow(img_sobel_x, []);
title('Vertical');
saveas(fig, 'output_img/sobel_vertical.png');
fig = figure(3);
imshow(img_sobel_y, []);
title('Horizontal');
saveas(fig, 'output_img/sobel_horizontal.png');
fig = figure(4);
imshow(img_sobel, []);
title('Gradient magnitude');
saveas(fig, 'output_img/sobel_grad_mag.png');

gaussian kernel
x = 5;
y = 5;
sigma = 100;
[X, Y] = meshgrid(-(x-1)/2:(x-1)/2, -(y-1)/2:(y-1)/2);
gaussian = (1/(2*pi*(sigma^2))) * exp(-(X.^2+Y.^2) / (2*sigma^2));
g_kernel = gaussian / sum(gaussian, 'all'); %normalize

img_gaussian = conv2d(img, g_kernel);
fig = figure(5);
imshow(img_gaussian, []);
title(sprintf('Gaussian x=%d, y=%d, sigma=%d', x, y, sigma));
saveas(fig, sprintf('output_img/gaussian_%dx_%dy_%dsigma.png', x, y, sigma'));

%haar-like masks
scale = [2 5 7];
fig = figure(5+i);
sgtitle('Haar-like masks');
for i = 1:length(scale)
    for j = 1:5
        switch j
            case 1
                haar_mask = imresize([-1, 1], scale(i), 'nearest');
            case 2
                haar_mask = imresize([-1; 1], scale(i), 'nearest');
            case 3
                haar_mask = imresize([1, -1, 1], scale(i), 'nearest');
            case 4
                haar_mask = imresize([1; -1; 1], scale(i), 'nearest');
            case 5
                haar_mask = imresize([-1, 1; 1, -1], scale(i), 'nearest');
        end
        haar_img = conv2d(img, haar_mask);
        subplot(3,5,j+((i-1)*5))
        imshow((haar_img), []);
        title(sprintf('Type=%d Scale=%d', j, scale(i)));
        saveas(fig, sprintf('output_img/haar_mask_%dt_%ds.png', j, scale(i)));
    end
end