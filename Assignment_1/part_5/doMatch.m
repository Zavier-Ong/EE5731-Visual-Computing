function matches = doMatch(d1, d2, threshold)
    d1 = (double(d1));
    d2 = (double(d2));
    matches  = [];
    
    for i=1:size(d1,2)
        dist = zeros(1, size(d2, 2));
        for j=1:size(d2, 2)
            d = d1(:,i) - d2(:,j);
            dist(j) = sum(d.^2);
        end
        [~, min_idx] = min(dist);
        sort_dist = sort(dist);
        if sort_dist(1)*threshold < sort_dist(2)
            matches = cat(2, matches, [i; min_idx]);
        end
    end
end