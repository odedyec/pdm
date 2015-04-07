%Match between detected pedestrians
function res = pedestrianMatch(leftImage,rightImage,bbs1R,bbs1L)
    res = zeros(size(bbs1R,1),1);
    for ped=1:size(bbs1R,1)
        P1 = (imcrop(rightImage,bbs1R(ped,1:4)));
        maxxx = [0,0];
        for ped2=1:size(bbs1L,1)
            P2 = (imcrop(leftImage,bbs1L(ped2,1:4)));
            s = min(size(P1),size(P2));
            P1 = imresize(P1,s(1:2));
            P2 = imresize(P2,s(1:2));
            val = psnr(P1,P2);
            if val > maxxx(1)
                maxxx = [val,ped2];
            end
        end
        res(ped) = maxxx(2);
    end
end