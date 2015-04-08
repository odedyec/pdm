function  printFeaturs(im1,im2,matches,f1,f2,color)
figure();
if size(size(im1),2) == 3
    im1 = im2uint8(rgb2gray(im1));
end
if size(size(im2),2) == 3
    im2 = im2uint8(rgb2gray(im2));
end



if (size(im1,1) > size(im2,1))
    longestWidth = size(im1,1);
else
    longestWidth = size(im2,1);
end

if (size(im1,2) > size(im2,2))
    longestHeight = size(im1,2);
else
    longestHeight = size(im2,2);
end

% create new matrices with longest width and longest height
newim = uint8(zeros(longestWidth, longestHeight)); %3 cuz image is RGB
newim2 = uint8(zeros(longestWidth, longestHeight));

% transfer both images to the new matrices respectively.
newim(1:size(im1,1), 1:size(im1,2)) = im1;
newim2(1:size(im2,1), 1:size(im2,2)) = im2;

% with the same proportion and dimension, we can now show both
% images. Parts that are not used in the matrices will be black.
imshow([newim newim2]);

hold on;

X = zeros(2,1);
Y = zeros(2,1);

for k=1:numel(matches(1,:))
    
    X(1) = f1(1, matches(1, k));
    Y(1) = f1(2, matches(1, k));
    X(2) = f2(1, matches(2, k)) + longestHeight; % for placing matched point of 2nd image correctly.
    Y(2) = f2(2, matches(2, k));
    
    line(X,Y,'Color',color);
    
end


hold off;
