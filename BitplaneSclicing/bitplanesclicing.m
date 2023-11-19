clc 
clear all
% Load the image
originalImage = imread('test.jpg');

% Convert the image to grayscale if it's in RGB
grayImage = rgb2gray(originalImage);

% Perform bit-plane slicing
bitPlanes = cell(8, 1);
for i = 1:8
    bitPlanes{i} = bitget(grayImage, i); % Get i-th bit plane
end

% Display the original image and individual bit planes
figure;
subplot(3, 3, 1);
imshow(grayImage);
title('Original Image');

for i = 1:8
    subplot(3, 3, i + 1);
    imshow(logical(bitPlanes{i}));
    title(['Bit Plane ', num2str(i)]);
end

% Remerge without the LSB
remergedImage = zeros(size(grayImage));
remergedImage = double(remergedImage);
for i = 2:8 % Exclude the LSB (i = 1)
    remergedImage = remergedImage + double(bitPlanes{i} * 2^(i-1));
end

% Display the remerged image
figure;
subplot(1, 2, 1);
imshow(grayImage);
title('Original Image');

subplot(1, 2, 2);
imshow(uint8(remergedImage));
title('Remerged Image without LSB');