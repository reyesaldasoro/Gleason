
clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
setSelected                 = 3;
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\';
saveDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataR\';
dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.tiff'));
dirR                        = dir(strcat(saveDir,'Subset',num2str(setSelected),'_*.mat'));
numFiles                    = length (dir0);
clear fileName_number;
fileName_number(numFiles,1)   = 0;
for k=1:numFiles
    if setSelected ==3
        loc_undersc=strfind(dir0(k).name,'_');
        fileName_number(k,1)      = str2double(dirR(k).name(loc_undersc(2)+1:loc_undersc(3)-1));
    else
         fileName_number(k)      = str2double(dir0(k).name(15:end-5));
    end
end

%%
%currentFile                 = 18;
step                        = 4;
for currentFile=6:numFiles
    fileName                    = dirR(currentFile).name;
    pos_hyphens            = strfind(fileName,'_');
    scannerType                 = fileName(pos_hyphens(3)+1:pos_hyphens(4)-1);
    %fileName                    = strcat('Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'.tiff');
    currentImageName            = strcat(saveDir,fileName);
    %currentImageInfo            = imfinfo(currentImageName);
    disp(currentImageName)
    %cols                        = currentImageInfo.Width;
    %rows                        = currentImageInfo.Height;
    clear G3R G4R G5R StromaR NormalR currentImageR
    load(currentImageName);
    [rows,cols,levs]            = size(currentImageR);
    %currentImageR               = currentImage(1:step:end,1:step:end,:);
    locationMasks               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\',scannerType,'\Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'_',scannerType,filesep,'*.tif');% num2str( fileName_number(currentFile)),filesep,'*.tif');    
    allMasks                    = dir(locationMasks);
    rowsR       = numel(1:step:rows);
    colsR       = numel(1:step:cols);
    tic;
    if ~isempty(strfind([allMasks.name],'G3'))
        currentG3               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\',scannerType,'\Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'_',scannerType,filesep,'G3_Mask.tif');
        G3                      = imread(currentG3);
        G3R                     = G3(1:step:end,1:step:end,:);
    else
        disp('No mask for G3')
        G3R                      = zeros(rowsR,colsR);
    end
    if ~isempty(strfind([allMasks.name],'G4'))
        currentG4               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\',scannerType,'\Subset',num2str(setSelected),'_Train_',num2str( fileName_number(currentFile)),'_',scannerType,filesep,'G4_Mask.tif');
        G4                      = imread(currentG4);
        G4R                     = G4(1:step:end,1:step:end,:);
    else
        disp('No mask for G4')
        G4R                      = zeros(rowsR,colsR);
    end
    if ~isempty(strfind([allMasks.name],'G5'))
        currentG5               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\',scannerType,'\Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'_',scannerType,filesep,'G5_Mask.tif');
        G5                      = imread(currentG5);
        G5R                     = G5(1:step:end,1:step:end,:);
    else
        disp('No mask for G5')
        G5R                      = zeros(rowsR,colsR);
    end
    if ~isempty(strfind([allMasks.name],'Normal'))
        currentNo               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\',scannerType,'\Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'_',scannerType,filesep,'Normal_Mask.tif');
        Normal                  = imread(currentNo);
        NormalR                 = Normal(1:step:end,1:step:end,:);
        
    else
        disp('No mask for Normal')
        NormalR                  = zeros(rowsR,colsR);
    end
    if ~isempty(strfind([allMasks.name],'Stroma'))
        currentSt               = strcat(baseDir,'Subset',num2str(setSelected),'_Train_annotation\Train\',scannerType,'\Subset',num2str(setSelected),'_Train_',num2str(fileName_number(currentFile)),'_',scannerType,filesep,'Stroma_Mask.tif');
        Stroma                  = imread(currentSt);
        StromaR                 = Stroma(1:step:end,1:step:end,:);
    else
        StromaR                  = zeros(rowsR,colsR);
        disp('No mask for Stroma')
    end
    %save( strcat(saveDir,fileName(1:end-5),'_R.mat'),'currentImageR','G3R','G4R','G5R','NormalR','StromaR','-v7.3')
end
