%stitching of images
function stitched_img = doStitch(im1, im2, x_range, y_range)
    im1_height = size(im1, 1);
    im1_width = size(im1, 2);
    canvas_xWorldLimit = [floor(min(x_range(1),0)), ceil(max(x_range(2),im1_width))];
    canvas_yWorldLimit = [floor(min(y_range(1),0)), ceil(max(y_range(2),im1_height))];

    canvas1 = zeros(canvas_yWorldLimit(2)-canvas_yWorldLimit(1), ...
                   canvas_xWorldLimit(2)-canvas_xWorldLimit(1),3);
    canvas2 = zeros(canvas_yWorldLimit(2)-canvas_yWorldLimit(1), ...
                   canvas_xWorldLimit(2)-canvas_xWorldLimit(1),3);

    y_offset = canvas_yWorldLimit(1);
    x_offset = canvas_xWorldLimit(1);

    canvas1(1+y_range(1)-y_offset:y_range(2)-y_offset, ...
            1+x_range(1)-x_offset:x_range(2)-x_offset, :) = im2(:,:,:);
    canvas2(1-y_offset:im1_height-y_offset, ...
            1-x_offset:im1_width-x_offset, :) = im1(:,:,:);

    stitched_img = max(canvas1, canvas2);
end