function [backgroundMask,innerWhite,innerTissue,meanBackground,meanTissue] = detectBackground(currentImage)

%%
% Find the background through a combination of saturation and morphological
% operators
% Will not run with full resolution, reduce size
[rows,cols,levs]        = size(currentImage);
data_hsv                = rgb2hsv(currentImage);
%% Black regions on edges
% There are some images that contain black regions, select from value
strelElement1           = strel('disk',15);
strelElement2           = strel('disk',20);
black_background        = imclose(imopen(data_hsv(:,:,3)<0.3,strelElement2),strelElement1);

%% H & E chromatic region 
H_E_chromatic           = data_hsv(:,:,1)>0.6;
%% select regions with low saturation 
low_sat                 = graythresh((data_hsv(:,:,2)));
data_lowSat             = data_hsv(:,:,2)<( 0.5*low_sat);
% data_lowSat1            = (bwmorph(bwmorph(data_lowSat,'majority'),'majority'));
% data_lowSat2            = (imfilter(data_hsv(:,:,2),ones(3)/9))<low_sat;
%data_lowSat1           =  bwmorph(bwmorph(bwmorph(data_lowSat,'majority'),'majority'),'majority');
%imagesc(data_lowSat1)
%%
strelElement1        = strel('disk',25);
strelElement2        = strel('disk',50);
H_E_chromatic_highSat = H_E_chromatic.*(1-data_lowSat);
% H_E_chromatic_highSatL = bwlabel(H_E_chromatic_highSat);
%H_E_chromatic_highSat2 =  imopen(imclose(H_E_chromatic_highSat,strelElement1),strelElement2);
H_E_chromatic_highSat2 =  (imclose(H_E_chromatic_highSat,strelElement1));
%backgroundMask      = (H_E_chromatic_highSat2)| black_background;


backgroundMask1      = (H_E_chromatic_highSat2)| black_background;
backgroundMask_L     = bwlabel(1-backgroundMask1);
backgroundMask_LP    = regionprops(backgroundMask_L,'area');
% this returns small regions of white to be included later in innerWhute
backgroundMask      = backgroundMask1+ismember(backgroundMask_L,find([backgroundMask_LP.Area]<(rows*cols*1e-2)));


%% Inner white 
% rCh                 = currentImage(:,:,1);
% gCh                 = currentImage(:,:,2);
% bCh                 = currentImage(:,:,3);
% rCh_1               = mean(rCh(backgroundMask==1));
% rCh_0               = mean(rCh(backgroundMask==0));
% gCh_1               = mean(gCh(backgroundMask==1));
% gCh_0               = mean(gCh(backgroundMask==0));
% bCh_1               = mean(bCh(backgroundMask==1));
% bCh_0               = mean(bCh(backgroundMask==0));
% 
% meanBackground      = [rCh_0 gCh_0 bCh_0 ];
% meanTissue          = [rCh_1 gCh_1 bCh_1 ];
% strelElement3       = strel('disk',15);
% backgroundMask2     = imerode(backgroundMask,strelElement3);
% %backgroundMask3     = imdilate(1-backgroundMask2,ones(9));
% innerWhite1         = bwmorph(backgroundMask2.*(1-H_E_chromatic_highSat),'majority');
% [innerWhite2,numW]  = bwlabel(innerWhite1);
% innerWhite2_P       = regionprops(innerWhite2,'area');
% % remove small specks and those that touch background
% %notTouchBackground  = setdiff((1:numW), unique((backgroundMask3).*innerWhite2));
% largeSpecks         = find([innerWhite2_P.Area]>10);
% %largestSpecks       = find([innerWhite2_P.Area]>10);
% %innerWhite3         = ismember(innerWhite2,intersect(largeSpecks,notTouchBackground));
% 
% innerWhite3         = ismember(innerWhite2,largeSpecks);
% innerWhite          = innerWhite3;
% innerTissue         = (1-innerWhite3).*backgroundMask2;

