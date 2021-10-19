clear
close all

addpath('../GCMex')
img = (imread('../InputImages/bayes_in.jpg'));
[H,W,~] = size(img);

source_color = [0,0,255]; %label=0
sink_color = [245,210,110]; %label=1

img_1d = reshape(img,H*W,3);
C = 2;
N = H*W;
unary = zeros(C,N);
class= zeros(1,N);

for i=1:N
    unary(1,i) = getDist(source_color, img_1d(i,:));
    unary(2,i) = getDist(sink_color, img_1d(i,:));
    if unary(1,i) > unary(2,i)
        class(1,i) = 1;
    end
end

num_edges = H*(W-1)+W*(H-1);
pairwise_idx_x = zeros(1,num_edges);
pairwise_idx_y = zeros(1,num_edges);
is_neighbor = zeros(1, num_edges);
edge_idx = 1;

for row=0:H-1
    for col=0:W-1
        pixelIdx = 1+row*W+col;
        if row+1 < H
            pairwise_idx_x(edge_idx) = pixelIdx;
            pairwise_idx_y(edge_idx) = 1+col+(row+1)*W;
            is_neighbor(edge_idx) = 1;
            edge_idx = edge_idx+1;
        end
        if row-1 >= 0
            pairwise_idx_x(edge_idx) = pixelIdx;
            pairwise_idx_y(edge_idx) = 1+col+(row-1)*W;
            is_neighbor(edge_idx) = 1;
            edge_idx = edge_idx + 1;
        end
        if col+1 < W
            pairwise_idx_x(edge_idx) = pixelIdx;
            pairwise_idx_y(edge_idx) = 1+col+1+row*W;
            is_neighbor(edge_idx) = 1;
            edge_idx = edge_idx + 1;
        end
        if col-1 >= 0
            pairwise_idx_x(edge_idx) = pixelIdx;
            pairwise_idx_y(edge_idx) = 1+col-1+row*W;
            is_neighbor(edge_idx) = 1;
            edge_idx = edge_idx + 1;
        end
    end
end     

lambda = 88888888;
pairwise = sparse(pairwise_idx_x, pairwise_idx_y, is_neighbor*lambda);
labelcost = [0,1;1,0];

[labels, ~, ~] = GCMex(double(class), single(unary), pairwise, single(labelcost));

denoised = zeros(N,3);
for i=1:N
    if labels(i) == 0
        denoised(i,:) = source_color;
    else
        denoised(i,:) = sink_color;
    end
end
    
imshow(uint8(reshape(denoised,[H,W,3])));


%% Functions

function dist = getDist(a, b)
    a = double(a);
    b = double(b);

    dist = (abs( a(1) - b(1) ) + ...
        abs( a(2) - b(2) ) + ...
        abs( a(3) - b(3) )) / 3;
end