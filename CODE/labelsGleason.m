clear
close all
cd ('C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\CODE')
%%
baseDirP                    = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\trainingPatch\';
saveDirL                    = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\trainingLabel\';
%dir0                       = dir(strcat(baseDir,'Subset',num2str(setSelected),'_*.mat'));
dirPatches                  = dir(strcat(baseDirP,'*.png'));
numFiles                    = length (dirPatches);

%%
basicPatch = uint8(ones(256,256));
for k = 1:numFiles
    disp(k)
    switch dirPatches(k).name(1:2)
        case 'G3'
            multiplierPatch = 3;
        case 'G4'
            multiplierPatch = 4;
        case 'G5'
            multiplierPatch = 5;
        case 'N_'
            multiplierPatch = 1;
        case 'S_'
            multiplierPatch = 2;
    end
            
    filename =  strcat(saveDirL,dirPatches(k).name(1:end-4),'_L.png');
    imwrite(basicPatch*multiplierPatch,filename);
end