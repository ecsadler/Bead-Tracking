I= frame(:,:,1);
imshow(I)

pause

background = imopen(I,strel('disk',10));

% Display the Background Approximation as a Surface
figure
surf(double(background(1:8:end,1:8:end))),zlim([0 255]);
ax = gca;
ax.YDir = 'reverse';

pause

I2 = I - background;
imshow(I2)

pause

I3 = imadjust(I2);
imshow(I3);

pause

level = graythresh(I3);
bw = im2bw(I3,.5);
bw = bwareaopen(bw, 100);
imshow(bw)

pause

cc = bwconncomp(bw, 8)

grain = false(size(bw));
grain(cc.PixelIdxList{50}) = true;
imshow(grain);
