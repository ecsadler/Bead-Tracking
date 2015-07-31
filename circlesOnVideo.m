vid= VideoReader('5SM_2RBeads_3Percoll_DAPI_10x_3s_10min_FBL12Halfway.avi');

%initializations based on video being used
height= vid.Height;
width= vid.Width;
numFrames= vid.NumberOfFrames;

%3-D matrix of frames grayscale
im= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    im(:,:,k)= read(vid,k);
end

centersCell= cell(1,numFrames);
radiiCell= cell(1,numFrames);
metricCell= cell(1,numFrames);
for k=1:numFrames
    %f= figure('visible','off');
    %imshow(im(:,:,k))
    [centers, radii, metric] = imfindcircles(im(:,:,k),[1 2], ...
        'ObjectPolarity','dark'); %These numbers can be played with
    %viscircles(centers, radii,'EdgeColor','b');
    centersCell{k}= centers;
    radiiCell{k}= radii;
    metricCell{k}= metric;
end

