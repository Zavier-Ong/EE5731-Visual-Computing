function sequence = generateStitchOrder(num_img)
    sequence = zeros(1, num_img);
    start_idx = ceil(num_img/2);
    sequence(1) = start_idx;
    stitch_idx = 2;
    left_idx = start_idx-1;
    right_idx = start_idx+1;
    left_flag = false;
    right_flag = false;
    while true
        if (left_idx > 0)
            sequence(stitch_idx) = left_idx;
            left_idx = left_idx-1;
            stitch_idx = stitch_idx+1;
        else
            left_flag = true;
        end
        if (right_idx <= num_img)
            sequence(stitch_idx) = right_idx;
            right_idx = right_idx+1;
            stitch_idx = stitch_idx+1;
        else
            right_flag = true;
        end
        if left_flag && right_flag
            break;
        end
    end