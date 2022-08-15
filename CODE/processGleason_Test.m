clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTestR\';
saveDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTestClasses\';
%dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.mat'));
dirall                      = dir(strcat(baseDir,'*_*.mat'));
numFiles                    = length (dirall);

%sizeEdge                    = 64;





%
% currentFile=121;
% currentImageName                = dirall(currentFile).name;
% disp(currentImageName)
% currentImageNamePath            = strcat(baseDir,currentImageName);
% 
% load(currentImageNamePath);
% 
% [backgroundMask,innerWhite] = detectBackground(currentImageR);
% step                        = 2;

%%


for currentFile= 61: numFiles
    %currentFile                     = 219;
    currentImageName                = dirall(currentFile).name;
    disp(currentImageName)
    currentImageNamePath            = strcat(baseDir,currentImageName);
    currentImageNamePathS           = strcat(saveDir,currentImageName(1:end-3),'mat');
    load(currentImageNamePath);
    [rows,cols,~]               = size(currentImageR);
    
    if (rows>40000)|(cols>40000)
        currentImageR=currentImageR(1:4:end,1:4:end,:);
    elseif (rows>24000)|(cols>24000)
        currentImageR=currentImageR(1:2:end,1:2:end,:);
    end
%    [backgroundMask,innerWhite,innerTissue,meanBackground,meanTissue] = detectBackground(currentImageR(1:1:end,1:1:end,:));
    [backgroundMask,innerWhite,innerTissue,meanBackground,meanTissue,finalMask] = detectClasses(currentImageR);   
    % Calculate F1 per class
    % First all true positives
 
    %
   % h13=figure(15);
%     h1=subplot(211);
%     imagesc(currentImageR(1:1:end,1:1:end,:))
%     title('Original')
%     
%     h2=subplot(212);
%     imagesc(finalMask)
%     caxis([0 5])
%     h1.Title.String = currentImageName;
%     h1.Title.Interpreter='none';
%    print('-dpng','-r500',currentImageNamePathS)
    save(currentImageNamePathS,'finalMask','-v7.3')
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

