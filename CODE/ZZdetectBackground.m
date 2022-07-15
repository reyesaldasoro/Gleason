function [backgroundMask,innerWhite] = detectBackground(currentImage)

%%
% Find the background through a combination of saturation and morphological
% operators
% Will not run with full resolution, reduce size
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
data_lowSat1            = (bwmorph(bwmorph(data_lowSat,'majority'),'majority'));
data_lowSat2            = (imfilter(data_hsv(:,:,2),ones(3)/9))<low_sat;
%data_lowSat1           =  bwmorph(bwmorph(bwmorph(data_lowSat,'majority'),'majority'),'majority');
%imagesc(data_lowSat1)
%%
strelElement1        = strel('disk',25);
strelElement2        = strel('disk',50);
H_E_chromatic_highSat = H_E_chromatic.*(1-data_lowSat);
H_E_chromatic_highSatL = bwlabel(H_E_chromatic_highSat);
H_E_chromatic_highSat2 =  imopen(imclose(H_E_chromatic_highSat,strelElement1),strelElement2);

%%
% Label to keep large regions
data_lowSat_L       = bwlabel(data_lowSat1);
data_lowSat_P       = regionprops(data_lowSat1,'area','BoundingBox');
avArea              =  mean([data_lowSat_P.Area]);
stdArea             =  std([data_lowSat_P.Area]);
%larg
data_lowSat_Large   = bwlabel(ismember(data_lowSat_L,find([data_lowSat_P.Area]>(avArea+stdArea))));
data_lowSat_Small   = bwlabel(ismember(data_lowSat_L,find([data_lowSat_P.Area]<(avArea+stdArea))));

%data_lowSat_P      = regionprops(data_lowSat_Large,'area','BoundingBox');
% Keep only those in the edges
inEdges = unique([unique( data_lowSat_Large([1:5 end-4:end] ,:));unique(data_lowSat_Large(:,[1:5 end-4:end]))  ]);
inEdges(inEdges==0)=[];
%%
backgroundMask1      = (imclose(ismember(data_lowSat_Large,inEdges),strel('disk',40)));
backgroundMask      = imerode(backgroundMask1,strel('disk',20))| black_background;
%% Now detect the inner white regions, potentially the regions of normal tissue

%discard whites that overlap with background before erosion
numSmall            = max(data_lowSat_Small(:));
notInBackground     = unique(data_lowSat_Small.*(1-backgroundMask1));
inBackground        = unique(data_lowSat_Small.*(backgroundMask1));
notInBack           = setdiff(1:numSmall,inBackground);
innerWhite_0        = bwlabel(ismember(data_lowSat_Small,notInBack));
innerWhite_P        = regionprops(innerWhite_0,'area','BoundingBox','MinoraxisLength');
% now there is a balance, very small are not normal glands, VERY large
% neither as they can be cuts in the tissue, only in between, but what
% margins?
avAreaSmall         =  mean([innerWhite_P.Area]);
stdAreaSmall        =  std([innerWhite_P.Area]);
innerWhite=innerWhite_0;
%imagesc(backgroundMask+backgroundMask1)
