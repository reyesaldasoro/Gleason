figure(1)
imagesc(currentImageR)
%%
figure(2)
imagesc(currentImageR.*repmat(1-uint8(backgroundMask),[1 1 3]))

%%
figure(3)
imagesc(currentImageR.*repmat(uint8(backgroundMask),[1 1 3]))

%%

figure(11)
subplot(231)
imagesc(currentImage.*repmat(uint8(H_E_chromatic),[1 1 3]))
subplot(232)
imagesc(currentImage.*repmat(uint8(H_E_chromatic_highSat),[1 1 3]))
subplot(233)
imagesc(currentImage.*repmat(uint8(H_E_chromatic_highSat2),[1 1 3]))
subplot(234)
imagesc(data_hsv(:,:,2))
subplot(235)
imagesc(currentImage.*repmat(uint8(1-H_E_chromatic_highSat2),[1 1 3]))
subplot(236)
imagesc(currentImage.*repmat(uint8(1-H_E_chromatic_highSat2),[1 1 3]))

%% 
for k=1:6
subplot(2,3,k)
%axis([3700 4300 3700 4300 ])
 axis([1 2000 14000 18000 ])
end

