function [cropVid]= fileToMatrix(filename)

vid= VideoReader(filename);

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
cropVid= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    cropVid(:,:,k)= read(vid,k);
end