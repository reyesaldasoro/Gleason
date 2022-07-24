
clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
setSelected                 = 3;
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTest\';
saveDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTestR\';
dir0                        = dir(strcat(baseDir,'Subset2*.tiff'));

numFiles                    = length (dir0);

%%
%currentFile                 = 18;
%step                        = 4;
for currentFile=1:numFiles
    fileName                    = dir0(currentFile).name;
    %fileName                    = strcat('Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'.tiff');
    currentImageName            = strcat(baseDir,fileName);
    currentImageInfo            = imfinfo(currentImageName);
    disp(currentImageName)
    cols                        = currentImageInfo.Width;
    rows                        = currentImageInfo.Height;
    if (rows>30000)|(cols>30000)
        step = 2;
    else
        step = 1;
    end     
    currentImage                = imread(currentImageName);
    currentImageR               = currentImage(1:step:end,1:step:end,:);
    save( strcat(saveDir,fileName(1:end-5),'_R.mat'),'currentImageR','-v7.3')
end
