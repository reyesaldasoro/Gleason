clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
setSelected                 = 3;
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataR\';
saveDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataPng\';
dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.mat'));
dirall                      = dir(strcat(baseDir,'*_*.mat'));
numFiles                    = length (dirall);

step                        = 1;
sizeEdge                    = 64;


jet3=[0 0 0;...
    0.6    0.0    0.0  ;...
    1.0    0.4    0 ;...
    1.0    1.0    0.4 ;...
    0.5    0.9    1.0 ;...
    1.0    1.0    1.0 ];


%% Times to read TIFFs
% read main image   ~ 1000 sec ~ 17 min
% read masks        ~  170 sec ~  3 min
% calculate edges   ~    3 sec

%% Times to read MATs
% Subset1,3 between 5-15 sec
% Subset2 82 sec
%%

%%
for currentFile=143: numFiles
    %currentFile                     = 219;
    clear G3* G4* G5* Stroma* Normal* currentImageR
    currentImageName                = dirall(currentFile).name;
    disp(currentImageName)
    currentImageNamePath            = strcat(baseDir,currentImageName);
    currentImageNamePathS           = strcat(saveDir,currentImageName(1:end-3),'png');
    load(currentImageNamePath);
    [rows,cols,~]               = size(currentImageR);
    
    if (rows>30000)|(cols>30000)
        step=2;
        currentImageR=currentImageR(1:step:end,1:step:end,:);
        G3R = G3R(1:step:end,1:step:end,:);
        G4R = G4R(1:step:end,1:step:end,:);
        G5R = G5R(1:step:end,1:step:end,:);
        NormalR = NormalR(1:step:end,1:step:end,:);
        StromaR = StromaR(1:step:end,1:step:end,:);
        
        step=1;
    end
        
    
    
    G3_edge                 =  imdilate(edge(G3R(1:step:end,1:step:end,:),'canny'),ones(sizeEdge/step));
    G4_edge                 =  imdilate(edge(G4R(1:step:end,1:step:end,:),'canny'),ones(sizeEdge/step));
    G5_edge                 =  imdilate(edge(G5R(1:step:end,1:step:end,:),'canny'),ones(sizeEdge/step));
    Normal_edge             =  imdilate(edge(NormalR(1:step:end,1:step:end,:),'canny'),ones(sizeEdge/step));
    Stroma_edge             =  imdilate(edge(StromaR(1:step:end,1:step:end,:),'canny'),ones(sizeEdge/step));
    
    clear regions
    regions(:,:,1) = currentImageR(:,:,1).*uint8(1-G3_edge).*uint8(1-G5_edge).*uint8(1-Normal_edge);
    regions(:,:,2) = currentImageR(:,:,2).*uint8(1-G4_edge).*uint8(1-Stroma_edge).*uint8(1-Normal_edge);
    regions(:,:,3) = currentImageR(:,:,3).*uint8(1-Stroma_edge).*uint8(1-G5_edge).*uint8(1-Normal_edge);
    
    figure(13)
    h1=subplot(121);
   % title()
    imagesc(regions)
    h2=subplot(122);
    imagesc(3*G3R + 4* G4R.*(1-NormalR).*(1-G5R).*(1-G3R) + 5*G5R.*(1-NormalR).*(1-G4R).*(1-G3R) +2*StromaR.*(1-G4R).*(1-G3R) + 1*NormalR)
    caxis([0 5])
    colormap(jet3)
    
    h1.Position=[0.05 0.09 0.44 0.85];
    h2.Position=[0.55 0.09 0.44 0.85];
    h1.FontSize=7;
    h2.FontSize=7;
    h1.Title.String = currentImageName;
    h1.Title.Interpreter='none';
    print('-dpng','-r200',currentImageNamePathS)
end
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

