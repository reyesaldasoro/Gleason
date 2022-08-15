clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTestClasses\';
saveDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTestClasses2\';
%dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.mat'));
dirall                      = dir(strcat(baseDir,'*_*.mat'));
numFiles                    = length (dirall);


%%

for currentFile= 45 %86:numFiles
    %currentFile                     = 219;
    currentImageName                = dirall(currentFile).name;
    disp(currentImageName)
    currentImageNamePath            = strcat(baseDir,currentImageName);
    currentImageNamePathS           = strcat(saveDir,currentImageName(1:end-6),'.png');
    load(currentImageNamePath);
    
    qqq=uint8(imresize(finalMask,1/2.5));
    imwrite(qqq,currentImageNamePathS);
    
end  


%%


for currentFile= 46:62
    %currentFile                     = 219;
    currentImageName                = dirall(currentFile).name;
    disp(currentImageName)
    currentImageNamePath            = strcat(baseDir,currentImageName);
    currentImageNamePathS           = strcat(saveDir,currentImageName(1:end-6),'.png');
    load(currentImageNamePath);
    
    qqq=uint8(imresize(finalMask,[dimensions(currentFile).rows dimensions(currentFile).cols]/10));
    imwrite(qqq,currentImageNamePathS);
    
end  

%%


for currentFile= 86:128
    %currentFile                     = 219;
    currentImageName                = dimensions(currentFile).name;
    disp(currentImageName)
    %currentImageNamePath            = strcat(baseDir,currentImageName);
    currentImageNamePathS           = strcat(saveDir,currentImageName(1:end-6),'.png');
    %load(currentImageNamePath);
    
    qqq=uint8(imresize(finalMask,[dimensions(currentFile).rows dimensions(currentFile).cols]/10));
    imwrite(qqq,currentImageNamePathS);
    
end  
