function [beforeLight,afterLight]= splittingBands(band,lightFrame,numFrames)
%function splits bands from makingBands into separate grayscale matrices
%for before and after the blue light is turned on

%band- a cell array of the bands (created through makingBands)
%lightFrame- the number of the frame where the blue light comes on
%numFrames- total number of frames in the video

[a,b]= size(band);
beforeLight= cell(a,b);
afterLight= cell(a,b);

for k=1:b
    beforeLight{k}= band{k}(:,:,1:lightFrame-1);
    afterLight{k}= band{k}(:,:,lightFrame:numFrames);
end