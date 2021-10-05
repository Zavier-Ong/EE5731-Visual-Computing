% Compute the homography 
% transforms kp1 to kp2
function H = computeH(kp1, kp2)
    m = size(kp1, 2);
    x = kp1(1,:);
    y = kp1(2,:);
    X = kp2(1,:);
    Y = kp2(2,:);
    
    A = zeros(m*2, 9);
    for i = 1:m
        A([i,i+m],:) = [x(i), y(i), 1, 0, 0, 0, -X(i)*x(i), -X(i)*y(i), -X(i);
                        0, 0, 0, x(i), y(i), 1, -Y(i)*x(i), -Y(i)*y(i), -Y(i);];
    end
    
    [~,~,V] = svd(A);
    Vt= V';
    h = Vt(end,:);
    H = reshape(h, [3,3])';
end