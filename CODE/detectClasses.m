function [backgroundMask,innerWhite,innerTissue,meanBackground,meanTissue,finalMask] = detectClasses(currentImage)

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
%tic;
%H_E_chromatic_highSat2 =  imopen(imclose(H_E_chromatic_highSat,strelElement1),strelElement2);
%t1=toc;
%tic;
H_E_chromatic_highSat2 =  (imclose(H_E_chromatic_highSat,strelElement1));
%t2=toc;
%[t1 t2]
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
largeSpecks         = find([innerWhite2_P.Area]>500);
%largestSpecks       = find([innerWhite2_P.Area]>10);
%innerWhite3         = ismember(innerWhite2,intersect(largeSpecks,notTouchBackground));

innerWhite3         = ismember(innerWhite2,largeSpecks);
innerWhite          = innerWhite3;

%%

innerTissue         = (1-innerWhite3).*backgroundMask4;
%%
% Normal is the regions where there is white surrounded by blue/purple
blue_purple         = innerTissue.*H_E_chromatic_highSat.*(data_hsv(:,:,1)>0.55).*(data_hsv(:,:,1)<=0.79);
pink_purple         = innerTissue.*H_E_chromatic_highSat.*(data_hsv(:,:,1)>0.79).*(data_hsv(:,:,1)<0.90);

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
% else so it is G>0.3 But this may change between images
% Find limits with order statistics
region_G            = blockproc(regionsCombined,[sizeRegion sizeRegion],f_G);
distGvalues         = sort(region_G(:));
lowerG              = distGvalues(round(0.9*numel(distGvalues)));
upperG              = distGvalues(round(0.97*numel(distGvalues)));


G345_low            = bwlabel(region_G>lowerG);%imagesc(G345_low)
G345_high           = bwlabel(region_G>upperG);%imagesc(G345_high)
G345_inBoth         = unique(G345_low.*(G345_high>0));
G345_both           = ismember(G345_low,G345_inBoth(2:end));
G345_filled         = imfill(G345_both,'holes');
G345_final          = backgroundMask.*imdilate(G345_filled,strelElement1);
%figure(21);imagesc(currentImage.*uint8(repmat(G345_final,[1 1 3])))
%figure(22);imagesc(currentImage.*uint8(repmat(1-G345_final,[1 1 3])))

% Stroma regions are those with a high percentage of pink S>0,75, but far from
% normal previously defined 

%
% counterReg = 8813;
clear isNormal;
isNormal(numW,1) = 0;
[innerWhite_L,numW] = bwlabel(innerWhite);
innerWhite_P        = regionprops(innerWhite_L);
for counterReg = 1:numW
       % counterReg = 2436;
    if  innerWhite_P(counterReg).Area<40000
        %disp(counterReg)
        margin          = 20;
        rStart          = max(1,-margin+innerWhite_P(counterReg).BoundingBox(2));
        rFin            = min(rows,2*margin+rStart+innerWhite_P(counterReg).BoundingBox(4));
        cStart          = max(1,-margin+innerWhite_P(counterReg).BoundingBox(1));
        cFin            = min(cols,2*margin+cStart+innerWhite_P(counterReg).BoundingBox(3));
        rr = round(rStart:rFin);
        cc = round(cStart:cFin);
%         try 
%             qq=sum(sum(G345_final(rr,cc)));
%         catch
%             qq=1;
%         end
            
        % should not be close to G345
        if ( sum(sum(G345_final(rr,cc)))==0)
            candidateGland  = innerWhite_L(rr,cc)==counterReg;
            candidateBlue   = imdilate(candidateGland,ones(21));
            blueSurround    = sum(sum((candidateBlue-candidateGland).*blue_purple(rr,cc)))/ sum(sum((candidateBlue-candidateGland)));
            stromaSurround  = sum(sum(pink_purple(rr,cc)))/sum(sum(1-innerWhite(rr,cc)));
            backgroundSurr  = sum(sum(1-backgroundMask(rr,cc)))/numel(rr)/numel(cc);
            
            % Conditions to be normal:
            % backgroundSurr<0.01  not on the edge of the tissue
            % 0.1 <blueSurround < 0.25  surrounded by a circle of cells, not too many
            % stromaSurround>0.5
            
            if (backgroundSurr<0.01)
                if (stromaSurround>0.5)
                    if (blueSurround>0.04)&(blueSurround<0.5)
                        isNormal(counterReg) = 1;
                    end
                end
            end
        end
    end
end
%final condition, normals should be surrounded by normals
candidate_normal    = ismember(innerWhite_L,find(isNormal(1:end)));
normal_blurr        = (imfilter(double(candidate_normal),ones(500)/500/500));
normal_final        = (normal_blurr>0.15).*(1-G345_final);

region_S            = blockproc(regionsCombined,[sizeRegion sizeRegion],f_S);
Stroma_blurr        = imfilter(double((region_S>0.75).*(1-G345_final).*(1-normal_final)),ones(500)/500/500);
Stroma_final        = (Stroma_blurr>0.10).*(1-G345_final).*(1-normal_final);


% G5 will be regions of G where there is no inner white or very little
G345_L              = bwlabel(G345_final);
G345_P              = regionprops(G345_L,'Area');
G345_White          = G345_L.*innerWhite;
G345_WP             = regionprops(G345_White,'Area');
propInnerWhite      =([G345_WP.Area]./[G345_P.Area])';
G5_final            = ismember(G345_L,find(propInnerWhite<0.01));
G3_final            = ismember(G345_L,find(propInnerWhite>0.1));
G4_final            = G345_final-G5_final-G3_final;

finalMask           = normal_final+2*Stroma_final+3*G3_final+4*G4_final+5*G5_final;
%   figure(8)
%   imagesc(finalMask)
% 
%   kkk=1;
% figure(1)
% imagesc(currentImage(rr,cc,:))
% figure(2)
% imagesc(currentImage.*uint8(repmat(imerode(innerWhite_L~=counterReg,ones(190)),[1 1 3])  ))
%     figure(3)
%     imagesc(pink_purple(rr,cc)+innerWhite(rr,cc)*2+blue_purple(rr,cc)*3)
%     title(strcat('Blue = ',num2str(blueSurround),', Str=',num2str(stromaSurround),', Bac=',num2str(backgroundSurr)))
%%
% 
% imagesc(innerWhite3*2+blue_purple );
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
