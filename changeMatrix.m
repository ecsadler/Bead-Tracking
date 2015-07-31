function [change]= changeMatrix(filename)

vid= VideoReader(filename);

height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
frame= zeros(height,width,numFrames);
for k=1:numFrames
    frame(:,:,k)= read(vid,k);
end

%3-D matrix representing the change in color between each frame
change= zeros(height,width,numFrames-1);
for k=1:numFrames-1
    change(:,:,k)= frame(:,:,k+1) - frame(:,:,k);
end