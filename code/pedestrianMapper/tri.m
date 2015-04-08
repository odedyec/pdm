% run('VLFEATROOT/toolbox/vl_setup');
% 
% 
% 
% 
% %% Create detector
% cd(fileparts(which('acfDemoCal.m'))); dataDir='../../data/Caltech/';
%     for s=1:2
%       if(s==1), type='test'; skip=[]; else type='train'; skip=4; end
%       dbInfo(['Usa' type]); if(s==2), type=['train' int2str2(skip,2)]; end
%       if(exist([dataDir type '/annotations'],'dir')), continue; end
%       dbExtract([dataDir type],1,skip);
%     end
% 
%     %%set up opts for training detector (see acfTrain)
%     opts=acfTrain(); opts.modelDs=[50 20.5]; opts.modelDsPad=[64 32];
%     opts.pPyramid.pChns.pColor.smooth=0; opts.nWeak=[64 256 1024 4096];
%     opts.pBoost.pTree.maxDepth=5; opts.pBoost.discrete=0;
%     opts.pBoost.pTree.fracFtrs=1/16; opts.nNeg=25000; opts.nAccNeg=50000;
%     opts.pPyramid.pChns.pGradHist.softBin=1; opts.pJitter=struct('flip',1);
%     opts.posGtDir=[dataDir 'train' int2str2(skip,2) '/annotations'];
%     opts.posImgDir=[dataDir 'train' int2str2(skip,2) '/images'];
%     opts.pPyramid.pChns.shrink=2; opts.name='models/AcfCaltech+';
%     pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41}};
%     opts.pLoad = [pLoad 'hRng',[50 inf], 'vRng',[1 1] ];
% 
%     %%optionally switch to LDCF version of detector (see acfTrain)
%     if( 0 ), opts.filters=[5 4]; opts.name='models/LdcfCaltech'; end
% 
%     %%train detector (see acfTrain)
%     pedDetector = acfTrain( opts );
% 
%     %%modify detector (see acfModify)
%     
%     pModify=struct('cascThr',-1,'cascCal',.025);
%     pedDetector=acfModify(pedDetector,pModify); 
% 
%  cd('C:\Users\owner\Documents\GitHub\pdm\code');
%% Run Shit

for i=250:1:1736  
PicName = sprintf('C:\\Users\\owner\\Documents\\MATLAB\\pictures\\take2\\%04dl.jpeg',i);
IL = imread(PicName); origiSize = size(IL); IL = imresize(IL,[480 640]);
PicName(52)='r';
IR = imread(PicName); IR = imresize(IR,[480 640]);

bbs=acfDetect(IR,pedDetector);
Ind = find(bbs(:,end) > 150); bbsR = bbs(Ind,:);
figure(1); imshow(IR); bbApply('draw',bbsR);
% [xR,yR]=ginput(size(bbsR,1)); close(1);

bbs=acfDetect(IL,pedDetector);
Ind = find(bbs(:,end) > 150); bbsL = bbs(Ind,:);
% figure(2); imshow(IL);bbApply('draw',bbsL);
% [xL,yL]=ginput(size(bbsL,1)); close(2);
figure(1);imshow(IL); 
figure(2);imshow(IR); 
matchesPed=[];
matchesPed = pedestrianMatch(IL,IR,bbsL,bbsR);
loc = zeros(size(matchesPed,1),2);
for j=1:size(matchesPed,1)
    if matchesPed(j)==0
        continue
    end
    cropedR = imcrop(IR,bbsR(matchesPed(j),1:4));
    cropedL = imcrop(IL,bbsL(j,1:4)); 
    % figure(3);imshow(cropedR);figure(4);imshow(cropedL);
    
    [massL,massR] = pedDist(cropedL,cropedR);
    massL = massL + bbsL(j,1:2);
    massR = massR + bbsR(matchesPed(j),1:2);
    figure(1);hold;plot(massL(1,1),massL(1,2),'b*');hold off;
    figure(2);hold;plot(massR(1,1),massR(1,2),'b*');hold off;
    massL = [massL(1,1)*964/480 , massL(1,2)*1288/640];
    massR = [massR(1,1)*964/480 , massR(1,2)*1288/640];
    
    
    worldpoint = triangulate(massL,massR,stereoParams);
    loc(j,1) = worldpoint(1); loc(j,2) = worldpoint(3);
    
end
pause(0.5);

%_______Oded's shit%
% figure(2);plot(loc(:,1),loc(:,2),'bo','MarkerSize',14)
% axis([-5000,5000,0,35000])
% pause(0.01)

% % % matchesR = []; 
% % % for j = 1 : size(bbsR,1)
% % %     for k = 1 : size(bbsR,1)
% % %         if(bbsR(j,1)+bbsR(j,3) > xR(k) && xR(k) > bbsR(j,1) && bbsR(j,2) + bbsR(j,4) > yR(k) && yR(k) > bbsR(j,2))
% % %             matchesR = [ matchesR ; xR(k),yR(k),j];
% % %         end
% % %     end
% % % end
% % % 
% % % matchesL = []; 
% % % for j = 1 : size(bbsL,1)
% % %     for k = 1 : size(bbsL,1)
% % %         if(bbsL(j,1)+bbsL(j,3) > xL(k) && xL(k) > bbsL(j,1) && bbsL(j,2) + bbsL(j,4) > yL(k) && yL(k) > bbsL(j,2))
% % %             matchesL = [ matchesL ; xL(k),yL(k),j];
% % %         end
% % %     end
% % % end
% % % 
% % % 
% % % 
% % % 
% % % 
% % % matches = 





end
