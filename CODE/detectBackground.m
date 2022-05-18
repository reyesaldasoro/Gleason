function [backgroundMask,innerWhite] = detectBackground(currentImage)

%%
% Find the background through a combination of saturation and morphological
% operators
% Will not run with full resolution, reduce size
data_hsv            = rgb2hsv(currentImageR);
%% select regions with low saturation 
low_sat             = 0.5*graythresh((data_hsv(:,:,2)));
data_lowSat         = data_hsv(:,:,2)<low_sat;
data_lowSat1        =  bwmorph(bwmorph(data_lowSat,'majority'),'majority');
imagesc(data_lowSat1)
%%
% Label to keep large regions
data_lowSat_L       = bwlabel(data_lowSat1);
data_lowSat_P       = regionprops(data_lowSat1,'area','BoundingBox');
avArea              =  mean([data_lowSat_P.Area]);
stdArea             =  std([data_lowSat_P.Area]);
data_lowSat_Large   = bwlabel(ismember(data_lowSat_L,find([data_lowSat_P.Area]>(avArea+stdArea))));
data_lowSat_Small   = bwlabel(ismember(data_lowSat_L,find([data_lowSat_P.Area]<(avArea+stdArea))));

%data_lowSat_P      = regionprops(data_lowSat_Large,'area','BoundingBox');
% Keep only those in the edges
inEdges = unique([unique( data_lowSat_Large([1:5 end-4:end] ,:));unique(data_lowSat_Large(:,[1:5 end-4:end]))  ]);
inEdges(inEdges==0)=[];
%%
backgroundMask1      = (imclose(ismember(data_lowSat_Large,inEdges),strel('disk',40)));

backgroundMask      = imerode(backgroundMask1,strel('disk',20));

imagesc(backgroundMask+backgroundMask1)
