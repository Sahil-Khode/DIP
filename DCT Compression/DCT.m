clc;
clear all;
% Load the image you want to compress
img = imread('test.jpg');

% Convert the image to grayscale (if it's not already)
gray_img = rgb2gray(img);

% Set the block size for the DCT
block_size = 8;

% Determine the size of the image and the number of blocks
[row, column] = size(gray_img);
num_blocks_row = row / block_size;
num_blocks_column = column / block_size;

% Initialize a matrix to hold the compressed image
compressed_img = zeros(row, column);

% Loop through each block in the image
for i = 1:num_blocks_row
    for j = 1:num_blocks_column
        
        % Extract the block from the image
        block = gray_img((i-1)*block_size+1:i*block_size, (j-1)*block_size+1:j*block_size);
        
        % Apply the DCT to the block
        dct_block = dct2(block);
        
        % Set the lower frequency coefficients to zero to compress the block
        compressed_block = zeros(block_size);
        num_coeffs_to_keep = round(block_size * block_size * 0.1); % change this value to adjust the compression ratio
        for k = 1:num_coeffs_to_keep
            [r, c] = find(abs(dct_block) == max(max(abs(dct_block))));
            compressed_block(r, c) = dct_block(r, c);
            dct_block(r, c) = 0;
        end
        
        % Apply the inverse DCT to the compressed block
        compressed_img((i-1)*block_size+1:i*block_size, (j-1)*block_size+1:j*block_size) = idct2(compressed_block);
    end
end

% Display the original and compressed images
figure;
subplot(1,2,1);
imshow(gray_img);
title('Original Image');
subplot(1,2,2);
imshow(uint8(compressed_img));
title('Compressed Image');