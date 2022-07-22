clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
setSelected                 = 1;
baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTest\';
dir0                        = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.tiff'));
dirall                      = dir(strcat(baseDir,'*_*.tiff'));
numFiles                    = length (dirall);
%%
currentFile                 = 18;
step                        = 4;

for currentFile=106:142%143:numFiles
    disp(currentFile)
    currentImageName            = strcat(baseDir,dirall(currentFile).name);
    currentImageInfo            = imfinfo(currentImageName);
    cols                        = currentImageInfo.Width;
    rows                        = currentImageInfo.Height;
    dirall(currentFile).rows    = rows;
    dirall(currentFile).cols    = cols;
    if (rows>30000)|(cols>30000)
        step=2;
        
        dirall(currentFile).rowsR    = round(rows/step);
        dirall(currentFile).colsR    = round(cols/step);
    else
        dirall(currentFile).rowsR    = (rows);
        dirall(currentFile).colsR    = (cols);
    end
end

%%
for currentFile=1:286
    dirall(currentFile).ratioRows    = round(dirall(currentFile).rows/dirall(currentFile).rowsR) ;
    dirall(currentFile).ratioCols    = round(dirall(currentFile).cols/dirall(currentFile).colsR) ;
end