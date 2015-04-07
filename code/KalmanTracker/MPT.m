%% CLEAN
clear all;clc;close all;
%% Simulate detection
X = 0:0.1:10;
N = length(X);
Y = zeros(size(X));
FOV = 90 * pi / 180; %60 deg field of view
DIST = 20;
me = [X' Y'];
peds{1} = [ones(N,1) * 2, ones(N,1) * -0.2]; %Pedestrian that stands in place
peds{2} = [ones(N,1) * 6, ones(N,1) * 1]; %Pedestrian that stands in place
for m=1:N
    figure(1);plot(me(m,1),me(m,2),'bo','MarkerSize',14);axis([-1 12 -10 10]);hold on;
    seen = isSeen(peds,FOV,DIST,me,m);
    for i=1:length(seen)
       if seen(i) == 1
           plot(peds{i}(m,1),peds{i}(m,2),'rx','MarkerSize',14);
       end
    end
    hold off;pause(0.05);
end
%% 