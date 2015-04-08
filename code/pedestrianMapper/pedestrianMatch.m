%Match between detected pedestrians
function res = pedestrianMatch(leftImage,rightImage,bbs1L,bbs1R,showMatches)
res = NaN;
if nargin < 4
    fprintf('\n\n===============================================================\n');
    fprintf('This function should get at least 4 arguments! you entered %d!!\n\nUsage: \n\n',nargin);
    fprintf('Input arguments\n---------------\n\tLeft Image\n\tRight Image\n\tDollars bounding box matrix for left image(bbs1L)\n\tDollars bounding box matrix for right image(bbs1R)\n\t(optional) show figures of matched output - enter a value greater than zero as a figure number\n\n');
    fprintf('Output arguments\n----------------\n\tMatch matrix M.\n\nM is a n by 2 matrix where, \n');
    fprintf('the first column contains indices from the left image bounding boxes (bbs1L)\n');
    fprintf('the seconds column is the corresponding indices from the right image bounding boxes (bbs1R)\n');
    fprintf('\nNote that a value of zero will be returned if a bounding box does not correspond to a bounding box from the opposite image\n'); 
    fprintf('\nReturning NaN\n');
    return;
end
if nargin < 5
    showMatches = 0;
end

n = size(bbs1L,1);
m = size(bbs1R,1);
arr = zeros(n,m);
if isempty(arr)
    %Check if the array is empty due to no bounding boxes by Dollar
    res = arr;
    return;
end

%Add scores to the array
for i=1:n
    for j=1:m
        if abs(bbs1L(i,1) - bbs1R(j,1)) > 50 | abs(bbs1L(i,2) - bbs1R(j,2)) > 50
            arr(i,j) = inf;
        else
            arr(i,j) = (bbs1R(j,1) - bbs1L(i,1))^2 + (bbs1R(j,2) - bbs1L(i,2))^2;% + (bbs1R(j,5) - bbs1L(i,5))^2;
        end
    end
end

%Perform Hungarian algorithm for matching
[matches, score] = Hungarian(arr);
res = zeros(n,1);
for i=1:n
    val = find(matches(i,:) == 1);
    if ~isempty(val)
        res(i) = val;
    end
end

if showMatches > 0
    for i=1:n
        if res(i) ~= 0
            figure(showMatches+1);imshow(imcrop(leftImage ,bbs1L(i,1:4)));
            figure(showMatches+2);imshow(imcrop(rightImage,bbs1R(res(i),1:4)));
            showMatches = showMatches + 2;
        end
    end
end
%     res = zeros(size(bbs1R,1),1);
%     for ped=1:size(bbs1R,1)
%         P1 = (imcrop(rightImage,bbs1R(ped,1:4)));
%         maxxx = [0,0];
%         for ped2=1:size(bbs1L,1)
%             P2 = (imcrop(leftImage,bbs1L(ped2,1:4)));
%             s = min(size(P1),size(P2));
%             P1 = imresize(P1,s(1:2));
%             P2 = imresize(P2,s(1:2));
%             val = psnr(P1,P2);
%             if val > maxxx(1)
%                 maxxx = [val,ped2];
%             end
%         end
%         res(ped) = maxxx(2);
%     end
end