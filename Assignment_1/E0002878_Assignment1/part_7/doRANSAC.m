function [best_H, inlier1, inlier2] = doRANSAC(iteration, e, n, f1, f2, matches)
    im1_kp = f1(1:2, matches(1,:));
    im1_kp(3,:) = 1; %setting last row to 1
    im2_kp = f2(1:2, matches(2,:));
    im2_kp(3,:) = 1; %setting last row to 1

    inlier_count = 0;
    for i = 1:iteration
        chosen = randperm(size(matches,2), n);

        kp1 = im1_kp(1:2, chosen);
        kp2 = im2_kp(1:2, chosen);
        H1to2 = computeH(kp1, kp2);

        t_im2 = H1to2 * im1_kp;
        t_im2 = t_im2 ./ t_im2(3,:); %normalize
        dx = t_im2(1,:) - (im2_kp(1,:));
        dy = t_im2(2,:) - (im2_kp(2,:));
        dist = sqrt(dx.^2 + dy.^2);
        inliers_idx = find(dist < e);

        if size(inliers_idx, 2) > inlier_count
            inlier_count = size(inliers_idx,2);
            inlier1 = im1_kp(:, inliers_idx);
            inlier2 = im2_kp(:, inliers_idx);
        end
    end

    %recalculate H matrix
    best_H = computeH(inlier1, inlier2);