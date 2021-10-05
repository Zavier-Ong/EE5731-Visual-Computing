function conv2d = conv2d(img, kernel)
% get the input dimension
[row, col] = size(img);
[row_k, col_k] = size(kernel);

% zero padding
conv2d = zeros(row, col);
padImg = double(padarray(img, [floor((row_k-1)/2) floor((col_k-1)/2)], 'pre'));
padImg = double(padarray(padImg, [ceil((row_k-1)/2) ceil((col_k-1)/2)], 'post'));

% convolution
for i = 1:row
    for j = 1:col
        wdw = padImg(i:i+row_k-1, j:j+col_k-1);
        conv2d(i,j) = sum(wdw.*kernel, 'all');
    end
end