clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
setSelected                 = 1;
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\';
dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.tiff'));

numFiles                    = length (dir0);
clear fileName_number;
fileName_number(numFiles)   = 0;
for k=1:numFiles
    if setSelected ==3
        loc_undersc=strfind(dir0(k).name,'_');
        fileName_number(k)      = str2double(dir0(k).name(loc_undersc(2)+1:loc_undersc(3)-1));
    else
         fileName_number(k)      = str2double(dir0(k).name(15:end-5));
    end
end

%% Times
% read main image   ~ 1000 sec ~ 17 min
% read masks        ~  170 sec ~  3 min
% calculate edges   ~    3 sec

%%
currentFile                 = 18;
step                        = 16;

currentImageName            = strcat(baseDir,'Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'.tiff');
currentImageInfo            = imfinfo(currentImageName);
cols                        = currentImageInfo.Width;
rows                        = currentImageInfo.Height;
%%
tic;
currentImage                = imread(currentImageName);
t1=toc
currentImageR               = currentImage(1:step:end,1:step:end,:);

locationMasks               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\Subset',num2str(setSelected),'_Train_',num2str( fileName_number(currentFile)),filesep,'*.tif');    
allMasks                    = dir(locationMasks);

%%
rowsR       = numel(1:step:rows);
colsR       = numel(1:step:cols);
tic;
if ~isempty(strfind([allMasks.name],'G3'))
    currentG3               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\Subset',num2str(setSelected),'_Train_',num2str( fileName_number(currentFile)),filesep,'G3_Mask.tif');
    G3                      = imread(currentG3);
    G3R                     = G3(1:step:end,1:step:end,:);
else
    disp('No mask for G3')
    G3R                      = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'G4'))
    currentG4               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\Subset',num2str(setSelected),'_Train_',num2str( fileName_number(currentFile)),filesep,'G4_Mask.tif');
    G4                      = imread(currentG4);
    G4R                     = G4(1:step:end,1:step:end,:);
else
    disp('No mask for G4')
    G4R                      = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'G5'))
    currentG5               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\Subset',num2str(setSelected),'_Train_',num2str( fileName_number(currentFile)),filesep,'G5_Mask.tif');
    G5                      = imread(currentG5);
    G5R                     = G5(1:step:end,1:step:end,:);
else
    disp('No mask for G5')
    G5R                      = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'Normal'))
    currentNo               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\Subset',num2str(setSelected),'_Train_',num2str( fileName_number(currentFile)),filesep,'Normal_Mask.tif');
    Normal                  = imread(currentNo);
    NormalR                 = Normal(1:step:end,1:step:end,:);

else
    disp('No mask for Normal')
    NormalR                  = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'Stroma'))
    currentSt               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\Subset',num2str(setSelected),'_Train_',num2str( fileName_number(currentFile)),filesep,'Stroma_Mask.tif');
    Stroma                  = imread(currentSt);
    StromaR                 = Stroma(1:step:end,1:step:end,:);
else
    StromaR                  = zeros(rowsR,colsR);
    disp('No mask for Stroma')
end

t2=toc

%%
tic;
if ~isempty(strfind([allMasks.name],'G3'))
    G3_edge                 =  imdilate(edge(G3(1:step:end,1:step:end,:),'canny'),ones(64/step));
else
    G3_edge                 = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'G4'))
    G4_edge                 =  imdilate(edge(G4(1:step:end,1:step:end,:),'canny'),ones(64/step));
else
    G4_edge                 = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'G5'))
    G5_edge                 =  imdilate(edge(G5(1:step:end,1:step:end,:),'canny'),ones(64/step));
else
    G5_edge                 = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'Normal'))
    Normal_edge             =  imdilate(edge(Normal(1:step:end,1:step:end,:),'canny'),ones(64/step));
else
    Normal_edge             = zeros(rowsR,colsR);
end
if ~isempty(strfind([allMasks.name],'Stroma'))
    Stroma_edge             =  imdilate(edge(Stroma(1:step:end,1:step:end,:),'canny'),ones(64/step));
