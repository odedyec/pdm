% Demo for aggregate channel features object detector on Caltech dataset.
%
% See also acfReadme.m
%
% Piotr's Computer Vision Matlab Toolbox      Version 3.40
% Copyright 2014 Piotr Dollar.  [pdollar-at-gmail.com]
% Licensed under the Simplified BSD License [see external/bsd.txt]

%% extract training and testing images and ground truth
cd(fileparts(which('acfDemoCal.m'))); dataDir='../../data/Caltech/';
for s=1:2
  if(s==1), type='test'; skip=[]; else type='train'; skip=4; end
  dbInfo(['Usa' type]); if(s==2), type=['train' int2str2(skip,2)]; end
  if(exist([dataDir type '/annotations'],'dir')), continue; end
  dbExtract([dataDir type],1,skip);
end

%% set up opts for training detector (see acfTrain)
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

%% optionally switch to LDCF version of detector (see acfTrain)
if( 0 ), opts.filters=[5 4]; opts.name='models/LdcfCaltech'; end

%% train detector (see acfTrain)
detector = acfTrain( opts );

%% modify detector (see acfModify)
pModify=struct('cascThr',-1,'cascCal',.025);
detector=acfModify(detector,pModify);

%% run detector on a sample image (see acfDetect)

%%%
vid = VideoReader('Right.mpg');


%%%

imgNms=bbGt('getFiles',{[dataDir 'test/images']});
for i=1:606
    I=imread(imgNms{i}); tic, bbs=acfDetect(I,detector);
    Ind = find(bbs(:,end) > 80);
    bbs = bbs(Ind,:);
    toc
    figure(1); im(I);bbApply('draw',bbs); pause(.1);
    input('Press enter...');
end

%% test detector and plot roc (see acfTest)
[~,~,gt,dt]=acfTest('name',opts.name,'imgDir',[dataDir 'test/images'],...
  'gtDir',[dataDir 'test/annotations'],'pLoad',[pLoad, 'hRng',[50 inf],...
  'vRng',[.65 1],'xRng',[5 635],'yRng',[5 475]],...
  'pModify',pModify,'reapply',0,'show',2);
