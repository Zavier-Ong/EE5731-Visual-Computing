function stitch_seq = generateStitchOrder(num_img, img_sift_list, threshold, iteration, epsilon , n)
    match_matrix = zeros(num_img, num_img);
    for i = 1:num_img
        for j = 1:num_img
            if i~=j
                desc1 = double(img_sift_list{2, i});
                desc2 = double(img_sift_list{2, j});
                d1_size = size(desc1, 2);
                matches = zeros(d1_size, 1);
                kdtree = KDTreeSearcher(desc2');
                for k = 1:d1_size
                    desc = desc1(:,k);
                    idx = knnsearch(kdtree, desc', 'K', 4);
                    neighbor_1 = desc2(:,idx(1));
                    neighbor_2 = desc2(:,idx(2));
                    if sum((desc-neighbor_1).^2)*threshold < sum((desc-neighbor_2).^2)
                        matches(k) = idx(1);
                    else
                        matches(k) = 0;
                    end
                end
                match_matrix(i,j) = sum(matches, 'all');
            end
        end
    end

    rank_matrix = zeros(num_img, num_img);
    ordered_matrix = zeros(num_img, num_img);
    for i=1:num_img
        [row,index] = sort(match_matrix(i,:), 'descend');
        rank_matrix(i,:) = index;
        ordered_matrix(i,:) = row;
    end
    
    %considering a constant number of m images
    m = 2;
    potential_image_matches = ordered_matrix(:, 1:m);
    potential_image_idx = rank_matrix(:,1:m);

    num_inlier = zeros(size(potential_image_idx));
    for i = 1:size(potential_image_idx,1)
        for j = 1:size(potential_image_idx, 2)
            f1 = img_sift_list{1, i};
            f2 = img_sift_list{1, potential_image_idx(i,j)};
            d1 = img_sift_list{2, i};
            d2 = img_sift_list{2, potential_image_idx(i,j)};

            matches = doMatch(d1, d2, threshold);
            [~,inlier1,~] = doRANSAC(iteration, epsilon, n, f1, f2, matches);
            num_inlier(i,j) = sum(inlier1, 'all');
        end
    end

    accepted_img_match = zeros(size(potential_image_idx));
    for i = 1:size(potential_image_idx,1)
        for j = 1:size(potential_image_idx, 2)
            ni = num_inlier(i,j);
            a = 5.9;
            b = 0.22;
            % probabilistic model for image match verification
            nf = potential_image_matches(i,j);
            if ni > a+b*nf
                accepted_img_match(i,j) = nf;
            else
                accepted_img_match(i,j) = 0;
            end
        end
    end

    accepted_rank = zeros(size(potential_image_idx));
    accepted_matches = zeros(size(potential_image_idx));
    for i=1:num_img
        [row,index] = sort(accepted_img_match(i,:), 'descend');
        accepted_rank(i,:) = potential_image_idx(i,index);
        accepted_matches(i,:) = row;
    end

    [~, idx] = sort(accepted_matches(:,1), 1, 'descend');
    stitch_seq(1,:) = potential_image_idx(idx,1);
end
    