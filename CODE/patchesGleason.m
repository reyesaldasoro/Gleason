clear
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataR\';
saveDirP                    = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\trainingPatch\';
saveDirL                    = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\trainingLabel\';
%dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.mat'));
dirall                      = dir(strcat(baseDir,'*_*.mat'));
numFiles                    = length (dirall);

%%

for currentFile= 36:1: numFiles
    currentImageName                = dirall(currentFile).name;
    disp(currentImageName)
    currentImageNamePath            = strcat(baseDir,currentImageName);
    currentImageNamePathS           = strcat(saveDir,currentImageName(1:end-3),'png');
    load(currentImageNamePath);
    [rows,cols,~]               = size(currentImageR);
    
    if (sum(sum(G5R)))>0
        for k1=1:256:rows-256
            disp(k1)
            
            for k2=1:256:cols-256
                rr = k1:k1+255;
                cc = k2:k2+255;
                currPatch=currentImageR(rr,cc,:);
                if (sum(sum(NormalR(rr,cc)))/256/256)>0.99
                    currentImageNamePathS  = strcat(saveDirP,'N_',currentImageName(1:end-4),num2str(k1),'_',num2str(k2),'.png');
                    imwrite(currPatch,currentImageNamePathS)
                end
                if (sum(sum(StromaR(rr,cc)))/256/256)>0.99
                    currentImageNamePathS  = strcat(saveDirP,'S_',currentImageName(1:end-4),num2str(k1),'_',num2str(k2),'.png');
                    imwrite(currPatch,currentImageNamePathS)
                end
                if (sum(sum(G3R(rr,cc)))/256/256)>0.99
                    currentImageNamePathS  = strcat(saveDirP,'G3_',currentImageName(1:end-4),num2str(k1),'_',num2str(k2),'.png');
                    imwrite(currPatch,currentImageNamePathS)
                end
                if (sum(sum(G4R(rr,cc)))/256/256)>0.99
                    currentImageNamePathS  = strcat(saveDirP,'G4_',currentImageName(1:end-4),num2str(k1),'_',num2str(k2),'.png');
                    imwrite(currPatch,currentImageNamePathS)
                end
                if (sum(sum(G5R(rr,cc)))/256/256)>0.9
                    currentImageNamePathS  = strcat(saveDirP,'G5_',currentImageName(1:end-4),num2str(k1),'_',num2str(k2),'.png');
                    imwrite(currPatch,currentImageNamePathS)
                end
            end
        end
    end
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

