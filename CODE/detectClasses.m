function [backgroundMask,innerWhite,innerTissue,meanBackground,meanTissue] = detectClasses(currentImage)

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
H_E_chromatic_highSat2 =  imopen(imclose(H_E_chromatic_highSat,strelElement1),strelElement2);
backgroundMask1      = (H_E_chromatic_highSat2)| black_background;
backgroundMask_L     = bwlabel(1-backgroundMask1);
backgroundMask_LP    = regionprops(backgroundMask_L,'area');
% this returns small regions of white to be included later in innerWhute
backgroundMask      = backgroundMask1+ismember(backgroundMask_L,find([backgroundMask_LP.Area]<(rows*cols*1e-2)));


%% Inner white 
rCh                 = currentImage(:,:,1);
gCh                 = currentImage(:,:,2);
bCh                 = currentImage(:,:,3);
rCh_1               = mean(rCh(backgroundMask==1));
rCh_0               = mean(rCh(backgroundMask==0));
gCh_1               = mean(gCh(backgroundMask==1));
gCh_0               = mean(gCh(backgroundMask==0));
bCh_1               = mean(bCh(backgroundMask==1));
bCh_0               = mean(bCh(backgroundMask==0)); 

meanBackground      = [rCh_0 gCh_0 bCh_0 ]; 
meanTissue          = [rCh_1 gCh_1 bCh_1 ]; 
strelElement3       = strel('disk',15);
backgroundMask4     = imerode(backgroundMask,strelElement3);
%backgroundMask3     = imdilate(1-backgroundMask2,ones(9));
innerWhite1         = bwmorph(backgroundMask4.*(1-H_E_chromatic_highSat),'majority');
[innerWhite2,numW]  = bwlabel(innerWhite1);
innerWhite2_P       = regionprops(innerWhite2,'area');
% remove small specks and those that touch background
%notTouchBackground  = setdiff((1:numW), unique((backgroundMask3).*innerWhite2));
largeSpecks         = find([innerWhite2_P.Area]>10);
%largestSpecks       = find([innerWhite2_P.Area]>10);
%innerWhite3         = ismember(innerWhite2,intersect(largeSpecks,notTouchBackground));

innerWhite3         = ismember(innerWhite2,largeSpecks);
innerWhite          = innerWhite3;
innerTissue         = (1-innerWhite3).*backgroundMask4;
%%
% Normal is the regions where there is white surrounded by blue/purple
blue_purple         = innerTissue.*H_E_chromatic_highSat.*(data_hsv(:,:,1)>0.55).*(data_hsv(:,:,1)<0.75);
pink_purple         = innerTissue.*H_E_chromatic_highSat.*(data_hsv(:,:,1)>0.75).*(data_hsv(:,:,1)<0.90);

sizeRegion          = 64;
regionsCombined     = ((innerWhite3*1+2*blue_purple+3*pink_purple) );
f_G                 = @(block_struct) (sum(sum(block_struct.data==2)))/numel(block_struct.data) * ones(size(block_struct.data));
f_N                 = @(block_struct) (sum(sum(block_struct.data==1)))/numel(block_struct.data) * ones(size(block_struct.data));
f_S                 = @(block_struct) (sum(sum(block_struct.data==3)))/numel(block_struct.data) * ones(size(block_struct.data));
% This defines the normal regions, which are predominantly white but
% surrounded by pink and blue, thus the percentage has to be 0.4<n<0.8 PLUS
% it has to be far from the background
region_N            = blockproc(regionsCombined,[sizeRegion sizeRegion],f_N);

% G3/G4/G5 are easier to define as they have a majority of blue and nothing
% else so it is G>0.3
region_G            = blockproc(regionsCombined,[sizeRegion sizeRegion],f_G);
G345                =region_G>0.3;
% Stroma regions are those with a high percentage of pink S>0,75, but far from
% normal previously defined 
region_S            = blockproc(regionsCombined,[sizeRegion sizeRegion],f_S);

imagesc(innerWhite3*2+blue_purple );
% % Label to keep large regions
% data_lowSat_L       = bwlabel(data_lowSat1);
% data_lowSat_P       = regionprops(data_lowSat1,'area','BoundingBox');
% avArea              =  mean([data_lowSat_P.Area]);
% stdArea             =  std([data_lowSat_P.Area]);
% %larg
% data_lowSat_Large   = bwlabel(ismember(data_lowSat_L,find([data_lowSat_P.Area]>(avArea+stdArea))));
% data_lowSat_Small   = bwlabel(ismember(data_lowSat_L,find([data_lowSat_P.Area]<(avArea+stdArea))));
% 
% %data_lowSat_P      = regionprops(data_lowSat_Large,'area','BoundingBox');
% % Keep only those in the edges
% inEdges = unique([unique( data_lowSat_Large([1:5 end-4:end] ,:));unique(data_lowSat_Large(:,[1:5 end-4:end]))  ]);
% inEdges(inEdges==0)=[];
% %%
% backgroundMask1      = (imclose(ismember(data_lowSat_Large,inEdges),strel('disk',40)));
% backgroundMask      = imerode(backgroundMask1,strel('disk',20))| black_background;
% %% Now detect the inner white regions, potentially the regions of normal tissue
% 
% %discard whites that overlap with background before erosion
% numSmall            = max(data_lowSat_Small(:));
% notInBackground     = unique(data_lowSat_Small.*(1-backgroundMask1));
% inBackground        = unique(data_lowSat_Small.*(backgroundMask1));
% notInBack           = setdiff(1:numSmall,inBackground);
% innerWhite_0        = bwlabel(ismember(data_lowSat_Small,notInBack));
% innerWhite_P        = regionprops(innerWhite_0,'area','BoundingBox','MinoraxisLength');
% % now there is a balance, very small are not normal glands, VERY large
% % neither as they can be cuts in the tissue, only in between, but what
% % margins?
% avAreaSmall         =  mean([innerWhite_P.Area]);
% stdAreaSmall        =  std([innerWhite_P.Area]);
% innerWhite=innerWhite_0;
%imagesc(backgroundMask+backgroundMask1)