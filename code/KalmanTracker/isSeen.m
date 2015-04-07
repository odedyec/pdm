function res = isSeen(pedestrians, FOV, DIST, me, idx)
res = zeros(size(pedestrians));
if idx == 1; return; end; %for idx 1 return
dx = me(idx,1) - me(idx-1,1);
dy = me(idx,2) - me(idx-1,2);
theta = atan2(dy,dx);
a1 = theta - FOV / 2;
a2 = theta + FOV / 2;
for i=1:size(pedestrians,2)
    ped = pedestrians{i};
    dx =  ped(idx,1) - me(idx,1);
    dy =  ped(idx,2) - me(idx,2);
    gama = atan2(dy,dx);
    if pdist([me(idx,:);ped(idx,:)],'euclidean') < DIST & a2 > gama & a1 < gama
        res(i) = 1;
    end
end

end