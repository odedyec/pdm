function [matches,scores] = slopeFilter(matches,scores,framesL,framesR,longestHeight)

M = numel(matches(1,:));
div = zeros(2,M);

for k = 1:M
    xs = [ framesL(1, matches(1, k)) ; framesR(1, matches(2, k)) + longestHeight ];
    ys = [ framesL(2, matches(1, k)) ; framesR(2, matches(2, k)) ];
    slope = (ys(1) - ys(2)) / (xs(1) - xs(2));
    dist = sqrt( (ys(1) - ys(2))^2 + (xs(1) - xs(2))^2 );
    div(:,k) = [slope; dist];
end

m = [mean(div(1,:)) ; mean(div(2,:))];
s = [std(div(1,:)) / 4 ; std(div(2,:)) / 4];
a=0;
keep1 = [];
keep2 = [];
for k = 1:M
    myNorm = pdf('Normal',div(1,k),m(1),s(1));
    myNorm2 = pdf('Normal',div(2,k),m(2),s(2));
    if myNorm < 0.5
        continue;end
    if myNorm2 < 0.00001
        continue;end
    keep1 = [keep1 matches(:,k)];
    keep2 = [keep2 scores(:,k)];
end
matches = keep1;
scores = keep2;

end