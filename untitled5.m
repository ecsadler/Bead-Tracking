A= VideoReader('3um_ref_fluor_beads+swimmingSM_DAPI.avi');

%initializations based on video being used
height= A.Height;
width= A.Width;
numFrames= A.NumberOfFrames;

%3-D matrix of frames grayscale
im= zeros(height,width,numFrames,'uint8');
for k=1:numFrames
    im(:,:,k)= read(A,k);
end

centersCell= cell(1,numFrames);
radiiCell= cell(1,numFrames);
metricCell= cell(1,numFrames);
for k=1:numFrames
    %f= figure('visible','off');
    %imshow(im(:,:,k))
    [centers, radii, metric] = imfindcircles(im(:,:,k),[5 20]);
    %viscircles(centers, radii,'EdgeColor','b');
    centersCell{k}= centers;
    radiiCell{k}= radii;
    metricCell{k}= metric;
end

