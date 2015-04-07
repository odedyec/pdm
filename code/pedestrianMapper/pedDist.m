function longestWidth = pedDist(L,R)


1+1
[framesL,dL] = vl_covdet(im2single(rgb2gray(L)), 'Method', 'MultiscaleHessian','EstimateAffineShape', true);
[framesR,dR] = vl_covdet(im2single(rgb2gray(R)), 'Method', 'MultiscaleHessian','EstimateAffineShape', true);
[matches,scores] = vl_ubcmatch(dL, dR);

    if (size(L,1) > size(R,1))
        longestWidth = size(L,1);
    else
        longestWidth = size(R,1);
    end

    if (size(L,2) > size(R,2))
        longestHeight = size(L,2);
    else
        longestHeight = size(R,2);
    end

    

    M = numel(matches(1,:));
    div = zeros(2,M);
    
    for k = 1:M
        xs = [ framesL(1, matches(1, k)) ; framesR(1, matches(2, k)) + longestHeight ];
        ys = [ framesL(2, matches(1, k)) ; framesR(2, matches(2, k)) ];
        slope = (ys(1) - ys(2)) / (xs(1) - xs(2));
        dist = sqrt( (ys(1) - ys(2))^2 + (xs(1) - xs(2))^2 );
        div(:,k) = [slope; dist];
    end

m = [mean(div(1,:));mean(div(2,:))];
s = [std(div(1,:)) / 4;std(div(2,:)) / 4];
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
    keep1 = [keep1 matches];
    keep2 = [keep2 scores];
end
matches = keep1;
scores = keep2;


end


