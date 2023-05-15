clear all
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTestClasses2')

baseDir                     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTest\';
dir0                        = dir(strcat(baseDir,'*.tiff'));

dirall                      = dir(strcat('*_*.png'));
numFiles                    = length (dirall);

%%


for k=1:128
    currentImageName                = dirall(k).name;
    disp(currentImageName)
    currentImage                                = imread(dirall(k).name);
    currentTest                                 = imfinfo(strcat(baseDir,dir0(k).name));
    % ensure nothing is more than 6 in the classes
    max_currentImage(k)                         = max(currentImage(:));
    if (max_currentImage(k)>5)
        currentImage(currentImage==6)                     = 5;
        disp(k)
        imwrite(currentImage,currentImageName);
    end
    % ensure dimensions
    [rows,cols]                                 = size(currentImage);
    if((currentTest(1).Width/10)~=cols)|((currentTest(1).Height/10)~=rows)

        disp([ cols rows currentTest(1).Width currentTest(1).Height ])

        [rows2,cols2,~]     = size(currentImage);
        [Y,X]               = meshgrid(linspace(1,cols,round(currentTest(1).Width/10)),linspace(1,rows,round(currentTest(1).Height/10)));
        [Y1,X1]             = meshgrid(1:cols,1:rows);
        b                   = interp2(Y1,X1,double(currentImage),Y,X);
        %figure(1)
        %imagesc(currentImage)
        %figure(2)
        %imagesc(b)
        imwrite(currentImage,currentImageName);
    end


end