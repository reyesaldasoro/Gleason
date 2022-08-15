clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTest\';
dirall                      = dir(strcat(baseDir,'*_*.tiff'));
numFiles                    = length (dirall);

for currentFile=1:numFiles
    disp(currentFile)
     currentImageName                = dirall(currentFile).name;
     qq= imfinfo(strcat(baseDir,currentImageName));
     dirall(currentFile).cols=qq.Width;
     dirall(currentFile).rows=qq.Height;
end