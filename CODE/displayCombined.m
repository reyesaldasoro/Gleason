figure(1)
imagesc(currentImageR)
%%
figure(2)
imagesc(currentImageR.*repmat(1-uint8(backgroundMask),[1 1 3]))

%%
figure(3)
imagesc(currentImageR.*repmat(uint8(backgroundMask),[1 1 3]))
