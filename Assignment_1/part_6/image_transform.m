% transform image
function [t_img, x_range, y_range] = image_transform(H, img)
    tform = projective2d(H.');
    img_height = size(img, 1);
    img_width = size(img, 2);
    corner_pts = [0, 0, img_width, img_width;
                  0, img_height, 0, img_height;
                  1, 1, 1, 1];
    t_corner_pts = H * corner_pts;
    t_corner_pts = t_corner_pts ./ t_corner_pts(3,:); %normalize

    max_x = floor(max(t_corner_pts(1,:)));
    min_x = ceil(min(t_corner_pts(1,:)));
    max_y = floor(max(t_corner_pts(2,:)));
    min_y = ceil(min(t_corner_pts(2,:)));
    t_img_width = max_x - min_x;
    t_img_height = max_y - min_y;

    xWorldLimits = [min_x, max_x];
    yWorldLimits = [min_y, max_y];
    R = imref2d([t_img_height,t_img_width], xWorldLimits, yWorldLimits);
    t_img = imwarp(img, tform, 'OutputView', R);
    x_range = [min_x max_x];
    y_range = [min_y max_y];
end
