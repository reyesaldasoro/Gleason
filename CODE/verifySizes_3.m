clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
setSelected                 = 3;
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataR\';
saveDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataR\';
dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.mat'));
dirall                      = dir(strcat(baseDir,'*_*.mat'));
numFiles                    = length (dir0);
%% Times to read TIFFs
% read main image   ~ 1000 sec ~ 17 min
% read masks        ~  170 sec ~  3 min
% calculate edges   ~    3 sec

%% Times to read MATs
% Subset1,3 between 5-15 sec
% Subset2 82 sec
%%

%%
for currentFile=1:numFiles
    %currentFile                     = 219;
    clear G3* G4* G5* Stroma* Normal* currentImageR
    currentImageName                = dir0(currentFile).name;
    disp(currentImageName)
    currentImageNamePath            = strcat(baseDir,currentImageName);
    currentImageNamePathS           = strcat(saveDir,currentImageName(1:end-3),'png');
    load(currentImageNamePath);
    [rows,cols,~]               = size(currentImageR);
    [rows3,cols3,~]               = size(G3R);
    [rows4,cols4,~]               = size(G4R);
    [rows5,cols5,~]               = size(G5R);
    [rowsN,colsN,~]               = size(NormalR);
    [rowsS,colsS,~]               = size(StromaR);

    modified =0;
    if (rows~=rows3)|(cols~=cols3)
           disp('G3')
        G3R = zeros(rows,cols);
        modified =1;
    end
    if (rows~=rows4)|(cols~=cols4)
           disp('G4')
        G4R = zeros(rows,cols);
        modified =1;
    end
    if (rows~=rows5)|(cols~=cols5)
           disp('G5')
        G5R = zeros(rows,cols);
        modified =1;
    end
    if (rows~=rowsN)|(cols~=colsN)
           disp('N')
        NormalR = zeros(rows,cols);
        modified =1;
    end
    if (rows~=rowsS)|(cols~=colsS)
        disp('S')
        StromaR = zeros(rows,cols);
        modified =1;
    end
    
    if modified==1
%        disp('****')
        save( strcat(saveDir,currentImageName(1:end-5),'R.mat'),'currentImageR','G3R','G4R','G5R','NormalR','StromaR','-v7.3')
    end
    %print('-dpng','-r200',currentImageNamePathS)
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

