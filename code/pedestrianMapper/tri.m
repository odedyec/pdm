run('VLFEATROOT/toolbox/vl_setup');




%% Create detector
cd(fileparts(which('acfDemoCal.m'))); dataDir='../../data/Caltech/';
    for s=1:2
      if(s==1), type='test'; skip=[]; else type='train'; skip=4; end
      dbInfo(['Usa' type]); if(s==2), type=['train' int2str2(skip,2)]; end
      if(exist([dataDir type '/annotations'],'dir')), continue; end
      dbExtract([dataDir type],1,skip);
    end

    %%set up opts for training detector (see acfTrain)
    opts=acfTrain(); opts.modelDs=[50 20.5]; opts.modelDsPad=[64 32];
    opts.pPyramid.pChns.pColor.smooth=0; opts.nWeak=[64 256 1024 4096];
    opts.pBoost.pTree.maxDepth=5; opts.pBoost.discrete=0;
    opts.pBoost.pTree.fracFtrs=1/16; opts.nNeg=25000; opts.nAccNeg=50000;
    opts.pPyramid.pChns.pGradHist.softBin=1; opts.pJitter=struct('flip',1);
    opts.posGtDir=[dataDir 'train' int2str2(skip,2) '/annotations'];
    opts.posImgDir=[dataDir 'train' int2str2(skip,2) '/images'];
    opts.pPyramid.pChns.shrink=2; opts.name='models/AcfCaltech+';
    pLoad={'lbls',{'person'},'ilbls',{'people'},'squarify',{3,.41}};
    opts.pLoad = [pLoad 'hRng',[50 inf], 'vRng',[1 1] ];

    %%optionally switch to LDCF version of detector (see acfTrain)
    if( 0 ), opts.filters=[5 4]; opts.name='models/LdcfCaltech'; end

    %%train detector (see acfTrain)
    pedDetector = acfTrain( opts );

    %%modify detector (see acfModify)
    
    pModify=struct('cascThr',-1,'cascCal',.025);
    pedDetector=acfModify(pedDetector,pModify); 

cd('C:\Users\owner\Documents\GitHub\pdm\code');
%% Run Shit

for i=90:1736  
PicName = sprintf('C:\\Users\\owner\\Documents\\MATLAB\\pictures\\take2\\%04dl.jpeg',i);
IL = imread(PicName); IL = imresize(IL,[480 640]);
PicName(52)='r';
IR = imread(PicName); IR = imresize(IR,[480 640]);

bbs=acfDetect(IR,pedDetector);
Ind = find(bbs(:,end) > 150); bbsR = bbs(Ind,:);
figure(1); imshow(IR); bbApply('draw',bbsR);
%[xR,yR]=ginput(size(bbsR,1)); close(1);

bbs=acfDetect(IL,pedDetector);
Ind = find(bbs(:,end) > 150); bbsL = bbs(Ind,:);
figure(2); imshow(IL);bbApply('draw',bbsL);
%[xL,yL]=ginput(size(bbsL,1)); close(2);

matches = pedestrianMatch(IR,IL,bbsR,bbsL);


cropedR = imcrop(IR,bbsR(matches(1,1),1:4));
cropedL = imcrop(IL,bbsL(matches(2,1),1:4));
figure(3);imshow(cropedR);figure(4);imshow(cropedL);

R=cropedR; L=cropedL;
pedDist(cropedR,cropedL,'r',1);




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
%  
% matchedPoints1 = [x,y];
% matchedPoints2 = [x2,y2];
% 
% worldPoints = triangulate(matchedPoints1,matchedPoints2,stereoParams)
% 
