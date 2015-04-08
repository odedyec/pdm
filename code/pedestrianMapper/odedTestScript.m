%New Oded Script - Pedestrian match 
%% Load image parameters
MAX = 1735;
imNum = 0;
baseString = '/home/lar5/Desktop/database/images/take2/';
%nameL = sprintf('%s%04dl.jpeg',baseString,imNum);nameR = sprintf('%s%04dr.jpeg',baseString,imNum);Il = imread(nameL);Ir = imread(nameR);
%% Create detector
if ~exist('pedDetector')
    try
        load('pedDetector.mat')
    catch
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
    end
end

%% Assaf the gaylord
% % % vidR = VideoReader('Right.mpg');
% % % FramesR = read(vidR);
% % % vidL = VideoReader('Left.mpg');
% % % FramesL = read(vidL);
% % % Il = imresize(FramesL(:,:,:,i),[480 640]); Ir = imresize(FramesR(:,:,:,i),[480 640]);
%% Detect and match
startFrame = 300;
endFrame = 405;%MAX;
Thresh = 120;
% profile on
for i=startFrame:endFrame%which frames
    nameL = sprintf('%s%04dl.jpeg',baseString,i);nameR = sprintf('%s%04dr.jpeg',baseString,i);Il = imcrop(imresize(imread(nameL),[480 640]),[0 110 530 480]);Ir = imcrop(imresize(imread(nameR),[480 640]),[0 110 530 480]);
    bbsR = acfDetect(Ir,pedDetector);IndR = find(bbsR(:,end) > Thresh);bbs1R = bbsR(IndR,:);
    bbsL = acfDetect(Il,pedDetector);IndL = find(bbsL(:,end) > Thresh);bbs1L = bbsL(IndL,:);
%      figure(1);imshow(Ir);bbApply('draw',bbs1R);
%      figure(2);imshow(Il);bbApply('draw',bbs1L);
%      pause(1)

    matches = pedestrianMatch(Il,Ir,bbs1L,bbs1R,1);
    pause(1)
    
end
% profile viewer