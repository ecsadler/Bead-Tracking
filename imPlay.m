I= cropVid(:,:,1);
imshow(I)

pause

background = imopen(I,strel('disk',5));

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
bw = im2bw(I3,level);
bw = bwareaopen(bw, 50);
imshow(bw)

pause

cc = bwconncomp(bw, 4)

pause

grain = false(size(bw));
grain(cc.PixelIdxList{50}) = true;
imshow(grain);

pause

labeled = labelmatrix(cc);
whos labeled

pause

RGB_label = label2rgb(labeled, @spring, 'c', 'shuffle');
imshow(RGB_label)

pause

graindata = regionprops(cc,'basic')

pause

graindata(50).Area

pause

grain_areas = [graindata.Area]

pause

[min_area, idx] = min(grain_areas)
grain = false(size(bw));
grain(cc.PixelIdxList{idx}) = true;
imshow(grain);

pause

nbins = 20;
figure, hist(grain_areas,nbins)
title('Histogram of Rice Grain Area');