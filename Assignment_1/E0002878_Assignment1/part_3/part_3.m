clear
close all
mkdir('output_img');

% load image
h1 = im2double(imread('../h1.jpg'));
h2 = im2double(imread('../h2.jpg'));

% H1 to H2
imshow(h1, []);
title('Click 4 homography points');
h1_kp = ginput(4)';
imshow(h2, []);
title('Click 4 homography points');
h2_kp = ginput(4)';

H1to2 = computeH(h1_kp, h2_kp);

tform = projective2d(H1to2.');
fig = figure(1);
imshow(imwarp(h1, tform), []);
title('H1 to H2');
saveas(fig, 'output_img/H1toH2.png');

% H2 to H1
H2to1 = computeH(h2_kp, h1_kp);

transform = projective2d(H2to1.');
fig = figure(2);
imshow(imwarp(h2, transform), []);
title('H2 to H1');
saveas(fig, 'output_img/H2toH1.png');