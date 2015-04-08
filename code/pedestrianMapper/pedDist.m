function longestWidth = pedDist(L,R)


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

    
[matches,scores] = scoreFilter(matches,scores,framesL,framesR);
[matches,scores] = slopeFilter(matches,scores,framesL,framesR,longestHeight);



%%returning the pixels





end


