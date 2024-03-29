%% Clear all variables and close all figures
clear all
close all
clc


%% Read the files that have been stored in the current folder
% To be adapted depending on the computer where this is executed
    % running in windows Alienware
    baseDir         = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\';
    
    baseDirData     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataR\';
    baseDirTest     = 'C:\Users\sbbk034\OneDrive - City, University of London\Documents\GitHub\Gleason\DataTestR\';
    dirData         = dir(strcat(baseDirData,'*.mat'));
    dirTest         = dir(strcat(baseDirTest,'*.mat'));
    
%    
%     cd (strcat(baseDir,'CODE'))
%     dataSaveDir = strcat(baseDir,'CODE\Results\');
     dataSetDir  = strcat(baseDir,'CODE\');
%     %GTDir       = strcat(baseDir,'CODE\GroundTruth\');
%     GTDir       = strcat(baseDir,'CODE\GroundTruth_multiNuclei\');
%     baseDirSeg  = strcat(baseDir,'CODE\GroundTruth_4c\');
%     
%     dir_8000    = 'C:\Users\sbbk034\Documents\Acad\Crick\Hela8000_tiff\';
%     dirSeg      = dir(strcat(baseDirSeg,'*.mat'));
%     dirGT       = dir(strcat(GTDir,'*.mat'));
% end
% 

% numSlices       = numel(dirGT);
%% Training data and labels
% location of the training data data and labels are stored as pairs of textures arranged in Horizontal,
% Vertical and Diagonal pairs of class 1-2, 1-3, 1-4 ... 2-1, 2-3,...
imageDir                    = fullfile(baseDir,strcat('trainingPatch',filesep));
labelDir                    = fullfile(baseDir,strcat('trainingLabel',filesep));
sizeTrainingPatch           = 256;
encoderDepth                = 4;

% These are the data stores with the training pairs and training labels
% They can be later used to create montages of the pairs.
imds                        = imageDatastore(imageDir);
imds2                       = imageDatastore(labelDir);


%% U-Net definition and training
numClasses                  = 6 ;

% The class names are a sequence of options for the classes, e.g.
% classNames = ["T1","T2","T3","T4","T5"];
clear classNames
for counterClass=1:numClasses
    classNames(counterClass) = strcat("T",num2str(counterClass));
end
% The labels are simply the numbers of the textures, same numbers
% as with the classNames. For randen examples, these vary 1-5, 1-16, 1-10
labelIDs                    = (1:numClasses);
pxds                        = pixelLabelDatastore(labelDir,classNames,labelIDs);


% training data
trainingData                = pixelLabelImageDatastore(imds,pxds);

%%

% Create  U-Net
typeEncoder        = 'adam';
imageSize           = [sizeTrainingPatch sizeTrainingPatch 3];

encoderDepth        = 4;
numEpochs           = 1;
lgraph              = unetLayers(imageSize,numClasses,'EncoderDepth',encoderDepth);
opts                = trainingOptions(typeEncoder, ...
    'InitialLearnRate',1e-3, ...
    'MaxEpochs',numEpochs, ...
    'MiniBatchSize',32);

%%

% Train U-Net
net2                = trainNetwork(trainingData,lgraph,opts);
save gleasonUnet_2022_08_10_background net2
%% Segment in one go, max size 2048 x 2048
% segmentedData                   = semanticseg( currentImageR,net2);
%% Segment in quarters
%  Q1                   = semanticseg((currentImageR(4000+1:4000+2048,4000+1:4000+2048)),net2);
%  Q2                   = semanticseg((currentImageR(4000+1:4000+2048,4000+1+2048:4000+4096)),net2);
%  Q3                   = semanticseg((currentImageR(4000+1+2048:4000+4096,4000+1:4000+2048)),net2);
%  Q4                   = semanticseg((currentImageR(4000+1+2048:4000+4096,4000+1+2048:4000+4096)),net2);
%  segmentedData        = [Q1 Q2; Q3 Q4];
 
%% Segment in blocks of 2048x2048
[rows,cols,~]           = size(currentImageR);
segmentedData           = zeros(rows,cols);
sizeBlock               = 2048;
 for k1=1:sizeBlock:rows-sizeBlock
     disp(k1)
            for k2=1:sizeBlock:cols-sizeBlock
                
                rStart          = k1;
                rFin            = min(rows,k1+sizeBlock-1);
                cStart          = k2;
                cFin            = min(cols,k2+sizeBlock-1);
                rr = round(rStart:rFin);
                cc = round(cStart:cFin);
                %rr = k1:k1+sizeBlock-1;
                %cc = k2:k2+sizeBlock-1;
                Q1                   = semanticseg(currentImageR(rr,cc,:),net2);
                result                  = zeros(sizeBlock,sizeBlock);
                for counterClass=1:numClasses
                    result = result +(counterClass*(Q1==strcat('T',num2str(counterClass))));
                end
                segmentedData(rr,cc) = result;              
            end
 end

 %Q1                   = semanticseg((currentImageR(4000+1:2048,4000+1:2048)),net2);
%%