else
    Stroma_edge             = zeros(rowsR,colsR);
end
t3=toc

%%

% b   = imread(currentName);
% G3  = imread(currentG3);
% G4  = imread(currentG4);

% b=imread('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\Subset1_Train_16.tiff');
% G3=imread('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\Subset1_Train_annotation\Train\Subset1_Train_16\G3_Mask.tif');
% G4=imread('Subset1_Train_annotation\Train\Subset1_Train_16\G4_Mask.tif');
% St=imread('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\Subset1_Train_annotation\Train\Subset1_Train_16\Stroma_Mask.tif');
%%
figure(1)
imagesc(currentImage)
%%

figure(2)
subplot(231)
imagesc(currentImageR.*uint8(repmat(G3R,[1 1 3])))
title('G3')
subplot(232)
imagesc(currentImageR.*uint8(repmat(G4R,[1 1 3])))
title('G4')
subplot(233)
imagesc(currentImageR.*uint8(repmat(G5R,[1 1 3])))
title('G5r')
subplot(234)
imagesc(currentImageR.*uint8(repmat(StromaR,[1 1 3])))
title('Stroma')
subplot(235)
imagesc(currentImageR.*uint8(repmat(NormalR,[1 1 3])))
title('Normal')
%%
%all_edges = imdilate(G3_edge+G4_edge+Stroma_edge,ones(5));
clear regions
regions(:,:,1) = currentImageR(:,:,1).*uint8(1-G3_edge).*uint8(1-G5_edge).*uint8(1-Normal_edge);
regions(:,:,2) = currentImageR(:,:,2).*uint8(1-G4_edge).*uint8(1-Stroma_edge).*uint8(1-Normal_edge);
regions(:,:,3) = currentImageR(:,:,3).*uint8(1-Stroma_edge).*uint8(1-G5_edge).*uint8(1-Normal_edge);

figure(3)
imagesc(regions)
%%
figure(4) 
imagesc(3*G3R + 4* G4R.*(1-NormalR).*(1-G5R).*(1-G3R) + 5*G5R.*(1-NormalR).*(1-G4R).*(1-G3R) +2*StromaR.*(1-G4R).*(1-G3R) + 1*NormalR)



%% Resources
% https://www.pathologyoutlines.com/topic/prostategrading.html
% https://www.humpath.com/spip.php?article18060
% https://www.mdpi.com/2072-6694/13/7/1524/htm
% https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6624635/
% https://www.webpathology.com/image.asp?n=24&Case=20
% https://www.google.com/search?q=gleason+score+pathology+outlines&tbm=isch&client=firefox-b-d&hl=en&sa=X&ved=2ahUKEwjf152d_-P3AhWH_IUKHZIWD5QQrNwCKAB6BQgBEOwB&biw=1264&bih=646#imgrc=GgCrrxm8KBqBCM
% https://www.google.com/search?q=prostate+glands+histology&client=firefox-b-d&tbm=isch&source=iu&ictx=1&vet=1&sa=X&ved=2ahUKEwj397SEneT3AhWCQEEAHVu0As8Q_h16BAgNEAk&biw=1281&bih=646&dpr=1.25#imgrc=56KYpG4c5Yf1nM
% https://www.youtube.com/watch?v=V_MrdEuNk7A  % Prostatic pathology
% https://www.youtube.com/watch?v=F9piu1ckDbI  %Prostatic Adenocarcinoma - Histopathology
% https://www.youtube.com/watch?v=9YuqsprhFm4  % Shotgun Histology Prostate
% https://www.youtube.com/watch?v=lMeRg_V53G0  % Histology Of PROSTATE GLAND
% https://www.youtube.com/watch?v=9ff-94Z5Ykc  % Prostate Cancer Pathology in 2021 | Jonathan Epstein, MD | PCRI 2021
% https://www.osmosis.org/learn/Prostate_gland_histology 

