clear all
close all

%%
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\';
dir0                        = dir(strcat(baseDir,'Subset1_*.tiff'));

numFiles                    = length (dir0);
fileName_number(numFiles)   = 0;
for k=1:numFiles
    fileName_number(k)      = str2double(dir0(k).name(15:end-5));
end

%%
currentFile                 = 5;
currentImage                = strcat(baseDir,'Subset1_Train_',num2str( fileName_number(currentFile)),'.tiff');
locationMasks               = strcat(baseDir,'Subset1_Train_annotation\Train\Subset1_Train_',num2str( fileName_number(currentFile)),filesep,'*.tif');    
allMasks                    = dir(locationMasks);

currentG3                   = strcat(baseDir,'Subset1_Train_annotation\Train\Subset1_Train_',num2str( fileName_number(currentFile)),filesep,'G3_Mask.tif');
currentG4                   = strcat(baseDir,'Subset1_Train_annotation\Train\Subset1_Train_',num2str( fileName_number(currentFile)),filesep,'G4_Mask.tif');
currentG5                   = strcat(baseDir,'Subset1_Train_annotation\Train\Subset1_Train_',num2str( fileName_number(currentFile)),filesep,'G5_Mask.tif');
currentNo                   = strcat(baseDir,'Subset1_Train_annotation\Train\Subset1_Train_',num2str( fileName_number(currentFile)),filesep,'Normal_Mask.tif');
currentSt                   = strcat(baseDir,'Subset1_Train_annotation\Train\Subset1_Train_',num2str( fileName_number(currentFile)),filesep,'Stroma_Mask.tif');
%%

a   = imfinfo(currentName);
b   = imread(currentName);
G3  = imread(currentG3);
G4  = imread(currentG4);
St  = imread(currentSt);

% b=imread('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\Subset1_Train_16.tiff');
% G3=imread('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\Subset1_Train_annotation\Train\Subset1_Train_16\G3_Mask.tif');
% G4=imread('Subset1_Train_annotation\Train\Subset1_Train_16\G4_Mask.tif');
% St=imread('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\Data\Subset1_Train_annotation\Train\Subset1_Train_16\Stroma_Mask.tif');
%%
step=16;
figure(2)
imagesc(b(1:step:end,1:step:end,:).*uint8(repmat(1-G4(1:step:end,1:step:end,:),[1 1 3])))
%%
step=4;

G3_edge =  imdilate(edge(G3(1:step:end,1:step:end,:),'canny'),ones(64/step));
G4_edge =  imdilate(edge(G4(1:step:end,1:step:end,:),'canny'),ones(64/step));
St_edge =  imdilate(edge(St(1:step:end,1:step:end,:),'canny'),ones(64/step));
%all_edges = imdilate(G3_edge+G4_edge+St_edge,ones(5));
clear regions
regions(:,:,1) = b(1:step:end,1:step:end,1).*uint8(1-G3_edge);
regions(:,:,2) = b(1:step:end,1:step:end,2).*uint8(1-G4_edge);
regions(:,:,3) = b(1:step:end,1:step:end,3).*uint8(1-St_edge);

figure(3)
imagesc(regions)

figure(4) 
imagesc(G3(1:step:end,1:step:end,:) + 2* G4(1:step:end,1:step:end,:) + 3*St(1:step:end,1:step:end,:))